<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
		xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="axf f t m db"
                version='2.0'>

<!-- restore db:set, db:part -->

<!-- ==================================================================== -->

<xsl:template match="db:book">
  <xsl:call-template name="t:front-cover"/>

  <xsl:call-template name="t:page-sequence">
    <xsl:with-param name="master-reference"
		    select="f:select-pagemaster(.,'titlepage')"/>
    <xsl:with-param name="content">
      <fo:block id="{f:node-id(.)}">
	<!-- FIXME: titlepage -->
      </fo:block>
    </xsl:with-param>
  </xsl:call-template>

  <!--
  <xsl:apply-templates select="db:dedication" mode="dedication"/>
  -->

  <xsl:variable name="toc.params"
		select="f:find-toc-params(., $generate.toc)"/>

  <xsl:call-template name="make-lots">
    <xsl:with-param name="toc.params" select="$toc.params"/>
    <xsl:with-param name="toc">
      <xsl:call-template name="division-toc"/>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates/>

  <xsl:call-template name="t:back-cover"/>
</xsl:template>

<xsl:template match="db:book/db:info"></xsl:template>

<!-- Placeholder templates -->
<xsl:template name="t:front-cover"/>
<xsl:template name="t:back-cover"/>

</xsl:stylesheet>

