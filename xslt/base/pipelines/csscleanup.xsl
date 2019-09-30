<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xs html"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="no"
            omit-xml-declaration="yes"/>

<xsl:param name="discard-script" select="'true'"/>

<xsl:template match="html:head">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="contains(/html:html/@class, 'draft')">
      <style type="text/css">
        @page {
          background-image: url("./build/test/resources/img/draft.svg");
          background-repeat: no-repeat;
          background-position: center center;
        }
      </style>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="html:head/html:link[@rel='stylesheet']">
  <!-- discard -->
</xsl:template>

<xsl:template match="html:script">
  <xsl:if test="$discard-script != 'true'">
    <xsl:next-match/>
  </xsl:if>
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
