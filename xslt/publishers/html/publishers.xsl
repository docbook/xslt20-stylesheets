<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="db f m mp t xs"
                version="2.0">

<xsl:import href="../../base/html/final-pass.xsl"/>
<xsl:import href="params.xsl"/>
<xsl:import href="titlepage-templates.xsl"/>
<xsl:import href="html.xsl"/>

<!-- ====================================================================== -->

<xsl:template match="db:dialogue">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:drama">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:linegroup">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:line">
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

<xsl:template match="db:poetry">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

</xsl:stylesheet>
