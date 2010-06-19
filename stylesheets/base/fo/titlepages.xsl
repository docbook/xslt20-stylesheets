<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f fn m t xs"
                version="2.0">

<!-- ============================================================ -->

<xsl:param name="titlepage.document.order" select="0"/>

<xsl:param name="component.titlepage.recto.elements" as="element()*">
  <db:title/>
  <db:subtitle/>
  <db:author/>
  <db:authorgroup/>
  <db:othercredit/>
  <db:releaseinfo/>
  <db:copyright/>
  <db:legalnotice/>
  <db:pubdate/>
  <db:revision/>
  <db:revhistory/>
  <db:abstract/>
</xsl:param>

<xsl:param name="component.titlepage.verso.elements" as="element()*"/>

<xsl:param name="article.titlepage.recto.elements" as="element()*"
	   select="$component.titlepage.recto.elements"/>

<xsl:param name="article.titlepage.verso.elements" as="element()*"
	   select="$component.titlepage.verso.elements"/>

<xsl:param name="dedication.titlepage.recto.elements" as="element()*"
	   select="$component.titlepage.recto.elements"/>

<xsl:param name="dedication.titlepage.verso.elements" as="element()*"
	   select="$component.titlepage.verso.elements"/>

<xsl:param name="preface.titlepage.recto.elements" as="element()*"
	   select="$component.titlepage.recto.elements"/>

<xsl:param name="preface.titlepage.verso.elements" as="element()*"
	   select="$component.titlepage.verso.elements"/>

<xsl:param name="chapter.titlepage.recto.elements" as="element()*"
	   select="$component.titlepage.recto.elements"/>

<xsl:param name="chapter.titlepage.verso.elements" as="element()*"
	   select="$component.titlepage.verso.elements"/>

<xsl:param name="appendix.titlepage.recto.elements" as="element()*"
	   select="$component.titlepage.recto.elements"/>

<xsl:param name="appendix.titlepage.verso.elements" as="element()*"
	   select="$component.titlepage.verso.elements"/>

<xsl:param name="colophon.titlepage.recto.elements" as="element()*"
	   select="$component.titlepage.recto.elements"/>

<xsl:param name="colophon.titlepage.verso.elements" as="element()*"
	   select="$component.titlepage.verso.elements"/>

<xsl:param name="section.titlepage.recto.elements" as="element()*">
  <db:title/>
  <db:subtitle/>
  <db:author/>
  <db:authorgroup/>
  <db:abstract/>
</xsl:param>

<xsl:param name="section.titlepage.verso.elements" as="element()*"/>

<!-- ============================================================ -->

<xsl:template name="t:titlepage-recto-content">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" as="element()*"/>

  <xsl:choose>
    <xsl:when test="$titlepage.document.order = 0">
      <xsl:for-each select="$recto">
	<xsl:variable name="infoname" select="node-name(.)"/>
	<xsl:apply-templates select="$info/*[node-name(.) = $infoname]"
			     mode="m:titlepage-recto-mode"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="*">
	<xsl:variable name="elem" select="."/>
	<xsl:if test="$recto[node-name(.) = node-name($elem)]">
	  <xsl:apply-templates select="." mode="m:titlepage-recto-mode"/>
	</xsl:if>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:titlepage-verso-content">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="verso" as="element()*"/>

  <xsl:choose>
    <xsl:when test="$titlepage.document.order = 0">
      <xsl:for-each select="$verso">
	  <xsl:variable name="infoname" select="node-name(.)"/>
	  <xsl:apply-templates select="$info/*[node-name(.) = $infoname]"
			       mode="m:titlepage-verso-mode"/>
	</xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select="*">
	  <xsl:variable name="elem" select="."/>
	  <xsl:if test="$verso[node-name(.) = node-name($elem)]">
	    <xsl:apply-templates select="." mode="m:titlepage-verso-mode"/>
	  </xsl:if>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="t:titlepage-content">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" as="element()*"/>
  <xsl:param name="verso" as="element()*"/>

  <fo:block>
    <xsl:call-template name="t:titlepage-recto-content">
      <xsl:with-param name="info" select="$info"/>
      <xsl:with-param name="recto" select="$recto"/>
    </xsl:call-template>
  </fo:block>

  <fo:block>
    <xsl:call-template name="t:titlepage-verso-content">
      <xsl:with-param name="info" select="$info"/>
      <xsl:with-param name="verso" select="$verso"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>

<xsl:template name="t:article-titlepage">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" select="$article.titlepage.recto.elements"/>
  <xsl:param name="verso" select="$article.titlepage.verso.elements"/>

  <xsl:call-template name="t:titlepage-content">
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="recto" select="$recto"/>
    <xsl:with-param name="verso" select="$verso"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:dedication-titlepage">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" select="$dedication.titlepage.recto.elements"/>
  <xsl:param name="verso" select="$dedication.titlepage.verso.elements"/>

  <xsl:call-template name="t:titlepage-content">
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="recto" select="$recto"/>
    <xsl:with-param name="verso" select="$verso"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:preface-titlepage">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" select="$preface.titlepage.recto.elements"/>
  <xsl:param name="verso" select="$preface.titlepage.verso.elements"/>

  <xsl:call-template name="t:titlepage-content">
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="recto" select="$recto"/>
    <xsl:with-param name="verso" select="$verso"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:chapter-titlepage">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" select="$chapter.titlepage.recto.elements"/>
  <xsl:param name="verso" select="$chapter.titlepage.verso.elements"/>

  <xsl:call-template name="t:titlepage-content">
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="recto" select="$recto"/>
    <xsl:with-param name="verso" select="$verso"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:appendix-titlepage">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" select="$appendix.titlepage.recto.elements"/>
  <xsl:param name="verso" select="$appendix.titlepage.verso.elements"/>

  <xsl:call-template name="t:titlepage-content">
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="recto" select="$recto"/>
    <xsl:with-param name="verso" select="$verso"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:colophon-titlepage">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" select="$colophon.titlepage.recto.elements"/>
  <xsl:param name="verso" select="$colophon.titlepage.verso.elements"/>

  <xsl:call-template name="t:titlepage-content">
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="recto" select="$recto"/>
    <xsl:with-param name="verso" select="$verso"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:section-titlepage">
  <xsl:param name="info" select="."/>  <!-- expected context: db:info -->
  <xsl:param name="recto" select="$section.titlepage.recto.elements"/>
  <xsl:param name="verso" select="$section.titlepage.verso.elements"/>

  <xsl:call-template name="t:titlepage-content">
    <xsl:with-param name="info" select="$info"/>
    <xsl:with-param name="recto" select="$recto"/>
    <xsl:with-param name="verso" select="$verso"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:info">
  <!-- nop -->
</xsl:template>

<xsl:template match="db:article/db:info" mode="m:titlepage-mode">
  <xsl:call-template name="t:article-titlepage"/>
</xsl:template>

<xsl:template match="db:dedication/db:info" mode="m:titlepage-mode">
  <xsl:call-template name="t:dedication-titlepage"/>
</xsl:template>

<xsl:template match="db:preface/db:info" mode="m:titlepage-mode">
  <xsl:call-template name="t:preface-titlepage"/>
</xsl:template>

<xsl:template match="db:chapter/db:info" mode="m:titlepage-mode">
  <xsl:call-template name="t:chapter-titlepage"/>
</xsl:template>

<xsl:template match="db:appendix/db:info" mode="m:titlepage-mode">
  <xsl:call-template name="t:appendix-titlepage"/>
</xsl:template>

<xsl:template match="db:colophon/db:info" mode="m:titlepage-mode">
  <xsl:call-template name="t:colophon-titlepage"/>
</xsl:template>

<xsl:template match="db:section/db:info
                     |db:sect1/db:info
                     |db:sect2/db:info
                     |db:sect3/db:info
                     |db:sect4/db:info
                     |db:sect5/db:info
                     |db:simplesect/db:info"
	      mode="m:titlepage-mode">
  <xsl:call-template name="t:section-titlepage"/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:titlepage-recto-mode"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting elements on the recto title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the recto title page.
Any element processed in this mode should generate markup appropriate
for the recto side of the title page.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:titlepage-recto-mode">
  <xsl:apply-templates select="." mode="m:titlepage-mode"/>
</xsl:template>

<doc:mode name="m:titlepage-verso-mode"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting elements on the verso title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the verso title page.
Any element processed in this mode should generate markup appropriate
for the verso side of the title page.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:titlepage-verso-mode">
  <xsl:apply-templates select="." mode="m:titlepage-mode"/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:titlepage-mode"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting elements on the title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the title page.
Any element processed in this mode should generate markup appropriate
for the title page.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:set/db:info/db:title
		     |db:book/db:info/db:title
		     |db:part/db:info/db:title
		     |db:reference/db:info/db:title
		     |db:setindex/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <fo:block keep-with-next.within-column="always">
    <xsl:apply-templates select="../.." mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:set/db:info/db:subtitle
		     |db:book/db:info/db:subtitle
		     |db:part/db:info/db:subtitle
		     |db:reference/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <fo:block keep-with-next.within-column="always">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:dedication/db:info/db:title
	             |db:preface/db:info/db:title
		     |db:chapter/db:info/db:title
		     |db:appendix/db:info/db:title
		     |db:colophon/db:info/db:title
		     |db:article/db:info/db:title
		     |db:bibliography/db:info/db:title
		     |db:glossary/db:info/db:title
		     |db:index/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <fo:block xsl:use-attribute-sets="component.title.properties">
    <xsl:apply-templates select="../.." mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:article/db:appendix/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="110">
  <fo:block xsl:use-attribute-sets="section.title.level1.properties">
    <xsl:apply-templates select="../.." mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:dedication/db:info/db:subtitle
	             |db:preface/db:info/db:subtitle
		     |db:chapter/db:info/db:subtitle
		     |db:appendix/db:info/db:subtitle
		     |db:colophon/db:info/db:subtitle
		     |db:article/db:info/db:subtitle
		     |db:bibliography/db:info/db:subtitle
		     |db:glossary/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <fo:block keep-with-next.within-column="always">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:bibliodiv/db:info/db:title
		     |db:glossdiv/db:info/db:title
		     |db:indexdiv/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <fo:block keep-with-next.within-column="always">
    <xsl:apply-templates select="../.." mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:bibliodiv/db:info/db:subtitle
		     |db:glossdiv/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <fo:block keep-with-next.within-column="always">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:section/db:info/db:title
		     |db:sect1/db:info/db:title
		     |db:sect2/db:info/db:title
		     |db:sect3/db:info/db:title
		     |db:sect4/db:info/db:title
		     |db:sect5/db:info/db:title
		     |db:simplesect/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">

  <xsl:variable name="section" 
                select="(ancestor::db:section |
                        ancestor::db:simplesect |
                        ancestor::db:sect1 |
                        ancestor::db:sect2 |
                        ancestor::db:sect3 |
                        ancestor::db:sect4 |
                        ancestor::db:sect5)[position() = last()]"/>

  <xsl:variable name="id" select="f:node-id($section)"/>

  <xsl:variable name="level" select="f:section-level($section)"/>

  <xsl:variable name="marker">
    <xsl:choose>
      <xsl:when test="$level &lt;= $marker.section.level">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="title">
    <xsl:apply-templates select="$section" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:variable name="marker.title">
    <xsl:apply-templates select="$section" mode="m:titleabbrev-markup">
      <xsl:with-param name="allow-anchors" select="0"/>
    </xsl:apply-templates>
  </xsl:variable>

  <fo:block keep-with-next.within-column="always">
    <xsl:choose>
      <xsl:when test="$fo.processor = 'passivetex'">
	<fotex:bookmark xmlns:fotex="http://www.tug.org/fotex" 
			fotex-bookmark-level="{$level + 2}" 
			fotex-bookmark-label="{$id}">
	  <xsl:value-of select="$marker.title"/>
	</fotex:bookmark>
      </xsl:when>
      <xsl:when test="$fo.processor = 'antennahouse'">
	<xsl:attribute name="axf:outline-level">
	  <xsl:value-of select="count(ancestor::*)-1"/>
	</xsl:attribute>
	<xsl:attribute name="axf:outline-expand">false</xsl:attribute>
	<xsl:attribute name="axf:outline-title">
	  <xsl:value-of select="normalize-space($title)"/>
	</xsl:attribute>
      </xsl:when>
    </xsl:choose>

    <xsl:call-template name="t:section-heading">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="marker" select="$marker"/>
      <xsl:with-param name="marker.title" select="$marker.title"/>
    </xsl:call-template>
  </fo:block>
</xsl:template>

<xsl:template match="db:section/db:info/db:subtitle
		     |db:sect1/db:info/db:subtitle
		     |db:sect2/db:info/db:subtitle
		     |db:sect3/db:info/db:subtitle
		     |db:sect4/db:info/db:subtitle
		     |db:sect5/db:info/db:subtitle
		     |db:simplesect/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="level" select="f:section-level(../..)"/>
  <fo:block font-weight="bold" keep-with-next.within-column="always">
    <xsl:next-match/>
  </fo:block>
</xsl:template>

<xsl:template match="db:refsection/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="count(ancestor::db:refsection)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>
  
  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:next-match/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:refsection/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="count(ancestor::db:refsection)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>
  
  <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:title" mode="m:titlepage-mode">
  <xsl:apply-templates select="../.." mode="m:object-title-markup">
    <xsl:with-param name="allow-anchors" select="1"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:sidebar/db:info/db:title"
	      mode="m:titlepage-mode">
  <fo:block keep-with-next.within-column="always">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:copyright" mode="m:titlepage-mode">
  <fo:block>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:call-template name="gentext-space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext-space"/>
    <xsl:call-template name="t:copyright-years">
      <xsl:with-param name="years" select="db:year"/>
      <xsl:with-param name="print.ranges" select="$make.year.ranges"/>
      <xsl:with-param name="single.year.ranges"
		      select="$make.single.year.ranges"/>
    </xsl:call-template>
    <xsl:apply-templates select="db:holder" mode="m:titlepage-mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:year" mode="m:titlepage-mode">
  <fo:inline>
    <xsl:call-template name="id"/>
    <xsl:apply-templates/>
  </fo:inline>
  <xsl:if test="following-sibling::db:year">, </xsl:if>
</xsl:template>

<xsl:template match="db:holder" mode="m:titlepage-mode">
  <xsl:text> </xsl:text>
  <fo:inline>
    <xsl:call-template name="id"/>
    <xsl:apply-templates/>
  </fo:inline>
  <xsl:if test="following-sibling::db:holder">
    <xsl:text>,</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:releaseinfo" mode="m:titlepage-mode">
  <fo:block>
    <xsl:call-template name="id"/>
    <xsl:apply-templates mode="m:titlepage-mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:abstract" mode="m:titlepage-mode">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:legalnotice" mode="m:titlepage-mode">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:titlepage-mode">
  <xsl:apply-templates mode="m:titlepage-mode"/>
</xsl:template>

<xsl:template match="db:info/db:author
		     |db:info/db:authorgroup/db:author"
	      mode="m:titlepage-mode">
  <fo:block>
    <xsl:apply-templates select="."/>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
