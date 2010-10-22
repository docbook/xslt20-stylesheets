<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f l m mp xs"
                version="2.0">

<!-- ********************************************************************
     $Id: titles.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="*" mode="m:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>
  <xsl:param name="template">
    <xsl:apply-templates select="." mode="m:object-title-template"/>
  </xsl:param>

<!--
<xsl:message>NODE: <xsl:value-of select="local-name(.)"/></xsl:message>
<xsl:message>TEMPLATE: <xsl:value-of select="$template"/></xsl:message>
-->

  <xsl:variable name="title" as="node()*">
    <xsl:apply-templates select="." mode="mp:title-content">
      <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    </xsl:apply-templates>
  </xsl:variable>

<!--
<xsl:message>TITLE: [[<xsl:sequence select="$title"/>]]</xsl:message>
-->

  <xsl:variable name="subtitle" as="node()*">
    <xsl:apply-templates select="." mode="mp:subtitle-content"/>
  </xsl:variable>

  <xsl:variable name="titleabbrev" as="node()*">
    <xsl:apply-templates select="." mode="mp:titleabbrev-content"/>
  </xsl:variable>

  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="m:label-content"/>
  </xsl:variable>

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="template" select="$template"/>
    <xsl:with-param name="title" select="$title"/>
    <xsl:with-param name="subtitle" select="$subtitle"/>
    <xsl:with-param name="label" select="$label"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->
<!-- find title content -->

<doc:mode name="mp:title-content"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for computing title content</refpurpose>

<refdescription>
<para>This mode is used to compute the content of a title for an element.
For most elements, this is the result of applying templates to its db:title,
but for elements that have optional titles, it may be a computed string.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="mp:title-content" priority="100" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="content" as="node()*">
    <xsl:next-match>
      <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    </xsl:next-match>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$allow-anchors">
      <xsl:sequence select="$content"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$content" mode="m:strip-anchors"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:bibliography|db:glossary|db:index|db:setindex
                     |db:dedication|db:colophone"
              mode="mp:title-content"
              as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="title" select="(db:title,db:info/db:title)[1]"/>

  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="local-name(.)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:tip|db:note|db:important|db:warning|db:caution"
              mode="mp:title-content"
              as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="title" select="(db:title,db:info/db:title)[1]"/>

  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="local-name(.)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="title" select="(db:title,db:info/db:title)[1]"/>

  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Request for title of element with no title: </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:if test="@id|@xml:id">
          <xsl:text> (id="</xsl:text>
          <xsl:value-of select="(@id|@xml:id)[1]"/>
          <xsl:text>")</xsl:text>
        </xsl:if>
      </xsl:message>
      <xsl:text>???TITLE???</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:partintro" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>
  <!-- For better or worse (I'm betting worse), partintro didn't used to
       have a title, so now the title isn't required. That means we have
       to be a little bit careful...if there isn't one, use the parent's title,
       for lack of anything better
  -->

  <xsl:choose>
    <xsl:when test="db:title or db:info/db:title">
      <xsl:apply-templates select="(db:title|db:info/db:title)[1]" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="parent::*" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:refentry" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="refmeta" select=".//db:refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//db:refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//db:refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//db:refname"/>

  <xsl:choose>
    <xsl:when test="$refentrytitle">
      <xsl:apply-templates select="$refentrytitle[1]" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$refname">
      <xsl:apply-templates select="$refname[1]" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Request for title of refentry with no title: </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:if test="@id|@xml:id">
          <xsl:text> (id="</xsl:text>
          <xsl:value-of select="(@id|@xml:id)[1]"/>
          <xsl:text>")</xsl:text>
        </xsl:if>
      </xsl:message>
      <xsl:text>???REFENTRY TITLE???</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:title" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:refentrytitle|db:refname" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:bridgehead" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:apply-templates mode="mp:title-content">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:glossentry" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:apply-templates select="db:glossterm" mode="mp:title-content">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:glossterm" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:question" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <!-- questions don't have titles -->
  <xsl:value-of select="*[1]"/>
</xsl:template>

<xsl:template match="db:answer" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <!-- answers don't have titles -->
  <xsl:value-of select="*[1]"/>
</xsl:template>

<xsl:template match="db:qandaentry" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="title" select="(db:title,db:info/db:title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="db:question[1]" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:titleabbrev-content"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for computing abbreviated title content</refpurpose>

<refdescription>
<para>This mode is used to compute the content of an abbreviated title for an element.
For most elements, this is the result of applying templates to its db:titleabbrev,
if it has one, and the result of applying templates to its db:title otherwise,
but for elements that have optional titles, it may be a computed string.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:titleabbrev-content" priority="100" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="content" as="node()*">
    <xsl:next-match/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$allow-anchors">
      <xsl:sequence select="$content"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$content" mode="m:strip-anchors"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="m:titleabbrev-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="titleabbrev"
                select="(db:titleabbrev,db:info/db:titleabbrev)[1]"/>

  <xsl:choose>
    <xsl:when test="$titleabbrev">
      <xsl:apply-templates select="$titleabbrev" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:titleabbrev" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:apply-templates/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:subtitle-content"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for computing subtitle content</refpurpose>

<refdescription>
<para>This mode is used to compute the content of a subtitle for an element.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:subtitle-content" priority="100" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="content" as="node()*">
    <xsl:next-match/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$allow-anchors">
      <xsl:sequence select="$content"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$content" mode="m:strip-anchors"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="m:subtitle-content" as="node()*">
  <xsl:variable name="subtitle"
                select="(db:subtitle,db:info/db:subtitle)[1]"/>

  <xsl:choose>
    <xsl:when test="$subtitle">
      <xsl:apply-templates select="$subtitle"
                           mode="m:subtitle-content"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:subtitle" mode="m:subtitle-content" as="node()*">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>

