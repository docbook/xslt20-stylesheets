<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:html="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xs html"
                version="2.0">

<xsl:output method="xhtml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:template match="html:img/@src[starts-with(., 'test/graphics')]"
              priority="100">
  <xsl:attribute name="src">
    <xsl:value-of select="concat('../', substring-after(., 'test/'))"/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
