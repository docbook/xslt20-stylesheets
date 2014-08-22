<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:ext="http://docbook.org/extensions/xslt20"
                xmlns:xdmp="http://marklogic.com/xdmp"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:tp="http://docbook.org/xslt/ns/template/private"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="doc h f m mp fn db t ext xdmp xs tp"
                version="2.0">

<xsl:template match="db:programlistingco|db:screenco">
  <xsl:variable name="lines" as="xs:string*">
    <xsl:for-each select="db:areaspec//db:area">
      <xsl:choose>
        <xsl:when test="@units = 'linecolumn' or not(@units)">
          <xsl:value-of select="tokenize(@coords,'\s+')[1]"/>
        </xsl:when>
        <xsl:when test="@units = 'linerange'">
          <xsl:variable name="l1" select="tokenize(@coords,'\s+')[1]"/>
          <xsl:variable name="l2" select="tokenize(@coords,'\s+')[2]"/>
          <xsl:if test="$l1 ne '' and $l2 ne ''">
            <xsl:value-of select="concat($l1,'-',$l2)"/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="@units = 'linecolumnpair'">
          <xsl:variable name="l1" select="tokenize(@coords,'\s+')[1]"/>
          <xsl:variable name="l2" select="tokenize(@coords,'\s+')[3]"/>
          <xsl:if test="$l1 ne '' and $l2 ne ''">
            <xsl:value-of select="concat($l1,'-',$l2)"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Unable to process area with </xsl:text>
            <xsl:value-of select="@units"/>
            <xsl:text> coords.</xsl:text>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <xsl:apply-templates select="db:programlisting|db:screen" mode="m:verbatim">
    <xsl:with-param name="lines" select="$lines"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="db:calloutlist"/>
</xsl:template>

<xsl:template match="db:programlisting|db:address|db:screen
                     |db:synopsis|db:literallayout">
  <xsl:apply-templates select="." mode="m:verbatim"/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:verbatim" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing normalized verbatim elements</refpurpose>

<refdescription>
<para>This mode is used to format normalized verbatim elements.</para>
</refdescription>
</doc:mode>

<xsl:function name="f:lastLineNumber" as="xs:decimal">
  <xsl:param name="listing" as="element()"/>

  <xsl:variable name="startnum" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="$listing/@continuation != 'continues'">
        <xsl:value-of select="0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="prev"
             select="$listing/preceding::*[node-name(.)=node-name($listing)][1]"/>
        <xsl:choose>
          <xsl:when test="empty($prev)">
            <xsl:value-of select="0"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="f:lastLineNumber($prev)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alltext" select="string-join($listing//text(), ' ')"/>
  <xsl:value-of select="count(tokenize($alltext,'&#10;'))"/>
</xsl:function>

<xsl:template match="db:programlisting|db:synopsis"
	      mode="m:verbatim">
  <xsl:param name="lines" select="()" as="xs:string*"/>
  <xsl:variable name="this" select="."/>

  <xsl:variable name="startno" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="@startinglinenumber">
        <xsl:value-of select="xs:decimal(@startinglinenumber) - 1"/>
      </xsl:when>
      <xsl:when test="@continuation = 'continues'">
        <xsl:variable name="prev"
             select="preceding::*[node-name(.)=node-name($this)][1]"/>
        <xsl:choose>
          <xsl:when test="empty($prev)">
            <xsl:value-of select="0"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="f:lastLineNumber($prev)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="numbered" as="xs:boolean"
                select="f:lineNumbering(.,'everyNth') != 0"/>

  <xsl:variable name="data-attr" as="attribute()*">
    <xsl:choose>
      <xsl:when test="$syntax-highlighter = '0'">
        <!-- nop -->
      </xsl:when>
      <xsl:when test="empty($lines)">
        <xsl:if test="$startno != 0 and $numbered">
          <xsl:attribute name="data-start" select="$startno + 1"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$startno != 0">
            <xsl:attribute name="data-line-offset" select="$startno"/>
            <xsl:variable name="adj-lines" as="xs:string*">
              <xsl:for-each select="$lines">
                <xsl:choose>
                  <xsl:when test="contains(.,'-')">
                    <xsl:variable name="l1" select="substring-before(.,'-')"/>
                    <xsl:variable name="l2" select="substring-after(.,'-')"/>
                    <xsl:value-of select="concat(xs:decimal($l1) + $startno,
                                                 '-',
                                                 xs:decimal($l2) + $startno)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="xs:decimal(.) + $startno"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:variable>
            <xsl:attribute name="data-line" select="string-join($adj-lines,',')"/>
          </xsl:when>
          <xsl:otherwise>
          <xsl:attribute name="data-line" select="string-join($lines,',')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pre" as="element()">
    <pre>
      <xsl:sequence select="$data-attr"/>
      <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.),
                                              f:syntax-highlight-class($this))"/>
      <code>
        <xsl:apply-templates/>
      </code>
    </pre>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$syntax-highlighter = '0' and $numbered">
      <div class="numbered-verbatim">
        <table border="0">
          <tr>
            <td align="right" valign="top">
              <pre class="line-numbers">
                <xsl:for-each
                    select="tokenize(string-join($pre/h:code//text(),''),'&#10;')">
                  <code class="line-number">
                    <xsl:value-of select="position() + $startno"/>
                  </code>
                  <xsl:text>&#10;</xsl:text>
                </xsl:for-each>
              </pre>
            </td>
            <td valign="top">
              <xsl:sequence select="$pre"/>
            </td>
          </tr>
        </table>
      </div>
    </xsl:when>
    <xsl:when test="$syntax-highlighter = '0'"> <!-- and not($numbered) -->
      <div class="unnumbered-verbatim">
        <xsl:sequence select="$pre"/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$pre"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:screen|db:literallayout[@class='monospaced']"
	      mode="m:verbatim">
  <xsl:variable name="this" select="."/>
  <pre>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.),
                                            f:syntax-highlight-class($this))"/>
    <xsl:apply-templates/>
  </pre>
</xsl:template>

<xsl:template match="db:literallayout|db:address"
	      mode="m:verbatim">
  <xsl:variable name="this" select="."/>
  <div>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.),
                                            f:syntax-highlight-class($this))"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

</xsl:stylesheet>
