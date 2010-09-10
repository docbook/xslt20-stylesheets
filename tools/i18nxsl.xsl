<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xxx="http://example.com/"
                version="2.0">

<xsl:namespace-alias stylesheet-prefix="xxx" result-prefix="xsl"/>

<xsl:output method="xml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:template match="/">
  <xxx:stylesheet version="2.0">
    <xsl:namespace name="l" select="'http://docbook.sourceforge.net/xmlns/l10n/1.0'"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:comment> This variable must declare a document node, don't add as= </xsl:comment>
    <xsl:text>&#10;</xsl:text>
    <xxx:variable name="localization.data">
      <xsl:text>&#10;</xsl:text>
      <xsl:copy-of select="/"/>
    </xxx:variable>
  </xxx:stylesheet>
</xsl:template>

</xsl:stylesheet>
