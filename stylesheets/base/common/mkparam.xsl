<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:src="http://nwalsh.com/xmlns/litprog/fragment" 
		exclude-result-prefixes="src"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="no"/>
<xsl:preserve-space elements="*"/>

<xsl:param name="condition" select="'html'"/>

<xsl:template match="/">
  <xsl:element name="xsl:stylesheet">
    <xsl:attribute name="version" select="'2.0'"/>
    <xsl:namespace name="xsl" select="'http://www.w3.org/1999/XSL/Transform'"/>
    <xsl:namespace name="db" select="'http://docbook.org/ns/docbook'"/>
    <xsl:apply-templates select="//db:refentry">
      <xsl:sort select="@xml:id"/>
    </xsl:apply-templates>
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:element>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="db:refentry">
  <xsl:variable name="refentry"
		select="document(concat('../../params/',@xml:id,'.xml'))"/>

  <xsl:text>&#10;&#10;</xsl:text>

  <xsl:apply-templates select="$refentry//src:fragment/xsl:*[not(@condition)]"
		       mode="copy"/>
  <xsl:apply-templates select="$refentry//src:fragment/xsl:*[@condition = $condition]"
		       mode="copy"/>
</xsl:template>

<xsl:template match="xsl:*" mode="copy">
  <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*[name(.) != 'condition']"/>
    <xsl:apply-templates mode="copy"/>
  </xsl:element>
</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*[name(.) != 'condition']"/>
    <xsl:apply-templates mode="copy"/>
  </xsl:element>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="copy">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
