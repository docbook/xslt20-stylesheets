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
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		exclude-result-prefixes="db doc f fn h m t xs fo"
                version="2.0">

<xsl:template match="db:info|db:title|db:subtitle|db:titleabbrev">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:title-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting title and titleabbrev elements</refpurpose>

<refdescription>
<para>This mode is used to format title and titleabbrev elements on the title page.
Any element processed in this mode should generate markup appropriate
for the title page.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:set|db:book|db:part|db:reference|db:setindex"
              mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:partintro" mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:dedication|db:preface|db:chapter|db:appendix
		     |db:colophon|db:article|db:glossary|db:index
                     |db:bibliography"
              mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:bibliodiv|db:glossdiv|db:indexdiv"
	      mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:qandaset"
	      mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:bibliolist|db:glosslist|db:qandadiv|db:task"
	      mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:tasksummary|db:taskprerequisites|db:taskrelated"
	      mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:procedure"
	      mode="m:title-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="ancestor::db:task">
      <fo:block> <!-- FIXME: add property set -->
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block> <!-- FIXME: add property set -->
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:step"
	      mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:tip|db:note|db:important|db:warning|db:caution"
	      mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:sidebar"
	      mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:annotation"
	      mode="m:title-markup">
  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:section"
	      mode="m:title-markup">
  <xsl:variable name="depth"
		select="count(ancestor::db:section)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>

  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:sect1|db:sect2|db:sect3|db:sect4|db:sect5|db:sect6"
	      mode="m:title-markup">

  <xsl:variable name="depth"
		select="xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>

  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:simplesect"
	      mode="m:title-markup">
  <xsl:variable name="depth" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="ancestor::db:sect5">5</xsl:when>
      <xsl:when test="ancestor::db:sect4">4</xsl:when>
      <xsl:when test="ancestor::db:sect3">3</xsl:when>
      <xsl:when test="ancestor::db:sect2">2</xsl:when>
      <xsl:when test="ancestor::db:sect1">1</xsl:when>
      <xsl:when test="ancestor::db:section">
        <xsl:value-of select="count(ancestor::db:section)"/>
      </xsl:when>
      <xsl:otherwise>6</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>

  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:refsection"
	      mode="m:title-markup">
  <xsl:variable name="depth"
		select="count(ancestor::db:refsection)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>

  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:refsect1|db:refsect2|db:refsect3"
	      mode="m:title-markup">

  <xsl:variable name="depth"
		select="xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>

  <fo:block> <!-- FIXME: add property set -->
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:set|db:book|db:part|db:reference|db:setindex"
              mode="m:subtitle-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:if test="not(empty($content))">
    <fo:block> <!-- FIXME: add property set -->
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="db:dedication|db:preface|db:chapter|db:appendix
		     |db:colophon|db:article|db:glossary|db:index
                     |db:bibliography"
              mode="m:subtitle-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:if test="not(empty($content))">
    <fo:block> <!-- FIXME: add property set -->
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="db:bibliodiv|db:glossdiv|db:indexdiv"
              mode="m:subtitle-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:if test="not(empty($content))">
    <fo:block> <!-- FIXME: add property set -->
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="db:section"
	      mode="m:subtitle-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="not(empty($content))">
    <xsl:variable name="depth"
                  select="count(ancestor::db:section)"/>

    <xsl:variable name="hlevel"
                  select="if ($depth &lt; 3) then $depth else 2"/>

    <fo:block> <!-- FIXME: add property set -->
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="db:sect1|db:sect2|db:sect3|db:sect4|db:sect5|db:sect6"
	      mode="m:subtitle-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="not(empty($content))">
    <xsl:variable name="depth"
                  select="xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>

    <xsl:variable name="hlevel"
                  select="if ($depth &lt; 4) then $depth else 3"/>

    <fo:block> <!-- FIXME: add property set -->
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="db:simplesect"
	      mode="m:subtitle-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="not(empty($content))">
    <xsl:variable name="depth" as="xs:decimal">
      <xsl:choose>
        <xsl:when test="ancestor::db:sect5">5</xsl:when>
        <xsl:when test="ancestor::db:sect4">4</xsl:when>
        <xsl:when test="ancestor::db:sect3">3</xsl:when>
        <xsl:when test="ancestor::db:sect2">2</xsl:when>
        <xsl:when test="ancestor::db:sect1">1</xsl:when>
        <xsl:when test="ancestor::db:section">
          <xsl:value-of select="count(ancestor::db:section)"/>
        </xsl:when>
        <xsl:otherwise>6</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="hlevel"
                  select="if ($depth &lt; 4) then $depth else 3"/>

    <fo:block> <!-- FIXME: add property set -->
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="db:refsection"
	      mode="m:subtitle-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="not(empty($content))">
    <xsl:variable name="depth"
                  select="count(ancestor::db:refsection)"/>

    <xsl:variable name="hlevel"
                  select="if ($depth &lt; 4) then $depth else 3"/>

    <fo:block> <!-- FIXME: add property set -->
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="db:refsect1|db:refsect2|db:refsect3"
	      mode="m:subtitle-markup">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="not(empty($content))">
    <xsl:variable name="depth"
                  select="xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>

    <xsl:variable name="hlevel"
                  select="if ($depth &lt; 4) then $depth else 3"/>

    <fo:block> <!-- FIXME: add property set -->
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:titleabbrev-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting title and titleabbrev elements</refpurpose>

<refdescription>
<para>This mode is used to format title and titleabbrev elements on page header and footers.
Any element processed in this mode should generate markup appropriate
for headers/footers.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:titleabbrev-markup">
  <!-- FIXME: implement this -->
  <xsl:apply-templates select="." mode="m:title-markup"/>
</xsl:template>

</xsl:stylesheet>
