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
  <xsl:variable name="recto"
		select="$titlepages/*[node-name(.) = node-name(current())
			              and @t:side='recto'][1]"/>
  <xsl:variable name="verso"
		select="$titlepages/*[node-name(.) = node-name(current())
			              and @t:side='verso'][1]"/>

  <xsl:call-template name="t:front-cover"/>

  <xsl:call-template name="t:page-sequence">
    <xsl:with-param name="master-reference"
		    select="f:select-pagemaster(.,'titlepage')"/>
    <xsl:with-param name="content">
      <fo:block id="{f:node-id(.)}">
	<xsl:call-template name="titlepage">
	  <xsl:with-param name="content" select="$recto"/>
	</xsl:call-template>
	
	<xsl:if test="not(empty($verso))">
	  <xsl:call-template name="titlepage">
	    <xsl:with-param name="content" select="$verso"/>
	  </xsl:call-template>
	</xsl:if>
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

