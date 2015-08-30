<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:c="http://www.w3.org/ns/xproc-step"
		exclude-result-prefixes="xs db"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:template match="/">
  <c:param-set>
    <xsl:apply-templates select="//db:info/c:param"/>
  </c:param-set>
</xsl:template>

<xsl:template match="c:param[@name]" priority="100">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="c:param">
  <xsl:message>
    <xsl:value-of select="base-uri(/)"/>
    <xsl:text>: document parameters must have name attributes.</xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="db:para">
  <!-- nop; just make Saxon shut up about the namespaces. -->
</xsl:template>

</xsl:stylesheet>
