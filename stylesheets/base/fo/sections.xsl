<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="db f m t"
                version='2.0'>

<!-- ********************************************************************
     $Id: sections.xsl 6910 2007-06-28 23:23:30Z xmldoc $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:attribute-set name="section.properties"/>
<xsl:attribute-set name="section.level1.properties" use-attribute-sets="section.properties"/>
<xsl:attribute-set name="section.level2.properties" use-attribute-sets="section.properties"/>
<xsl:attribute-set name="section.level3.properties" use-attribute-sets="section.properties"/>
<xsl:attribute-set name="section.level4.properties" use-attribute-sets="section.properties"/>
<xsl:attribute-set name="section.level5.properties" use-attribute-sets="section.properties"/>
<xsl:attribute-set name="section.level6.properties" use-attribute-sets="section.properties"/>

<xsl:attribute-set name="section.title.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.font.family"/>
  </xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <!-- font size is calculated dynamically by section.heading template -->
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1.0em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
  <xsl:attribute name="text-align">left</xsl:attribute>
  <xsl:attribute name="start-indent"><xsl:value-of select="$title.margin.left"/></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level1.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'20.736pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level2.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'17.28pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level3.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'14.4pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level4.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'12pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level5.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'10pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level6.properties" use-attribute-sets="section.title.properties">
  <xsl:attribute name="font-size" select="'10pt'"/>
</xsl:attribute-set>

<xsl:param name="section.container.element" select="'block'"/>

<xsl:param name="marker.section.level" select="2"/>

<!-- ==================================================================== -->

<xsl:template match="db:section">
  <xsl:choose>
    <xsl:when test="$rootid = @xml:id">
      <xsl:call-template name="t:section-page-sequence"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="level" select="f:section-level(.)"/>

      <!-- xsl:use-attribute-sets takes only a Qname, not a variable -->
      <xsl:choose>
        <xsl:when test="$level = 1">
          <xsl:element name="fo:{$section.container.element}"
		       use-attribute-sets="section.level1.properties">
	    <xsl:call-template name="t:section-content"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$level = 2">
          <xsl:element name="fo:{$section.container.element}"
		       use-attribute-sets="section.level2.properties">
            <xsl:call-template name="t:section-content"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$level = 3">
          <xsl:element name="fo:{$section.container.element}"
                       use-attribute-sets="section.level3.properties">
            <xsl:call-template name="t:section-content"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$level = 4">
          <xsl:element name="fo:{$section.container.element}"
                       use-attribute-sets="section.level4.properties">
            <xsl:call-template name="t:section-content"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$level = 5">
          <xsl:element name="fo:{$section.container.element}"
		       use-attribute-sets="section.level5.properties">
            <xsl:call-template name="t:section-content"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="fo:{$section.container.element}"
		       use-attribute-sets="section.level6.properties">
            <xsl:call-template name="t:section-content"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:section-content">
  <xsl:variable name="toc.params"
		select="f:find-toc-params(., $generate.toc)"/>

  <fo:block>
    <xsl:call-template name="t:id"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:call-template name="make-lots">
      <xsl:with-param name="toc.params" select="$toc.params"/>
      <xsl:with-param name="toc">
	<xsl:call-template name="t:section-toc">
	  <xsl:with-param name="toc.title" select="$toc.params/@title != 0"/>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="/db:section|/db:sect1" name="t:section-page-sequence">
  <xsl:variable name="master-reference" select="f:select-pagemaster(.)"/>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}">
    <xsl:call-template name="t:page-sequence-attributes"/>

    <xsl:apply-templates select="." mode="m:running-head-mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="." mode="m:running-foot-mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>

    <fo:flow flow-name="xsl-region-body">
      <xsl:call-template name="t:flow-properties">
        <xsl:with-param name="element" select="local-name(.)"/>
        <xsl:with-param name="master-reference" select="$master-reference"/>
      </xsl:call-template>

      <xsl:call-template name="t:section-content"/>
   </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="db:sect1">
  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level1.properties">
    <xsl:call-template name="t:section-content"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:sect2">
  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level2.properties">
    <xsl:call-template name="t:section-content"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:sect3">
  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level3.properties">
    <xsl:call-template name="t:section-content"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:sect4">
  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level4.properties">
    <xsl:call-template name="t:section-content"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:sect5">
  <xsl:element name="fo:{$section.container.element}"
	       use-attribute-sets="section.level5.properties">
    <xsl:call-template name="t:section-content"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:simplesect">
  <xsl:element name="fo:{$section.container.element}">
    <xsl:call-template name="t:section-content"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:section/db:info"></xsl:template>
<xsl:template match="db:sect1/db:info"></xsl:template>
<xsl:template match="db:sect2/db:info"></xsl:template>
<xsl:template match="db:sect3/db:info"></xsl:template>
<xsl:template match="db:sect4/db:info"></xsl:template>
<xsl:template match="db:sect5/db:info"></xsl:template>
<xsl:template match="db:simplesect/db:info"></xsl:template>

<!-- ==================================================================== -->

<xsl:template name="t:section-heading">
  <xsl:param name="level" select="1"/>
  <xsl:param name="marker" select="1"/>
  <xsl:param name="title"/>
  <xsl:param name="marker.title"/>

  <fo:block xsl:use-attribute-sets="section.title.properties">
    <xsl:if test="$marker != 0">
      <fo:marker marker-class-name="section.head.marker">
        <xsl:copy-of select="$marker.title"/>
      </fo:marker>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$level=1">
        <fo:block xsl:use-attribute-sets="section.title.level1.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=2">
        <fo:block xsl:use-attribute-sets="section.title.level2.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=3">
        <fo:block xsl:use-attribute-sets="section.title.level3.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=4">
        <fo:block xsl:use-attribute-sets="section.title.level4.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=5">
        <fo:block xsl:use-attribute-sets="section.title.level5.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="section.title.level6.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<!--
<xsl:template match="bridgehead">
  <xsl:variable name="container"
                select="(ancestor::appendix
                        |ancestor::article
                        |ancestor::bibliography
                        |ancestor::chapter
                        |ancestor::glossary
                        |ancestor::glossdiv
                        |ancestor::index
                        |ancestor::partintro
                        |ancestor::preface
                        |ancestor::refsect1
                        |ancestor::refsect2
                        |ancestor::refsect3
                        |ancestor::sect1
                        |ancestor::sect2
                        |ancestor::sect3
                        |ancestor::sect4
                        |ancestor::sect5
                        |ancestor::section
                        |ancestor::setindex
                        |ancestor::simplesect)[last()]"/>

  <xsl:variable name="clevel">
    <xsl:choose>
      <xsl:when test="local-name($container) = 'appendix'
                      or local-name($container) = 'chapter'
                      or local-name($container) = 'article'
                      or local-name($container) = 'bibliography'
                      or local-name($container) = 'glossary'
                      or local-name($container) = 'index'
                      or local-name($container) = 'partintro'
                      or local-name($container) = 'preface'
                      or local-name($container) = 'setindex'">2</xsl:when>
      <xsl:when test="local-name($container) = 'glossdiv'">
        <xsl:value-of select="count(ancestor::glossdiv)+2"/>
      </xsl:when>
      <xsl:when test="local-name($container) = 'sect1'
                      or local-name($container) = 'sect2'
                      or local-name($container) = 'sect3'
                      or local-name($container) = 'sect4'
                      or local-name($container) = 'sect5'
                      or local-name($container) = 'refsect1'
                      or local-name($container) = 'refsect2'
                      or local-name($container) = 'refsect3'
                      or local-name($container) = 'section'
                      or local-name($container) = 'simplesect'">
        <xsl:variable name="slevel">
          <xsl:call-template name="section.level">
            <xsl:with-param name="node" select="$container"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$slevel + 1"/>
      </xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="level">
    <xsl:choose>
      <xsl:when test="@renderas = 'sect1'">1</xsl:when>
      <xsl:when test="@renderas = 'sect2'">2</xsl:when>
      <xsl:when test="@renderas = 'sect3'">3</xsl:when>
      <xsl:when test="@renderas = 'sect4'">4</xsl:when>
      <xsl:when test="@renderas = 'sect5'">5</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$clevel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="marker">
    <xsl:choose>
      <xsl:when test="$level &lt;= $marker.section.level">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="marker.title">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:call-template name="section.heading">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title">
        <xsl:apply-templates/>
      </xsl:with-param>
      <xsl:with-param name="marker" select="$marker"/>
      <xsl:with-param name="marker.title" select="$marker.title"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>
-->

</xsl:stylesheet>

