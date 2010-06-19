<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="h f m fn db t"
                version="2.0">

<xsl:template match="db:set|db:book|db:part|db:reference">
  <xsl:variable name="recto"
		select="$titlepages/*[node-name(.) = node-name(current())
			              and @t:side='recto'][1]"/>
  <xsl:variable name="verso"
		select="$titlepages/*[node-name(.) = node-name(current())
			              and @t:side='verso'][1]"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$recto"/>
    </xsl:call-template>

    <xsl:if test="not(empty($verso))">
      <xsl:call-template name="titlepage">
	<xsl:with-param name="content" select="$verso"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:variable name="toc.params"
		  select="f:find-toc-params(., $generate.toc)"/>

    <xsl:call-template name="make-lots">
      <xsl:with-param name="toc.params" select="$toc.params"/>
      <xsl:with-param name="toc">
	<xsl:call-template name="division-toc"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:partintro">
  <xsl:variable name="recto"
		select="$titlepages/*[node-name(.) = node-name(current())
			              and @t:side='recto'][1]"/>
  <xsl:variable name="verso"
		select="$titlepages/*[node-name(.) = node-name(current())
			              and @t:side='verso'][1]"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$recto"/>
    </xsl:call-template>

    <xsl:if test="not(empty($verso))">
      <xsl:call-template name="titlepage">
	<xsl:with-param name="content" select="$verso"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:apply-templates/>

    <xsl:call-template name="t:process-footnotes"/>
  </div>
</xsl:template>

</xsl:stylesheet>
