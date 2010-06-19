<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://docbook.org/ns/docbook"
		xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
		version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:preserve-space elements="*"/>

<xsl:variable name="plist" select="document('../plist')/plist/name"/>

<xsl:template match="/">
  <xsl:for-each select="//refentry">
    <xsl:variable name="rname" select="refmeta/refentrytitle"/>
    <xsl:if test="$plist[. = $rname]">
      <xsl:apply-templates select="."/>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template match="refentry">
  <xsl:variable name="uri">
    <xsl:text>/sourceforge/docbook/xsl2/params/</xsl:text>
    <xsl:value-of select="refmeta/refentrytitle"/>
    <xsl:text>.xml</xsl:text>
  </xsl:variable>

  <xsl:result-document href="{$uri}">
    <xsl:element name="{name(.)}"
		 namespace="http://docbook.org/ns/docbook">
      <xsl:namespace name="src"
		     select="'http://nwalsh.com/xmlns/litprog/fragment'"/>
      <xsl:namespace name="xsl"
		     select="'http://www.w3.org/1999/XSL/Transform'"/>
      <xsl:namespace name="xlink"
		     select="'http://www.w3.org/1999/xlink'"/>
      <xsl:copy-of select="@*[not(name(.)='id')]"/>
      <xsl:attribute name="version" select="'5.0'"/>
      <xsl:if test="@id">
	<xsl:attribute name="xml:id" select="@id"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:text>&#10;</xsl:text>
  </xsl:result-document>
</xsl:template>

<xsl:template match="src:fragment">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*[not(name(.)='id')]"/>
    <xsl:if test="@id">
      <xsl:attribute name="xml:id" select="@id"/>
    </xsl:if>
    <xsl:if test="node()[1] instance of element()">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="node()[last()] instance of element()">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:element>
</xsl:template>    

<xsl:template match="src:*">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*[not(name(.)='id')]"/>
    <xsl:if test="@id">
      <xsl:attribute name="xml:id" select="@id"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>    

<xsl:template match="xsl:*">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>    

<xsl:template match="*">
  <xsl:element name="{name(.)}"
	       namespace="http://docbook.org/ns/docbook">
    <xsl:copy-of select="@*[not(name(.)='id')]"/>
    <xsl:if test="@id">
      <xsl:attribute name="xml:id" select="@id"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
