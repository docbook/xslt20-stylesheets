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
  <h1>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h1>
</xsl:template>

<xsl:template match="db:partintro" mode="m:title-markup">
  <h2>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="db:dedication|db:preface|db:chapter|db:appendix
		     |db:colophon|db:article|db:glossary|db:index
                     |db:bibliography"
              mode="m:title-markup">
  <h2>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="db:bibliodiv|db:glossdiv|db:indexdiv"
	      mode="m:title-markup">
  <h3>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h3>
</xsl:template>

<xsl:template match="db:qandaset"
	      mode="m:title-markup">
  <h2>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="db:bibliolist|db:glosslist|db:qandadiv|db:task"
	      mode="m:title-markup">
  <h3>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h3>
</xsl:template>

<xsl:template match="db:tasksummary|db:taskprerequisites|db:taskrelated"
	      mode="m:title-markup">
  <h4>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h4>
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
      <h4><xsl:sequence select="$content"/></h4>
    </xsl:when>
    <xsl:otherwise>
      <h3><xsl:sequence select="$content"/></h3>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:step"
	      mode="m:title-markup">
  <h4>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h4>
</xsl:template>

<xsl:template match="db:tip|db:note|db:important|db:warning|db:caution"
	      mode="m:title-markup">
  <h3>
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h3>
</xsl:template>

<xsl:template match="db:sidebar"
	      mode="m:title-markup">
  <!-- Oooh, this seems like a bit of a hack! -->
  <xsl:variable name="parent" as="node()*">
    <xsl:apply-templates select="parent::*" mode="m:title-markup"/>
  </xsl:variable>

  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="matches(local-name($parent[1]), '^h[12345]$')">
      <xsl:variable name="plevel" select="xs:integer(substring(local-name($parent[1]),2,1))"/>
      <xsl:variable name="level" select="$plevel + 1"/>
      <xsl:element name="h{$level}" namespace="http://www.w3.org/1999/xhtml">
        <xsl:sequence select="$content"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <div class="title">
        <xsl:sequence select="$content"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:annotation"
	      mode="m:title-markup">
  <div class="title">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="db:section"
	      mode="m:title-markup">
  <xsl:variable name="depth"
		select="count(ancestor::db:section)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>

  <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="db:sect1|db:sect2|db:sect3|db:sect4|db:sect5|db:sect6"
	      mode="m:title-markup">

  <xsl:variable name="depth"
		select="xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>

  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:element>
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

  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="db:refsection"
	      mode="m:title-markup">
  <xsl:variable name="depth"
		select="count(ancestor::db:refsection)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>

  <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="db:refsect1|db:refsect2|db:refsect3"
	      mode="m:title-markup">

  <xsl:variable name="depth"
		select="xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>

  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:element>
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
    <h2>
      <xsl:sequence select="$content"/>
    </h2>
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
    <h3>
      <xsl:sequence select="$content"/>
    </h3>
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
    <h4>
      <xsl:sequence select="$content"/>
    </h4>
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

    <xsl:element name="h{$hlevel+4}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:sequence select="$content"/>
    </xsl:element>
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

    <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:sequence select="$content"/>
    </xsl:element>
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

    <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:sequence select="$content"/>
    </xsl:element>
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

    <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:sequence select="$content"/>
    </xsl:element>
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

    <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:sequence select="$content"/>
    </xsl:element>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
