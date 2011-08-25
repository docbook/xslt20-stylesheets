<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="db doc f fn h m t xs"
                version="2.0">

<!-- ============================================================ -->

<doc:mode name="m:titlepage-mode"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting elements on the title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the title page.
Any element processed in this mode should generate markup appropriate
for the title page.</para>
<note>
<para>Title, subtitle, and titleabbrev are handled by <mode>m:title-markup</mode>
because they're optional on some elements (and because they're reused in
multiple places).</para>
</note>
</refdescription>
</doc:mode>

<xsl:template match="db:copyright" mode="m:titlepage-mode">
  <p class="{local-name(.)}">
    <xsl:apply-templates select="."/> <!-- no mode -->
  </p>
</xsl:template>

<xsl:template match="db:year" mode="m:titlepage-mode">
  <span class="{local-name(.)}">
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:holder" mode="m:titlepage-mode">
  <span class="{local-name(.)}">
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:holder">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:releaseinfo" mode="m:titlepage-mode">
  <p class="{local-name(.)}">
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates mode="m:titlepage-mode"/>
  </p>
</xsl:template>

<xsl:template match="db:abstract" mode="m:titlepage-mode">
  <div class="{local-name()}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:legalnotice" mode="m:titlepage-mode">
  <div class="{local-name()}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:titlepage-mode">
  <xsl:apply-templates mode="m:titlepage-mode"/>
</xsl:template>

<xsl:template match="db:pubdate" mode="m:titlepage-mode">
  <div>
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="class"/>

    <p>
      <xsl:choose>
        <xsl:when test=". castable as xs:dateTime">
          <xsl:value-of select="format-dateTime(xs:dateTime(.),
                                                $dateTime-format)"/>
        </xsl:when>
        <xsl:when test=". castable as xs:date">
          <xsl:value-of select="format-date(xs:date(.), $date-format)"/>
        </xsl:when>
        <xsl:when test=". castable as xs:gYearMonth">
          <xsl:value-of select="format-date(xs:date(concat(.,'-01')),
                                            $gYearMonth-format)"/>
        </xsl:when>
        <xsl:when test=". castable as xs:gYear">
          <xsl:value-of select="format-date(xs:date(concat(.,'-01-01')),
                                            $gYear-format)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </div>
</xsl:template>

<xsl:template match="db:info/db:author
                     |db:info/db:authorgroup/db:author
                     |db:info/db:editor
                     |db:info/db:authorgroup/db:editor"
	      mode="m:titlepage-mode">
  <xsl:call-template name="t:credits.div"/>
</xsl:template>

<xsl:param name="editedby.enabled" select="1"/>

<xsl:template name="t:credits.div">
  <div class="{local-name(.)}">
    <xsl:call-template name="t:id"/>

    <xsl:if test="self::db:editor[position()=1] and not($editedby.enabled = 0)">
      <h4 class="editedby">
        <xsl:value-of select="f:gentext(.,'editedby')"/>
      </h4>
    </xsl:if>

    <h3>
      <!-- use normal mode -->
      <xsl:apply-templates select="db:orgname|db:personname"/>
    </h3>
  </div>
</xsl:template>

</xsl:stylesheet>
