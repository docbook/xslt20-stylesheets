<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
		exclude-result-prefixes="db doc f fn h m t xs fo axf"
                version="2.0">

<!-- ============================================================ -->

<doc:mode name="m:titlepage-recto-mode"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting elements on the recto title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the recto title page.
Any element processed in this mode should generate markup appropriate
for the recto side of the title page.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:titlepage-recto-mode">
  <xsl:param name="attributes" tunnel="yes"/>
  <xsl:apply-templates select="." mode="m:titlepage-mode">
    <xsl:with-param name="attributes" select="$attributes"/>
  </xsl:apply-templates>
</xsl:template>

<doc:mode name="m:titlepage-verso-mode"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting elements on the verso title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the verso title page.
Any element processed in this mode should generate markup appropriate
for the verso side of the title page.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:titlepage-verso-mode">
  <xsl:param name="attributes" tunnel="yes"/>
  <xsl:apply-templates select="." mode="m:titlepage-mode">
    <xsl:with-param name="attributes" select="$attributes"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:title" mode="m:titlepage-verso-mode">
  <xsl:param name="attributes" tunnel="yes"/>
  <fo:block>
    <xsl:copy-of select="$attributes"/>
    <xsl:apply-templates select="ancestor::*[not(self::db:info)][1]" mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:subtitle" mode="m:titlepage-verso-mode">
  <xsl:param name="attributes" tunnel="yes"/>
  <fo:block>
    <xsl:copy-of select="$attributes"/>
    <xsl:apply-templates select="ancestor::*[not(self::db:info)][1]" mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:titlepage-mode"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting elements on the title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the title page.
Any element processed in this mode should generate markup appropriate
for the title page.</para>
<note>
<para>Title, subtitle, and titleabbrev are handled by <mode>m:title-markup</mode>
because they're optional on some elements (and because they're reused in
multiple places).</para>
</note>
</refdescription>
</doc:mode>

<xsl:template match="db:copyright" mode="m:titlepage-mode">
  <fo:block>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:call-template name="gentext-space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext-space"/>
    <xsl:call-template name="t:copyright-years">
      <xsl:with-param name="years" select="db:year"/>
      <xsl:with-param name="print.ranges" select="$make.year.ranges"/>
      <xsl:with-param name="single.year.ranges"
		      select="$make.single.year.ranges"/>
    </xsl:call-template>
    <xsl:apply-templates select="db:holder" mode="m:titlepage-mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:year" mode="m:titlepage-mode">
  <fo:inline>
    <xsl:call-template name="t:id"/>
    <xsl:apply-templates/>
  </fo:inline>
  <xsl:if test="following-sibling::db:year">, </xsl:if>
</xsl:template>

<xsl:template match="db:holder" mode="m:titlepage-mode">
  <xsl:text> </xsl:text>
  <fo:inline>
    <xsl:call-template name="t:id"/>
    <xsl:apply-templates/>
  </fo:inline>
  <xsl:if test="following-sibling::db:holder">
    <xsl:text>,</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:releaseinfo" mode="m:titlepage-mode">
  <fo:block>
    <xsl:call-template name="t:id"/>
    <xsl:apply-templates mode="m:titlepage-mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:abstract" mode="m:titlepage-mode">
  <xsl:param name="attributes" as="attribute()*"/>
  <fo:block>
    <xsl:copy-of select="$attributes"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:legalnotice" mode="m:titlepage-mode">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:titlepage-mode">
  <xsl:param name="attributes" as="attribute()*"/>
  <fo:block>
    <xsl:copy-of select="$attributes"/>
    <xsl:apply-templates mode="m:titlepage-mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:info/db:author
		     |db:info/db:authorgroup/db:author"
	      mode="m:titlepage-mode">
  <xsl:param name="attributes" as="attribute()*"/>
  <fo:block>
    <xsl:copy-of select="$attributes"/>
    <xsl:apply-templates select="."/>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
