<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f h m t xs"
                version="2.0">

<!-- ============================================================ -->

<doc:template name="t:formal-object" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing formal objects</refpurpose>

<refdescription>
<para>This template processes formal objects, block objects with a
title.</para>
</refdescription>
</doc:template>

<xsl:template name="t:formal-object">
  <xsl:param name="context" select="."/>
  <xsl:param name="placement" select="'before'"/>
  <xsl:param name="longdesc" select="()"/>
  <xsl:param name="class" select="local-name($context)"/>
  <xsl:param name="object" as="element()*" required="yes"/>

  <xsl:variable name="title">
    <xsl:call-template name="t:titlepage">
      <xsl:with-param name="node" select="$context"/>
    </xsl:call-template>
    <xsl:call-template name="t:longdesc-link">
      <xsl:with-param name="textobject" select="$longdesc[1]"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="wrapper">
    <figure>
      <xsl:sequence select="f:html-attributes($context, f:node-id($context), concat($class,'-wrapper'))"/>
      <xsl:choose>
	<xsl:when test="$placement = 'before'">
	  <xsl:sequence select="$title"/>
	  <xsl:sequence select="$object"/>
	  <xsl:apply-templates select="$context/db:caption"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:sequence select="$object"/>
	  <xsl:apply-templates select="$context/db:caption"/>
	  <xsl:sequence select="$title"/>
	</xsl:otherwise>
      </xsl:choose>
    </figure>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$context/@floatstyle">
      <div class="float-{$context/@floatstyle}">
	<xsl:copy-of select="$wrapper"/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$wrapper"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:formal-object-heading"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing the title of formal objects</refpurpose>

<refdescription>
<para>This template processes the title of formal objects.
</para>
</refdescription>
</doc:template>

<xsl:template name="t:formal-object-heading">
  <xsl:param name="object" select="."/>
  <xsl:param name="title">
    <xsl:apply-templates select="$object" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:param>

  <xsl:sequence select="$title"/>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:informal-object" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing informal objects</refpurpose>

<refdescription>
<para>This template processes informal objects, block objects without a
title.</para>
</refdescription>
</doc:template>

<xsl:template name="t:informal-object">
  <xsl:param name="context" select="."/>
  <xsl:param name="class" select="local-name($context)"/>
  <xsl:param name="object" as="element()*" required="yes"/>

  <xsl:variable name="wrapper">
    <figure>
      <xsl:sequence select="f:html-attributes($context, f:node-id($context), concat($class,'-wrapper'))"/>
      <xsl:sequence select="$object"/>
      <xsl:apply-templates select="$context/db:caption"/>
    </figure>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$context/@floatstyle">
      <div class="float-{$context/@floatstyle}">
	<xsl:copy-of select="$wrapper"/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$wrapper"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:semiformal-object" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing objects that are sometimes
formal, sometimes informal</refpurpose>

<refdescription>
<para>This template processes objects that are sometimes
formal, sometimes informal, by calling the appropriate template.
</para>
</refdescription>
</doc:template>

<xsl:template name="t:semiformal-object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:param name="class" select="local-name(.)"/>
  <xsl:param name="object" as="element()*" required="yes"/>

  <xsl:choose>
    <xsl:when test="db:title|db:info/db:title">
      <xsl:call-template name="t:formal-object">
	<xsl:with-param name="placement" select="$placement"/>
	<xsl:with-param name="class" select="$class"/>
	<xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="t:informal-object">
	<xsl:with-param name="class" select="$class"/>
	<xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:figure">
  <xsl:call-template name="t:formal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:figure]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-attributes(., ())"/>
	<xsl:apply-templates select="*[not(self::db:caption)]"/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:informalfigure">
  <xsl:call-template name="t:informal-object">
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-attributes(., ())"/>
	<xsl:apply-templates select="*[not(self::db:caption)]"/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:example">
  <xsl:call-template name="t:formal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:example]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-attributes(., ())"/>
	<xsl:apply-templates select="*[not(self::db:caption)]"/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:informalexample">
  <xsl:call-template name="t:informal-object">
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-attributes(., ())"/>
	<xsl:apply-templates select="*[not(self::db:caption)]"/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:formalpara">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates select="db:indexterm"/>
    <xsl:apply-templates select="db:para">
      <xsl:with-param name="runin" as="node()*" tunnel="yes">
        <b>
          <xsl:apply-templates select="." mode="m:title-content"/>
        </b>
        <xsl:text>&#160;&#160;</xsl:text>
      </xsl:with-param>
    </xsl:apply-templates>
  </div>
</xsl:template>

</xsl:stylesheet>
