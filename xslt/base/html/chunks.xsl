<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:ch="http://docbook.sf.net/xmlns/chunk"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:out="http://docbook.org/xslt/ns/output"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="ch db f fn h m mp out t xs"
                version="2.0">

<xsl:param name="chunks" select="'0'" as="xs:string"/>

<xsl:output name="out:xhtml"
            method="xhtml"
            encoding="utf-8"
            indent="no"/>

<xsl:output name="out:xml"
            method="xml"
            encoding="utf-8"
            indent="no"/>

<xsl:variable name="chunk-tree" as="document-node()?">
  <xsl:if test="$chunks != '0' and $chunks != 'false'">
    <xsl:document>
      <xsl:apply-templates select="/" mode="m:identify-chunks"/>
    </xsl:document>
  </xsl:if>
</xsl:variable>

<xsl:variable name="chunk-elements" as="element()*">
  <xsl:variable name="root" select="/"/>
  <xsl:sequence select="$chunk-tree//h:chunk ! key('genid', @xml:id, $root)"/>
</xsl:variable>

<xsl:function name="f:chunk" as="xs:boolean">
  <xsl:param name="node" as="element()"/>
  <xsl:sequence select="exists($chunk-tree)
                        and exists(key('id', generate-id($node), $chunk-tree))"/>
</xsl:function>

<!-- ============================================================ -->

<xsl:template name="t:chunk">
  <xsl:param name="content" as="node()*" required="yes"/>

  <xsl:variable name="chunkfn" select="f:chunk-filename(.)"/>
  <xsl:variable name="pinav"
                select="(f:pi(./processing-instruction('dbhtml'), 'navigation'),
                         'true')[1]"/>

  <xsl:variable name="chunk"
                select="key('id', generate-id(.), $chunk-tree)"/>
  <xsl:variable name="nchunk"
                select="($chunk/following::h:chunk|$chunk/descendant::h:chunk)[1]"/>
  <xsl:variable name="pchunk"
                select="($chunk/preceding::h:chunk|$chunk/parent::h:chunk)[last()]"/>
  <xsl:variable name="uchunk"
                select="$chunk/ancestor::h:chunk[1]"/>

  <xsl:call-template name="t:write-chunk">
    <xsl:with-param name="filename" select="concat($base.dir, $chunkfn)"/>
    <xsl:with-param name="content">
      <xsl:call-template name="t:chunk-structure">
        <xsl:with-param name="preamble">
          <xsl:apply-templates select="." mode="m:pre-root"/>
        </xsl:with-param>
        <xsl:with-param name="head-content">
          <xsl:apply-templates select="." mode="mp:html-head"/>
        </xsl:with-param>
        <xsl:with-param name="page-header">
          <xsl:if test="$pinav = 'true'">
            <xsl:apply-templates select="." mode="m:user-header-content">
              <xsl:with-param name="node" select="."/>
              <xsl:with-param name="next" select="key('genid', $nchunk/@xml:id)"/>
              <xsl:with-param name="prev" select="key('genid', $pchunk/@xml:id)"/>
              <xsl:with-param name="up" select="key('genid', $uchunk/@xml:id)"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="page-footer">
          <xsl:if test="$pinav = 'true'">
            <xsl:apply-templates select="." mode="m:user-footer-content">
              <xsl:with-param name="node" select="."/>
              <xsl:with-param name="next" select="key('genid', $nchunk/@xml:id)"/>
              <xsl:with-param name="prev" select="key('genid', $pchunk/@xml:id)"/>
              <xsl:with-param name="up" select="key('genid', $uchunk/@xml:id)"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="page-main" select="$content"/>
        <xsl:with-param name="chunk" select="$chunk"/>
        <xsl:with-param name="chunk-next" select="$nchunk"/>
        <xsl:with-param name="chunk-prev" select="$pchunk"/>
        <xsl:with-param name="chunk-up" select="$uchunk"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="/" mode="m:identify-chunks">
  <xsl:apply-templates select="*" mode="m:identify-chunks"/>
</xsl:template>

<xsl:template match="/*" mode="m:identify-chunks" priority="100">
  <chunk>
    <xsl:attribute name="xml:id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:apply-templates select="*" mode="m:identify-chunks"/>
  </chunk>
</xsl:template>

<xsl:template match="db:set|db:book|db:part|db:reference|db:refentry"
              mode="m:identify-chunks">
  <chunk>
    <xsl:attribute name="xml:id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:apply-templates select="*" mode="m:identify-chunks"/>
  </chunk>
</xsl:template>

<xsl:template match="db:preface|db:chapter|db:appendix|db:colophon"
              mode="m:identify-chunks">
  <chunk>
    <xsl:attribute name="xml:id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:apply-templates select="*" mode="m:identify-chunks"/>
  </chunk>
</xsl:template>

<xsl:template match="db:book/db:bibliography|db:book/db:glossary"
              mode="m:identify-chunks">
  <chunk>
    <xsl:attribute name="xml:id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:apply-templates select="*" mode="m:identify-chunks"/>
  </chunk>
</xsl:template>

<xsl:template match="db:book/db:index|db:setindex"
              mode="m:identify-chunks">
  <chunk>
    <xsl:attribute name="xml:id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:apply-templates select="*" mode="m:identify-chunks"/>
  </chunk>
</xsl:template>

<xsl:template match="db:partintro/db:section
                     |db:partintro/db:sect1
                     |db:partintro/db:sect2
                     |db:partintro/db:sect3
                     |db:partintro/db:sect4
                     |db:partintro/db:sect5"
              mode="m:identify-chunks"
              priority="10">
  <xsl:apply-templates select="*" mode="m:identify-chunks"/>
</xsl:template>

<xsl:template match="db:section|db:sect1|db:sect2|db:sect3|db:sect4|db:sect5"
              mode="m:identify-chunks">
  <xsl:variable name="might-chunk" as="xs:boolean">
    <xsl:choose>
      <xsl:when test="self::db:section">
        <xsl:sequence select="$chunk.section.depth &gt; count(ancestor::db:section)"/>
      </xsl:when>
      <xsl:when test="self::db:sect1">
        <xsl:sequence select="$chunk.section.depth &gt; 0"/>
      </xsl:when>
      <xsl:when test="self::db:sect2">
        <xsl:sequence select="$chunk.section.depth &gt; 1"/>
      </xsl:when>
      <xsl:when test="self::db:sect3">
        <xsl:sequence select="$chunk.section.depth &gt; 2"/>
      </xsl:when>
      <xsl:when test="self::db:sect4">
        <xsl:sequence select="$chunk.section.depth &gt; 3"/>
      </xsl:when>
      <xsl:when test="self::db:sect5">
        <xsl:sequence select="$chunk.section.depth &gt; 4"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
        <xsl:text>might-chunk </xsl:text>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text>?</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="ancestor::*/processing-instruction('dbhtml')
                    [normalize-space(.) = 'stop-chunking']">
      <xsl:apply-templates select="*" mode="m:identify-chunks"/>
    </xsl:when>
    <xsl:when test="$might-chunk">
      <chunk>
        <xsl:attribute name="xml:id">
          <xsl:value-of select="generate-id()"/>
        </xsl:attribute>
        <xsl:apply-templates select="*" mode="m:identify-chunks"/>
      </chunk>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*" mode="m:identify-chunks"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="m:identify-chunks">
  <xsl:apply-templates select="*" mode="m:identify-chunks"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:function name="f:chunk-filename" as="xs:string">
  <xsl:param name="chunk" as="element()"/>

  <xsl:variable name="pis"  select="$chunk/processing-instruction('dbhtml')"/>
  <xsl:variable name="pibn" select="f:pi($pis, 'basename')"/>

  <!-- typing href instead of filename is a common mistake. -->
  <xsl:variable name="pifn"
                select="if (empty(f:pi($pis, 'filename')))
                        then f:pi($pis, 'href')
                        else f:pi($pis, 'filename')"/>

  <xsl:choose>
    <xsl:when test="string($pifn) != ''">
      <xsl:sequence select="string($pifn)"/>
    </xsl:when>
    <xsl:when test="string($pibn) != ''">
      <xsl:sequence select="concat($pibn, $html.ext)"/>
    </xsl:when>
    <xsl:when test="$chunk/@xml:id and $use.id.as.filename">
      <xsl:sequence select="concat($chunk/@xml:id,$html.ext)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="concat('chunk-', local-name($chunk),
                                   '-', generate-id($chunk), $html.ext)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

  <xsl:function name="f:chunk-href" as="xs:string">
    <xsl:param name="context" as="node()"/>
    <xsl:param name="node" as="element()"/>

    <xsl:variable name="context-chunk"
                  select="$context/ancestor-or-self::*[. intersect $chunk-elements][1]"/>
    <xsl:variable name="node-chunk"
                  select="$node/ancestor-or-self::*[. intersect $chunk-elements][1]"/>

    <xsl:choose>
      <xsl:when test="$context-chunk = $node-chunk">
        <xsl:sequence select="concat('#', f:node-id($node))"/>
      </xsl:when>
      <xsl:when test="$node-chunk = $node">
        <xsl:sequence select="f:chunk-filename($node-chunk)"/>
      </xsl:when>
      <xsl:when test="empty($node-chunk)">
        <xsl:message>
          <xsl:text>Warning: broken link to </xsl:text>
          <xsl:sequence select="f:node-id($node)"/>
          <xsl:text>; not in output.</xsl:text>
        </xsl:message>
        <xsl:sequence select="concat('#',f:node-id($node))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="concat(f:chunk-filename($node-chunk),'#',f:node-id($node))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

<!-- ============================================================ -->

<xsl:template name="t:write-chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="quiet" select="true()"/>
  <xsl:param name="output" select="'out:xhtml'"/>
  <xsl:param name="content"/>

  <xsl:if test="not($quiet)">
    <xsl:message>
      <xsl:text>Writing </xsl:text>
      <xsl:value-of select="$filename"/>
      <xsl:if test="name(.) != ''">
        <xsl:text> for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:if test="@id">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:message>
  </xsl:if>

  <xsl:result-document href="{$filename}" format="{$output}">
    <xsl:sequence select="$content"/>
  </xsl:result-document>
</xsl:template>

<xsl:template name="t:chunk-structure">
  <xsl:param name="preamble" as="node()*" required="yes"/>
  <xsl:param name="head-content" as="node()*" required="yes"/>
  <xsl:param name="page-header" as="node()*" required="yes"/>
  <xsl:param name="page-footer" as="node()*" required="yes"/>
  <xsl:param name="page-main" as="node()*" required="yes"/>
  <xsl:param name="chunk" as="element()" required="yes"/>
  <xsl:param name="chunk-next" as="element()?" required="yes"/>
  <xsl:param name="chunk-prev" as="element()?" required="yes"/>
  <xsl:param name="chunk-up" as="element()?" required="yes"/>

  <xsl:sequence select="$preamble"/>
  <html>
    <head>
      <xsl:sequence select="$head-content"/>
    </head>
    <body>
      <xsl:call-template name="t:body-attributes"/>
      <div class="page">
        <xsl:if test="@status">
          <xsl:attribute name="class" select="@status"/>
        </xsl:if>

        <div class="content">
          <xsl:sequence select="$page-header"/>
          <div class="body">
            <xsl:sequence select="$page-main"/>
          </div>
        </div>

        <xsl:sequence select="$page-footer"/>
      </div>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
