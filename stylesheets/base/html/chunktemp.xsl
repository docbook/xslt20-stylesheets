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

  <xsl:import href="chunkfunc.xsl"/>

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
      <xsl:variable name="src-elem" select="key('genid', @xml:id, $root)"/>
      <xsl:choose>
        <xsl:when test="$rootid = ''">
          <xsl:sequence select="$src-elem"/>
        </xsl:when>
        <xsl:when test="$src-elem/@xml:id = $rootid">
          <xsl:message>Selecting root element: <xsl:value-of select="local-name($src-elem)"/></xsl:message>
          <xsl:sequence select="$src-elem"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- skip it -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <xsl:function name="f:chunk-tree" as="document-node()">
    <xsl:sequence select="$chunk-tree"/>
  </xsl:function>

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

    <xsl:message>Creating chunk: <xsl:value-of select="concat($base.dir,$chunkfn)"/></xsl:message>

    <xsl:result-document href="{$base.dir}{$chunkfn}" method="xhtml" indent="no">
      <html>
        <xsl:call-template name="t:head">
          <xsl:with-param name="root" select="."/>
        </xsl:call-template>
        <body>
          <div class="page">
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

            <div class="body">
              <xsl:apply-templates select=".">
                <xsl:with-param name="override-chunk" select="true()"/>
              </xsl:apply-templates>
            </div>
          </div>

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
        <!--
        <xsl:if test="self::db:part|self::db:book|self::db:reference|self::db:refentry">
          <xsl:message>Not a chunk: <xsl:value-of select="local-name(.)"/></xsl:message>
        </xsl:if>
        -->
        <xsl:apply-imports/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
