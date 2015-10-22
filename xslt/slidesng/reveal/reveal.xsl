<?xml version="1.0" encoding="utf-8"?>	<!---->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:dbs="http://docbook.org/ns/docbook-slides"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:mp="http://docbook.org/xslt/ns/mode/private"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:tmpl="http://docbook.org/xslt/titlepage-templates"
		exclude-result-prefixes="db f h m t xs dbs tmpl"
                version="2.0">

<xsl:import href="../../base/html/final-pass.xsl"/>

<xsl:output indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="root.elements">
  <dbs:slides/>
</xsl:param>

<xsl:param name="reveal.uri">reveal/</xsl:param>

<!-- Generate reveal.js skeleton -->
<xsl:template match="/">
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html>
</xsl:text>
  <html>
    <xsl:call-template name="t:head">
      <xsl:with-param name="node" select="/*"/>
    </xsl:call-template>
    <body>
      <xsl:call-template name="t:body-attributes"/>
      <xsl:if test="/*/@status">
        <xsl:attribute name="class" select="/*/@status"/>
      </xsl:if>

      <xsl:apply-templates/>

      <xsl:call-template name="t:reveal-footer"/>
    </body>
  </html>
</xsl:template>

<!-- Disable DocBook JS and CSS -->
<xsl:template match="*" mode="mp:javascript-head">
</xsl:template>
<xsl:template match="*" mode="mp:javascript-body">
</xsl:template>
<xsl:template match="*" mode="mp:css">
</xsl:template>

<!-- Link reveal.js CSS + JS -->
<xsl:template match="*" mode="m:head-content">
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />

  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

  <link rel="stylesheet" href="{$reveal.uri}/css/reveal.min.css"/>
  <link rel="stylesheet" href="{$reveal.uri}/css/theme/default.css" id="theme"/>

  <link rel="stylesheet" href="{$reveal.uri}/lib/css/zenburn.css"/>

  <xsl:comment>[if lt IE 9]>
  &lt;script src="<xsl:value-of select="$reveal.uri"/>lib/js/html5shiv.js">&lt;/script>
  &lt;![endif]</xsl:comment>
</xsl:template>

<!-- Load and configure reveal.js -->
<xsl:template name="t:reveal-footer">
  <script src="{$reveal.uri}/lib/js/head.min.js"></script>
  <script src="{$reveal.uri}/js/reveal.min.js"></script>
  <script>

	  // Full list of configuration options available here:
	  // https://github.com/hakimel/reveal.js#configuration
	  Reveal.initialize({
		  controls: true,
		  progress: true,
		  slideNumber: false,
		  history: true,
		  keyboard: true,
		  overview: true,
		  center: true,
		  touch: true,
		  loop: false,
		  rtl: false,
		  fragments: true,

	  });

  </script>

</xsl:template>

<xsl:template match="dbs:slides">
  <div class="reveal">
    <div class="slides">
      <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>
      <section>
	<xsl:call-template name="t:titlepage"/>
      </section>

      <xsl:apply-templates/>
    </div>
  </div>
</xsl:template>

<xsl:template match="dbs:foil">
  <section>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="dbs:foilgroup">
  <section>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>
    <section>
      <xsl:call-template name="t:titlepage"/>
    </section>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="dbs:foil/db:title|dbs:foilgroup/db:title"
              mode="m:titlepage-mode">
  <h2>
    <xsl:apply-templates select=".." mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="dbs:slides/db:title|dbs:slides/db:info/db:title"
              mode="m:titlepage-mode">
  <h1>
    <xsl:variable name="context"
                  select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h1>
</xsl:template>

<xsl:template name="t:user-titlepage-templates" as="element(tmpl:templates-list)?">
  <tmpl:templates-list>

    <tmpl:templates name="slides foil foilgroup" namespace="http://docbook.org/ns/docbook-slides">
      <tmpl:titlepage>
	<db:title/>
      </tmpl:titlepage>
    </tmpl:templates>
  </tmpl:templates-list>
</xsl:template>

<xsl:template name="t:user-localization-data">
  <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
    <l:context name="title" >
      <l:template name="slides" text="%t"/>
    </l:context>
  </l:l10n>
</xsl:template>

</xsl:stylesheet>
