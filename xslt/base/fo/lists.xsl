<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f m t xs"
                version='2.0'>

<!-- ********************************************************************
     $Id: lists.xsl 7469 2007-09-27 17:37:14Z mzjn $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="db:itemizedlist|db:orderedlist">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:variable name="pi-label-width"
		select="f:dbfo-pi-attribute(.,'label-width')"/>

  <xsl:variable name="label-width">
    <xsl:choose>
      <xsl:when test="$pi-label-width = ''">
	<xsl:value-of select="$itemizedlist.label.width"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$pi-label-width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="t:titlepage"/>

  <!-- Preserve order of PIs and comments -->
  <xsl:apply-templates
      select="*[not(self::db:listitem)]
              |comment()[not(preceding-sibling::listitem)]
              |processing-instruction()[not(preceding-sibling::listitem)]"/>

  <xsl:variable name="content">
    <xsl:apply-templates
          select="db:listitem
                  |comment()[preceding-sibling::listitem]
                  |processing-instruction()[preceding-sibling::listitem]"/>
  </xsl:variable>

  <!-- nested lists don't add extra list-block spacing -->
  <xsl:choose>
    <xsl:when test="ancestor::db:listitem">
      <fo:list-block id="{$id}" xsl:use-attribute-sets="itemizedlist.properties">
	<xsl:attribute name="provisional-distance-between-starts"
		       select="$label-width"/>
        <xsl:sequence select="$content"/>
      </fo:list-block>
    </xsl:when>
    <xsl:otherwise>
      <fo:list-block id="{$id}" xsl:use-attribute-sets="list.block.spacing itemizedlist.properties">
	<xsl:attribute name="provisional-distance-between-starts"
		       select="$label-width"/>
	<xsl:sequence select="$content"/>
      </fo:list-block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:itemizedlist/db:listitem">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:variable name="item.contents">
    <fo:list-item-label end-indent="label-end()"
			xsl:use-attribute-sets="itemizedlist.label.properties">
      <fo:block font-size="{f:font-size(.)}">
        <xsl:call-template name="itemizedlist.label.markup">
          <xsl:with-param name="itemsymbol" select="f:itemizedlist-symbol(parent::db:itemizedlist)"/>
        </xsl:call-template>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()" font-size="{f:font-size(.)}">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
    </fo:list-item-body>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="parent::*/@spacing = 'compact'">
      <fo:list-item id="{$id}" xsl:use-attribute-sets="compact.list.item.spacing">
        <xsl:sequence select="$item.contents"/>
      </fo:list-item>
    </xsl:when>
    <xsl:otherwise>
      <fo:list-item id="{$id}" xsl:use-attribute-sets="list.item.spacing">
        <xsl:sequence select="$item.contents"/>
      </fo:list-item>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="itemizedlist.label.markup">
  <xsl:param name="itemsymbol" select="'disc'"/>

  <xsl:choose>
    <xsl:when test="$itemsymbol='none'"></xsl:when>
    <xsl:when test="$itemsymbol='disc'">&#x2022;</xsl:when>
    <xsl:when test="$itemsymbol='bullet'">&#x2022;</xsl:when>
    <xsl:when test="$itemsymbol='endash'">&#x2013;</xsl:when>
    <xsl:when test="$itemsymbol='emdash'">&#x2014;</xsl:when>
    <!-- Some of these may work in your XSL-FO processor and fonts -->
    <!--
    <xsl:when test="$itemsymbol='square'">&#x25A0;</xsl:when>
    <xsl:when test="$itemsymbol='box'">&#x25A0;</xsl:when>
    <xsl:when test="$itemsymbol='smallblacksquare'">&#x25AA;</xsl:when>
    <xsl:when test="$itemsymbol='circle'">&#x25CB;</xsl:when>
    <xsl:when test="$itemsymbol='opencircle'">&#x25CB;</xsl:when>
    <xsl:when test="$itemsymbol='whitesquare'">&#x25A1;</xsl:when>
    <xsl:when test="$itemsymbol='smallwhitesquare'">&#x25AB;</xsl:when>
    <xsl:when test="$itemsymbol='round'">&#x25CF;</xsl:when>
    <xsl:when test="$itemsymbol='blackcircle'">&#x25CF;</xsl:when>
    <xsl:when test="$itemsymbol='whitebullet'">&#x25E6;</xsl:when>
    <xsl:when test="$itemsymbol='triangle'">&#x2023;</xsl:when>
    <xsl:when test="$itemsymbol='point'">&#x203A;</xsl:when>
    <xsl:when test="$itemsymbol='hand'"><fo:inline
                         font-family="Wingdings 2">A</fo:inline></xsl:when>
    -->
    <xsl:otherwise>&#x2022;</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:orderedlist/db:listitem" mode="m:listitem-number">
  <xsl:variable name="numeration"
		select="f:orderedlist-numeration(parent::db:orderedlist)"/>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$numeration='arabic'">1.</xsl:when>
      <xsl:when test="$numeration='loweralpha'">a.</xsl:when>
      <xsl:when test="$numeration='lowerroman'">i.</xsl:when>
      <xsl:when test="$numeration='upperalpha'">A.</xsl:when>
      <xsl:when test="$numeration='upperroman'">I.</xsl:when>
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

  <xsl:variable name="item-number"
		select="f:orderedlist-item-number(.)"/>

  <xsl:if test="parent::db:orderedlist/@inheritnum='inherit'
                and ancestor::db:listitem[parent::db:orderedlist]">
    <xsl:apply-templates select="ancestor::db:listitem[parent::orderedlist][1]"
			 mode="m:listitem-number"/>
  </xsl:if>

  <xsl:number value="$item-number" format="{$type}"/>
</xsl:template>

<xsl:template match="db:orderedlist/db:listitem">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:variable name="item.contents">
    <fo:list-item-label end-indent="label-end()"
			xsl:use-attribute-sets="orderedlist.label.properties">
      <fo:block font-size="{f:font-size(.)}">
        <xsl:apply-templates select="." mode="m:listitem-number"/>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()" font-size="{f:font-size(.)}">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
    </fo:list-item-body>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="parent::*/@spacing = 'compact'">
      <fo:list-item id="{$id}" xsl:use-attribute-sets="compact.list.item.spacing">
        <xsl:sequence select="$item.contents"/>
      </fo:list-item>
    </xsl:when>
    <xsl:otherwise>
      <fo:list-item id="{$id}" xsl:use-attribute-sets="list.item.spacing">
        <xsl:sequence select="$item.contents"/>
      </fo:list-item>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- FIXME: can we do better? -->
<!--
<xsl:template match="listitem/*[1][local-name()='para' or
                                   local-name()='simpara' or
                                   local-name()='formalpara']
                     |glossdef/*[1][local-name()='para' or
                                   local-name()='simpara' or
                                   local-name()='formalpara']
                     |step/*[1][local-name()='para' or
                                   local-name()='simpara' or
                                   local-name()='formalpara']
                     |callout/*[1][local-name()='para' or
                                   local-name()='simpara' or
                                   local-name()='formalpara']"
              priority="2">
  <fo:block>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>
-->

<xsl:template match="db:variablelist">
  <xsl:variable name="presentation"
		select="f:dbfo-pi-attribute(.,'list-presentation')"/>

  <xsl:choose>
    <xsl:when test="$presentation = 'list'">
      <xsl:apply-templates select="." mode="mp:vl.as.list"/>
    </xsl:when>
    <xsl:when test="$presentation = 'blocks'">
      <xsl:apply-templates select="." mode="mp:vl.as.blocks"/>
    </xsl:when>
    <xsl:when test="$variablelist.as.blocks != 0">
      <xsl:apply-templates select="." mode="mp:vl.as.blocks"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="mp:vl.as.list"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:variablelist" mode="mp:vl.as.list">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:variable name="term-width"
		select="f:dbfo-pi-attribute(.,'term-width')"/>

  <xsl:variable name="termlength">
    <xsl:choose>
      <xsl:when test="$term-width != ''">
        <xsl:value-of select="$term-width"/>
      </xsl:when>
      <xsl:when test="@termlength">
	<xsl:choose>
          <xsl:when test="@termlength castable as xs:double">
	    <xsl:value-of select="@termlength"/>
	    <xsl:choose>
              <!-- workaround for passivetex and non-constant expressions -->
              <xsl:when test="$fo.processor = 'passivetex'">
		<xsl:text>em</xsl:text>
	      </xsl:when>
              <xsl:otherwise>
		<xsl:text>em * 0.60</xsl:text>
	      </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
	  <xsl:otherwise>
	    <!-- if the term length isn't a number, assume it's a measurement -->
            <xsl:value-of select="@termlength"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="t:longest-term">
          <xsl:with-param name="terms" select="db:varlistentry/db:term"/>
          <xsl:with-param name="maxlength" select="$variablelist.max.termlength"/>
        </xsl:call-template>

        <xsl:choose>
          <!-- workaround for passivetex and non-constant expressions -->
	  <xsl:when test="$fo.processor = 'passivetex'">
            <xsl:text>em</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>em * 0.60</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:text>term width: </xsl:text>
    <xsl:value-of select="$termlength"/>
  </xsl:message>
-->

  <xsl:variable name="label-separation">1em</xsl:variable>
  <xsl:variable name="distance-between-starts">
    <xsl:choose>
      <!-- workaround for passivetex and non-constant expressions -->
      <xsl:when test="$fo.processor = 'passivetex'">
	<xsl:value-of select="$termlength"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$termlength"/>
	<xsl:text>+</xsl:text>
        <xsl:value-of select="$label-separation"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="t:titlepage"/>

  <!-- Preserve order of PIs and comments -->
  <xsl:apply-templates
    select="*[not(self::db:varlistentry)]
            |comment()[not(preceding-sibling::db:varlistentry)]
            |processing-instruction()[not(preceding-sibling::db:varlistentry)]"/>

  <xsl:variable name="content">
    <xsl:apply-templates mode="mp:vl.as.list"
      select="db:varlistentry
              |comment()[preceding-sibling::db:varlistentry]
              |processing-instruction()[preceding-sibling::db:varlistentry]"/>
  </xsl:variable>

  <!-- nested lists don't add extra list-block spacing -->
  <xsl:choose>
    <xsl:when test="ancestor::db:listitem">
      <fo:list-block id="{$id}"
                     provisional-distance-between-starts="{$distance-between-starts}"
                     provisional-label-separation="{$label-separation}">
        <xsl:copy-of select="$content"/>
      </fo:list-block>
    </xsl:when>
    <xsl:otherwise>
      <fo:list-block id="{$id}"
                     provisional-distance-between-starts="{$distance-between-starts}"
                     provisional-label-separation="{$label-separation}"
                     xsl:use-attribute-sets="list.block.spacing">
        <xsl:copy-of select="$content"/>
      </fo:list-block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:longest-term">
  <xsl:param name="longest" select="0"/>
  <xsl:param name="terms" select="."/>
  <xsl:param name="maxlength" select="-1"/>

  <!-- Process out any indexterms in the term -->
  <xsl:variable name="term.text">
    <xsl:apply-templates select="$terms[1]"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$longest &gt; $maxlength and $maxlength &gt; 0">
      <xsl:value-of select="$maxlength"/>
    </xsl:when>
    <xsl:when test="not($terms)">
      <xsl:value-of select="$longest"/>
    </xsl:when>
    <xsl:when test="string-length($term.text) &gt; $longest">
      <xsl:call-template name="t:longest-term">
        <xsl:with-param name="longest"
            select="string-length($term.text)"/>
        <xsl:with-param name="maxlength" select="$maxlength"/>
        <xsl:with-param name="terms" select="$terms[position() &gt; 1]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="t:longest-term">
        <xsl:with-param name="longest" select="$longest"/>
        <xsl:with-param name="maxlength" select="$maxlength"/>
        <xsl:with-param name="terms" select="$terms[position() &gt; 1]"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:varlistentry" mode="mp:vl.as.list">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:variable name="item.contents">
    <fo:list-item-label end-indent="label-end()" text-align="start">
      <fo:block font-size="{f:font-size(.)}">
        <xsl:apply-templates select="db:term"/>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block font-size="{f:font-size(.)}">
        <xsl:apply-templates select="db:listitem"/>
      </fo:block>
    </fo:list-item-body>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="parent::*/@spacing = 'compact'">
      <fo:list-item id="{$id}"
          xsl:use-attribute-sets="compact.list.item.spacing">
        <xsl:sequence select="$item.contents"/>
      </fo:list-item>
    </xsl:when>
    <xsl:otherwise>
      <fo:list-item id="{$id}" xsl:use-attribute-sets="list.item.spacing">
        <xsl:sequence select="$item.contents"/>
      </fo:list-item>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:variablelist" mode="m:vl.as.blocks">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <!-- termlength is irrelevant -->

  <xsl:call-template name="t:titlepage"/>

  <!-- Preserve order of PIs and comments -->
  <xsl:apply-templates
    select="*[not(self::db:varlistentry)]
            |comment()[not(preceding-sibling::db:varlistentry)]
            |processing-instruction()[not(preceding-sibling::db:varlistentry)]"/>

  <xsl:variable name="content">
    <xsl:apply-templates mode="mp:vl.as.blocks"
      select="db:varlistentry
              |comment()[preceding-sibling::db:varlistentry]
              |processing-instruction()[preceding-sibling::db:varlistentry]"/>
  </xsl:variable>

  <!-- nested lists don't add extra list-block spacing -->
  <xsl:choose>
    <xsl:when test="ancestor::db:listitem">
      <fo:block id="{$id}">
        <xsl:sequence select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}" xsl:use-attribute-sets="list.block.spacing">
        <xsl:sequence select="$content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:varlistentry" mode="mp:vl.as.blocks">
  <xsl:variable name="id" select="f:node-id(.)"/>

  <fo:block id="{$id}"
	    xsl:use-attribute-sets="list.item.spacing"
	    keep-together.within-column="always"
	    keep-with-next.within-column="always">
    <xsl:apply-templates select="db:term"/>
  </fo:block>

  <fo:block margin-left="0.25in">
    <xsl:apply-templates select="db:listitem"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:varlistentry/db:term">
  <fo:inline>
    <xsl:call-template name="t:simple-xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </fo:inline>

  <xsl:choose>
    <xsl:when test="not(following-sibling::db:term)"/> <!-- do nothing -->
    <xsl:otherwise>
      <!-- * if we have multiple terms in the same varlistentry, generate -->
      <!-- * a separator (", " by default) and/or an additional line -->
      <!-- * break after each one except the last -->
      <fo:inline><xsl:value-of select="$variablelist.term.separator"/></fo:inline>
      <xsl:if test="not($variablelist.term.break.after = '0')">
        <fo:block/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:varlistentry/db:listitem">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:simplelist|db:simplelist[@type='vert']">
  <!-- with no type specified, the default is 'vert' -->

  <xsl:variable name="explicit.table.width"
		select="f:dbfo-pi-attribute(.,'list-width')"/>

  <xsl:variable name="table.width">
    <xsl:choose>
      <xsl:when test="$explicit.table.width != ''">
        <xsl:value-of select="$explicit.table.width"/>
      </xsl:when>
      <xsl:when test="$default.table.width = ''">
        <xsl:text>100%</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$default.table.width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:table xsl:use-attribute-sets="normal.para.spacing">

    <xsl:choose>
      <xsl:when test="$fo.processor = 'antennahouse' or $fo.processor = 'xep'">
	<xsl:attribute name="table-layout" select="'auto'"/>
	<xsl:if test="$explicit.table.width != ''">
	  <xsl:attribute name="width" select="$explicit.table.width"/>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="table-layout" select="'fixed'"/>
        <xsl:attribute name="width" select="$table.width"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="t:simplelist-table-columns">
      <xsl:with-param name="cols">
        <xsl:choose>
          <xsl:when test="@columns">
            <xsl:value-of select="@columns"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <fo:table-body start-indent="0pt" end-indent="0pt">
      <xsl:call-template name="t:simplelist-vert">
        <xsl:with-param name="cols">
          <xsl:choose>
            <xsl:when test="@columns">
              <xsl:value-of select="@columns"/>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </fo:table-body>
  </fo:table>
</xsl:template>

<xsl:template match="db:simplelist[@type='inline']">
  <!-- if dbchoice PI exists, use that to determine the choice separator -->
  <!-- (that is, equivalent of "and" or "or" in current locale), or literal -->
  <!-- value of "choice" otherwise -->
  <fo:inline>
    <xsl:variable name="localized-choice-separator">
      <!-- FIXME: -->
      <xsl:text>and</xsl:text>
    </xsl:variable>

    <xsl:for-each select="member">
      <xsl:apply-templates/>
      <xsl:choose>
	<xsl:when test="position() = last()"/> <!-- do nothing -->
	<xsl:otherwise>
	  <xsl:text>, </xsl:text>
	  <xsl:if test="position() = last() - 1">
	    <xsl:if test="$localized-choice-separator != ''">
	      <xsl:value-of select="$localized-choice-separator"/>
	      <xsl:text> </xsl:text>
	    </xsl:if>
	  </xsl:if>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </fo:inline>
</xsl:template>

<xsl:template match="db:simplelist[@type='horiz']">

  <xsl:variable name="explicit.table.width"
		select="f:dbfo-pi-attribute(.,'list-width')"/>

  <xsl:variable name="table.width">
    <xsl:choose>
      <xsl:when test="$explicit.table.width != ''">
        <xsl:value-of select="$explicit.table.width"/>
      </xsl:when>
      <xsl:when test="$default.table.width = ''">
        <xsl:text>100%</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$default.table.width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:table xsl:use-attribute-sets="normal.para.spacing">
    <xsl:choose>
      <xsl:when test="$fo.processor = 'antennahouse' or $fo.processor = 'xep'">
        <xsl:attribute name="table-layout" select="'auto'"/>
	<xsl:if test="$explicit.table.width != ''">
	  <xsl:attribute name="width" select="$explicit.table.width"/>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="table-layout" select="'fixed'"/>
        <xsl:attribute name="width" select="$table.width"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="t:simplelist-table-columns">
      <xsl:with-param name="cols">
        <xsl:choose>
          <xsl:when test="@columns">
            <xsl:value-of select="@columns"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <fo:table-body start-indent="0pt" end-indent="0pt">
      <xsl:call-template name="t:simplelist-horiz">
        <xsl:with-param name="cols">
          <xsl:choose>
            <xsl:when test="@columns">
              <xsl:value-of select="@columns"/>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </fo:table-body>
  </fo:table>
</xsl:template>

<xsl:template name="t:simplelist-table-columns">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="curcol" select="1"/>
  <fo:table-column column-number="{$curcol}"
                   column-width="proportional-column-width(1)"/>
  <xsl:if test="$curcol &lt; $cols">
    <xsl:call-template name="t:simplelist-table-columns">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="curcol" select="$curcol + 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="t:simplelist-horiz">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="db:member"/>

  <xsl:if test="$cell &lt;= count($members)">
    <fo:table-row>
      <xsl:call-template name="t:simplelist-horiz-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
   </fo:table-row>
    <xsl:call-template name="t:simplelist-horiz">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell + $cols"/>
      <xsl:with-param name="members" select="$members"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="t:simplelist-horiz-row">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./member"/>
  <xsl:param name="curcol">1</xsl:param>

  <xsl:if test="$curcol &lt;= $cols">
    <fo:table-cell>
      <fo:block>
        <xsl:if test="$members[position()=$cell]">
          <xsl:apply-templates select="$members[position()=$cell]"/>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    <xsl:call-template name="t:simplelist-horiz-row">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="curcol" select="$curcol+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="t:simplelist-vert">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="db:member"/>
  <xsl:param name="rows"
             select="floor((count($members)+$cols - 1) div $cols)"/>

  <xsl:if test="$cell &lt;= $rows">
    <fo:table-row>
      <xsl:call-template name="t:simplelist-vert-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
   </fo:table-row>
    <xsl:call-template name="t:simplelist-vert">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="rows" select="$rows"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="t:simplelist-vert-row">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="rows">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./member"/>
  <xsl:param name="curcol">1</xsl:param>

  <xsl:if test="$curcol &lt;= $cols">
    <fo:table-cell>
      <fo:block>
        <xsl:if test="$members[position()=$cell]">
          <xsl:apply-templates select="$members[position()=$cell]"/>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    <xsl:call-template name="t:simplelist-vert-row">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rows" select="$rows"/>
      <xsl:with-param name="cell" select="$cell+$rows"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="curcol" select="$curcol+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="db:member">
  <xsl:call-template name="t:simple-xlink">
    <xsl:with-param name="content">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:procedure">
  <xsl:variable name="numeration" select="f:procedure-step-numeration(.)"/>

  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:procedure]/@placement"/>
    <xsl:with-param name="object" as="element()">
      <xsl:variable name="step1" select="db:step[1]"/>

      <xsl:apply-templates select="node()[not(self::db:info|self::db:title) and (. &lt;&lt; $step1)]"/>

      <fo:list-block xsl:use-attribute-sets="list.block.spacing"
		     provisional-distance-between-starts="{$procedure.label.width}">
	<xsl:apply-templates select="$step1 | node()[. >> $step1]"/>
      </fo:list-block>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:step">
  <xsl:variable name="keep.together">
    <!-- FIXME:
    <xsl:call-template name="pi.dbfo_keep-together"/>
    -->
  </xsl:variable>

  <fo:list-item xsl:use-attribute-sets="list.item.spacing">
    <xsl:call-template name="t:id"/>
    <xsl:if test="$keep.together != ''">
      <xsl:attribute name="keep-together.within-column"><xsl:value-of
                      select="$keep.together"/></xsl:attribute>
    </xsl:if>
    <fo:list-item-label end-indent="label-end()">
      <fo:block>
        <!-- dwc: fix for one step procedures. Use a bullet if there's no step 2 -->
        <xsl:choose>
          <xsl:when test="count(../db:step) = 1">
            <xsl:text>&#x2022;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="m:number">
              <xsl:with-param name="recursive" select="0"/>
            </xsl:apply-templates>.
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
	<xsl:call-template name="t:titlepage"/>
        <xsl:apply-templates select="node()[not(self::db:info|self::db:title)]"/>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<xsl:template match="db:substeps">
  <fo:list-block xsl:use-attribute-sets="list.block.spacing"
                 provisional-distance-between-starts="{$procedure.label.width}">
    <xsl:apply-templates/>
  </fo:list-block>
</xsl:template>

<xsl:template match="db:stepalternatives">
  <fo:list-block xsl:use-attribute-sets="list.block.spacing"
                 provisional-distance-between-starts="{$procedure.label.width}">
    <xsl:apply-templates select="node()[not(self::db:info)]"/>
  </fo:list-block>
</xsl:template>

<!-- FIXME: support segmentedlist -->
<!-- FIXME: support calloutlist -->

<xsl:function name="f:font-size" as="xs:string">
  <xsl:param name="context" as="element()"/>
  <xsl:value-of select="'inherit'"/>
</xsl:function>

</xsl:stylesheet>
