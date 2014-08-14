<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="f m fn db t xs"
                version="2.0">

  <xsl:include href="../VERSION.xsl"/>
  <xsl:include href="param.xsl"/>
  <xsl:include href="../common/control.xsl"/>
  <xsl:include href="../common/l10n.xsl"/>
  <xsl:include href="../common/spspace.xsl"/>
  <xsl:include href="../common/gentext.xsl"/>
  <xsl:include href="../common/normalize.xsl"/>
  <xsl:include href="../common/functions.xsl"/>
  <xsl:include href="../common/common.xsl"/>
  <xsl:include href="../common/label-content.xsl"/>
  <xsl:include href="../common/title-content.xsl"/>
  <xsl:include href="../common/inlines.xsl"/>
<!--  <xsl:include href="../common/olink.xsl"/>-->
  <xsl:include href="pagesetup.xsl"/>
  <xsl:include href="../common/titlepages.xsl"/>
  <xsl:include href="titlepage-templates.xsl"/>
  <xsl:include href="titlepage-mode.xsl"/>
  <xsl:include href="autotoc.xsl"/>
  <xsl:include href="division.xsl"/>
  <xsl:include href="component.xsl"/>
  <xsl:include href="fo.xsl"/>
<!--
  <xsl:include href="refentry.xsl"/>
  <xsl:include href="synopsis.xsl"/>
-->
  <xsl:include href="sections.xsl"/>
  <xsl:include href="biblio.xsl"/>
  <xsl:include href="pi.xsl"/>
  <xsl:include href="info.xsl"/>
  <xsl:include href="glossary.xsl"/>
  <xsl:include href="lists.xsl"/>
<!--
  <xsl:include href="task.xsl"/>
  <xsl:include href="callouts.xsl"/>
-->

  <xsl:include href="table.xsl"/>
  <xsl:include href="formal.xsl"/>

  <xsl:include href="blocks.xsl"/>
  <xsl:include href="graphics.xsl"/>
  <xsl:include href="footnotes.xsl"/>
  <xsl:include href="admonitions.xsl"/>
  <xsl:include href="verbatim.xsl"/>
<!--
  <xsl:include href="qandaset.xsl"/>
-->
  <xsl:include href="inlines.xsl"/>
  <xsl:include href="xref.xsl"/>
<!--
  <xsl:include href="math.xsl"/>
  <xsl:include href="html.xsl"/>
-->
  <xsl:include href="index.xsl"/>
<!--
  <xsl:include href="autoidx.xsl"/>
  <xsl:include href="chunker.xsl"/>
-->

<xsl:output method="xml" encoding="utf-8" indent="no"/>

<xsl:param name="stylesheet.result.type" select="'fo'"/>

<xsl:param name="body.fontset" as="xs:string">
  <xsl:variable name="fontlist" as="xs:string+">
    <xsl:value-of select="$body.font.family"/>
    <xsl:if test="$symbol.font.family != ''">
      <xsl:value-of select="$symbol.font.family"/>
    </xsl:if>
  </xsl:variable>
  <xsl:value-of select="$fontlist" separator=","/>
</xsl:param>

<xsl:template match="/">
  <xsl:if test="$verbosity &gt; 3">
    <xsl:message>Styling...</xsl:message>
  </xsl:if>

  <xsl:variable name="title" select="f:title(/)"/>

  <fo:root xsl:use-attribute-sets="root.properties">
      <!--
	<xsl:attribute name="language">
	  <xsl:call-template name="l10n.language">
	    <xsl:with-param name="target" select="/*[1]"/>
	  </xsl:call-template>
	</xsl:attribute>
      -->

      <!--
	<xsl:if test="$fo.processor = 'xep'">
	  <xsl:call-template name="xep-pis"/>
	  <xsl:call-template name="xep-document-information"/>
	</xsl:if>

	<xsl:if test="$fo.processor = 'axf'">
	  <xsl:call-template name="axf-document-information"/>
	</xsl:if>
      -->

      <xsl:call-template name="t:setup-pagemasters"/>

      <!--
	<xsl:if test="$fo.processor = 'fop'">
	  <xsl:apply-templates select="$root" mode="fop.outline"/>
	</xsl:if>

	<xsl:if test="$fo.processor = 'fop1'">
	  <xsl:variable name="bookmarks">
	    <xsl:apply-templates select="$root" 
				 mode="fop1.outline"/>
	  </xsl:variable>
	  <xsl:if test="string($bookmarks) != ''">
	    <fo:bookmark-tree>
	      <xsl:copy-of select="$bookmarks"/>
	    </fo:bookmark-tree>
	  </xsl:if>
	</xsl:if>

	<xsl:if test="$fo.processor = 'xep'">
	  <xsl:variable name="bookmarks">
	    <xsl:apply-templates select="$root" mode="xep.outline"/>
	  </xsl:variable>
	  <xsl:if test="string($bookmarks) != ''">
	    <rx:outline xmlns:rx="http://www.renderx.com/XSL/Extensions">
	      <xsl:copy-of select="$bookmarks"/>
	    </rx:outline>
	  </xsl:if>
	</xsl:if>
      -->

      <xsl:apply-templates/>
  </fo:root>
</xsl:template>

<xsl:template match="*">
  <fo:block>
    <xsl:call-template name="t:id"/>
    <fo:inline color="red">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:for-each select="@*">
	<xsl:text> </xsl:text>
	<xsl:value-of select="name(.)"/>
	<xsl:text>="</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>"</xsl:text>
      </xsl:for-each>
      <xsl:text>&gt;</xsl:text>
    </fo:inline>
    <xsl:apply-templates/>
    <fo:inline color="red">
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>&gt;</xsl:text>
    </fo:inline>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
