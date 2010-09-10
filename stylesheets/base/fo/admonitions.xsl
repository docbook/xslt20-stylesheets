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

<xsl:template match="db:note|db:important|db:warning|db:caution|db:tip">
  <xsl:choose>
    <xsl:when test="$admonition.graphics">
      <xsl:call-template name="t:graphical-admonition"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="t:nongraphical-admonition"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:function name="f:admon-graphic-width">
  <xsl:param name="node"/>
  <xsl:sequence select="'36pt'"/>
</xsl:function>

<xsl:function name="f:admon-graphic">
  <xsl:param name="node"/>

  <xsl:variable name="filename">
    <xsl:value-of select="$admonition.graphics.path"/>
    <xsl:choose>
      <xsl:when test="$node/self::db:note">note</xsl:when>
      <xsl:when test="$node/self::db:warning">warning</xsl:when>
      <xsl:when test="$node/self::db:caution">caution</xsl:when>
      <xsl:when test="$node/self::db:tip">tip</xsl:when>
      <xsl:when test="$node/self::db:important">important</xsl:when>
      <xsl:otherwise>note</xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$admonition.graphics.extension"/>
  </xsl:variable>

  <xsl:sequence select="f:fo-external-image($filename)"/>
</xsl:function>

<xsl:template name="t:graphical-admonition">
  <xsl:variable name="id" select="f:node-id(.)"/>
  <xsl:variable name="graphic.width" select="f:admon-graphic-width(.)"/>

  <fo:block id="{$id}"
            xsl:use-attribute-sets="graphical.admonition.properties">
    <fo:list-block provisional-distance-between-starts="{$graphic.width} + 18pt"
                   provisional-label-separation="18pt">
      <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block>
              <fo:external-graphic width="auto" height="auto"
                                         content-width="{$graphic.width}" >
                <xsl:attribute name="src" select="f:admon-graphic(.)"/>
              </fo:external-graphic>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <xsl:if test="$admonition.textlabel or title or info/title">
              <fo:block xsl:use-attribute-sets="admonition.title.properties">
                <xsl:apply-templates select="." mode="m:object-title-markup">
		  <xsl:with-param name="allow-anchors" select="true()"/>
		</xsl:apply-templates>
              </fo:block>
            </xsl:if>
            <fo:block xsl:use-attribute-sets="admonition.properties">
              <xsl:apply-templates/>
            </fo:block>
          </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </fo:block>
</xsl:template>

<xsl:template name="t:nongraphical-admonition">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <fo:block id="{$id}"
            xsl:use-attribute-sets="nongraphical.admonition.properties">
    <xsl:if test="$admonition.textlabel or db:title or db:info/db:title">
      <fo:block keep-with-next.within-column='always'
                xsl:use-attribute-sets="admonition.title.properties">
         <xsl:apply-templates select="." mode="m:object-title-markup">
	   <xsl:with-param name="allow-anchors" select="true()"/>
	 </xsl:apply-templates>
      </fo:block>
    </xsl:if>

    <fo:block xsl:use-attribute-sets="admonition.properties">
      <xsl:apply-templates/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="db:note/db:title"></xsl:template>
<xsl:template match="db:important/db:title"></xsl:template>
<xsl:template match="db:warning/db:title"></xsl:template>
<xsl:template match="db:caution/db:title"></xsl:template>
<xsl:template match="db:tip/db:title"></xsl:template>

</xsl:stylesheet>
