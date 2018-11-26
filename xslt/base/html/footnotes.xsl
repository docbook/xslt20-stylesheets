<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f h m t xs ghost"
                version='2.0'>

<!-- ********************************************************************
     $Id: footnotes.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:include href="../common/footnotes.xsl"/>

<xsl:template match="db:footnote">
  <xsl:variable name="name" select="f:node-id(.)"/>
  <sup>
    <xsl:sequence select="f:html-attributes(.)"/>
    <span class="osq">[</span>
    <a id="{$name}" href="{concat('#ftn.', $name)}">
      <xsl:apply-templates select="." mode="m:footnote-number"/>
    </a>
    <span class="csq">]</span>
  </sup>
</xsl:template>

<xsl:template match="db:footnoteref">
  <xsl:variable name="footnote" select="key('id',@linkend)[1]"/>
  <xsl:variable name="href" select="concat('#ftn.', f:node-id($footnote))"/>

  <sup>
    <xsl:sequence select="f:html-attributes(.)"/>
    <span class="osq">[</span>
    <a href="{$href}">
      <xsl:apply-templates select="$footnote" mode="m:footnote-number"/>
    </a>
    <span class="csq">]</span>
  </sup>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="t:process-footnotes">
  <xsl:variable name="table.footnotes"
                select=".//db:tgroup//db:footnote|.//db:tr//db:footnote"/>
  <xsl:variable name="footnotes" select=".//db:footnote except $table.footnotes"/>
  <xsl:variable name="annotations" select=".//ghost:annotation"/>
  <xsl:variable name="longdescs"
                select=".//db:mediaobject/db:textobject[not(db:phrase)]"/>

  <xsl:if test="exists($footnotes)">
    <div class="footnotes">
      <hr width="100" align="left" class="footnotes-divider"/>
      <xsl:apply-templates select="$footnotes" mode="m:process-footnote-mode"/>
    </div>
  </xsl:if>

  <xsl:if test="exists($annotations)">
    <div class="annotations-list">
      <xsl:for-each select="$annotations">
        <div id="annotation-{@xml:id}" class="dialog annotation-hide">
          <xsl:apply-templates/>
        </div>
      </xsl:for-each>
    </div>
  </xsl:if>

  <xsl:if test="exists($longdescs)">
    <div class="longdesc-list">
      <xsl:for-each select="$longdescs">
        <div id="longdesc-{generate-id(.)}" class="dialog longdesc-hide">
          <xsl:apply-templates select="*"/>
        </div>
      </xsl:for-each>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="process.chunk.footnotes">
  <!-- nop -->
</xsl:template>

<xsl:template match="db:footnote" name="t:process-footnote"
	      mode="m:process-footnote-mode">
  <xsl:variable name="name" select="f:node-id(.)"/>

  <xsl:variable name="footnote.body.doc">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:variable name="footnote.body" as="element()*"
		select="$footnote.body.doc/*"/>

  <xsl:variable name="footnote.number" as="xs:string">
    <xsl:apply-templates select="." mode="m:footnote-number"/>
  </xsl:variable>

  <div class="{name(.)}">
    <div class="footnote-wrapper">
      <div class="footnote-symbol-wrapper">
	<p>
	  <sup>
            <span class="osq">[</span>
	    <a href="#{$name}" id="{concat('ftn.', $name)}">
	      <xsl:copy-of select="$footnote.number"/>
	    </a>
            <span class="csq">]</span>
	  </sup>
          <xsl:text>&#160;</xsl:text>
        </p>
      </div>
      <div class="footnote-body-wrapper">
        <xsl:sequence select="$footnote.body"/>
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template match="db:tgroup//db:footnote"
	      mode="m:process-footnote-mode">
</xsl:template>

<xsl:template match="db:footnote" mode="m:table-footnote-mode">
  <xsl:call-template name="t:process-footnote"/>
</xsl:template>

</xsl:stylesheet>
