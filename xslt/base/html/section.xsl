<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db t xs"
                version="2.0">

<xsl:template match="db:section|db:sect1|db:sect2|db:sect3|db:sect4|db:sect5"
              name="db:section">
  <section>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="db:simplesect">
  <section>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="db:bridgehead">
  <xsl:variable name="renderas">
    <xsl:choose>
      <xsl:when test="@renderas">
	<xsl:value-of select="@renderas"/>
      </xsl:when>
      <xsl:when test="ancestor::db:sect4|ancestor::db:sect5">sect5</xsl:when>
      <xsl:when test="ancestor::db:sect3">sect4</xsl:when>
      <xsl:when test="ancestor::db:sect2">sect3</xsl:when>
      <xsl:when test="ancestor::db:sect1">sect2</xsl:when>
      <xsl:when test="ancestor::db:section">
	<xsl:choose>
	  <xsl:when test="count(ancestor::db:section) &gt;= 4">sect5</xsl:when>
	  <xsl:otherwise>
	    <xsl:text>sect</xsl:text>
	    <xsl:value-of select="count(ancestor::db:section)+1"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>sect1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="sdepth" select="replace($renderas,'sect(\d)','$1')"/>
  <xsl:variable name="depth" select="xs:integer($sdepth)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>

  <xsl:element name="h{$hlevel+1}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
