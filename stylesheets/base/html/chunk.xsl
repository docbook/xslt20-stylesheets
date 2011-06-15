<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:ch="http://docbook.sf.net/xmlns/chunk"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="ch db f fn h m t xs"
                version="2.0">

  <xsl:import href="docbook.xsl"/>

  <xsl:param name="html.ext" select="'.html'"/>
  <xsl:param name="base.dir" select="''"/>

  <!-- ====================================================================== -->

  <xsl:variable name="chunk-tree" as="document-node()">
    <xsl:document>
      <xsl:apply-templates select="/" mode="m:identify-chunks"/>
    </xsl:document>
  </xsl:variable>

  <xsl:template match="/" mode="m:identify-chunks">
    <xsl:apply-templates select="*" mode="m:identify-chunks"/>
  </xsl:template>

  <xsl:template match="/*" mode="m:identify-chunks" priority="100">
    <chunk xml:id="{generate-id()}">
      <xsl:apply-templates select="*" mode="m:identify-chunks"/>
    </chunk>
  </xsl:template>

  <xsl:template match="db:book|db:part|db:reference|db:refentry" mode="m:identify-chunks">
    <chunk xml:id="{generate-id()}">
      <xsl:apply-templates select="*" mode="m:identify-chunks"/>
    </chunk>
  </xsl:template>

  <xsl:template match="db:preface|db:chapter|db:appendix|db:colophon" mode="m:identify-chunks">
    <chunk xml:id="{generate-id()}">
      <xsl:apply-templates select="*" mode="m:identify-chunks"/>
    </chunk>
  </xsl:template>

  <xsl:template match="db:book/db:bibliography|db:book/db:glossary" mode="m:identify-chunks">
    <chunk xml:id="{generate-id()}">
      <xsl:apply-templates select="*" mode="m:identify-chunks"/>
    </chunk>
  </xsl:template>

  <xsl:template match="db:book/db:index|db:setindex" mode="m:identify-chunks">
    <chunk xml:id="{generate-id()}">
      <xsl:apply-templates select="*" mode="m:identify-chunks"/>
    </chunk>
  </xsl:template>

  <xsl:template match="*" mode="m:identify-chunks">
    <xsl:apply-templates select="*" mode="m:identify-chunks"/>
  </xsl:template>

  <xsl:variable name="chunks" as="element()*">
    <xsl:variable name="root" select="/"/>
    <xsl:for-each select="$chunk-tree//h:chunk">
      <xsl:sequence select="key('genid', @xml:id, $root)"/>
    </xsl:for-each>
  </xsl:variable>

  <!-- ====================================================================== -->

  <xsl:template match="/">
    <xsl:apply-templates select="$chunks" mode="m:chunk"/>
  </xsl:template>

  <xsl:template match="*" mode="m:chunk">
    <xsl:variable name="chunkfn" select="f:chunk-filename(.)"/>

    <xsl:variable name="pinav"
                  select="(f:pi(./processing-instruction('dbhtml'), 'navigation'),'true')[1]"/>

    <xsl:variable name="chunk" select="key('id', generate-id(.), $chunk-tree)"/>
    <xsl:variable name="nchunk" select="($chunk/following::h:chunk|$chunk/descendant::h:chunk)[1]"/>
    <xsl:variable name="pchunk" select="($chunk/preceding::h:chunk|$chunk/parent::h:chunk)[last()]"/>
    <xsl:variable name="uchunk" select="$chunk/ancestor::h:chunk[1]"/>

    <xsl:result-document href="{$base.dir}{$chunkfn}" method="xhtml" indent="no">
      <html>
        <xsl:call-template name="t:head">
          <xsl:with-param name="root" select="."/>
        </xsl:call-template>
        <body>
          <xsl:call-template name="t:body-attributes"/>
          <xsl:if test="@status">
            <xsl:attribute name="class" select="@status"/>
          </xsl:if>

          <xsl:if test="$pinav = 'true'">
            <xsl:call-template name="t:user-header-content">
              <xsl:with-param name="node" select="."/>
              <xsl:with-param name="next" select="key('genid', $nchunk/@xml:id)"/>
              <xsl:with-param name="prev" select="key('genid', $pchunk/@xml:id)"/>
              <xsl:with-param name="up" select="key('genid', $uchunk/@xml:id)"/>
            </xsl:call-template>
          </xsl:if>

          <xsl:apply-templates select=".">
            <xsl:with-param name="override-chunk" select="true()"/>
          </xsl:apply-templates>

          <xsl:if test="$pinav = 'true'">
            <xsl:call-template name="t:user-footer-content">
              <xsl:with-param name="node" select="."/>
              <xsl:with-param name="next" select="key('genid', $nchunk/@xml:id)"/>
              <xsl:with-param name="prev" select="key('genid', $pchunk/@xml:id)"/>
              <xsl:with-param name="up" select="key('genid', $uchunk/@xml:id)"/>
            </xsl:call-template>
          </xsl:if>
        </body>
      </html>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="*">
    <xsl:param name="override-chunk" as="xs:boolean" select="false()"/>

    <xsl:choose>
      <xsl:when test="not($override-chunk) and key('id', generate-id(.), $chunk-tree)">
        <!--
        <xsl:message>
          <xsl:text>Suppress inline formatting of chunk: </xsl:text>
          <xsl:value-of select="local-name(.)"/>
        </xsl:message>
        -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ====================================================================== -->

  <xsl:function name="f:chunk-filename" as="xs:string">
    <xsl:param name="chunk" as="element()"/>

    <xsl:variable name="pifn" select="f:pi($chunk/processing-instruction('dbhtml'), 'filename')"/>

    <xsl:choose>
      <xsl:when test="string($pifn) = ''">
        <xsl:value-of select="concat('chunk-', local-name($chunk),
                                     '-', generate-id($chunk), $html.ext)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pifn"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- ====================================================================== -->

  <xsl:function name="f:href" as="xs:string">
    <xsl:param name="context" as="node()"/>
    <xsl:param name="node" as="element()"/>

    <xsl:variable name="context-chunk" select="f:find-chunk($context)"/>
    <xsl:variable name="node-chunk" select="f:find-chunk($node)"/>

    <xsl:choose>
      <xsl:when test="$context-chunk = $node-chunk">
        <xsl:value-of select="concat('#', f:node-id($node))"/>
      </xsl:when>
      <xsl:when test="$node-chunk = $node">
        <xsl:value-of select="f:chunk-filename($node-chunk)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(f:chunk-filename($node-chunk),'#',f:node-id($node))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="f:find-chunk" as="element()?">
    <xsl:param name="node" as="node()"/>
    <xsl:sequence select="$node/ancestor-or-self::*[. = $chunks][1]"/>
  </xsl:function>

</xsl:stylesheet>
