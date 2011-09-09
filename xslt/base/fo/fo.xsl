<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="f m fn db t xs"
                version="2.0">

<xsl:template name="dingbat">
  <xsl:param name="dingbat">bullet</xsl:param>
  <xsl:variable name="symbol">
    <xsl:choose>
      <xsl:when test="$dingbat='bullet'">o</xsl:when>
      <xsl:when test="$dingbat='copyright'">&#x00A9;</xsl:when>
      <xsl:when test="$dingbat='trademark'">&#x2122;</xsl:when>
      <xsl:when test="$dingbat='trade'">&#x2122;</xsl:when>
      <xsl:when test="$dingbat='registered'">&#x00AE;</xsl:when>
      <xsl:when test="$dingbat='service'">(SM)</xsl:when>
      <xsl:when test="$dingbat='ldquo'">"</xsl:when>
      <xsl:when test="$dingbat='rdquo'">"</xsl:when>
      <xsl:when test="$dingbat='lsquo'">'</xsl:when>
      <xsl:when test="$dingbat='rsquo'">'</xsl:when>
      <xsl:when test="$dingbat='em-dash'">&#x2014;</xsl:when>
      <xsl:when test="$dingbat='en-dash'">-</xsl:when>
      <xsl:otherwise>o</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$dingbat.font.family = ''">
      <xsl:copy-of select="$symbol"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-family="{$dingbat.font.family}">
        <xsl:copy-of select="$symbol"/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:page-sequence-attributes">
  <!--
    <xsl:attribute name="language">
      <xsl:call-template name="l10n.language"/>
    </xsl:attribute>

    <xsl:attribute name="format">
      <xsl:call-template name="page.number.format">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="initial-page-number">
      <xsl:call-template name="initial.page.number">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="force-page-count">
      <xsl:call-template name="force.page.count">
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>
    </xsl:attribute>

    <xsl:attribute name="hyphenation-character">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-character'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-push-character-count">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="hyphenation-remain-character-count">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
      </xsl:call-template>
    </xsl:attribute>
  -->
</xsl:template>

<xsl:param name="direction.align.start">
  <xsl:choose>
    <!-- FOP does not support writing-mode="rl-tb" -->
    <xsl:when test="$fo.processor eq 'fop'">left</xsl:when>
    <xsl:when test="starts-with($writing.mode, 'lr')">left</xsl:when>
    <xsl:when test="starts-with($writing.mode, 'rl')">right</xsl:when>
    <xsl:when test="starts-with($writing.mode, 'tb')">top</xsl:when>
    <xsl:otherwise>left</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="direction.align.end">
  <xsl:choose>
    <xsl:when test="$fo.processor eq 'fop'">right</xsl:when>
    <xsl:when test="starts-with($writing.mode, 'lr')">right</xsl:when>
    <xsl:when test="starts-with($writing.mode, 'rl')">left</xsl:when>
    <xsl:when test="starts-with($writing.mode, 'tb')">bottom</xsl:when>
    <xsl:otherwise>right</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="direction.mode">
  <xsl:choose>
    <xsl:when test="$fo.processor eq 'fop' and starts-with($writing.mode, 'rl')">
      <xsl:message>WARNING: FOP does not support right-to-left writing-mode</xsl:message>
      <xsl:text>lr-tb</xsl:text>
    </xsl:when>
    <xsl:when test="starts-with($writing.mode, 'lr')">lr-tb</xsl:when>
    <xsl:when test="starts-with($writing.mode, 'rl')">rl-tb</xsl:when>
    <xsl:when test="starts-with($writing.mode, 'tb')">tb-rl</xsl:when>
    <xsl:otherwise>lr-tb</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:function name="f:hsize" as="xs:decimal">
  <xsl:param name="size" as="xs:integer"/>

  <xsl:choose>
    <xsl:when test="$size &lt;= 0">
      <xsl:value-of select="$body.font.master"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="f:hsize($size - 1) * 1.2"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ====================================================================== -->

<xsl:function name="f:keep-titlepage-fragment" as="xs:boolean">
  <xsl:param name="fragment" as="node()*"/>

  <xsl:value-of select="string($fragment) != ''
                        or count($fragment//fo:block) != count($fragment//*)"/>
</xsl:function>

<xsl:template name="t:default-titlepage-template" as="element()">
  <fo:block>
    <db:title/>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
