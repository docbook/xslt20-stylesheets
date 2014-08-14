<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:html="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:css="https://github.com/docbook/css-rules"
		exclude-result-prefixes="db doc f ghost h m t u xs html css"
                version="2.0">

<xsl:param name="table.width.nominal" select="'6.5in'"/>
<xsl:param name="table.frame.default">all</xsl:param>
<xsl:param name="table.frame.border.style">solid</xsl:param>
<xsl:param name="table.frame.border.thickness">0.8pt</xsl:param>
<xsl:param name="table.frame.border.color">black</xsl:param>
<xsl:param name="table.cell.border.style">solid</xsl:param>
<xsl:param name="table.cell.border.thickness">0.4pt</xsl:param>
<xsl:param name="table.cell.border.color">black</xsl:param>
<xsl:attribute-set name="table.cell.properties">
  <xsl:attribute name="padding-start">2pt</xsl:attribute>
  <xsl:attribute name="padding-end">2pt</xsl:attribute>
  <xsl:attribute name="padding-top">2pt</xsl:attribute>
  <xsl:attribute name="padding-bottom">2pt</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="table.head.properties">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.body.properties"/>
<xsl:attribute-set name="table.foot.properties"/>

<xsl:include href="../common/table.xsl"/>

<xsl:key name="css-table-class" match="css:table-class" use="@name"/>

<xsl:variable name="css-rules" as="element(css:rules)">
  <xsl:variable name="system-rules" as="element(css:rules)?">
    <xsl:call-template name="t:system-css-rules"/>
  </xsl:variable>
  <xsl:variable name="user-rules" as="element(css:rules)?">
    <xsl:call-template name="t:user-css-rules"/>
  </xsl:variable>
  <css:rules>
    <xsl:sequence select="$user-rules/*"/>
    <xsl:sequence select="$system-rules/*"/>
  </css:rules>
</xsl:variable>

<xsl:template name="t:system-css-rules" as="element(css:rules)?">
  <!-- none by default -->
</xsl:template>

<xsl:template name="t:user-css-rules" as="element(css:rules)?">
  <!-- none by default -->
</xsl:template>

<xsl:param name="css-property-maps" as="element(css:property-map)*">
  <css:property-map css="background-color" fo="background-color"/>
  <css:property-map css="border"/>
  <css:property-map css="border-bottom"/>
  <css:property-map css="border-bottom-color"/>
  <css:property-map css="border-bottom-style"/>
  <css:property-map css="border-bottom-width"/>
  <css:property-map css="border-collapse"/>
  <css:property-map css="border-left"/>
  <css:property-map css="border-left-color"/>
  <css:property-map css="border-left-style"/>
  <css:property-map css="border-left-width"/>
  <css:property-map css="border-right"/>
  <css:property-map css="border-right-color"/>
  <css:property-map css="border-right-style"/>
  <css:property-map css="border-right-width"/>
  <css:property-map css="border-top"/>
  <css:property-map css="border-top-color"/>
  <css:property-map css="border-top-style"/>
  <css:property-map css="border-top-width"/>
  <css:property-map css="font-family"/>
  <css:property-map css="font-style"/>
  <css:property-map css="font-weight"/>
  <css:property-map css="text-align"/>
</xsl:param>

<xsl:template name="t:make.table.content">
  <xsl:choose>
    <xsl:when test="db:tgroup|db:mediaobject">
      <xsl:apply-templates select="db:tgroup|db:mediaobject"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="m:html"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:table-longdesc">
  <!-- NOP -->
</xsl:template>

<!-- ==================================================================== -->

<!-- Placeholder template enables wrapping a fo:table in
     another table for purposes of layout or applying
     extensions such as XEP table-omit-initial-header to
     create "continued" titles on page breaks. -->
<xsl:template name="t:table.layout">
  <xsl:param name="table.content" select="()"/>

  <xsl:copy-of select="$table.content"/>
</xsl:template>

<xsl:template name="t:table.block">
  <xsl:param name="table.layout" select="()"/>

  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:variable name="placement" select="$formal.title.placement[self::db:table]/@placement"/>

  <xsl:variable name="keep.together"><!--
    <xsl:call-template name="pi.dbfo_keep-together"/>
  --></xsl:variable>

  <xsl:choose>
    <xsl:when test="self::db:table and (db:info/db:title or db:title)">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="table.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column">
            <xsl:value-of select="$keep.together"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$placement = 'before'">
          <xsl:call-template name="t:formal-object-heading">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:copy-of select="$table.layout"/>
        <xsl:call-template name="t:table.footnote.block"/>
        <xsl:if test="$placement != 'before'">
          <xsl:call-template name="t:formal-object-heading">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </xsl:if>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                xsl:use-attribute-sets="informaltable.properties">
        <xsl:copy-of select="$table.layout"/>
        <xsl:call-template name="t:table.footnote.block"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Output a table's footnotes in a block -->
<xsl:template name="t:table.footnote.block">
  <xsl:if test=".//db:footnote">
    <fo:block keep-with-previous.within-column="always" margin-top="0.5em">
      <xsl:apply-templates select=".//db:footnote" mode="m:table-footnote-mode"/>
    </fo:block>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:table.container">
  <xsl:param name="table.block"/>
  <xsl:choose>
    <xsl:when test="@orient='land'" >
      <fo:block-container reference-orientation="90"
            padding="6pt"
            xsl:use-attribute-sets="list.block.spacing">
	<!-- FIXME: 
        <xsl:attribute name="width">
          <xsl:call-template name="table.width"/>
	</xsl:attribute> 
	-->
        <fo:block start-indent="0pt" end-indent="0pt">
          <xsl:copy-of select="$table.block"/>
        </fo:block>
      </fo:block-container>
    </xsl:when>
    <xsl:when test="@pgwide = 1">
      <fo:block xsl:use-attribute-sets="pgwide.properties">
        <xsl:copy-of select="$table.block"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$table.block"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->
<!-- CALS tables -->

<xsl:template match="db:tgroup">
  <xsl:if test="not(@cols) or @cols = ''">
    <xsl:message terminate="yes">
      <xsl:text>Error: CALS tables must specify the number of columns.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:apply-templates select="." mode="m:cals"/>
</xsl:template>

<xsl:template match="db:tgroup" name="db:tgroup" mode="m:cals">
  <xsl:variable name="summary"
		select="f:pi(processing-instruction('dbhtml'),'table-summary')"/>

  <xsl:variable name="cellspacing"
		select="f:pi(processing-instruction('dbhtml'),'cellspacing')"/>

  <xsl:variable name="cellpadding"
		select="f:pi(processing-instruction('dbhtml'),'cellpadding')"/>

  <fo:table>
    <xsl:if test="../@pgwide=1 or self::db:entrytbl">
      <xsl:attribute name="width" select="'100%'"/>
    </xsl:if>

    <xsl:call-template name="t:table-frame">
      <xsl:with-param name="frame" select="if (../@frame)
					   then ../@frame
					   else $table.frame.default"/>
    </xsl:call-template>

    <xsl:variable name="colgroup" as="element()">
      <colgroup>
	<xsl:call-template name="generate-colgroup">
          <xsl:with-param name="cols" select="@cols"/>
	</xsl:call-template>
      </colgroup>
    </xsl:variable>

    <xsl:variable name="explicit.table.width"
		  select="f:pi(processing-instruction('dbfo'),'table-width')"/>

    <xsl:variable name="table.width">
      <xsl:choose>
	<xsl:when test="$explicit.table.width != ''">
          <xsl:value-of select="$explicit.table.width"/>
        </xsl:when>
	<xsl:when test="string($table.width.default) = ''">
          <xsl:text>100%</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$table.width.default"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="string($table.width.default) != ''
                  or $explicit.table.width != ''">
      <xsl:attribute name="width"
		     select="f:convert-length($table.width)"/>
    </xsl:if>

    <!-- FIXME: * should be mapped to proportional-column-width() and width="auto" -->
    <xsl:variable name="adjusted-colgroup" as="element()">
      <xsl:call-template name="adjust-column-widths">
	<xsl:with-param name="table-width" select="$table.width"/>
	<xsl:with-param name="colgroup" select="$colgroup"/>
	<xsl:with-param name="abspixels" select="0"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="every $c in $adjusted-colgroup/html:col satisfies contains($c/@width, '%')">
	<xsl:attribute name="table-layout">auto</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="table-layout">fixed</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:call-template name="t:colgroup-to-fo">
      <xsl:with-param name="colgroup" select="$adjusted-colgroup"/>
    </xsl:call-template>

    <xsl:apply-templates select="db:thead" mode="m:cals"/>
    <xsl:apply-templates select="db:tfoot" mode="m:cals"/>
    <xsl:apply-templates select="db:tbody" mode="m:cals"/>
  </fo:table>
</xsl:template>

<xsl:template match="db:entrytbl" mode="m:cals">
  <fo:table-cell>
    <xsl:call-template name="db:tgroup"/>
  </fo:table-cell>
</xsl:template>

<xsl:template name="t:table-frame">
  <xsl:param name="frame"/>

  <xsl:choose>
    <xsl:when test="$frame='all'">
      <xsl:attribute name="border-start-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-start-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-start-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$frame='bottom'">
      <xsl:attribute name="border-start-style">none</xsl:attribute>
      <xsl:attribute name="border-end-style">none</xsl:attribute>
      <xsl:attribute name="border-top-style">none</xsl:attribute>
      <xsl:attribute name="border-bottom-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$frame='sides'">
      <xsl:attribute name="border-start-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-style">none</xsl:attribute>
      <xsl:attribute name="border-bottom-style">none</xsl:attribute>
      <xsl:attribute name="border-start-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-start-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$frame='lhs'">
      <xsl:attribute name="border-start-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-style">none</xsl:attribute>
      <xsl:attribute name="border-top-style">none</xsl:attribute>
      <xsl:attribute name="border-bottom-style">none</xsl:attribute>
      <xsl:attribute name="border-start-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-start-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$frame='rhs'">
      <xsl:attribute name="border-end-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-style">none</xsl:attribute>
      <xsl:attribute name="border-top-style">none</xsl:attribute>
      <xsl:attribute name="border-bottom-style">none</xsl:attribute>
      <xsl:attribute name="border-end-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-end-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$frame='top'">
      <xsl:attribute name="border-start-style">none</xsl:attribute>
      <xsl:attribute name="border-end-style">none</xsl:attribute>
      <xsl:attribute name="border-top-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-style">none</xsl:attribute>
      <xsl:attribute name="border-top-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$frame='topbot'">
      <xsl:attribute name="border-start-style">none</xsl:attribute>
      <xsl:attribute name="border-end-style">none</xsl:attribute>
      <xsl:attribute name="border-top-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-style">
        <xsl:value-of select="$table.frame.border.style"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-width">
        <xsl:value-of select="$table.frame.border.thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-color">
        <xsl:value-of select="$table.frame.border.color"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$frame='none'">
      <xsl:attribute name="border-start-style">none</xsl:attribute>
      <xsl:attribute name="border-end-style">none</xsl:attribute>
      <xsl:attribute name="border-top-style">none</xsl:attribute>
      <xsl:attribute name="border-bottom-style">none</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Impossible frame on table: </xsl:text>
        <xsl:value-of select="$frame"/>
      </xsl:message>
      <xsl:attribute name="border-start-style">none</xsl:attribute>
      <xsl:attribute name="border-end-style">none</xsl:attribute>
      <xsl:attribute name="border-top-style">none</xsl:attribute>
      <xsl:attribute name="border-bottom-style">none</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:border">
  <xsl:param name="side" select="'start'"/>

  <xsl:attribute name="border-{$side}-width">
    <xsl:value-of select="$table.cell.border.thickness"/>
  </xsl:attribute>
  <xsl:attribute name="border-{$side}-style">
    <xsl:value-of select="$table.cell.border.style"/>
  </xsl:attribute>
  <xsl:attribute name="border-{$side}-color">
    <xsl:value-of select="$table.cell.border.color"/>
  </xsl:attribute>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:cals" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing normalized CALS tables</refpurpose>

<refdescription>
<para>This mode is used to format normalized CALS tables.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:thead" mode="m:cals">
  <fo:table-header xsl:use-attribute-sets="table.head.properties">
    <xsl:apply-templates mode="m:cals"/>
  </fo:table-header>
</xsl:template>

<xsl:template match="db:tbody" mode="m:cals">
  <fo:table-body>
    <xsl:apply-templates mode="m:cals"/>
    </xsl:apply-templates>
  </fo:table-body>
</xsl:template>

<xsl:template match="db:tfoot" mode="m:cals">
  <fo:table-footer>
    <xsl:apply-templates mode="m:cals"/>
  </fo:table-footer>
</xsl:template>

<xsl:template match="db:colspec|db:spanspec" mode="m:cals">
  <!-- nop -->
</xsl:template>

<xsl:template match="db:row" mode="m:cals">
  <xsl:variable name="row-height"
		select="f:pi(processing-instruction('dbfo'),'row-height')"/>

  <xsl:variable name="bgcolor"
		select="f:pi(processing-instruction('dbfo'),'bgcolor')"/>

  <fo:table-row>
    <xsl:if test="$row-height != ''">
      <xsl:attribute name="block-progression-dimension" select="$row-height"/>
    </xsl:if>

    <xsl:if test="$bgcolor != ''">
      <xsl:attribute name="background-color" select="$bgcolor"/>
    </xsl:if>

    <xsl:if test="@rowsep = 1 and (following-sibling::db:row or ../(following-sibling::db:tbody|following-sibling::db:tfoot))">
      <xsl:call-template name="t:border">
        <xsl:with-param name="side" select="'bottom'"/>
      </xsl:call-template>
    </xsl:if>

    <!-- Keep header row with next row -->
    <xsl:if test="ancestor::db:thead">
      <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:if>

    <!-- FIXME: handle @valign -->
    <xsl:apply-templates mode="m:cals"/>
  </fo:table-row>
</xsl:template>

<xsl:template match="db:entry" mode="m:cals">
  <xsl:variable name="empty.cell" select="not(node())"/>

  <xsl:variable name="bgcolor"
		select="f:pi(processing-instruction('dbfo'),'bgcolor')"/>

  <fo:table-cell xsl:use-attribute-sets="table.cell.properties">
    <!-- FIXME: handle @revisionflag -->

    <xsl:if test="$bgcolor != ''">
      <xsl:attribute name="background-color" select="$bgcolor"/>
    </xsl:if>

    <xsl:if test="@ghost:morerows &gt; 0">
      <xsl:attribute name="number-rows-spanned" select="@ghost:morerows + 1"/>
    </xsl:if>

    <xsl:if test="@ghost:width &gt; 1">
      <xsl:attribute name="number-columns-spanned" select="@ghost:width"/>
    </xsl:if>

    <xsl:if test="@colsep &gt; 0 and following-sibling::*">
      <xsl:call-template name="t:border">
	<xsl:with-param name="side" select="'right'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="@rowsep &gt; 0 and (parent::*/following-sibling::db:row or ../../(following-sibling::db:tbody|following-sibling::db:tfoot))">
      <xsl:call-template name="t:border">
	<xsl:with-param name="side" select="'bottom'"/>
      </xsl:call-template>
    </xsl:if>

    <!-- FIXME: add support for <?dbfo ?> from XSLT1 stylesheets -->

    <xsl:if test="@valign != ''">
      <xsl:attribute name="display-align">
	<xsl:choose>
	  <xsl:when test="@valign='top'">before</xsl:when>
	  <xsl:when test="@valign='middle'">center</xsl:when>
	  <xsl:when test="@valign='bottom'">after</xsl:when>
	  <xsl:otherwise>
	    <xsl:message>
	      <xsl:text>Unexpected valign value: </xsl:text>
	      <xsl:value-of select="@valign"/>
	      <xsl:text>, center used.</xsl:text>
	    </xsl:message>
	    <xsl:text>center</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="@align = 'char' and @char != ''">
	<xsl:attribute name="text-align">
	  <xsl:value-of select="@char"/>
	</xsl:attribute>
      </xsl:when>
      <xsl:when test="@align != ''">
	<xsl:attribute name="text-align">
	  <xsl:value-of select="@align"/>
	</xsl:attribute>
      </xsl:when>
    </xsl:choose>

    <fo:block>
      <xsl:choose>
	<xsl:when test="$empty.cell">
	  <xsl:text>&#160;</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </fo:table-cell>
</xsl:template>

<xsl:template match="ghost:empty" mode="m:cals">
  <!-- FIXME: what about attributes on empty cells? -->
  <fo:table-cell>
    <xsl:if test="@colsep &gt; 0 and following-sibling::*">
      <xsl:call-template name="t:border">
	<xsl:with-param name="side" select="'right'"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="@rowsep &gt; 0 and parent::*/following-sibling::db:row">
      <xsl:call-template name="t:border">
	<xsl:with-param name="side" select="'bottom'"/>
      </xsl:call-template>
    </xsl:if>
  </fo:table-cell>
</xsl:template>

<xsl:template match="ghost:overlapped" mode="m:cals">
  <!-- nop -->
</xsl:template>

<xsl:template match="*" mode="m:cals">
  <xsl:message terminate="yes">
    <xsl:text>Error: attempt to process </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text> in mode m:cals.</xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:cals">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->
<!-- HTML tables -->

<doc:mode name="m:html" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing HTML tables</refpurpose>

<refdescription>
<para>This mode is used to format HTML tables.</para>
<para>FIXME: don't copy non-HTML attributes if there are any!</para>
</refdescription>
</doc:mode>

<xsl:template match="db:table|db:informaltable" mode="m:html">
  <xsl:variable name="cols" as="element(db:col)*">
    <xsl:apply-templates select="db:colgroup|db:col" mode="m:html-cols"/>
  </xsl:variable>

  <xsl:variable name="body">
    <!-- fixme: what about column spans here? -->
    <xsl:for-each select="$cols">
      <fo:table-column>
        <xsl:if test="@width">
          <xsl:attribute name="column-width" select="@width"/>
        </xsl:if>
      </fo:table-column>
    </xsl:for-each>

    <xsl:choose>
      <xsl:when test="db:tbody">
        <xsl:apply-templates select="db:thead|db:tfoot|db:tbody" mode="m:html">
          <xsl:with-param name="cols" select="$cols"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-body xsl:use-attribute-sets="table.body.properties">
          <xsl:call-template name="t:process-html-rows">
            <xsl:with-param name="cols" select="$cols"/>
            <xsl:with-param name="rows" select="db:tr"/>
          </xsl:call-template>
        </fo:table-body>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:block xsl:use-attribute-sets="table.properties">
    <xsl:choose>
      <xsl:when test="db:caption">
        <fo:table-and-caption>
          <xsl:apply-templates select="db:caption" mode="m:html"/>
          <fo:table>
            <xsl:if test="@border = '1'">
              <xsl:call-template name="t:table-frame">
                <xsl:with-param name="frame" select="'all'"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="empty(db:colgroup/db:col[@width]|db:col[@width])">
              <xsl:attribute name="width" select="'100%'"/>
            </xsl:if>
            <xsl:call-template name="t:parse-css">
              <xsl:with-param name="style" select="@style"/>
            </xsl:call-template>
            <xsl:copy-of select="$body"/>
          </fo:table>
        </fo:table-and-caption>
      </xsl:when>
      <xsl:otherwise>
        <fo:table>
          <xsl:if test="@border = '1'">
            <xsl:call-template name="t:table-frame">
              <xsl:with-param name="frame" select="'all'"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="empty(db:colgroup/db:col[@width]|db:col[@width])">
            <xsl:attribute name="width" select="'100%'"/>
          </xsl:if>
          <xsl:call-template name="t:parse-css">
            <xsl:with-param name="style" select="@style"/>
          </xsl:call-template>
          <xsl:copy-of select="$body"/>
        </fo:table>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template match="db:caption" mode="m:html">
  <fo:table-caption>
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </fo:table-caption>
</xsl:template>

<xsl:template match="db:colgroup" mode="m:html">
  <xsl:message terminate="yes">Error: db:colgroup should never be processed in m:html mode</xsl:message>
</xsl:template>

<xsl:template match="db:col" mode="m:html">
  <xsl:message terminate="yes">Error: db:col should never be processed in m:html mode</xsl:message>
</xsl:template>

<xsl:template match="db:thead" mode="m:html">
  <xsl:param name="cols" as="element(db:col)*"/>

  <fo:table-header xsl:use-attribute-sets="table.head.properties">
    <xsl:call-template name="t:parse-css">
      <xsl:with-param name="style" select="@style"/>
    </xsl:call-template>
    <xsl:call-template name="t:process-html-rows">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rows" select="db:tr"/>
    </xsl:call-template>
  </fo:table-header>
</xsl:template>

<xsl:template match="db:tbody" mode="m:html">
  <xsl:param name="cols" as="element(db:col)*"/>

  <fo:table-body xsl:use-attribute-sets="table.body.properties">
    <xsl:call-template name="t:parse-css">
      <xsl:with-param name="style" select="@style"/>
    </xsl:call-template>
    <xsl:call-template name="t:process-html-rows">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rows" select="db:tr"/>
    </xsl:call-template>
  </fo:table-body>
</xsl:template>

<xsl:template match="db:tfoot" mode="m:html">
  <xsl:param name="cols" as="element(db:col)*"/>

  <fo:table-footer xsl:use-attribute-sets="table.foot.properties">
    <xsl:call-template name="t:parse-css">
      <xsl:with-param name="style" select="@style"/>
    </xsl:call-template>
    <xsl:call-template name="t:process-html-rows">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rows" select="db:tr"/>
    </xsl:call-template>
  </fo:table-footer>
</xsl:template>

<xsl:template match="db:tr" mode="m:html">
  <xsl:param name="cells" as="element()*"/>

  <fo:table-row>
    <xsl:call-template name="t:parse-css">
      <xsl:with-param name="style" select="@style"/>
    </xsl:call-template>
    <xsl:copy-of select="$cells"/>
  </fo:table-row>
</xsl:template>

<xsl:template match="db:th|db:td" mode="m:html">
  <xsl:param name="col" select="()"/>

  <xsl:variable name="cell" select="."/>
  <xsl:variable name="table" select="(ancestor::db:table|ancestor::db:informaltable)[last()]"/>

  <fo:table-cell xsl:use-attribute-sets="table.cell.properties">
    <xsl:if test="$table/@border = 1">
      <xsl:call-template name="t:border">
        <xsl:with-param name="side" select="'bottom'"/>
      </xsl:call-template>
      <xsl:call-template name="t:border">
        <xsl:with-param name="side" select="'right'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:for-each select="tokenize(normalize-space(concat($col/@class,' ',$cell/@class)), '\s+')">
      <xsl:call-template name="t:apply-css-rules">
        <xsl:with-param name="node" select="$cell"/>
        <xsl:with-param name="class" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="($col/@style, $cell/@style)">
      <xsl:call-template name="t:parse-css">
        <xsl:with-param name="node" select="$cell"/>
        <xsl:with-param name="style" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:if test="@valign or $col/@valign">
      <xsl:variable name="valign" select="(@valign,$col/@valign)[1]"/>
      <xsl:attribute name="display-align">
        <xsl:choose>
          <xsl:when test="$valign = 'top'">before</xsl:when>
          <xsl:when test="$valign = 'middle'">center</xsl:when>
          <xsl:when test="$valign = 'bottom'">after</xsl:when>
          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="@align or $col/@align">
      <xsl:variable name="align" select="(@align,$col/@align)[1]"/>
      <xsl:attribute name="text-align">
        <xsl:choose>
          <xsl:when test="$align = 'left'">left</xsl:when>
          <xsl:when test="$align = 'center'">center</xsl:when>
          <xsl:when test="$align = 'right'">right</xsl:when>
          <xsl:when test="$align = 'justify'">justify</xsl:when>
          <xsl:when test="$align = 'char'">
            <xsl:value-of select="(@char,$col/@char)[1]"/>
          </xsl:when>
          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="self::db:th">
      <xsl:attribute name="font-weight" select="'bold'"/>
    </xsl:if>
    <xsl:if test="@rowspan">
      <xsl:attribute name="number-rows-spanned" select="@rowspan"/>
    </xsl:if>
    <xsl:if test="@colspan">
      <xsl:attribute name="number-columns-spanned" select="@colspan"/>
    </xsl:if>
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </fo:table-cell>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:process-html-rows">
  <xsl:param name="cols" as="element(db:col)*"/>
  <xsl:param name="rows" as="element(db:tr)*"/>
  <xsl:param name="overhang" as="xs:integer*"/>

  <xsl:variable name="rowdata" as="item()*">
    <xsl:call-template name="t:process-row">
      <xsl:with-param name="overhang" select="$overhang"/>
      <xsl:with-param name="cells" select="$rows[1]/(db:td|db:th)"/>
      <xsl:with-param name="cols" select="$cols"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="newhang" as="xs:integer*">
    <xsl:for-each select="$rowdata[position() mod 2 = 0]">
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:apply-templates select="$rows[1]" mode="m:html">
    <xsl:with-param name="cells"
                    select="$rowdata[(position() mod 2 = 1)
                                     and (namespace-uri(.) != 'http://docbook.org/ns/docbook/ephemeral')]"/>
  </xsl:apply-templates>

  <xsl:if test="count($rows) &gt; 1">
    <xsl:call-template name="t:process-html-rows">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rows" select="$rows[position() &gt; 1]"/>
      <xsl:with-param name="overhang" select="$newhang"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="t:process-row">
  <xsl:param name="overhang" as="xs:integer*"/>
  <xsl:param name="cells" as="element()*"/>
  <xsl:param name="cols" as="element(db:col)*"/>
  <xsl:param name="curcol" as="xs:integer" select="1"/>

  <xsl:choose>
    <xsl:when test="exists($overhang) and $overhang[1] &gt; 0">
      <ghost:overlap/>
      <ghost:overhang><xsl:value-of select="$overhang[1] - 1"/></ghost:overhang>
      <xsl:call-template name="t:process-row">
        <xsl:with-param name="overhang" select="$overhang[position() &gt; 1]"/>
        <xsl:with-param name="cells" select="$cells"/>
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="curcol" select="$curcol + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="exists($cells)">
      <xsl:apply-templates select="$cells[1]" mode="m:html">
        <xsl:with-param name="col" select="$cols[$curcol]"/>
      </xsl:apply-templates>

      <xsl:variable name="rowspan" select="if ($cells[1]/@rowspan) then xs:integer($cells[1]/@rowspan) else 1"/>
      <xsl:variable name="colspan" select="if ($cells[1]/@colspan) then xs:integer($cells[1]/@colspan) else 1"/>

      <xsl:for-each select="1 to xs:integer($colspan)">
        <xsl:if test=". &gt; 1"><ghost:overlap/></xsl:if>
        <ghost:overhang>
          <xsl:value-of select="$rowspan - 1"/>
        </ghost:overhang>
      </xsl:for-each>

      <xsl:call-template name="t:process-row">
        <xsl:with-param name="overhang" select="$overhang[position() &gt; 1]"/>
        <xsl:with-param name="cells" select="$cells[position() &gt; 1]"/>
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="curcol" select="$curcol + $colspan"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- nop -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:colgroup" mode="m:html-cols">
  <xsl:variable name="colgroup" select="."/>
  <xsl:choose>
    <xsl:when test="@span">
      <xsl:for-each select="1 to xs:integer(@span)">
        <db:col>
          <xsl:copy-of select="$colgroup/@* except $colgroup/@span"/>
        </db:col>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="db:col" mode="m:html-cols"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:col" mode="m:html-cols">
  <xsl:variable name="col" select="."/>
  <xsl:choose>
    <xsl:when test="@span">
      <xsl:for-each select="1 to xs:integer(@span)">
        <db:col>
          <xsl:copy-of select="$col/@* except $col/@span"/>
        </db:col>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:colgroup-to-fo">
  <xsl:param name="colgroup" as="element(html:colgroup)"/>

  <xsl:for-each select="$colgroup/html:col">
    <fo:table-column column-width="{@width}"/>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:apply-css-rules">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="class" as="xs:string"/>

  <xsl:variable name="style-rules" select="$css-rules/css:table-class[@name=$class]"/>
  <xsl:variable name="doc-rules" select="key('css-table-class', $class, root($node))"/>

  <xsl:for-each select="($style-rules/css:property, $doc-rules/css:property)">
    <xsl:if test="exists(@name) and exists(@value)">
      <xsl:attribute name="{@name}" select="@value"/>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="t:parse-css">
  <xsl:param name="node" as="element()" select="."/>
  <xsl:param name="style" as="xs:string?"/>

  <xsl:for-each select="tokenize($style, '\s*;\s*')">
    <xsl:variable name="property" select="normalize-space(substring-before(., ':'))"/>
    <xsl:variable name="value" select="normalize-space(substring-after(., ':'))"/>
    <xsl:variable name="map" select="$css-property-maps[@css = $property][last()]"/>
    <xsl:if test="$property != '' and $value != '' and exists($map)">
      <xsl:attribute name="{if ($map/@fo) then $map/@fo else $property}"
                     select="$value"/>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
