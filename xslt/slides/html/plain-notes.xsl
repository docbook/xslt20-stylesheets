<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f h m t xs"
                version="2.0">

<xsl:import href="common.xsl"/>

<xsl:template match="db:foil">
  <section class="{ if (parent::db:slides and preceding-sibling::db:foilgroup)
                then 'foil closingfoil'
                else 'foil' }">
    <article class="page">
      <header>
        <h1>
          <xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/>
        </h1>
      </header>
      <div class="body">
        <xsl:call-template name="t:clicknav">
          <xsl:with-param name="prev" select="concat('#', f:slideno(.)-1)"/>
          <xsl:with-param name="next"
                          select="if (following::db:foil) then concat('#', f:slideno(.)+1) else ()"/>
        </xsl:call-template>

        <div class="foil-body">
            <xsl:apply-templates select="*[not(self::db:title) and not(self::db:speakernotes)]"/>

            <xsl:call-template name="t:process-footnotes"/>
        </div>

        <div class="foil-notes">
          <xsl:variable name="foilinset" as="element(h:div)">
            <div class="foilinset">
              <xsl:apply-templates select="*[not(self::db:title) and not(self::db:speakernotes)]"/>
            </div>
          </xsl:variable>

          <xsl:apply-templates select="$foilinset" mode="trim-reveal"/>

          <xsl:choose>
            <xsl:when test="db:speakernotes">
              <xsl:apply-templates select="db:speakernotes"/>
            </xsl:when>
            <xsl:otherwise>
              <p>No speaker notes for this foil.</p>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
    </article>
    <xsl:call-template name="t:slide-footer"/>
  </section>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="element()" mode="trim-reveal">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()" mode="trim-reveal"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@class" mode="trim-reveal" priority="10">
  <xsl:attribute name="class">
    <xsl:value-of select="replace(., 'reveal1?', '')"/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()"
              mode="trim-reveal">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
