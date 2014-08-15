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

<doc:template name="adjust-column-widths" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Adjust column width values for HTML or XSL-FO</refpurpose>

<refdescription>
<para>CALS tables support column widths expressed in absolute (2.5in),
relative (2*), and mixed terms (1.5*+0.5in). HTML and XSL-FO support
column widths
expressed in either absolute units (only pixels in the HTML case)
or as a percentage of the total table width. This template takes an
HTML <tag>colgroup</tag> containing columns with widths expressed in CALS
terms and returns the equivalent group with columns expressed in terms
acceptable to HTML or XSL-FO.</para>

<itemizedlist>
<listitem>
<para>If there are no relative widths, the absolute widths are returned.</para>
</listitem>
<listitem>
<para>If there are no absolute widths, the relative widths are returned.</para>
</listitem>
<listitem>
<para>If there are a mixture of relative and absolute widths,</para>
  <itemizedlist>
  <listitem>
  <para>If the table width is absolute, all the column widths are converted
        to absolute widths and those are returned.</para>
  </listitem>
  <listitem>
  <para>If the table width is relative, all the column widths are converted
        to absolute widths based on a
	<parameter>table.width.nominal</parameter>. Then each width is
	converted back to a percentage and those are returned.</para>
  </listitem>
  </itemizedlist>
</listitem>
</itemizedlist>
</refdescription>

<refparameter>
<variablelist>
<varlistentry role="required"><term>table-width</term>
<listitem>
<para>The width of the table.</para>
</listitem>
</varlistentry>
<varlistentry role="required"><term>colgroup</term>
<listitem>
<para>The column group to adjust.</para>
</listitem>
</varlistentry>
<varlistentry><term>abspixels</term>
<listitem>
<para>Specifies if absolute widths should be expressed in pixels: 0 for
false, any other value for true. Converting lengths to pixels is dependent
on the <parameter>pixels.per.inch</parameter> parameter.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The adjusted column group.</para>
</refreturn>

<u:unittests template="adjust-column-widths">
  <u:param name="pixels.per.inch" select="96"/>
  <u:param name="table.width.nominal" select="6 * $pixels.per.inch"/>
  <u:test>
    <u:param name="table-width" select="'6in'"/>
    <u:param name="colgroup" as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml">
	<col width="3.5*"/>
	<col width="2*"/>
	<col/>
	<col width="1*"/>
      </colgroup>
    </u:param>
    <u:param name="abspixels">1</u:param>
    <u:result as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="47%"/>
	<col width="27%"/>
	<col width="13%"/>
	<col width="13%"/>
      </colgroup>
    </u:result>
  </u:test>
  <u:test>
    <u:param name="table-width">6in</u:param>
    <u:param name="colgroup" as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml">
	<col width="2in"/>
	<col width="3in"/>
	<col width="8pt"/>
	<col width="1in"/>
      </colgroup>
    </u:param>
    <u:param name="abspixels">1</u:param>
    <u:result as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="192"/>
	<col width="288"/>
	<col width="10"/>
	<col width="96"/>
      </colgroup>
    </u:result>
  </u:test>
  <u:test>
    <u:param name="table-width">6in</u:param>
    <u:param name="colgroup" as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="3.5*+2in" colname="foo"/>
	<col width="2*"/>
	<col/>
	<col width="1in" align="right"/>
      </colgroup>
    </u:param>
    <u:param name="abspixels">1</u:param>
    <u:result as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="502" colname="foo"/>
	<col width="177"/>
	<col width="89"/>
	<col width="96" align="right"/>
      </colgroup>
    </u:result>
  </u:test>
  <u:test>
    <u:param name="table-width">'100%'</u:param>
    <u:param name="colgroup" as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="3.5*+2in" colname="foo"/>
	<col width="2*"/>
	<col/>
	<col width="1in" align="right"/>
      </colgroup>
    </u:param>
    <u:param name="abspixels">1</u:param>
    <u:result as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="58.12%" colname="foo"/>
	<col width="20.51%"/>
	<col width="10.26%"/>
	<col width="11.11%" align="right"/>
      </colgroup>
    </u:result>
  </u:test>
  <u:test>
    <u:param name="table-width">6in</u:param>
    <u:param name="colgroup" as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="3.5*+2in" colname="foo"/>
	<col width="2*"/>
	<col/>
	<col width="1in" align="right"/>
      </colgroup>
    </u:param>
    <u:result as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="5.23in" colname="foo"/>
	<col width="1.85in"/>
	<col width="0.92in"/>
	<col width="1.00in" align="right"/>
      </colgroup>
    </u:result>
  </u:test>
  <u:test>
    <u:param name="table-width">100%</u:param>
    <u:param name="colgroup" as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="1in"/>
	<col width="1*"/>
	<col width="5*"/>
	<col width="1*+0.5in"/>
      </colgroup>
    </u:param>
    <u:result as="element()">
      <colgroup xmlns="http://www.w3.org/1999/xhtml"> 
	<col width="5.23in" colname="foo"/>
	<col width="1.85in"/>
	<col width="0.92in"/>
	<col width="1.00in" align="right"/>
      </colgroup>
    </u:result>
  </u:test>
</u:unittests>
</doc:template>

<xsl:template name="adjust-column-widths" as="element(html:colgroup)">
  <xsl:param name="table-width" as="xs:string"/>
  <xsl:param name="colgroup" as="element()"/>
  <xsl:param name="abspixels" select="0"/>

  <xsl:variable name="specify-widths"
                select="$default.table.column.widths != 0 or exists($colgroup/h:col/@width)"/>

  <xsl:variable name="parsedcols" as="element()*">
    <xsl:for-each select="$colgroup/*">
      <xsl:choose>
	<xsl:when test="not(@width)">
	  <col ghost:rel="1" ghost:abs="0">
	    <xsl:copy-of select="@*"/>
	  </col>
	</xsl:when>
	<xsl:when test="contains(@width, '*')">
	  <col ghost:rel="{substring-before(@width, '*')}"
	       ghost:abs="{if (substring-after(@width, '*') = '')
			   then 0
			   else f:convert-length(substring-after(@width, '*'))}">
	    <xsl:copy-of select="@*"/>
	  </col>
	</xsl:when>
	<xsl:when test="matches(@width, '^\d+$')">
	  <col ghost:rel="0"
	       ghost:abs="{f:convert-length(concat(@width,'px'))}">
	    <xsl:copy-of select="@*"/>
	  </col>
	</xsl:when>
	<xsl:otherwise>
	  <col ghost:rel="0" ghost:abs="{f:convert-length(@width)}">
	    <xsl:copy-of select="@*"/>
	  </col>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <colgroup xmlns="http://www.w3.org/1999/xhtml">
    <xsl:choose>
      <xsl:when test="sum($parsedcols/@ghost:rel) = 0">
	<xsl:for-each select="$parsedcols">
	  <col class="tcol{position()}">
	    <xsl:copy-of select="@*[namespace-uri(.) != 'http://docbook.org/ns/docbook/ephemeral']"/>
            <xsl:if test="$specify-widths">
              <xsl:attribute name="width">
                <xsl:choose>
                  <xsl:when test="$abspixels = 0">
                    <xsl:value-of select="format-number(@ghost:abs div $pixels.per.inch,
                                                        '0.00')"/>
                    <xsl:text>in</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@ghost:abs"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </xsl:if>
          </col>
	</xsl:for-each>
      </xsl:when>
      <xsl:when test="sum($parsedcols/@ghost:abs) = 0">
	<xsl:variable name="relTotal" select="sum($parsedcols/@ghost:rel)"/>
	<xsl:for-each select="$parsedcols">
	  <col class="tcol{position()}">
	    <xsl:copy-of select="@*[namespace-uri(.) != 'http://docbook.org/ns/docbook/ephemeral']"/>
            <xsl:if test="$specify-widths">
              <xsl:attribute name="width">
                <xsl:value-of select="round(@ghost:rel div $relTotal * 100)"/>
                <xsl:text>%</xsl:text>
              </xsl:attribute>
            </xsl:if>
	  </col>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="relTotal" select="sum($parsedcols/@ghost:rel)"/>
	<xsl:variable name="pixelwidth"
		      select="if (contains($table-width, '%'))
			      then f:convert-length($table.width.nominal)
			      else f:convert-length($table-width)"/>
        <xsl:variable name="relwidth"
                      select="$pixelwidth - sum($parsedcols/@ghost:abs)"/>

	<xsl:variable name="convcols" as="element()*">
	  <xsl:for-each select="$parsedcols">

            <!--
	    <xsl:message>
	      <xsl:value-of select="position()"/>
	      <xsl:text>=</xsl:text>
	      <xsl:value-of select="@ghost:rel"/>
	      <xsl:text>,</xsl:text>
	      <xsl:value-of select="@ghost:abs"/>
	      <xsl:text>; </xsl:text>
	      <xsl:value-of select="$relTotal"/>
	      <xsl:text>; </xsl:text>
	      <xsl:value-of select="$pixelwidth"/>
	      <xsl:text>; </xsl:text>
	      <xsl:value-of select="$relwidth"/>
	    </xsl:message>
            -->

	    <col class="tcol{position()}">
	      <xsl:copy-of select="@*"/>
	      <xsl:attribute name="ghost:rel"
			     select="(@ghost:rel div $relTotal * $relwidth)
				     + @ghost:abs"/>
	    </col>
	  </xsl:for-each>
	</xsl:variable>

	<xsl:variable name="absTotal" select="sum($convcols/@ghost:rel)"/>

	<xsl:if test="$absTotal &gt; $pixelwidth">
	  <xsl:message>
	    <xsl:text>Warning: table is wider than specified width. (</xsl:text>
	    <xsl:value-of select="$absTotal"/>
	    <xsl:text> vs. </xsl:text>
	    <xsl:value-of select="$pixelwidth"/>
	    <xsl:text>)</xsl:text>
	  </xsl:message>
	</xsl:if>

	<xsl:choose>
	  <xsl:when test="contains($table-width, '%')">
	    <xsl:for-each select="$convcols">
	      <col class="tcol{position()}">
		<xsl:copy-of select="@*[namespace-uri(.)
			        != 'http://docbook.org/ns/docbook/ephemeral']"/>
                <xsl:if test="$specify-widths">
                  <xsl:attribute name="width">
                    <xsl:value-of select="format-number(@ghost:rel div $absTotal * 100,
                                                        '0.00')"/>
                    <xsl:text>%</xsl:text>
                  </xsl:attribute>
                </xsl:if>
	      </col>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:for-each select="$convcols">
	      <col class="tcol{position()}">
		<xsl:copy-of select="@*[namespace-uri(.) != 'http://docbook.org/ns/docbook/ephemeral']"/>
                <xsl:if test="$specify-widths">
                  <xsl:attribute name="width">
                    <xsl:choose>
                      <xsl:when test="$abspixels = 0">
                        <xsl:value-of select="format-number(@ghost:rel div $pixels.per.inch,
					                    '0.00')"/>
                        <xsl:text>in</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="round(@ghost:rel)"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                </xsl:if>
	      </col>
	    </xsl:for-each>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </colgroup>
</xsl:template>

<!-- ============================================================ -->

<doc:function name="f:convert-length" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Converts a length to pixels</refpurpose>

<refdescription>
<para>This function converts a length, for example, “3mm” or “2in”,
into an integral number of pixels. The size of a pixel is determined
by the <parameter>pixels.per.inch</parameter> parameter.</para>
<para>The following units are recognized: inches (in), centimeters
(cm), milimeters (mm), picas (pc), points (pt), and pixels (px).
A value specified without units is assumed to be pixels. For convenience,
if a percentage is provided, it is returned unchanged.</para>
<para>If an unrecognized unit is specified, it is treated like “1in”.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>length</term>
<listitem>
<para>The length to convert.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The converted length, an integral number of pixels, unless the
length specified was a percentage, in which case it is returned unchanged.</para>
</refreturn>

<u:unittests function="f:convert-length">
  <u:test>
    <u:param>1in</u:param>
    <u:result>96</u:result>
  </u:test>
  <u:test>
    <u:param select="'+2in'"/>
    <u:result>192</u:result>
  </u:test>
  <u:test>
    <u:param>100pt</u:param>
    <u:result>133</u:result>
  </u:test>
  <u:test>
    <u:param>50%</u:param>
    <u:result>'50%'</u:result>
  </u:test>
  <u:test>
    <u:param>10barleycorn</u:param>
    <u:result>96</u:result>
  </u:test>
</u:unittests>

</doc:function>

<xsl:function name="f:convert-length">
  <xsl:param name="length" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="contains($length, '%')">
      <xsl:value-of select="$length"/>
    </xsl:when>
    <xsl:when test="$length castable as xs:double">
      <xsl:value-of select="round($length cast as xs:double)"/>
    </xsl:when>
    <xsl:when test="matches($length, '^[\+\-]?\d+\.?\d*\w+$')">
      <xsl:variable name="spaced"
		    select="replace($length,
			            '(^[\+\-]?\d+\.?\d*)(\w+)$',
				    '$1 $2')"/>
      <xsl:variable name="magnitude"
		    select="xs:double(substring-before($spaced, ' '))"/>
      <xsl:variable name="units" select="substring-after($spaced, ' ')"/>
      <xsl:choose>
	<xsl:when test="$units = 'in'">
	  <xsl:value-of select="xs:integer($magnitude * $pixels.per.inch)"/>
	</xsl:when>
	<xsl:when test="$units = 'cm'">
	  <xsl:value-of select="xs:integer($magnitude * $pixels.per.inch div 2.54)"/>
	</xsl:when>
	<xsl:when test="$units = 'mm'">
	  <xsl:value-of select="xs:integer($magnitude * $pixels.per.inch div 25.4)"/>
	</xsl:when>
	<xsl:when test="$units = 'pc'">
	  <xsl:value-of select="xs:integer($magnitude * $pixels.per.inch div 72 * 12)"/>
	</xsl:when>
	<xsl:when test="$units = 'pt'">
	  <xsl:value-of select="xs:integer($magnitude * $pixels.per.inch div 72)"/>
	</xsl:when>
	<xsl:when test="$units = 'px'">
	  <xsl:value-of select="xs:integer($magnitude)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>
	    <xsl:text>Unrecognized units in f:convert-length: </xsl:text>
	    <xsl:value-of select="$units"/>
	  </xsl:message>
	  <!-- 1in -->
	  <xsl:value-of select="$pixels.per.inch"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
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
