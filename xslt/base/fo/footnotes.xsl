<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		exclude-result-prefixes="f m fn db t"
                version="2.0">

<xsl:include href="../common/footnotes.xsl"/>

<xsl:template name="t:format-footnote-mark">
  <xsl:param name="mark" select="'?'"/>
  <fo:inline xsl:use-attribute-sets="footnote.mark.properties">
    <xsl:choose>
      <xsl:when test="$fo.processor eq 'fop'">
        <xsl:attribute name="vertical-align">super</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="baseline-shift">super</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:copy-of select="$mark"/>
  </fo:inline>
</xsl:template>

<xsl:template name="t:format-footnote-body">
  <xsl:param name="id" select="f:node-id(.)"/>

  <fo:list-block provisional-distance-between-starts="{$footnote.mark.width}" id="ftn.{$id}"
                 xsl:use-attribute-sets="footnote.block.properties">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
	<fo:block>
	  <fo:basic-link internal-destination="{$id}">
	    <xsl:call-template name="t:format-footnote-mark">
	      <xsl:with-param name="mark">
		<xsl:apply-templates select="." mode="m:footnote-number"/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </fo:basic-link>
	</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
	<xsl:apply-templates/>
      </fo:list-item-body>
    </fo:list-item>
  </fo:list-block>
</xsl:template>

<xsl:template match="db:footnote">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:choose>
    <xsl:when test="ancestor::db:table or ancestor::db:informaltable or $footnotes.as.endnotes">
      <fo:basic-link id="{$id}" internal-destination="ftn.{$id}">
	<xsl:call-template name="t:format-footnote-mark">
	  <xsl:with-param name="mark">
	    <xsl:apply-templates select="." mode="m:footnote-number"/>
	  </xsl:with-param>
	</xsl:call-template>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
      <fo:footnote>
        <fo:inline id="{$id}">
	  <fo:basic-link internal-destination="ftn.{$id}">
	    <xsl:call-template name="t:format-footnote-mark">
	      <xsl:with-param name="mark">
		<xsl:apply-templates select="." mode="m:footnote-number"/>
	      </xsl:with-param>
	    </xsl:call-template>
	  </fo:basic-link>
        </fo:inline>
	<fo:footnote-body xsl:use-attribute-sets="footnote.properties">
	  <xsl:call-template name="t:format-footnote-body"/>
        </fo:footnote-body>
      </fo:footnote>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:footnoteref">
  <xsl:variable name="footnote" select="key('id',@linkend)[1]"/>

  <fo:basic-link internal-destination="ftn.{f:node-id($footnote)}">
    <xsl:call-template name="t:format-footnote-mark">
      <xsl:with-param name="mark">
	<xsl:apply-templates select="." mode="m:footnote-number"/>
      </xsl:with-param>
    </xsl:call-template>
  </fo:basic-link>
</xsl:template>

<xsl:template match="db:footnote" mode="m:table-footnote-mode">
  <fo:block xsl:use-attribute-sets="footnote.properties">
    <xsl:call-template name="t:format-footnote-body"/>
  </fo:block>
</xsl:template>

<xsl:template name="t:make-endnotes">
  <!-- FIXME: add title -->
  <fo:block xsl:use-attribute-sets="endnotes.properties">
    <xsl:for-each select=".//db:footnote[not(ancestor::db:table|ancestor::db:informaltable)]">
      <fo:block xsl:use-attribute-sets="footnote.properties">
	<xsl:call-template name="t:format-footnote-body"/>
      </fo:block>
    </xsl:for-each>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
