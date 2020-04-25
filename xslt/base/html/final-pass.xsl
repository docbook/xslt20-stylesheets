<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="h f m mp fn db t ghost"
                version="2.0">

  <xsl:include href="../VERSION.xsl"/>
  <xsl:include href="param.xsl"/>
  <xsl:include href="../common/control.xsl"/>
  <xsl:include href="../common/dbfunctions.xsl"/>
  <xsl:include href="../common/l10n.xsl"/>
  <xsl:include href="../common/spspace.xsl"/>
  <xsl:include href="../common/gentext.xsl"/>
  <xsl:include href="../common/common.xsl"/>
  <xsl:include href="../common/label-content.xsl"/>
  <xsl:include href="../common/title-content.xsl"/>
  <xsl:include href="../common/inlines.xsl"/>
  <xsl:include href="../common/olink.xsl"/>
  <xsl:include href="../common/titlepages.xsl"/>
  <xsl:include href="titlepage-templates.xsl"/>
  <xsl:include href="titlepage-mode.xsl"/>
  <xsl:include href="autotoc.xsl"/>
  <xsl:include href="toc.xsl"/>
  <xsl:include href="division.xsl"/>
  <xsl:include href="component.xsl"/>
  <xsl:include href="refentry.xsl"/>
  <xsl:include href="synopsis.xsl"/>
  <xsl:include href="section.xsl"/>
  <xsl:include href="biblio.xsl"/>
  <xsl:include href="pi.xsl"/>
  <xsl:include href="info.xsl"/>
  <xsl:include href="glossary.xsl"/>
  <xsl:include href="table.xsl"/>
  <xsl:include href="lists.xsl"/>
  <xsl:include href="task.xsl"/>
  <xsl:include href="callouts.xsl"/>
  <xsl:include href="formal.xsl"/>
  <xsl:include href="blocks.xsl"/>
  <xsl:include href="msgset.xsl"/>
  <xsl:include href="graphics.xsl"/>
  <xsl:include href="footnotes.xsl"/>
  <xsl:include href="admonitions.xsl"/>
  <xsl:include href="verbatim.xsl"/>
  <xsl:include href="qandaset.xsl"/>
  <xsl:include href="inlines.xsl"/>
  <xsl:include href="xref.xsl"/>
  <xsl:include href="xlink.xsl"/>
  <xsl:include href="math.xsl"/>
  <xsl:include href="html.xsl"/>
  <xsl:include href="index.xsl"/>
  <xsl:include href="autoidx.xsl"/>
  <xsl:include href="chunks.xsl"/>

<!-- ============================================================ -->

<xsl:output method="xhtml" encoding="utf-8" indent="no" />
<xsl:output name="xml" method="xml" encoding="utf-8" indent="no"/>
<xsl:output name="final" method="xhtml" encoding="utf-8" indent="no"/>

<xsl:param name="stylesheet.result.type" select="'xhtml'"/>

<xsl:template match="/">
  <xsl:if test="$verbosity &gt; 3">
    <xsl:message>Styling...</xsl:message>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="empty($chunk-tree)">
      <xsl:apply-templates select="*" mode="m:pre-root"/>
      <html>
        <xsl:if test="/*/@status">
          <xsl:attribute name="class" select="/*/@status"/>
        </xsl:if>
        <head>
          <xsl:apply-templates select="*" mode="mp:html-head"/>
        </head>
        <body>
          <xsl:call-template name="t:body-attributes"/>
          <xsl:apply-templates/>
          <xsl:apply-templates select="." mode="mp:javascript-body"/>
          <xsl:apply-templates select="." mode="m:javascript-body"/>
        </body>
      </html>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="chunks" as="element()*">
        <xsl:choose>
          <xsl:when test="empty($rootid) or $rootid = ''">
            <xsl:sequence select="$chunk-elements"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="$chunk-elements[@xml:id=$rootid]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="empty($chunks)">
        <xsl:message terminate="yes">
          <xsl:text>There is no chunk with the ID: </xsl:text>
          <xsl:value-of select="$rootid"/>
        </xsl:message>
      </xsl:if>

      <xsl:for-each select="$chunks">
        <xsl:call-template name="t:chunk">
          <xsl:with-param name="content">
            <xsl:apply-templates select=".">
              <xsl:with-param name="processing-chunk-root" select="true()"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*">
  <div class="unknowntag">
    <xsl:sequence select="f:html-attributes(.)"/>
    <font color="red">
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
    </font>
    <xsl:apply-templates/>
    <font color="red">
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>&gt;</xsl:text>
    </font>
  </div>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
