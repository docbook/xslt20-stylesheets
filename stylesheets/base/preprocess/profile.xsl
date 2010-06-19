<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                exclude-result-prefixes="m"
                version="2.0">

<xsl:import href="2-profile.xsl"/>

<xsl:output method="xml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:param name="profile.separator" select="';'"/>
<xsl:param name="profile.arch" select="''"/>
<xsl:param name="profile.condition" select="''"/>
<xsl:param name="profile.conformance" select="''"/>
<xsl:param name="profile.lang" select="''"/>
<xsl:param name="profile.os" select="''"/>
<xsl:param name="profile.revision" select="''"/>
<xsl:param name="profile.revisionflag" select="''"/>
<xsl:param name="profile.role" select="''"/>
<xsl:param name="profile.security" select="''"/>
<xsl:param name="profile.userlevel" select="''"/>
<xsl:param name="profile.vendor" select="''"/>

<xsl:template match="/">
  <xsl:apply-templates select="/" mode="m:profile">
    <xsl:with-param name="profile.separator" select="$profile.separator"/>
    <xsl:with-param name="profile.arch" select="$profile.arch"/>
    <xsl:with-param name="profile.condition" select="$profile.condition"/>
    <xsl:with-param name="profile.conformance" select="$profile.conformance"/>
    <xsl:with-param name="profile.lang" select="$profile.lang"/>
    <xsl:with-param name="profile.os" select="$profile.os"/>
    <xsl:with-param name="profile.revision" select="$profile.revision"/>
    <xsl:with-param name="profile.revisionflag" select="$profile.revisionflag"/>
    <xsl:with-param name="profile.role" select="$profile.role"/>
    <xsl:with-param name="profile.security" select="$profile.security"/>
    <xsl:with-param name="profile.userlevel" select="$profile.userlevel"/>
    <xsl:with-param name="profile.vendor" select="$profile.vendor"/>
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
