<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f l m mp t xlink xs"
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

  <xsl:variable name="title" as="node()*">
    <xsl:apply-templates select="." mode="mp:title-content">
      <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    </xsl:apply-templates>
  </xsl:variable>

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
                     |db:dedication|db:colophon"
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

<xsl:template match="db:abstract"
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

<xsl:template match="db:table" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:variable name="title" select="(db:title,db:info/db:title,db:caption)[1]"/>

  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="mp:title-content">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Request for title of table with no title or caption: </xsl:text>
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

<xsl:template match="db:title|db:caption" mode="mp:title-content" as="node()*">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="mp:no-anchors"/>
    </xsl:otherwise>
  </xsl:choose>
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

<!-- ============================================================ -->

<xsl:template match="*" mode="mp:no-anchors">
  <!-- Switch to normal mode if no links -->
  <xsl:choose>
    <xsl:when test="descendant-or-self::db:footnote or
                    descendant-or-self::db:anchor or
                    descendant-or-self::db:link or
                    descendant-or-self::db:olink or
                    descendant-or-self::db:xref or
                    descendant-or-self::db:indexterm or
		    (ancestor::db:title and @xml:id)">
      <xsl:apply-templates mode="mp:no-anchors"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:footnote" mode="mp:no-anchors">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="db:anchor" mode="mp:no-anchors">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="db:link" mode="mp:no-anchors">
  <xsl:choose>
    <xsl:when test="exists(node())">
      <!-- If it has content, use it -->
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="@endterm">
      <!-- look for an endterm -->
      <xsl:variable name="etargets" select="key('id',@endterm)"/>
      <xsl:variable name="etarget" select="$etargets[1]"/>
      <xsl:choose>
        <xsl:when test="count($etarget) = 0">
          <xsl:message>
            <xsl:value-of select="count($etargets)"/>
            <xsl:text>Endterm points to nonexistent ID: </xsl:text>
            <xsl:value-of select="@endterm"/>
          </xsl:message>
          <xsl:text>???</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$etarget" mode="m:endterm"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:olink" mode="mp:no-anchors">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:indexterm" mode="mp:no-anchors">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="db:xref" mode="mp:no-anchors">
  <xsl:variable name="targets" select="key('id',@linkend)|key('id',substring-after(@xlink:href,'#'))"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="refelem" select="local-name($target)"/>

  <xsl:call-template name="t:check-id-unique">
    <xsl:with-param name="linkend" select="@linkend"/>
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="count($target) = 0">
      <xsl:message>
        <xsl:text>XRef to nonexistent id: </xsl:text>
        <xsl:value-of select="@linkend"/> 
        <xsl:value-of select="@xlink:href"/>
      </xsl:message>
      <xsl:text>???</xsl:text>
    </xsl:when>

    <xsl:when test="@endterm">
      <xsl:variable name="etargets" select="key('id',@endterm)"/>
      <xsl:variable name="etarget" select="$etargets[1]"/>
      <xsl:choose>
        <xsl:when test="count($etarget) = 0">
          <xsl:message>
            <xsl:value-of select="count($etargets)"/>
            <xsl:text>Endterm points to nonexistent ID: </xsl:text>
            <xsl:value-of select="@endterm"/>
          </xsl:message>
          <xsl:text>???</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$etarget" mode="m:endterm"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="$target/@xreflabel">
      <xsl:call-template name="t:xref-xreflabel">
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:choose>
	<!-- Watch out for the case when there is a xref or link inside
	     a title. See bugs #1811721 and #1838136. -->
	<xsl:when test="not(ancestor::*[@xml:id = $target/@xml:id])">
	  <xsl:apply-templates select="$target" mode="m:xref-to-prefix"/>
	  <xsl:apply-templates select="$target" mode="m:xref-to">
            <xsl:with-param name="referrer" select="."/>
	    <xsl:with-param name="xrefstyle">
	      <xsl:choose>
		<xsl:when test="@role and not(@xrefstyle) and $use.role.as.xrefstyle != 0">
		  <xsl:value-of select="@role"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="@xrefstyle"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:with-param>
	  </xsl:apply-templates>
	  <xsl:apply-templates select="$target" mode="m:xref-to-suffix"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
