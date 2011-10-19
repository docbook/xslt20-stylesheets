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
  <article>
    <xsl:sequence select="f:html-attributes(.,f:node-id(.))"/>
    <xsl:call-template name="t:titlepage"/>

    <xsl:if test="not(db:toc)">
      <!-- only generate a toc automatically if there's no explicit toc -->
      <xsl:apply-templates select="." mode="m:toc"/>
    </xsl:if>

    <xsl:apply-templates/>
  </article>
</xsl:template>

<xsl:template match="db:set|db:book|db:part|db:reference" mode="m:toc">
  <xsl:param name="toc.params"
             select="f:find-toc-params(., $generate.toc)"/>

  <xsl:call-template name="t:make-lots">
    <xsl:with-param name="toc.params" select="$toc.params"/>
    <xsl:with-param name="toc">
      <xsl:call-template name="t:division-toc"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:partintro">
  <section>
    <xsl:sequence select="f:html-attributes(.,f:node-id(.))"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
    <xsl:call-template name="t:process-footnotes"/>
  </section>
</xsl:template>

</xsl:stylesheet>
