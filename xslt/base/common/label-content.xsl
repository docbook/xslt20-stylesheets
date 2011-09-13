<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f m fn xs"
                version="2.0">

<!-- ********************************************************************
     $Id: labels.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ============================================================ -->

<doc:mode name="m:intralabel-punctuation"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for producing intra-label punctuation</refpurpose>

<refdescription>
<para>This mode is used to produce intra-label punctuation. All elements
processed in this mode should generate the punctuation symbol that should
be used to separate their label from other labels. This only occurs in
places where compound labels are necessary.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:intralabel-punctuation">
  <xsl:text>.</xsl:text>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:label-content"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for producing label markup</refpurpose>

<refdescription>
<para>This mode is used to produce label markup. All elements
processed in this mode should generate their label.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:label-content">
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="context" select="."/>

  <xsl:if test="$autolabel.elements/*[node-name(.) = node-name($context)]">
    <xsl:if test="$verbose">
      <xsl:message>
        <xsl:text>Request for label of unexpected element: </xsl:text>
        <xsl:value-of select="name(.)"/>
      </xsl:message>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="db:set|db:book" mode="m:label-content">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:part" mode="m:label-content">
  <xsl:variable name="label" select="$autolabel.elements/db:part"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$label and ancestor::db:book">
      <xsl:number from="db:book" format="{$format}" level="any"/>
    </xsl:when>
    <xsl:when test="$label">
      <xsl:number format="{$format}" level="any"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="partintro" mode="m:label-content">
  <!-- no label -->
</xsl:template>

<xsl:template match="db:preface|db:chapter|db:appendix" mode="m:label-content">
  <xsl:variable name="label" select="$autolabel.elements
				     /*[node-name(.) = node-name(current())]"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!--
  <xsl:message>label-markup for <xsl:value-of select="name(.)"/></xsl:message>
  <xsl:message>label: <xsl:copy-of select="$label"/></xsl:message>
  <xsl:message>format: <xsl:value-of select="$format"/></xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>

    <xsl:when test="$label">
      <xsl:if test="$component.label.includes.part.label != 0 and
		    ancestor::db:part">
	<xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::db:part" 
			       mode="m:label-content"/>
	</xsl:variable>
	<xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::db:part" 
			       mode="m:intralabel-punctuation"/>
	</xsl:if>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::db:part">
	  <xsl:number from="db:part" format="{$format}" level="any"/>
        </xsl:when>
	<xsl:when test="ancestor::db:article">
	  <xsl:number from="db:article" format="{$format}" level="any"/>
        </xsl:when>
	<xsl:when test="ancestor::db:book">
	  <xsl:number from="db:book" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:number format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:article" mode="m:label-content">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:dedication|db:colophon" mode="m:label-content">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:reference" mode="m:label-content">
  <xsl:variable name="label" select="$autolabel.elements/db:reference"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$label">
      <xsl:number from="db:book" format="{$format}" level="any"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:refentry" mode="m:label-content">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:section" mode="m:label-content">
  <xsl:variable name="label" select="$autolabel.elements/db:section"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@label or f:label-this-section(.)">
    <!-- if this is a nested section, label the parent -->
    <xsl:if test="../self::db:section and f:label-this-section(..)">
      <xsl:apply-templates select=".." mode="m:label-content"/>
      <xsl:apply-templates select=".." mode="m:intralabel-punctuation"/>
    </xsl:if>

    <xsl:if test="$section.label.includes.component.label != 0
		  and parent::* instance of element()
		  and f:is-component(..)">
      <xsl:variable name="parent.label">
	<xsl:apply-templates select=".." mode="m:label-content"/>
      </xsl:variable>
      <xsl:if test="$parent.label != ''">
	<xsl:copy-of select="$parent.label"/>
	<xsl:apply-templates select=".." mode="m:intralabel-punctuation"/>
      </xsl:if>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@label">
	<xsl:value-of select="@label"/>
      </xsl:when>
      <xsl:when test="$label">
	<xsl:number format="{$format}"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:sect1" mode="m:label-content">
  <!-- yes: it's /db:section in the expression below -->
  <xsl:variable name="label" select="$autolabel.elements/db:section"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@label or f:label-this-section(.)">
    <!-- if the parent is a component, maybe label that too -->
    <xsl:if test="$section.label.includes.component.label != 0
		  and f:is-component(..)">
      <xsl:variable name="parent.label">
	<xsl:apply-templates select=".." mode="m:label-content"/>
      </xsl:variable>
      <xsl:if test="$parent.label != ''">
	<xsl:copy-of select="$parent.label"/>
	<xsl:apply-templates select=".." mode="m:intralabel-punctuation"/>
      </xsl:if>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@label">
	<xsl:value-of select="@label"/>
      </xsl:when>
      <xsl:when test="$label">
	<xsl:number format="{$format}"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:sect2|db:sect3|db:sect4|db:sect5" mode="m:label-content">
  <!-- yes: it's /db:section in the expression below -->
  <xsl:variable name="label" select="$autolabel.elements/db:section"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@label or f:label-this-section(.)">
    <!-- label the parent -->
    <xsl:if test="f:label-this-section(..)">
      <xsl:apply-templates select=".." mode="m:label-content"/>
      <xsl:apply-templates select=".." mode="m:intralabel-punctuation"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@label">
	<xsl:value-of select="@label"/>
      </xsl:when>
      <xsl:when test="$label">
	<xsl:number format="{$format}"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:bridgehead" mode="m:label-content">
  <!-- Is empty really the right answer? -->
</xsl:template>

<xsl:template match="db:refsection" mode="m:label-content">
  <xsl:variable name="label" select="$autolabel.elements/db:refsection"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$label">
      <xsl:number format="{$format}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:refsect1" mode="m:label-content">
  <!-- yes: it's /db:refsection in the expression below -->
  <xsl:variable name="label" select="$autolabel.elements/db:refsection"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$label">
      <xsl:number format="{$format}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:refsect2|db:refsect3" mode="m:label-content">
  <!-- yes: it's /db:refsection in the expression below -->
  <xsl:variable name="label" select="$autolabel.elements/db:refsection"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@label or $label">
    <!-- label the parent -->
    <xsl:variable name="parent.label">
      <xsl:apply-templates select=".." mode="m:label-content"/>
    </xsl:variable>
    <xsl:if test="$parent.label != ''">
      <xsl:copy-of select="$parent.label"/>
      <xsl:apply-templates select=".." mode="m:intralabel-punctuation"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@label">
	<xsl:value-of select="@label"/>
      </xsl:when>
      <xsl:when test="$label">
	<xsl:number format="{$format}"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:simplesect" mode="m:label-content">
  <!-- yes: it's /db:section in the expression below -->
  <xsl:variable name="label" select="$autolabel.elements/db:section"/>
  <xsl:variable name="format" as="xs:string">
    <xsl:choose>
      <xsl:when test="$label/@format">
	<xsl:value-of select="$label/@format"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@label or $label or f:label-this-section(.)">
    <!-- if this is a nested section, label the parent -->
    <xsl:if test="../self::db:section
		  | ../self::db:sect1
		  | ../self::db:sect2
		  | ../self::db:sect3
		  | ../self::db:sect4
		  | ../self::db:sect5">
      <xsl:variable name="parent.section.label">
	<xsl:apply-templates select=".." mode="m:label-content"/>
      </xsl:variable>
      <xsl:if test="$parent.section.label != ''">
	<xsl:copy-of select="$parent.section.label"/>
	<xsl:apply-templates select=".." mode="m:intralabel-punctuation"/>
      </xsl:if>
    </xsl:if>

    <xsl:if test="$section.label.includes.component.label != 0
		  and f:is-component(..)">
      <xsl:variable name="parent.label">
	<xsl:apply-templates select=".." mode="m:label-content"/>
      </xsl:variable>
      <xsl:if test="$parent.label != ''">
	<xsl:copy-of select="$parent.label"/>
	<xsl:apply-templates select=".." mode="m:intralabel-punctuation"/>
      </xsl:if>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@label">
	<xsl:value-of select="@label"/>
      </xsl:when>
      <xsl:when test="$label">
	<xsl:number format="{$format}"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:qandaset" mode="m:label-content">
  <!-- what would the label be? -->
</xsl:template>

<xsl:template match="db:qandadiv" mode="m:label-content">
  <xsl:if test="$autolabel.elements/db:qandadiv">
    <xsl:variable name="lparent" select="(ancestor::db:set
					  |ancestor::db:book
					  |ancestor::db:chapter
					  |ancestor::db:appendix
					  |ancestor::db:preface
					  |ancestor::db:section
					  |ancestor::db:simplesect
					  |ancestor::db:sect1
					  |ancestor::db:sect2
					  |ancestor::db:sect3
					  |ancestor::db:sect4
					  |ancestor::db:sect5
					  |ancestor::db:refsect1
					  |ancestor::db:refsect2
					  |ancestor::db:refsect3)[last()]"/>

    <xsl:variable name="lparent.prefix">
      <xsl:apply-templates select="$lparent" mode="m:label-content"/>
    </xsl:variable>

    <xsl:variable name="prefix">
      <xsl:if test="$qanda.inherit.numeration != 0">
	<xsl:if test="$lparent.prefix != ''">
	  <xsl:copy-of select="$lparent.prefix"/>
	  <xsl:apply-templates select="$lparent"
			       mode="m:intralabel-punctuation"/>
	</xsl:if>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="count" as="xs:string">
      <xsl:number level="multiple" count="db:qandadiv" format="1"/>
    </xsl:variable>

    <xsl:variable name="label" as="xs:string" select="concat($prefix,$count)"/>
    <xsl:value-of select="$label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:qandaentry" mode="m:label-content">
  <xsl:apply-templates select="db:question[1]" mode="m:label-content"/>
</xsl:template>

<xsl:template match="db:question|db:answer" mode="m:label-content">
  <xsl:variable name="lparent" select="(ancestor::db:set
                                       |ancestor::db:book
                                       |ancestor::db:chapter
                                       |ancestor::db:appendix
                                       |ancestor::db:preface
                                       |ancestor::db:section
                                       |ancestor::db:simplesect
                                       |ancestor::db:sect1
                                       |ancestor::db:sect2
                                       |ancestor::db:sect3
                                       |ancestor::db:sect4
                                       |ancestor::db:sect5
                                       |ancestor::db:refsect1
                                       |ancestor::db:refsect2
                                       |ancestor::db:refsect3)[last()]"/>
  <xsl:variable name="lparent.prefix">
    <xsl:apply-templates select="$lparent" mode="m:label-content"/>
  </xsl:variable>

  <xsl:variable name="prefix">
    <xsl:if test="$qanda.inherit.numeration != 0">
      <xsl:if test="$lparent.prefix != ''">
	<xsl:copy-of select="$lparent.prefix"/>
	<xsl:apply-templates select="$lparent" mode="m:intralabel-punctuation"/>
      </xsl:if>

      <xsl:if test="ancestor::db:qandadiv">
        <xsl:apply-templates select="ancestor::db:qandadiv[1]"
			     mode="m:label-content"/>
	<xsl:apply-templates select="ancestor::db:qandadiv[1]"
			     mode="m:intralabel-punctuation"/>
      </xsl:if>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="inhlabel"
		select="ancestor-or-self::db:qandaset/@defaultlabel[1]"/>

  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="$inhlabel != ''">
        <xsl:value-of select="$inhlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="db:label">
      <xsl:apply-templates select="db:label"/>
    </xsl:when>

    <xsl:when test="$deflabel = 'qanda'">
      <xsl:if test="self::db:question">
	<xsl:call-template name="gentext">
	  <xsl:with-param name="key" select="'Question'"/>
	</xsl:call-template>
      </xsl:if>

      <xsl:if test="self::db:anser">
	<xsl:call-template name="gentext">
	  <xsl:with-param name="key" select="'Answer'"/>
	</xsl:call-template>
      </xsl:if>
    </xsl:when>

    <xsl:when test="$deflabel = 'number' and self::db:question">
      <xsl:value-of select="$prefix"/>
      <xsl:number level="multiple" count="db:qandaentry" format="1"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:bibliography|db:glossary|db:index|db:setindex"
	      mode="m:label-content">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:bibliodiv|db:glossdiv|db:indexdiv"
	      mode="m:label-content">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:sidebar" mode="m:label-content">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:table" mode="m:label-content">
  <!-- tables have to be handled specially because HTML tables with captions don't count -->
  <xsl:variable name="pchap"
                select="(ancestor::db:chapter
                         |ancestor::db:appendix
                         |ancestor::db:article[ancestor::db:book])[last()]"/>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$pchap">
	  <xsl:variable name="prefix">
	    <xsl:apply-templates select="$pchap" mode="m:label-content"/>
	  </xsl:variable>

	  <xsl:if test="$prefix != ''">
	    <xsl:copy-of select="$prefix"/>
	    <xsl:apply-templates select="$pchap"
				 mode="m:intralabel-punctuation"/>
	  </xsl:if>

          <xsl:variable name="count" as="xs:string*">
            <xsl:for-each select="$pchap//db:table intersect preceding::db:table">
              <xsl:if test="db:info/db:title|db:title">1</xsl:if>
            </xsl:for-each>
          </xsl:variable>

          <xsl:number format="1" value="count($count) + 1"/>
        </xsl:when>
	<xsl:when test="ancestor::db:book|ancestor::db:article">
          <xsl:variable name="anc" select="(ancestor::db:book|ancestor::db:article)[last()]"/>
          <xsl:variable name="count" as="xs:string*">
            <xsl:for-each select="$anc//db:table intersect preceding::db:table">
              <xsl:if test="db:info/db:title|db:title">1</xsl:if>
            </xsl:for-each>
          </xsl:variable>

          <xsl:number format="1" value="count($count) + 1"/>
	</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="count" as="xs:string*">
            <xsl:for-each select="preceding::db:table">
              <xsl:if test="db:info/db:title|db:title">1</xsl:if>
            </xsl:for-each>
          </xsl:variable>

          <xsl:number format="1" value="count($count) + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:figure|db:example|db:procedure" mode="m:label-content">
  <xsl:variable name="pchap"
                select="ancestor::db:chapter
                        |ancestor::db:appendix
                        |ancestor::db:article[ancestor::db:book]"/>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="self::db:procedure and $formal.procedures = 0">
      <!-- No label -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$pchap">
	  <xsl:variable name="prefix">
	    <xsl:apply-templates select="$pchap" mode="m:label-content"/>
	  </xsl:variable>

	  <xsl:if test="$prefix != ''">
	    <xsl:copy-of select="$prefix"/>
	    <xsl:apply-templates select="$pchap"
				 mode="m:intralabel-punctuation"/>
	  </xsl:if>
	  <xsl:number format="1" from="db:chapter|db:appendix" level="any"/>
        </xsl:when>
	<xsl:when test="ancestor::db:book|ancestor::db:article">
          <xsl:number format="1" from="db:book|db:article" level="any"/>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:number format="1" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:equation" mode="m:label-content">
  <xsl:variable name="pchap"
                select="ancestor::chapter
                        |ancestor::appendix
                        |ancestor::article[ancestor::book]"/>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$pchap">
	<xsl:variable name="prefix">
	  <xsl:apply-templates select="$pchap" mode="m:label-content"/>
	</xsl:variable>

	<xsl:if test="$prefix != ''">
	  <xsl:copy-of select="$prefix"/>
	  <xsl:apply-templates select="$pchap"
			       mode="m:intralabel-punctuation"/>
	</xsl:if>
      </xsl:if>

      <xsl:choose>
	<xsl:when test="ancestor::db:chapter or ancestor::db:appendix">
	  <xsl:number format="1" count="db:equation[db:title or db:info/db:title]"
		      from="db:chapter|db:appendix" level="any"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:number format="1" count="db:equation[db:title or db:info/db:title]"
		      level="any"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:orderedlist/db:listitem" mode="m:label-content">
  <xsl:variable name="numeration" select="f:orderedlist-numeration(..)"/>
  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$numeration='arabic'">1</xsl:when>
      <xsl:when test="$numeration='loweralpha'">a</xsl:when>
      <xsl:when test="$numeration='lowerroman'">i</xsl:when>
      <xsl:when test="$numeration='upperalpha'">A</xsl:when>
      <xsl:when test="$numeration='upperroman'">I</xsl:when>
      <!-- What!? This should never happen -->
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unexpected numeration: </xsl:text>
          <xsl:value-of select="$numeration"/>
        </xsl:message>
        <xsl:value-of select="1."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:number value="f:orderedlist-item-number(.)"
	      format="{$type}"/>
</xsl:template>

<xsl:template match="db:abstract" mode="m:label-content">
  <!-- nop -->
</xsl:template>

<xsl:template match="db:note|db:tip|db:warning|db:caution|db:important" mode="m:label-content">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
