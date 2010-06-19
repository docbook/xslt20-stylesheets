<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:simg="java:net.sf.docbook.saxon.ImageIntrinsics"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="simg xs"
                version="2.0">

<xsl:output method="text"/>

<xsl:param name="imagefn" select="'../../../testdocs/graphics/duck.png'"/>

<xsl:template match="/">
  <xsl:variable name="imageproperties" as="xs:integer*">
    <xsl:sequence use-when="function-available('simg:new')
			    and function-available('simg:properties')"
		  select="simg:properties(simg:new($imagefn))"/>
    <xsl:sequence use-when="not(function-available('simg:new'))
			    or not(function-available('simg:properties'))"
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
      <xsl:text>Cannot be interpreted.</xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
