<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cat="urn:oasis:names:tc:entity:xmlns:xml:catalog"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="cat xs"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"
	    omit-xml-declaration="yes"/>

<xsl:param name="jarloc" required="yes"/>
<xsl:param name="version" required="yes"/>

<xsl:variable name="http" select="'http://docbook.github.com/release/'"/>
<xsl:variable name="https" select="'https://docbook.github.io/release/'"/>

<xsl:template match="catalog">
  <catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
    <xsl:apply-templates select="@*,node()"/>
  </catalog>
</xsl:template>

<xsl:template match="uri">
  <xsl:variable name="name" select="@name"/>

  <xsl:for-each select="($http, $https)">
    <xsl:variable name="base" select="."/>
    <xsl:for-each select="('latest', $version)">
      <uri xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
        <xsl:attribute name="name" select="concat($base, ., $name)"/>
        <xsl:attribute name="uri" select="concat($jarloc, $name)"/>
      </uri>
    </xsl:for-each>
  </xsl:for-each>
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
