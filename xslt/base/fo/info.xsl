<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f fn m t xs"
                version="2.0">

<!-- ============================================================ -->

<xsl:template match="db:orgname">
  <fo:inline>
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:abstract">
  <fo:block>
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:legalnotice">
  <fo:block>
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:copyright">
  <xsl:param name="wrapper" select="'inline'"/>

  <xsl:element name="{$wrapper}" namespace="http://www.w3.org/1999/XSL/Format">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:call-template name="gentext-space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext-space"/>
    <xsl:call-template name="t:copyright-years">
      <xsl:with-param name="years" select="db:year"/>
      <xsl:with-param name="print.ranges" select="$make.year.ranges"/>
      <xsl:with-param name="single.year.ranges"
		      select="$make.single.year.ranges"/>
    </xsl:call-template>
    <xsl:apply-templates select="db:holder"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:year">
  <fo:inline>
    <xsl:call-template name="t:id"/>
    <xsl:apply-templates/>
  </fo:inline>
  <xsl:if test="following-sibling::db:year">, </xsl:if>
</xsl:template>

<xsl:template match="db:holder">
  <xsl:text> </xsl:text>
  <fo:inline>
    <xsl:call-template name="t:id"/>
    <xsl:apply-templates/>
  </fo:inline>
  <xsl:if test="following-sibling::db:holder">
    <xsl:text>,</xsl:text>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
