<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
		exclude-result-prefixes="h f m fn db doc t xs mml"
                version="2.0">

<xsl:template match="db:equation">
  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:equation]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-class(., local-name(.), @role)"/>
	<xsl:apply-templates select="*[not(self::db:caption)]"/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:informalequation">
  <xsl:call-template name="t:informal-object">
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-class(., local-name(.), @role)"/>
	<xsl:apply-templates select="*[not(self::db:caption)]"/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:inlineequation">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:mathphrase">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="mml:*">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1998/Math/MathML">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>

