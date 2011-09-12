<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db doc t xs"
                version="2.0">

<xsl:param name="variablelist.term.separator" select="', '"/>
<xsl:param name="variablelist.term.break.after" select="0"/>

<!-- ============================================================ -->

<xsl:template match="db:itemizedlist">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates select="node()[not(self::db:listitem)]"/>

    <ul>
      <xsl:apply-templates select="db:listitem"/>
    </ul>
  </div>
</xsl:template>

<xsl:template match="db:itemizedlist/db:listitem">
  <xsl:variable name="mark" select="xs:string(../@mark)"/>
  <xsl:variable name="override" select="xs:string(@override)"/>

  <xsl:variable name="usemark">
    <xsl:choose>
      <xsl:when test="$override != ''">
        <xsl:value-of select="$override"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$mark"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cssmark">
    <xsl:choose>
      <xsl:when test="$usemark = 'opencircle'">circle</xsl:when>
      <xsl:when test="$usemark = 'bullet'">disc</xsl:when>
      <xsl:when test="$usemark = 'round'">disc</xsl:when>
      <xsl:when test="$usemark = 'box'">square</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$usemark"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <li>
    <xsl:sequence select="f:html-attributes(., @xml:id, ())"/>
    <xsl:if test="$cssmark != ''">
      <xsl:attribute name="style">
	<xsl:text>list-style-type: </xsl:text>
	<xsl:value-of select="$cssmark"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:orderedlist">
  <xsl:variable name="starting.number"
		select="f:orderedlist-starting-number(.)"/>

  <xsl:variable name="numeration"
		select="f:orderedlist-numeration(.)"/>

  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates select="node()[not(self::db:listitem)]"/>

    <ol>
      <xsl:if test="$starting.number != 1">
	<xsl:attribute name="start" select="$starting.number"/>
      </xsl:if>

      <!-- If there's no inline style attribute, force the class -->
      <!-- to contain the numeration so that external CSS can work -->
      <!-- otherwise, leave the class whatever it was -->
      <xsl:if test="$inline.style.attribute = 0">
        <xsl:attribute name="class" select="$numeration"/>
      </xsl:if>

      <xsl:call-template name="style">
	<xsl:with-param name="css">
	  <xsl:text>list-style: </xsl:text>
	  <xsl:choose>
	    <xsl:when test="not($numeration)">decimal</xsl:when>
	    <xsl:when test="$numeration = 'arabic'">decimal</xsl:when>
	    <xsl:when test="$numeration = 'loweralpha'">lower-alpha</xsl:when>
	    <xsl:when test="$numeration = 'upperalpha'">upper-alpha</xsl:when>
	    <xsl:when test="$numeration = 'lowerroman'">lower-roman</xsl:when>
	    <xsl:when test="$numeration = 'upperroman'">upper-roman</xsl:when>
	    <xsl:when test="$numeration = 'loweralpha'">lower-alpha</xsl:when>
	    <xsl:otherwise>decimal</xsl:otherwise>
	  </xsl:choose>
	  <xsl:text>;</xsl:text>
	</xsl:with-param>
      </xsl:call-template>

      <xsl:apply-templates select="db:listitem"/>
    </ol>
  </div>
</xsl:template>

<xsl:template match="db:orderedlist/db:listitem">
  <li>
    <xsl:sequence select="f:html-attributes(., @xml:id, ())"/>
    <xsl:if test="@override">
      <xsl:attribute name="value">
        <xsl:value-of select="@override"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:variablelist">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates select="node()[not(self::db:varlistentry)]"/>

    <dl>
      <xsl:apply-templates select="db:varlistentry"/>
    </dl>
  </div>
</xsl:template>

<xsl:template match="db:varlistentry">
  <dt>
    <xsl:sequence select="f:html-attributes(., @xml:id, ())"/>
    <xsl:apply-templates select="db:term"/>
  </dt>
  <xsl:apply-templates select="db:listitem"/>
</xsl:template>

<xsl:template match="db:varlistentry/db:term">
  <span>
    <xsl:sequence select="f:html-attributes(., @xml:id)"/>
    <xsl:call-template name="t:simple-xlink"/>
  </span>

  <xsl:if test="following-sibling::db:term">
    <!-- * if we have multiple terms in the same varlistentry, generate -->
    <!-- * a separator (", " by default) and/or an additional line -->
    <!-- * break after each one except the last -->
    <xsl:value-of select="$variablelist.term.separator"/>
    <xsl:if test="string($variablelist.term.break.after) != '0'">
      <br/>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="db:varlistentry/db:listitem">
  <dd>
    <xsl:sequence select="f:html-attributes(., @xml:id, ())"/>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:simplelist[not(@type) or @type='vert']">
  <table border="0" summary="Simple list">
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="simplelist-vert">
      <xsl:with-param name="cols" select="if (@columns) then @columns else 1"/>
    </xsl:call-template>
  </table>
</xsl:template>

<xsl:template match="db:simplelist[@type='horiz']">
  <table border="0" summary="Simple list">
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="simplelist-horiz">
      <xsl:with-param name="cols" select="if (@columns) then @columns else 1"/>
    </xsl:call-template>
  </table>
</xsl:template>

<xsl:template match="db:simplelist[@type='inline']">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="simplelist-horiz" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Process a simplelist as a row-major table</refpurpose>

<refdescription>
<para>This template processes a <tag>simplelist</tag> as a row-major
(horizontal) table.</para>
</refdescription>
</doc:template>

<xsl:template name="simplelist-horiz">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="cell" select="1"/>
  <xsl:param name="members" select="db:member"/>

  <xsl:if test="$cell &lt;= count($members)">
    <tr>
<!--
      <xsl:call-template name="tr.attributes">
        <xsl:with-param name="row" select="$members[1]"/>
        <xsl:with-param name="rownum" select="(($cell - 1) div $cols) + 1"/>
      </xsl:call-template>
-->

      <xsl:call-template name="simplelist-horiz-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
   </tr>
    <xsl:call-template name="simplelist-horiz">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell + $cols"/>
      <xsl:with-param name="members" select="$members"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="simplelist-horiz-row" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Produce a row of a simplelist as a row-major table</refpurpose>

<refdescription>
<para>This template produces a single row in a
<tag>simplelist</tag> as a row-major
(horizontal) table.</para>
</refdescription>
</doc:template>

<xsl:template name="simplelist-horiz-row">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="cell" select="1"/>
  <xsl:param name="members" select="db:member"/>
  <xsl:param name="curcol" select="1"/>

  <xsl:if test="$curcol &lt;= $cols">
    <td>
      <xsl:choose>
        <xsl:when test="$members[position()=$cell]">
          <xsl:apply-templates select="$members[position()=$cell]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <xsl:call-template name="simplelist-horiz-row">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="curcol" select="$curcol+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="simplelist-vert" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Process a simplelist as a column-major table</refpurpose>

<refdescription>
<para>This template processes a <tag>simplelist</tag> as a column-major
(vertical) table.</para>
</refdescription>
</doc:template>

<xsl:template name="simplelist-vert">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="cell" select="1"/>
  <xsl:param name="members" select="db:member"/>
  <xsl:param name="rows"
             select="floor((count($members)+$cols - 1) div $cols)"/>

  <xsl:if test="$cell &lt;= $rows">
    <tr>
<!--
      <xsl:call-template name="tr.attributes">
        <xsl:with-param name="row" select="$members[1]"/>
        <xsl:with-param name="rownum" select="$cell"/>
      </xsl:call-template>
-->

      <xsl:call-template name="simplelist-vert-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
    </tr>
    <xsl:call-template name="simplelist-vert">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="rows" select="$rows"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="simplelist-vert-row" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Produce a row of a simplelist as a column-major table</refpurpose>

<refdescription>
<para>This template produces a single row in a
<tag>simplelist</tag> as a column-major
(vertical) table.</para>
</refdescription>
</doc:template>

<xsl:template name="simplelist-vert-row">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="rows" select="1"/>
  <xsl:param name="cell" select="1"/>
  <xsl:param name="members" select="db:member"/>
  <xsl:param name="curcol" select="1"/>

  <xsl:if test="$curcol &lt;= $cols">
    <td>
      <xsl:choose>
        <xsl:when test="$members[position()=$cell]">
          <xsl:apply-templates select="$members[position()=$cell]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <xsl:call-template name="simplelist-vert-row">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rows" select="$rows"/>
      <xsl:with-param name="cell" select="$cell+$rows"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="curcol" select="$curcol+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="db:member">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:simplelist[@type='inline']/db:member">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:member">, </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:procedure">
  <xsl:variable name="numeration" select="f:procedure-step-numeration(.)"/>

  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:procedure]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-class(., local-name(.), @role)"/>

	<xsl:apply-templates
	    select="(db:step[1]/preceding-sibling::node())[not(self::db:info)]"/>

	<xsl:choose>
	  <xsl:when test="count(db:step) = 1">
	    <ul>
	      <xsl:apply-templates
		  select="db:step[1]|db:step[1]/following-sibling::node()"/>
	    </ul>
	  </xsl:when>
	  <xsl:otherwise>
	    <ol>
	      <xsl:attribute name="type">
		<xsl:choose>
		  <xsl:when test="$numeration = 'arabic'">1</xsl:when>
		  <xsl:when test="$numeration = 'loweralpha'">a</xsl:when>
		  <xsl:when test="$numeration = 'upperalpha'">A</xsl:when>
		  <xsl:when test="$numeration = 'lowerroman'">i</xsl:when>
		  <xsl:when test="$numeration = 'upperroman'">I</xsl:when>
		  <xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	      <xsl:apply-templates
		  select="db:step[1]|db:step[1]/following-sibling::node()"/>
	    </ol>
	  </xsl:otherwise>
	</xsl:choose>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:step">
  <li>
    <xsl:sequence select="f:html-attributes(.)"/>
    <div>
      <xsl:call-template name="t:titlepage"/>
      <xsl:apply-templates/>
    </div>
  </li>
</xsl:template>

<xsl:template match="db:substeps">
  <xsl:variable name="numeration" select="f:procedure-step-numeration(.)"/>

  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <ol>
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="$numeration = 'arabic'">1</xsl:when>
          <xsl:when test="$numeration = 'loweralpha'">a</xsl:when>
          <xsl:when test="$numeration = 'upperalpha'">A</xsl:when>
          <xsl:when test="$numeration = 'lowerroman'">i</xsl:when>
          <xsl:when test="$numeration = 'upperroman'">I</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </ol>
  </div>
</xsl:template>

<xsl:template match="db:stepalternatives">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <ul>
      <xsl:apply-templates/>
    </ul>
  </div>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="db:segmentedlist">
  <xsl:variable name="presentation"
		select="f:pi(processing-instruction('dbhtml'),
			     'list-presentation')"/>

  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:choose>
      <xsl:when test="$presentation = 'table'">
        <xsl:apply-templates select="." mode="m:seglist-table"/>
      </xsl:when>
      <xsl:when test="$presentation = 'list'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$segmentedlist.as.table != 0">
        <xsl:apply-templates select="." mode="m:seglist-table"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="db:segtitle"/>

<xsl:template match="db:segtitle" mode="m:segtitle-in-seg">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:seglistitem">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:seg">
  <xsl:variable name="segnum" select="count(preceding-sibling::db:seg)+1"/>
  <xsl:variable name="seglist" select="ancestor::db:segmentedlist"/>
  <xsl:variable name="segtitles" select="$seglist/db:segtitle"/>

  <!--
     Note: segtitle is only going to be the right thing in a well formed
     SegmentedList.  If there are too many Segs or too few SegTitles,
     you'll get something odd...maybe an error
  -->

  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <strong>
      <span class="segtitle">
        <xsl:apply-templates select="$segtitles[$segnum=position()]"
                             mode="m:segtitle-in-seg"/>
        <xsl:text>: </xsl:text>
      </span>
    </strong>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:segmentedlist" mode="m:seglist-table">
  <xsl:variable name="table-summary"
		select="f:pi(processing-instruction('dbhtml'),
			     'table-summary')"/>

  <xsl:variable name="list-width"
		select="f:pi(processing-instruction('dbhtml'),
			     'list-width')"/>

  <table border="0">
    <xsl:if test="$list-width != ''">
      <xsl:attribute name="width">
        <xsl:value-of select="$list-width"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$table-summary != ''">
      <xsl:attribute name="summary">
        <xsl:value-of select="$table-summary"/>
      </xsl:attribute>
    </xsl:if>
    <thead class="segtitles">
      <tr>
        <xsl:apply-templates select="db:segtitle" mode="m:seglist-table"/>
      </tr>
    </thead>
    <tbody>
      <xsl:apply-templates select="db:seglistitem" mode="m:seglist-table"/>
    </tbody>
  </table>
</xsl:template>

<xsl:template match="db:segtitle" mode="m:seglist-table">
  <th>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </th>
</xsl:template>

<xsl:template match="db:seglistitem" mode="m:seglist-table">
  <xsl:variable name="seglinum">
    <xsl:number from="db:segmentedlist" count="db:seglistitem"/>
  </xsl:variable>

  <tr>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:seglist-table"/>
  </tr>
</xsl:template>

<xsl:template match="db:seg" mode="m:seglist-table">
  <td>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </td>
</xsl:template>

</xsl:stylesheet>
