<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:tp="http://docbook.org/xslt/ns/template/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fn h m mp t tp xs"
                version="2.0">

<!-- ********************************************************************
     $Id: autotoc.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ============================================================ -->

<doc:mode name="mp:toc" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing ToC and LoTs</refpurpose>

<refdescription>
<para>This mode is used to process Tables of Contents and Lists of Titles.
</para>
</refdescription>
</doc:mode>

<!-- ============================================================ -->

<doc:template name="tp:make-toc" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make a ToC</refpurpose>

<refdescription>
<para>This template formats a Table of Contents.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>toc-context</term>
<listitem>
<para>The context node of the ToC.</para>
</listitem>
</varlistentry>
<varlistentry><term>toc-context</term>
<listitem>
<para>The context node of the ToC.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted ToC.</para>
</refreturn>
</doc:template>

<xsl:template name="tp:make-toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title" select="true()"/>
  <xsl:param name="nodes" select="()"/>

  <xsl:variable name="toc.title">
    <xsl:if test="$toc.title">
      <xsl:call-template name="t:format-toc-title">
        <xsl:with-param name="toc-context" as="element()" select="$toc-context"/>
        <xsl:with-param name="toc-title" as="node()*">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">TableofContents</xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$manual.toc != ''">
      <xsl:variable name="id" select="f:node-id(.)"/>
      <xsl:variable name="toc" select="document($manual.toc, .)"/>
      <xsl:variable name="tocentry" select="$toc//db:tocentry[@linkend=$id]"/>
      <xsl:if test="$tocentry and $tocentry/*">
        <div class="toc">
          <xsl:copy-of select="$toc.title"/>
          <ul class="toc">
            <xsl:call-template name="t:manual-toc">
              <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
            </xsl:call-template>
          </ul>
        </div>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$nodes">
        <div class="toc">
          <xsl:copy-of select="$toc.title"/>
          <ul class="toc">
            <xsl:apply-templates select="$nodes" mode="mp:toc">
              <xsl:with-param name="toc-context" select="$toc-context"/>
            </xsl:apply-templates>
          </ul>
        </div>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:format-toc-title">
  <xsl:param name="toc-context" as="element()"/>
  <xsl:param name="toc-title" as="node()*"/>
  <p>
    <b>
      <xsl:sequence select="$toc-title"/>
    </b>
  </p>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:make-lots" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make LoTs</refpurpose>

<refdescription>
<para>This template formats Lists of Titles.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>toc.params</term>
<listitem>
<para>The ToC controlling parameters.</para>
</listitem>
</varlistentry>
<varlistentry><term>toc</term>
<listitem>
<para>The result tree that contains the generated Table of Contents.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted ToC and LoTs.</para>
</refreturn>
</doc:template>

<xsl:template name="t:make-lots">
  <xsl:param name="toc.params" as="element()?" select="()"/>
  <xsl:param name="toc"/>

  <xsl:if test="$toc.params/@toc != 0">
    <xsl:copy-of select="$toc"/>
  </xsl:if>

  <xsl:if test="$toc.params/@figure != 0">
    <xsl:call-template name="tp:list-of-titles">
      <xsl:with-param name="titles" select="'figure'"/>
      <xsl:with-param name="nodes" select=".//db:figure"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$toc.params/@table != 0">
    <xsl:call-template name="tp:list-of-titles">
      <xsl:with-param name="titles" select="'table'"/>
      <xsl:with-param name="nodes" select=".//db:table"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$toc.params/@example != 0">
    <xsl:call-template name="tp:list-of-titles">
      <xsl:with-param name="titles" select="'example'"/>
      <xsl:with-param name="nodes" select=".//db:example"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$toc.params/@equation != 0">
    <xsl:call-template name="tp:list-of-titles">
      <xsl:with-param name="titles" select="'equation'"/>
      <xsl:with-param name="nodes" select=".//db:equation[db:title]"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$toc.params/@procedure != 0">
    <xsl:call-template name="tp:list-of-titles">
      <xsl:with-param name="titles" select="'procedure'"/>
      <xsl:with-param name="nodes" select=".//db:procedure[db:title]"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:division-toc" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make ToC/LoTs for a division</refpurpose>

<refdescription>
<para>This template formats the Table of Contents and
Lists of Titles for a
division (book, part, etc.).</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>toc-context</term>
<listitem>
<para>The division context.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted ToC and LoTs for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:division-toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:make-toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes"
		    select="db:part|db:reference
			    |db:preface|db:chapter|db:appendix
			    |db:article
			    |db:bibliography|db:glossary|db:index
			    |db:refentry
			    |db:bridgehead[$bridgehead.in.toc != 0]"/>

  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:component-toc" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make ToC/LoTs for a component</refpurpose>

<refdescription>
<para>This template formats the Table of Contents and
Lists of Titles for a
component (chapter, article, etc.).</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>toc-context</term>
<listitem>
<para>The component context.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted ToC and LoTs for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:component-toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title" select="true()"/>

  <xsl:call-template name="tp:make-toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="toc.title" select="$toc.title"/>
    <xsl:with-param name="nodes"
		    select="db:section|db:sect1|db:refentry
			    |db:article|db:bibliography|db:glossary
			    |db:appendix|db:index
			    |db:bridgehead[not(@renderas)
			                   and $bridgehead.in.toc != 0]
			    |.//db:bridgehead[@renderas='sect1'
			                      and $bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:component-toc-separator"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make a separator for component ToCs</refpurpose>

<refdescription>
<para>This template outputs a separator after component ToC.
</para>
</refdescription>

<refreturn>
<para>The formatted separator.</para>
</refreturn>
</doc:template>

<xsl:template name="t:component-toc-separator">
  <!-- Customize to output something between
       component.toc and first output -->
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:section-toc" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make ToC/LoTs for a section</refpurpose>

<refdescription>
<para>This template formats the Table of Contents and
Lists of Titles for a
section.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>toc-context</term>
<listitem>
<para>The component context.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted ToC and LoTs for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:section-toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title" select="true()"/>

  <xsl:call-template name="tp:make-toc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="toc.title" select="$toc.title"/>
    <xsl:with-param name="nodes"
                    select="db:section
			    |db:sect1|db:sect2|db:sect3|db:sect4|db:sect5
			    |db:refentry
			    |db:bridgehead[$bridgehead.in.toc != 0]"/>

  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:section-toc-separator"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make a separator for section ToCs</refpurpose>

<refdescription>
<para>This template outputs a separator after section ToC.
</para>
</refdescription>

<refreturn>
<para>The formatted separator.</para>
</refreturn>
</doc:template>

<xsl:template name="t:section-toc-separator">
  <!-- Customize to output something between
       section.toc and first output -->
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:qanda-toc" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make ToC/LoTs for a QAndASet</refpurpose>

<refdescription>
<para>This template formats the Table of Contents and
Lists of Titles for a qandaset.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>toc-context</term>
<listitem>
<para>The component context.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted ToC and LoTs for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:qanda-toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title" select="true()"/>

  <xsl:if test="count(db:qandadiv) &gt; 1 or count(db:qandaentry) &gt; 1">
    <xsl:call-template name="tp:make-toc">
      <xsl:with-param name="toc-context" select="$toc-context"/>
      <xsl:with-param name="toc.title" select="$toc.title"/>
      <xsl:with-param name="nodes"
                      select="db:qandadiv|db:qandaentry"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:qanda-toc-separator"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make a separator for qandaset ToCs</refpurpose>

<refdescription>
<para>This template outputs a separator after qandaset ToC.
</para>
</refdescription>

<refreturn>
<para>The formatted separator.</para>
</refreturn>
</doc:template>

<xsl:template name="t:qanda-toc-separator">
  <!-- Customize to output something between
       component.toc and first output -->
</xsl:template>

<!-- ============================================================ -->

<doc:template name="tp:subtoc" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make subordinate ToC parts</refpurpose>

<refdescription>
<para>This is an internal-only template.</para>
</refdescription>

<refreturn>
<para>The formatted subordinate ToC.</para>
</refreturn>
</doc:template>

<xsl:template name="tp:subtoc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="nodes" select="()"/>

  <xsl:variable name="subtoc" as="element()">
    <ul class="toc">
      <xsl:apply-templates mode="mp:toc" select="$nodes">
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:apply-templates>
    </ul>
  </xsl:variable>

  <xsl:variable name="depth" as="xs:integer">
    <xsl:choose>
      <xsl:when test="self::db:section">
        <xsl:value-of select="count(ancestor::db:section) + 1"/>
      </xsl:when>
      <xsl:when test="self::db:sect1">1</xsl:when>
      <xsl:when test="self::db:sect2">2</xsl:when>
      <xsl:when test="self::db:sect3">3</xsl:when>
      <xsl:when test="self::db:sect4">4</xsl:when>
      <xsl:when test="self::db:sect5">5</xsl:when>
      <xsl:when test="self::db:refsect1">1</xsl:when>
      <xsl:when test="self::db:refsect2">2</xsl:when>
      <xsl:when test="self::db:refsect3">3</xsl:when>
      <xsl:when test="self::db:simplesect">
	<!-- sigh... -->
	<xsl:choose>
	  <xsl:when test="parent::db:section">
            <xsl:value-of select="count(ancestor::db:section)"/>
          </xsl:when>
          <xsl:when test="parent::db:sect1">2</xsl:when>
          <xsl:when test="parent::db:sect2">3</xsl:when>
          <xsl:when test="parent::db:sect3">4</xsl:when>
          <xsl:when test="parent::db:sect4">5</xsl:when>
          <xsl:when test="parent::db:sect5">6</xsl:when>
          <xsl:when test="parent::db:refsect1">2</xsl:when>
          <xsl:when test="parent::db:refsect2">3</xsl:when>
          <xsl:when test="parent::db:refsect3">4</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="depth.from.context"
		select="count(ancestor::*)-count($toc-context/ancestor::*)"/>

  <xsl:variable name="subtoc.list" select="$subtoc"/>

  <xsl:variable name="show.subtoc" as="xs:boolean"
		select="count($subtoc/*) &gt; 0
			and $toc.section.depth > $depth and exists($nodes)
			and $toc.max.depth > $depth.from.context"/>

  <li>
    <xsl:call-template name="tp:toc-line">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>
    <xsl:if test="$show.subtoc">
      <xsl:copy-of select="$subtoc.list"/>
    </xsl:if>
  </li>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="tp:toc-line" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make a line of the ToC</refpurpose>

<refdescription>
<para>This is an internal-only template.</para>
</refdescription>

<refreturn>
<para>The formatted ToC line.</para>
</refreturn>
</doc:template>

<xsl:template name="tp:toc-line">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="depth" select="1"/>
  <xsl:param name="depth.from.context" select="8"/>

  <span>
    <a href="{f:href(/,.)}">
      <xsl:variable name="label">
	<xsl:apply-templates select="." mode="m:label-content"/>
      </xsl:variable>
      <xsl:copy-of select="$label"/>
      <xsl:if test="$label != ''">
	<xsl:value-of select="$autotoc.label.separator"/>
      </xsl:if>

      <xsl:apply-templates select="." mode="m:titleabbrev-content"/>
    </a>
  </span>
</xsl:template>

<xsl:template match="db:book" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:part|db:reference
                                         |db:preface|db:chapter|db:appendix
                                         |db:article
                                         |db:bibliography|db:glossary|db:index
                                         |db:refentry
                                         |db:bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:setindex" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <!-- If the setindex tag is not empty, it should be it in the TOC -->
  <xsl:if test="* or $generate.index != 0">
    <xsl:call-template name="tp:subtoc">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="db:part|db:reference" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:appendix|db:chapter|db:article
                                         |db:index|db:glossary|db:bibliography
                                         |db:preface|db:reference|db:refentry
                                         |db:bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:preface|db:chapter|db:appendix|db:article" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:section|db:sect1|db:simplesect|db:refentry
                                         |db:glossary|db:bibliography|db:index
                                         |db:bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:sect1" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:sect2
                                         |db:bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:sect2" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:sect3
                                         |db:bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:sect3" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:sect4
                                         |db:bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:sect4" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:sect5
                                         |db:bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:sect5" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:section" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:section
                                         |db:bridgehead[$bridgehead.in.toc != 0]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:bridgehead" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:if test="$bridgehead.in.toc != 0">
    <xsl:call-template name="tp:subtoc">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="db:bibliography|db:glossary" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:index" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <!-- If the index tag is not empty, it should be it in the TOC -->
  <xsl:if test="* or $generate.index != 0">
    <xsl:call-template name="tp:subtoc">
      <xsl:with-param name="toc-context" select="$toc-context"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="db:refentry" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:variable name="refmeta" select=".//db:refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//db:refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//db:refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//db:refname"/>
  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$refentrytitle">
        <xsl:apply-templates select="$refentrytitle[1]" mode="m:titleabbrev-content"/>
      </xsl:when>
      <xsl:when test="$refname">
        <xsl:apply-templates select="$refname[1]" mode="m:titleabbrev-content"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <li>
    <span class='refentrytitle'>
      <a href="{f:href(/,.)}">
        <xsl:copy-of select="$title"/>
      </a>
    </span>
    <span class='refpurpose'>
      <xsl:if test="$annotate.toc != 0">
        <xsl:text> - </xsl:text>
        <xsl:value-of select="db:refnamediv/db:refpurpose"/>
      </xsl:if>
    </span>
  </li>
</xsl:template>

<xsl:template match="db:qandadiv|db:qandaentry" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <xsl:call-template name="tp:subtoc">
    <xsl:with-param name="toc-context" select="$toc-context"/>
    <xsl:with-param name="nodes" select="db:qandadiv|db:qandaentry"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:title" mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <a href="{f:href(/,..)}">
    <xsl:apply-templates/>
  </a>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:manual-toc" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handle manual ToCs (toc elements)</refpurpose>

<refdescription>
<para>Processes manual ToCs.</para>
</refdescription>

<refreturn>
<para>The formatted ToC.</para>
</refreturn>
</doc:template>

<xsl:template name="t:manual-toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="tocentry"/>

  <!-- be careful, we don't want to change the current document to the other tree! -->

  <xsl:if test="$tocentry">
    <xsl:variable name="node" select="key('id', $tocentry/@linkend)"/>

    <li>
      <xsl:variable name="label">
        <xsl:apply-templates select="$node" mode="m:label-content"/>
      </xsl:variable>
      <xsl:copy-of select="$label"/>
      <xsl:if test="$label != ''">
        <xsl:value-of select="$autotoc.label.separator"/>
      </xsl:if>
      <a href="{f:href(/,$node)}">
        <xsl:apply-templates select="$node" mode="m:titleabbrev-content"/>
      </a>
    </li>

    <xsl:if test="$tocentry/*">
      <ul class="toc">
        <xsl:call-template name="t:manual-toc">
          <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
        </xsl:call-template>
      </ul>
    </xsl:if>

    <xsl:if test="$tocentry/following-sibling::*">
      <xsl:call-template name="t:manual-toc">
        <xsl:with-param name="tocentry" select="$tocentry/following-sibling::*[1]"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="tp:list-of-titles" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles the headers for a List of Titles</refpurpose>

<refdescription>
<para>This is an internal-only template.</para>
</refdescription>

<refreturn>
<para>The formatted LoT.</para>
</refreturn>
</doc:template>

<xsl:template name="tp:list-of-titles">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="titles" select="'table'"/>
  <xsl:param name="nodes" select=".//db:table"/>

  <xsl:if test="$nodes">
    <div class="list-of-{$titles}s">
      <p>
        <b>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">
              <xsl:choose>
                <xsl:when test="$titles='table'">ListofTables</xsl:when>
                <xsl:when test="$titles='figure'">ListofFigures</xsl:when>
                <xsl:when test="$titles='equation'">ListofEquations</xsl:when>
                <xsl:when test="$titles='example'">ListofExamples</xsl:when>
                <xsl:when test="$titles='procedure'">ListofProcedures</xsl:when>
                <xsl:otherwise>ListofUnknown</xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </b>
      </p>

      <ul class="toc">
        <xsl:apply-templates select="$nodes" mode="mp:toc">
          <xsl:with-param name="toc-context" select="$toc-context"/>
        </xsl:apply-templates>
      </ul>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="db:figure|db:table|db:example|db:equation|db:procedure"
	      mode="mp:toc">
  <xsl:param name="toc-context" select="."/>

  <li>
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="m:label-content"/>
    </xsl:variable>
    <xsl:copy-of select="$label"/>
    <xsl:if test="$label != ''">
      <xsl:value-of select="$autotoc.label.separator"/>
    </xsl:if>
    <a href="{f:href(/,.)}">
      <xsl:apply-templates select="." mode="m:titleabbrev-content"/>
    </a>
  </li>
</xsl:template>

</xsl:stylesheet>
