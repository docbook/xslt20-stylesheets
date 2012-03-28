<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f m t xs"
		version='2.0'>

<!-- ********************************************************************
     $Id: pi.xsl 7666 2008-02-06 19:46:32Z mzjn $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<doc:reference xmlns="http://docbook.org/ns/docbook">
<info>
  <title>FO Processing Instruction Reference</title>
  <releaseinfo role="meta">$Id: pi.xsl 7666 2008-02-06 19:46:32Z mzjn $</releaseinfo>
</info>

<partintro xml:id="partintro">
  <title>Introduction</title>

  <para>This is generated reference documentation for all
  user-specifiable processing instructions (PIs) in the DocBook
  XSL stylesheets for FO output.
  <note>
    <para>You add these PIs at particular points in a document to
    cause specific “exceptions” to formatting/output behavior. To
    make global changes in formatting/output behavior across an
    entire document, it’s better to do it by setting an
    appropriate stylesheet parameter (if there is one).</para>
  </note>
  </para>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<xsl:function name="f:dbfo-pi-attribute">
  <xsl:param name="node"/>
  <xsl:param name="attribute"/>
  <xsl:value-of select="f:pi-attribute(($node/processing-instruction('dbfo'),$node/processing-instruction('dbstyle')),$attribute)"/>
</xsl:function>

<!-- FIXME: what the heck is this? -->
<xsl:template name="pi.dbfo-need">
  <xsl:variable name="pi-height"
		select="f:dbfo-pi-attribute(.,'height')"/>

  <xsl:variable name="height">
    <xsl:choose>
      <xsl:when test="$pi-height != ''">
        <xsl:value-of select="$pi-height"/>
      </xsl:when>
      <xsl:otherwise>0pt</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pi-before"
		select="f:dbfo-pi-attribute(.,'space-before')"/>

  <xsl:variable name="spacer">
    <fo:block-container width="100%" height="{$height}">
      <fo:block><fo:leader leader-length="0pt"/></fo:block>
    </fo:block-container>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$fo.processor = 'fop'">
      <!-- Doesn't work in fop -->
    </xsl:when>
    <xsl:when test="$pi-before != '' and
      not(following-sibling::db:listitem) and
      not(following-sibling::db:step)">
      <fo:block space-after="0pt" space-before="{$pi-before}">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::db:para">
      <fo:block space-after="0pt" 
        xsl:use-attribute-sets="normal.para.spacing">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::db:table or
      following-sibling::db:figure or
      following-sibling::db:example or
      following-sibling::db:equation">
      <fo:block space-after="0pt" 
        xsl:use-attribute-sets="formal.object.properties">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::db:informaltable or
      following-sibling::db:informalfigure or
      following-sibling::db:informalexample or
      following-sibling::db:informalequation">
      <fo:block space-after="0pt" 
        xsl:use-attribute-sets="informal.object.properties">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::db:itemizedlist or
      following-sibling::db:orderedlist or
      following-sibling::db:variablelist or
      following-sibling::db:simplelist">
      <fo:block space-after="0pt" 
        xsl:use-attribute-sets="informal.object.properties">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="following-sibling::db:listitem or
      following-sibling::db:step">
      <fo:list-item space-after="0pt" 
        xsl:use-attribute-sets="informal.object.properties">
        <fo:list-item-label/>
        <fo:list-item-body start-indent="0pt" end-indent="0pt">
          <xsl:copy-of select="$spacer"/>
        </fo:list-item-body>
      </fo:list-item>
    </xsl:when>
    <xsl:when test="following-sibling::db:sect1 or
      following-sibling::db:sect2 or
      following-sibling::db:sect3 or
      following-sibling::db:sect4 or
      following-sibling::db:sect5 or
      following-sibling::db:section">
      <fo:block space-after="0pt" 
        xsl:use-attribute-sets="section.title.properties">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block space-after="0pt" space-before="0em">
        <xsl:copy-of select="$spacer"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="$fo.processor = 'fop'">
      <!-- Doesn't work in fop -->
    </xsl:when>
    <xsl:when test="following-sibling::db:listitem or
      following-sibling::db:step">
      <fo:list-item space-before.precedence="force"
        space-before="-{$height}"
        space-after="0pt"
        space-after.precedence="force">
        <fo:list-item-label/>
        <fo:list-item-body start-indent="0pt" end-indent="0pt"/>
      </fo:list-item>
    </xsl:when>
    <xsl:otherwise>
      <fo:block space-before.precedence="force"
        space-before="-{$height}"
        space-after="0pt"
        space-after.precedence="force">
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="processing-instruction()">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="processing-instruction('dbfo-need')">
  <xsl:call-template name="pi.dbfo-need"/>
</xsl:template>

</xsl:stylesheet>
