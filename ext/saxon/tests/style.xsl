<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ext="http://docbook.org/extensions/xslt20"
		exclude-result-prefixes="ext xs"
                version="2.0">

<xsl:output method="text"/>

<xsl:param name="imagefn"
           select="substring-after(resolve-uri('../../../tests/xspec/graphics/duck.png'),'file:')"/>

<xsl:template match="/">
  <xsl:variable name="imageproperties" as="xs:integer*">
    <xsl:sequence use-when="function-available('ext:image-properties')"
                  select="ext:image-properties($imagefn)"/>
    <xsl:sequence use-when="not(function-available('ext:image-properties'))"
                  select="()"/>
  </xsl:variable>

  <xsl:value-of select="$imagefn"/>
  <xsl:text>&#10;</xsl:text>

  <xsl:choose>
    <xsl:when test="exists($imageproperties)">
      <xsl:text>Dimensions: </xsl:text>
      <xsl:value-of select="$imageproperties[1]"/>
      <xsl:text>x</xsl:text>
      <xsl:value-of select="$imageproperties[2]"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>Cannot be interpreted. </xsl:text>
      <xsl:text use-when="function-available('ext:image-properties')">Call failed?</xsl:text>
      <xsl:text use-when="not(function-available('ext:image-properties'))">Extension not available.</xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:variable name="code1" select="'print &quot;Hello world!&quot;'"/>
  <xsl:variable name="pp1" as="node()+">
    <xsl:sequence use-when="function-available('ext:pretty-print')"
                  select="ext:pretty-print($code1,'python')"/>
    <xsl:value-of use-when="not(function-available('ext:pretty-print'))">
      <xsl:value-of select="$code1"/>
    </xsl:value-of>
  </xsl:variable>

  <xsl:text>Pretty print of </xsl:text>
  <xsl:value-of select="$code1"/>
  <xsl:text>: </xsl:text>
  <xsl:value-of select="count($pp1//node())"/>
  <xsl:text> nodes</xsl:text>
  <xsl:text>&#10;</xsl:text>

  <xsl:variable name="code2" select="'$_ =~ s/a/b/g;'"/>
  <xsl:variable name="pp2" as="node()+">
    <xsl:sequence use-when="function-available('ext:pretty-print')"
                  select="ext:pretty-print($code2,'perl')"/>
    <xsl:value-of use-when="not(function-available('ext:pretty-print'))">
      <xsl:value-of select="$code2"/>
    </xsl:value-of>
  </xsl:variable>

  <xsl:text>Pretty print of </xsl:text>
  <xsl:value-of select="$code2"/>
  <xsl:text>: </xsl:text>
  <xsl:value-of select="count($pp2//node())"/>
  <xsl:text> nodes</xsl:text>
  <xsl:text>&#10;</xsl:text>

</xsl:template>

</xsl:stylesheet>
