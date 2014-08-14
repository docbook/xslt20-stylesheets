<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="db f t xs"
                version="2.0">

<xsl:import href="../../base/html/final-pass.xsl"/>

<!-- ====================================================================== -->

<xsl:template name="t:css">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="string($docbook.css) = ''">
      <!-- nop -->
    </xsl:when>
    <xsl:when test="$docbook.css.inline = 0">
      <link rel="stylesheet" type="text/css" href="{$docbook.css}"/>
    </xsl:when>
    <xsl:otherwise>
      <style type="text/css">
        <xsl:copy-of select="unparsed-text($docbook.css, 'utf-8')"/>
      </style>
    </xsl:otherwise>
  </xsl:choose>

  <link rel="stylesheet" type="text/css" href="publishers.css"/>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="db:dialogue">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:linegroup">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:speaker">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:note">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:line">
  <p>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>
