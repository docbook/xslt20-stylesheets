<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">

<xsl:param name="version" required="yes"/>
<xsl:param name="resourcesVersion" required="yes"/>

<xsl:output method="xml" encoding="utf-8" indent="yes"
	    omit-xml-declaration="yes"/>

<xsl:template name="main">
  <xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
    <xsl:attribute name="version" select="'2.0'"/>
    <xsl:element name="xsl:param" namespace="http://www.w3.org/1999/XSL/Transform">
      <xsl:attribute name="name" select="'VERSION'"/>
      <xsl:attribute name="select" select="concat('''', $version, '''')"/>
    </xsl:element>
    <xsl:element name="xsl:param" namespace="http://www.w3.org/1999/XSL/Transform">
      <xsl:attribute name="name" select="'RESOURCES.VERSION'"/>
      <xsl:attribute name="select" select="concat('''', $resourcesVersion, '''')"/>
    </xsl:element>
  </xsl:element>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
