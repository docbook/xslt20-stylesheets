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
  <fo:block xsl:use-attribute-sets="division.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:partintro" mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="partintro.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:dedication|db:preface|db:chapter|db:appendix
		     |db:colophon|db:article|db:glossary|db:index
                     |db:bibliography"
              mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="component.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:bibliodiv|db:glossdiv|db:indexdiv"
	      mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="div.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:qandaset"
	      mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="qandaset.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:bibliolist|db:glosslist|db:qandadiv|db:task"
	      mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="list.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:tasksummary|db:taskprerequisites|db:taskrelated"
	      mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="taskpart.title.properties">
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
      <fo:block xsl:use-attribute-sets="procedure.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block xsl:use-attribute-sets="procedure.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:step"
	      mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="step.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:tip|db:note|db:important|db:warning|db:caution"
	      mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="admonition.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:sidebar"
	      mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="sidebar.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:annotation"
	      mode="m:title-markup">
  <fo:block xsl:use-attribute-sets="annotation.title.properties">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:section|db:sect1|db:sect2|db:sect3|db:sect4|db:sect5|db:sect6|db:simplesect"
	      mode="m:title-markup">

  <xsl:variable name="depth" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="self::db:section">
	<xsl:sequence select="count(ancestor-or-self::db:section)"/>
      </xsl:when>
      <xsl:when test="self::db:simplesect">
	<xsl:choose>
	  <xsl:when test="ancestor::db:sect5">6</xsl:when>
	  <xsl:when test="ancestor::db:sect4">5</xsl:when>
	  <xsl:when test="ancestor::db:sect3">4</xsl:when>
	  <xsl:when test="ancestor::db:sect2">3</xsl:when>
	  <xsl:when test="ancestor::db:sect1">2</xsl:when>
	  <xsl:when test="ancestor::db:section">
	    <xsl:value-of select="count(ancestor::db:section) + 1"/>
	  </xsl:when>
	  <xsl:otherwise>1</xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="level" select="f:section-level(.)"/>

  <xsl:variable name="marker">
    <xsl:choose>
      <xsl:when test="$level &lt;= $marker.section.level">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="marker.title">
    <xsl:apply-templates select="." mode="m:titleabbrev-markup">
      <xsl:with-param name="allow-anchors" select="false()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:variable name="content">
    <xsl:if test="$marker != 0">
      <fo:marker marker-class-name="section.head.marker">
	<xsl:copy-of select="$marker.title"/>
      </fo:marker>
    </xsl:if> 
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$depth eq 1">
      <fo:block xsl:use-attribute-sets="section.level1.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="$depth eq 2">
      <fo:block xsl:use-attribute-sets="section.level2.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="$depth eq 3">
      <fo:block xsl:use-attribute-sets="section.level3.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="$depth eq 4">
      <fo:block xsl:use-attribute-sets="section.level4.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="$depth eq 5">
      <fo:block xsl:use-attribute-sets="section.level5.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="$depth eq 6">
      <fo:block xsl:use-attribute-sets="section.level6.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Warning: styling of more then six levels of nested sections is not supported.</xsl:message>
      <fo:block xsl:use-attribute-sets="section.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:refsection|db:refsect1|db:refsect2|db:refsect3"
	      mode="m:title-markup">
  <xsl:variable name="depth"
		select="if (self::db:refsection) then count(ancestor::db:refsection)
			                         else xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>

  <xsl:variable name="content">
    <xsl:apply-templates select="." mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$depth eq 1">
      <fo:block xsl:use-attribute-sets="refsection.level1.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="$depth eq 2">
      <fo:block xsl:use-attribute-sets="refsection.level2.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="$depth eq 3">
      <fo:block xsl:use-attribute-sets="refsection.level3.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Warning: styling of more then three levels of nested refsections is not supported.</xsl:message>
      <fo:block xsl:use-attribute-sets="section.title.properties">
	<xsl:sequence select="$content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
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
    <fo:block xsl:use-attribute-sets="division.subtitle.properties">
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
    <fo:block xsl:use-attribute-sets="component.subtitle.properties">
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
    <fo:block xsl:use-attribute-sets="div.subtitle.properties">
      <xsl:sequence select="$content"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="db:section|db:sect1|db:sect2|db:sect3|db:sect4|db:sect5|db:sect6|db:simplesect"
	      mode="m:subtitle-markup">
  <xsl:variable name="depth" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="self::db:section">
	<xsl:sequence select="count(ancestor-or-self::db:section)"/>
      </xsl:when>
      <xsl:when test="self::db:simplesect">
	<xsl:choose>
	  <xsl:when test="ancestor::db:sect5">6</xsl:when>
	  <xsl:when test="ancestor::db:sect4">5</xsl:when>
	  <xsl:when test="ancestor::db:sect3">4</xsl:when>
	  <xsl:when test="ancestor::db:sect2">3</xsl:when>
	  <xsl:when test="ancestor::db:sect1">2</xsl:when>
	  <xsl:when test="ancestor::db:section">
	    <xsl:value-of select="count(ancestor::db:section) + 1"/>
	  </xsl:when>
	  <xsl:otherwise>1</xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="not(empty($content))">
    <xsl:choose>
      <xsl:when test="$depth eq 1">
	<fo:block xsl:use-attribute-sets="section.level1.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:when test="$depth eq 2">
	<fo:block xsl:use-attribute-sets="section.level2.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:when test="$depth eq 3">
	<fo:block xsl:use-attribute-sets="section.level3.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:when test="$depth eq 4">
	<fo:block xsl:use-attribute-sets="section.level4.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:when test="$depth eq 5">
	<fo:block xsl:use-attribute-sets="section.level5.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:when test="$depth eq 6">
	<fo:block xsl:use-attribute-sets="section.level6.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Warning: styling of more then six levels of nested sections is not supported.</xsl:message>
	<fo:block xsl:use-attribute-sets="section.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:refsection|db:refsect1|db:refsect2|db:refsect3"
	      mode="m:subtitle-markup">
  <xsl:variable name="depth"
		select="if (self::db:refsection) then count(ancestor::db:refsection)
			                         else xs:decimal(substring-after(local-name(.), 'sect')) - 1"/>

  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates select="." mode="m:subtitle-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="not(empty($content))">
    <xsl:choose>
      <xsl:when test="$depth eq 1">
	<fo:block xsl:use-attribute-sets="refsection.level1.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:when test="$depth eq 2">
	<fo:block xsl:use-attribute-sets="refsection.level2.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:when test="$depth eq 3">
	<fo:block xsl:use-attribute-sets="refsection.level3.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>Warning: styling of more then three levels of nested refsections is not supported.</xsl:message>
	<fo:block xsl:use-attribute-sets="section.subtitle.properties">
	  <xsl:sequence select="$content"/>
	</fo:block>
      </xsl:otherwise>
    </xsl:choose>
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
  <xsl:param name="allow-anchors" select="false()"/>
  <xsl:apply-templates select="." mode="m:titleabbrev-content">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
