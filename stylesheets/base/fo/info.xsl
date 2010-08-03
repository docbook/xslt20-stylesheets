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

    <xsl:apply-templates select="db:info" mode="m:titlepage-mode"/>

    <fo:block>
      <xsl:apply-templates select="*[not(self::db:info)]"/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="db:legalnotice">
  <fo:block>
    <xsl:call-template name="t:id"/>

    <xsl:apply-templates select="db:info" mode="m:titlepage-mode"/>

    <fo:block>
      <xsl:apply-templates select="*[not(self::db:info)]"/>
    </fo:block>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
