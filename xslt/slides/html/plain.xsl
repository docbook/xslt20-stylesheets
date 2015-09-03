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
  <xsl:variable name="classes" as="xs:string*">
    <xsl:text>foil </xsl:text>
    <xsl:value-of select="@role"/>
    <xsl:if test="parent::db:slides and preceding-sibling::db:foilgroup">
      <xsl:text>titlefoil foilgroup </xsl:text>
    </xsl:if>
  </xsl:variable>

  <section class="{normalize-space(string-join($classes, ' '))}">
    <xsl:if test="@xml:id">
      <xsl:attribute name="id" select="@xml:id"/>
    </xsl:if>
    <article class="page">
      <header>
        <div class="header-content">
          <h1>
            <xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/>
          </h1>
        </div>
      </header>
      <div class="body">
        <xsl:call-template name="t:clicknav">
          <xsl:with-param name="prev" select="concat('#', f:slideno(.)-1)"/>
          <xsl:with-param name="next"
                          select="if (following::db:foil) then concat('#', f:slideno(.)+1) else ()"/>
        </xsl:call-template>

        <xsl:choose>
          <xsl:when test="string($speaker.notes) = '0'">
            <xsl:apply-templates select="*[not(self::db:title) and not(self::db:speakernotes)]"/>

            <xsl:call-template name="t:process-footnotes"/>
          </xsl:when>
          <xsl:when test="db:speakernotes">
            <div class="foilinset">
              <xsl:apply-templates select="*[not(self::db:title) and not(self::db:speakernotes)]"/>
            </div>
            <xsl:apply-templates select="db:speakernotes"/>
          </xsl:when>
          <xsl:otherwise>
            <div class="foilinset">
              <xsl:apply-templates select="*[not(self::db:title) and not(self::db:speakernotes)]"/>
            </div>
            <p>No speaker notes for this foil.</p>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </article>
    <xsl:call-template name="t:slide-footer"/>
  </section>
</xsl:template>

</xsl:stylesheet>

