<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:fp="http://docbook.org/xslt/ns/extension/private"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fp ghost h m u xs html"
                version="2.0">

<doc:mode name="m:cals-phase-1" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for normalizing CALS tables</refpurpose>

<refdescription>
<para>This mode is used to normalize CALS tables. A table has a rectangular
structure with a certain number of rows and columns. In the simplest case,
each row has the same number of entries (equal to the number of columns
in the table). Two complications arise: first, cells can span columns or
rows, second, a cell can identify the column in which it appears, potentially
“skipping” earlier columns (cells cannot appear out of order, so there's
no possibility of that column being “back filled” by a later cell that
explicitly identifies the skipped column).</para>

<para>Another complication arises in the way default values for cell
properties like alignment and row or column separators are calculated.
See <function role="named-template">inherit-table-attributes</function>.
</para>

<para>These complications make processing tables quite complicated. The
result of processing a table in the <literal>m:cals-phase-1</literal> mode
is a normalized table. In the normalized table, all of rows have one
child element for each column and all of the attributes associated with
an entry appear literally on the entry.</para>

<para>In the case where a cell spans across columns or rows, the normalized
table will have a <tag>ghost:overlapped</tag> element in the phantom cells.
In the case where a cell has skipped some columns, those columns will have
a <tag>ghost:empty</tag> element.</para>

<para>Processing a normalized table is a simple matter of processing
each row and cell.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:tgroup" mode="m:cals-phase-1">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="ghost:phase" select="1"/>
    <xsl:apply-templates mode="m:cals-phase-1"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="db:thead|db:tbody|db:tfoot"
	      mode="m:cals-phase-1">
  <xsl:variable name="overhang"
		select="for $col in (1 to xs:integer(../@cols))
			return 0"/>
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="db:row[1]" mode="m:cals-phase-1">
      <xsl:with-param name="overhang" select="$overhang"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<xsl:template match="db:row" mode="m:cals-phase-1">
  <xsl:param name="overhang" as="xs:integer+"/>

<!--
  <xsl:message>
    <xsl:text>ROW </xsl:text>
    <xsl:value-of select="count(preceding-sibling::db:row)+1"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$overhang" separator=","/>
  </xsl:message>
-->

  <xsl:variable name="row">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="(db:entry|db:entrytbl)[1]"
			   mode="m:cals-phase-1">
	<xsl:with-param name="overhang" select="$overhang"/>
	<xsl:with-param name="prevpos" select="0"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:variable>

  <xsl:copy-of select="$row/db:row"/>

  <xsl:variable name="decremented-overhang"
		select="for $col in (1 to count($overhang))
			return xs:integer(max(($overhang[$col] - 1, 0)))"/>

  <xsl:variable name="next-overhang"
		select="for $col in (1 to count($overhang))
			return
			  xs:integer($decremented-overhang[$col]
			              + $row/db:row/*[$col]/@ghost:morerows)"/>

  <xsl:apply-templates select="following-sibling::db:row[1]"
		       mode="m:cals-phase-1">
    <xsl:with-param name="overhang" select="$next-overhang"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:entry|db:entrytbl" mode="m:cals-phase-1">
  <xsl:param name="overhang" as="xs:integer+"/>
  <xsl:param name="prevpos" as="xs:integer"/>

  <xsl:variable name="entry" select="."/>
  <xsl:variable name="row" select="$entry/parent::db:row"/>
  <xsl:variable name="container" select="(ancestor::db:tgroup
                                          |ancestor::db:entrytbl)[last()]"/>

  <xsl:variable name="nextpos" select="f:skip-overhang($overhang, $prevpos+1)"
		as="xs:integer"/>

  <xsl:variable name="pos" as="xs:integer">
    <xsl:choose>
      <xsl:when test="@namest">
	<xsl:variable name="name" select="@namest"/>
	<xsl:variable name="colspec"
		      select="$container/db:colspec[@colname=$name]"/>
	<xsl:value-of select="f:colspec-colnum($colspec)"/>
      </xsl:when>
      <xsl:when test="@colname">
	<xsl:variable name="name" select="@colname"/>
	<xsl:variable name="colspec"
		      select="$container/db:colspec[@colname=$name]"/>
	<xsl:value-of select="f:colspec-colnum($colspec)"/>
      </xsl:when>
      <xsl:when test="@spanname">
	<xsl:variable name="name" select="@spanname"/>
	<xsl:variable name="spanspec"
		      select="$container/db:spanspec[@spanname=$name]"/>

	<xsl:value-of select="f:spanspec-colnum-start($spanspec)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$nextpos"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="width" as="xs:integer">
    <xsl:choose>
      <xsl:when test="@nameend">
	<xsl:variable name="name" select="@nameend"/>
	<xsl:variable name="colspec"
		      select="$container/db:colspec[@colname=$name]"/>

	<xsl:value-of select="f:colspec-colnum($colspec) - $pos + 1"/>
      </xsl:when>
      <xsl:when test="@spanname">
	<xsl:variable name="name" select="@spanname"/>
	<xsl:variable name="spanspec"
		      select="$container/db:spanspec[@spanname=$name]"/>

	<xsl:value-of select="f:spanspec-colnum-end($spanspec) - $pos + 1"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:text>  ENT </xsl:text>
    <xsl:value-of select="count(preceding-sibling::db:entry)+1"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$pos"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$width"/>
  </xsl:message>
-->

  <xsl:for-each select="for $col in ($prevpos+1 to $pos - 1) return $col">
    <xsl:variable name="col" select="."/>
    <xsl:choose>
      <xsl:when test="$overhang[$col] &gt; 0">
	<ghost:overlapped ghost:colnum="{$col}" ghost:morerows="0"/>
      </xsl:when>
      <xsl:otherwise>
	<ghost:empty ghost:colnum="{$col}" ghost:morerows="0">
	  <xsl:call-template name="inherit-table-attributes">
	    <xsl:with-param name="colnum" select="."/>
	    <xsl:with-param name="row" select="$row"/>
	  </xsl:call-template>
	</ghost:empty>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="ghost:id" select="generate-id(.)"/>
    <xsl:attribute name="ghost:colnum" select="$pos"/>
    <xsl:attribute name="ghost:width" select="$width"/>
    <xsl:attribute name="ghost:morerows"
		   select="if (@morerows)
			   then xs:integer(@morerows)
			   else 0"/>

    <xsl:call-template name="inherit-table-attributes">
      <xsl:with-param name="colnum" select="$pos"/>
    </xsl:call-template>

    <xsl:apply-templates mode="m:cals-phase-1"/>
  </xsl:copy>

  <xsl:for-each select="for $col in ($pos + 1 to $pos + $width - 1) return $col">
    <ghost:overlapped ghost:colnum="{.}">
      <xsl:attribute name="ghost:morerows"
		     select="if ($entry/@morerows)
			     then xs:integer($entry/@morerows)
			     else 0"/>
    </ghost:overlapped>
  </xsl:for-each>

  <!--
  <xsl:message>
    <xsl:value-of select="$pos"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="count(following-sibling::*)"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$container/@cols"/>
  </xsl:message>
  -->

  <xsl:apply-templates select="(following-sibling::db:entry
			        |following-sibling::db:entrytbl)[1]"
		       mode="m:cals-phase-1">
    <xsl:with-param name="overhang" select="$overhang"/>
    <xsl:with-param name="prevpos" select="$pos + $width - 1"/>
  </xsl:apply-templates>

  <!-- pad the row with empties if necessary -->
  <xsl:if test="not(following-sibling::db:entry|following-sibling::db:entrytbl)">
<!--
    <xsl:message>
      <xsl:text>  PAD </xsl:text>
      <xsl:value-of select="$pos+$width"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="$container/@cols"/>
    </xsl:message>
-->
    <xsl:for-each select="for $col
			  in ($pos + $width to $container/@cols)
			  return $col">
      <xsl:variable name="col" select="."/>
      <xsl:choose>
        <xsl:when test="$overhang[$col] = 0">
<!--
          <xsl:message>    empty</xsl:message>
-->
          <ghost:empty ghost:colnum="{.}" ghost:morerows="0">
            <xsl:call-template name="inherit-table-attributes">
              <xsl:with-param name="colnum" select="."/>
              <xsl:with-param name="row" select="$row"/>
            </xsl:call-template>
          </ghost:empty>
        </xsl:when>
        <xsl:otherwise>
<!--
          <xsl:message>    overlapped</xsl:message>
-->
          <ghost:overlapped ghost:colnum="{.}" ghost:morerows="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template match="db:colspec" mode="m:cals-phase-1">
  <xsl:copy>
    <xsl:attribute name="ghost:colnum" select="f:colspec-colnum(.)"/>
    <xsl:copy-of select="@*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="*" mode="m:cals-phase-1">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:cals-phase-1"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:cals-phase-1">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="inherit-table-attributes"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Calculates attribute values for table cells</refpurpose>

<refdescription>
<para>In a CALS table, each entry can have a number of properties
(alignment, row and column separators, etc.). If these properties aren't
specified directly on the entry, then their default values are calculated
by a complex series of defaults.
</para>

<para>A property can be specified in any of nine locations:</para>

<orderedlist>
<listitem>
<para>The <tag>entry</tag>.
</para>
</listitem>
<listitem>
<para>The <tag>row</tag>.
</para>
</listitem>
<listitem>
<para>The <tag>tgroup</tag>.
</para>
</listitem>
<listitem>
<para>The <tag>table</tag> or <tag>informaltable</tag>.
</para>
</listitem>
<listitem>
<para>The <tag>spanspec</tag> if this entry has
a <tag class="attribute">spanname</tag> attribute.</para>
</listitem>
<listitem>
<para>The starting column of the span as identified by the
<tag class="attribute">namest</tag> attribute on the <tag>spanspec</tag>
(if there is one, see previous.)
</para>
</listitem>
<listitem>
<para>The starting column of the span identified directly by a
<tag class="attribute">namest</tag> attribute on the <tag>entry</tag>.
</para>
</listitem>
<listitem>
<para>The <tag>colspec</tag> for the column in which it occurs (either
naturally or as a result of a <tag class="attribute">colname</tag> attribute).
</para>
</listitem>
<listitem>
<para>Some application default.
</para>
</listitem>
</orderedlist>

<para>This template performs those lookup operations and generates an
explicit attribute node for each inheritable property. In this way,
a normalized cell has all of the proper values specified directly.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>entry</term>
<listitem>
<para>The table cell element, defaults to the current context node.</para>
</listitem>
</varlistentry>
<varlistentry role="required"><term>colnum</term>
<listitem>
<para>The column number in which this entry appears.</para>
</listitem>
</varlistentry>
<varlistentry><term>row</term>
<listitem>
<para>The row containing the cell, defaults to the parent of the entry.
This parameter exists independent of the entry because when the entry is
an empty column (for example, at the end of a short row), the entry will
be an integer and won't have a parent.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>A sequence of attribute nodes, one for each property.</para>
</refreturn>
</doc:template>

<xsl:template name="inherit-table-attributes">
  <xsl:param name="entry" select="."/>
  <xsl:param name="colnum" required="yes"/>
  <xsl:param name="row" select="$entry/parent::db:row"/>

  <!-- the table attributes come from:
       1. the entry
       2. the row
       3. the tgroup
       4. the table or informaltable
       5. the spanspec (@spanname)
       6. the starting column of the spanspec (spanspec/@namest)
       7. the starting column (@namest)
       8. the colspec for the $colnum
       9. application default
       in that order -->

  <xsl:variable name="tgroup" select="$row/ancestor::db:tgroup[1]"/>
  <xsl:variable name="table" select="$tgroup/parent::*"/>
  <xsl:variable name="spanspec"
		select="$tgroup/db:spanspec[@spanname=$entry/@spanname]"/>

  <xsl:variable name="elements" as="element()*">
    <xsl:choose>
      <xsl:when test="$entry instance of element()">
	<xsl:sequence select="($entry,
			       $row,
			       $spanspec,
			       $tgroup/db:colspec[@colname=$spanspec/@namest],
			       $tgroup/db:colspec[@colname=$entry/@namest],
			       f:find-colspec-by-colnum($tgroup, $colnum),
			       $tgroup,
			       $tgroup/parent::*)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="($row,
			       f:find-colspec-by-colnum($tgroup, $colnum),
			       $tgroup,
			       $tgroup/parent::*)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colspec"
		select="f:find-colspec-by-colnum($tgroup, $colnum)"/>

  <xsl:for-each select="('rowsep', 'colsep',
                         'align', 'valign',
			 'char', 'charoff')">
    <xsl:variable name="attr" select="QName('', .)"/>

    <xsl:variable name="value">
      <xsl:choose>
	<xsl:when test="f:find-element-by-attribute($elements, $attr)">
	  <xsl:value-of select="f:find-element-by-attribute($elements, $attr)
				/@*[node-name(.) = $attr]"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:if test="$attr=QName('','rowsep') or $attr=QName('','colsep')">
	    <xsl:value-of select="1"/>
	  </xsl:if>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="f:find-element-by-attribute($elements, $attr)">
	<xsl:attribute name="{string($attr)}"
		       select="f:find-element-by-attribute($elements, $attr)
			       /@*[node-name(.) = $attr]"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- According to CALS, the default for each attribute is the
	     tgroup value, which we've already found above, if it exists,
	     except for colsep and rowsep which default to "1" -->
	<xsl:if test="$attr=QName('','rowsep') or $attr=QName('','colsep')">
	  <xsl:attribute name="{string($attr)}" select="1"/>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

<doc:function name="f:find-element-by-attribute"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Selects an element based on the presence of an attribute</refpurpose>

<refdescription>
<para>Given a sequence of elements and an attribute name, this
function returns the first element in the list that has the
specified attribute.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>elements</term>
<listitem>
<para>A sequence of zero or more elements.</para>
</listitem>
</varlistentry>
<varlistentry><term>attr</term>
<listitem>
<para>The name of the attribute to find.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>An element or the empty sequence if no element has the specified
attribute.</para>
</refreturn>
</doc:function>

<xsl:function name="f:find-element-by-attribute" as="element()?">
  <xsl:param name="elements" as="element()*"/>
  <xsl:param name="attr" as="xs:QName"/>

  <xsl:choose>
    <xsl:when test="not($elements)">
      <xsl:sequence select="()"/>
    </xsl:when>
    <xsl:when test="$elements[1]/@*[node-name(.) = $attr]">
      <xsl:sequence select="$elements[1]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="f:find-element-by-attribute($elements[position() &gt; 1], $attr)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:find-colspec-by-colnum"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Finds the <tag>colspec</tag> for the specified column
number.</refpurpose>

<refdescription>
<para>Searches the <tag>colspec</tag> elements and returns the one
for the specified column.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>tgroup</term>
<listitem>
<para>The <tag>tgroup</tag> element in which to search.</para>
</listitem>
</varlistentry>
<varlistentry><term>colnum</term>
<listitem>
<para>The column number.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The <tag>colspec</tag> or the empty sequence if there is no
specification for that column.</para>
</refreturn>
</doc:function>

<xsl:function name="f:find-colspec-by-colnum" as="element()?">
  <xsl:param name="tgroup" as="element(db:tgroup)"/>
  <xsl:param name="colnum" as="xs:integer"/>
  
  <xsl:sequence select="fp:find-colspec($tgroup/db:colspec[1], $colnum, 0)"/>
</xsl:function>

<xsl:function name="fp:find-colspec" as="element()?">
  <xsl:param name="colspec" as="element(db:colspec)?"/>
  <xsl:param name="colnum" as="xs:integer"/>
  <xsl:param name="curcol" as="xs:integer"/>

  <xsl:choose>
    <xsl:when test="not($colspec) or $curcol &gt; $colnum">
      <xsl:sequence select="()"/>
    </xsl:when>
    <xsl:when test="$colspec/@colnum">
      <xsl:choose>
	<xsl:when test="$colnum = $colspec/@colnum">
	  <xsl:sequence select="$colspec"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:sequence select="fp:find-colspec($colspec/following-sibling::db:colspec[1], $colnum, xs:integer($colspec/@colnum))"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
	<xsl:when test="$colnum = $curcol+1">
	  <xsl:sequence select="$colspec"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:sequence select="fp:find-colspec($colspec/following-sibling::db:colspec[1], $colnum, $colnum+1)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:skip-overhang" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Finds the next available column position in a CALS table</refpurpose>

<refdescription>
<para>This function returns the next available column position in a
CALS table, skipping over the columns that contains cells which hang
down into the current row.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>overhang</term>
<listitem>
<para>A sequence of integer values giving the depth of “overhang” from
previous rows for
cells in each column of the table.</para>
</listitem>
</varlistentry>
<varlistentry><term>pos</term>
<listitem>
<para>The nominal next column. This generally one more than the
current column number.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The next available column in the row.</para>
</refreturn>
</doc:function>

<xsl:function name="f:skip-overhang">
  <xsl:param name="overhang" as="xs:integer+"/>
  <xsl:param name="pos" as="xs:integer"/>

  <xsl:choose>
    <xsl:when test="$pos &gt; count($overhang)">
      <xsl:value-of select="$pos"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="if ($overhang[$pos] = 0)
			    then $pos
			    else f:skip-overhang($overhang, $pos+1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:colspec-colnum" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the column number associated with a particuluar
<tag>colspec</tag>.</refpurpose>

<refdescription>
<para>This function returns the column number of the specified
<tag>colspec</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>colspec</term>
<listitem>
<para>The <tag>colspec</tag> element.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The column number associated with that <tag>colspec</tag>.</para>
</refreturn>
</doc:function>

<xsl:function name="f:colspec-colnum" as="xs:integer">
  <xsl:param name="colspec" as="element(db:colspec)"/>

  <xsl:choose>
    <xsl:when test="$colspec/@colnum">
      <xsl:value-of select="$colspec/@colnum"/>
    </xsl:when>
    <xsl:when test="$colspec/preceding-sibling::db:colspec">
      <xsl:value-of select="f:colspec-colnum(
			       $colspec/preceding-sibling::db:colspec[1])
	                    + 1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:spanspec-colnum-start"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the column number of the starting column of a
span</refpurpose>

<refdescription>
<para>This function returns the column number of the starting column
of a span.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>spanspec</term>
<listitem>
<para>The <tag>spanspec</tag> element.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The column number associated with the first column of the
span.</para>
</refreturn>
</doc:function>

<xsl:function name="f:spanspec-colnum-start" as="xs:integer">
  <xsl:param name="spanspec" as="element(db:spanspec)"/>

  <xsl:value-of select="f:colspec-colnum($spanspec/ancestor::db:tgroup[1]
			      /db:colspec[@colname=$spanspec/@namest])"/>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:spanspec-colnum-end"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the column number of the ending column of a
span</refpurpose>

<refdescription>
<para>This function returns the column number of the ending column
of a span.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>spanspec</term>
<listitem>
<para>The <tag>spanspec</tag> element.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The column number associated with the last column of the span.</para>
</refreturn>
</doc:function>

<xsl:function name="f:spanspec-colnum-end" as="xs:integer">
  <xsl:param name="spanspec" as="element(db:spanspec)"/>

  <xsl:value-of select="f:colspec-colnum($spanspec/ancestor::db:tgroup[1]
			      /db:colspec[@colname=$spanspec/@nameend])"/>
</xsl:function>

<!-- ============================================================ -->

<doc:template name="generate-colgroup" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Generates an HTML <tag>colgroup</tag>.</refpurpose>

<refdescription>
<para>Generates an HTML <tag>colgroup</tag> for the CALS table.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry role="required"><term>cols</term>
<listitem>
<para>The number of columns in the table.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>A sequence of one or more <tag>col</tag> elements.</para>
</refreturn>
</doc:template>

<xsl:template name="generate-colgroup">
  <xsl:param name="cols" required="yes"/>
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count &gt; $cols"></xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="generate-col">
        <xsl:with-param name="countcol" select="$count"/>
      </xsl:call-template>
      <xsl:call-template name="generate-colgroup">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="generate-col" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Generates an HTML <tag>col</tag>.</refpurpose>

<refdescription>
<para>Generates an HTML <tag>col</tag> for a
<tag>colgroup</tag>.
See <function role="named-template">generate-colgroup</function>.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry role="required"><term>countcol</term>
<listitem>
<para>The number of the column.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>A <tag>col</tag> element.</para>
</refreturn>
</doc:template>

<xsl:template name="generate-col">
  <xsl:param name="countcol" required="yes"/>
  <xsl:param name="colspecs" select="./db:colspec"/>
  <xsl:param name="count">1</xsl:param>
  <xsl:param name="colnum">1</xsl:param>

  <xsl:choose>
    <xsl:when test="$count &gt; count($colspecs)">
      <col/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
      <xsl:variable name="colspec.colnum">
	<xsl:choose>
	  <xsl:when test="$colspec/@colnum">
            <xsl:value-of select="$colspec/@colnum"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$colnum"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
	<xsl:when test="$colspec.colnum=$countcol">
	  <col>
	    <xsl:if test="$colspec/@colwidth">
	      <xsl:attribute name="width">
		<xsl:choose>
		  <xsl:when test="normalize-space($colspec/@colwidth) = '*'">
		    <xsl:value-of select="'1*'"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="$colspec/@colwidth"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	    </xsl:if>

	    <xsl:choose>
	      <xsl:when test="$colspec/@align">
		<xsl:attribute name="align">
		  <xsl:value-of select="$colspec/@align"/>
		</xsl:attribute>
	      </xsl:when>
	      <!-- Suggested by Pavel ZAMPACH <zampach@nemcb.cz> -->
	      <xsl:when test="$colspecs/parent::db:tgroup/@align">
		<xsl:attribute name="align">
                  <xsl:value-of select="$colspecs/parent::db:tgroup/@align"/>
		</xsl:attribute>
              </xsl:when>
            </xsl:choose>

	    <xsl:if test="$colspec/@char">
              <xsl:attribute name="char">
                <xsl:value-of select="$colspec/@char"/>
              </xsl:attribute>
            </xsl:if>

            <xsl:if test="$colspec/@charoff">
              <xsl:attribute name="charoff">
                <xsl:value-of select="$colspec/@charoff"/>
              </xsl:attribute>
            </xsl:if>
	  </col>
	</xsl:when>
	<xsl:otherwise>
          <xsl:call-template name="generate-col">
            <xsl:with-param name="countcol" select="$countcol"/>
            <xsl:with-param name="colspecs" select="$colspecs"/>
            <xsl:with-param name="count" select="$count+1"/>
            <xsl:with-param name="colnum">
              <xsl:choose>
                <xsl:when test="$colspec/@colnum">
                  <xsl:value-of select="$colspec/@colnum + 1"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$colnum + 1"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
           </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
