<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f ghost h m t u xs"
                version="2.0">

<xsl:param name="table.width.nominal" select="'6.5in'"/>
<xsl:param name="table.frame.default">all</xsl:param>
<xsl:param name="table.frame.border.style">solid</xsl:param>
<xsl:param name="table.frame.border.thickness">0.8pt</xsl:param>
<xsl:param name="table.frame.border.color">black</xsl:param>
<xsl:param name="table.cell.border.style">solid</xsl:param>
<xsl:param name="table.cell.border.thickness">0.4pt</xsl:param>
<xsl:param name="table.cell.border.color">black</xsl:param>

<xsl:include href="../common/table.xsl"/>

<!-- FIXME:
<xsl:template match="db:table">
  <fo:block>
    <xsl:call-template name="t:make.table.content"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:informaltable">
  <fo:block>
    <xsl:call-template name="t:make.table.content"/>
  </fo:block>
</xsl:template>
-->

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
    <xsl:when test="self::db:table">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="table.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column">
            <xsl:value-of select="$keep.together"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$placement = 'before'">
          <xsl:call-template name="t:formal.object.heading">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:copy-of select="$table.layout"/>
        <xsl:call-template name="t:table.footnote.block"/>
        <xsl:if test="$placement != 'before'">
          <xsl:call-template name="t:formal.object.heading">
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
    <fo:block keep-with-previous.within-column="always">
      <xsl:apply-templates select=".//db:footnote" mode="m:table.footnote.mode"/>
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

  <!-- We start by normalizing the table, making all the columns, spans,
       etc. explicit. This vastly simplifies subsequent processing. But
       it introduces a problem, the normalized table is a different tree.
       That means that links to other parts of the real tree won't work.

       To resolve this problem, we carry the original table around and
       when it comes time to process the *content* of a table cell, we use
       the cell from the original tree.
  -->

  <xsl:variable name="normalized" as="element(db:tgroup)">
    <xsl:apply-templates select="." mode="m:cals-phase-1"/>
  </xsl:variable>

  <xsl:apply-templates select="$normalized" mode="m:cals">
    <xsl:with-param name="origtable" select="."/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:tgroup" name="db:tgroup" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>

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
      <xsl:with-param name="frame" select="if ($origtable/../@frame)
					   then $origtable/../@frame
					   else $table.frame.default"/>
    </xsl:call-template>
    <!-- FIXME: handle table width -->

    <xsl:apply-templates select="db:thead" mode="m:cals">
      <xsl:with-param name="origtable" select="$origtable"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="db:tfoot" mode="m:cals">
      <xsl:with-param name="origtable" select="$origtable"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="db:tbody" mode="m:cals">
      <xsl:with-param name="origtable" select="$origtable"/>
    </xsl:apply-templates>
  </fo:table>
</xsl:template>

<xsl:template match="db:entrytbl" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>

  <fo:table-cell>
    <xsl:call-template name="db:tgroup">
      <xsl:with-param name="origtable" select="$origtable"/>
    </xsl:call-template>
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
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>
  <fo:table-header>
    <xsl:apply-templates mode="m:cals">
      <xsl:with-param name="origtable" select="$origtable"/>
    </xsl:apply-templates>
  </fo:table-header>
</xsl:template>

<xsl:template match="db:tbody" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>
  <fo:table-body>
    <xsl:apply-templates mode="m:cals">
      <xsl:with-param name="origtable" select="$origtable"/>
    </xsl:apply-templates>
  </fo:table-body>
</xsl:template>

<xsl:template match="db:tfoot" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>
  <fo:table-footer>
    <xsl:apply-templates mode="m:cals">
      <xsl:with-param name="origtable" select="$origtable"/>
    </xsl:apply-templates>
  </fo:table-footer>
</xsl:template>

<xsl:template match="db:colspec|db:spanspec" mode="m:cals">
  <!-- nop -->
</xsl:template>

<xsl:template match="db:row" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>
  <fo:table-row>

    <xsl:if test="@rowsep = 1 and following-sibling::db:row">
      <xsl:attribute name="style">
	<xsl:call-template name="t:border">
	  <xsl:with-param name="side" select="'bottom'"/>
	</xsl:call-template>
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates mode="m:cals">
      <xsl:with-param name="origtable" select="$origtable"/>
    </xsl:apply-templates>
  </fo:table-row>
</xsl:template>

<xsl:template match="db:entry" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>

  <xsl:variable name="empty.cell" select="not(node())"/>

  <fo:table-cell>
    <!-- FIXME: handle @revisionflag -->
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

    <xsl:if test="@rowsep &gt; 0 and parent::*/following-sibling::db:row">
      <xsl:call-template name="t:border">
	<xsl:with-param name="side" select="'bottom'"/>
      </xsl:call-template>
    </xsl:if>
    
    <fo:block>
      <xsl:choose>
	<xsl:when test="$empty.cell">
	  <xsl:text>&#160;</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="origcell" select="key('genid',@ghost:id,$origtable)"/>
	  <xsl:apply-templates select="$origcell/node()"/>
	</xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </fo:table-cell>
</xsl:template>

<xsl:template match="ghost:empty" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>
  <!-- FIXME: what about attributes on empty cells? -->
  <table-cell>
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
  </table-cell>
</xsl:template>

<xsl:template match="ghost:overlapped" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>
  <!-- nop -->
</xsl:template>

<xsl:template match="*" mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>

  <xsl:message terminate="yes">
    <xsl:text>Error: attempt to process </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text> in mode m:cals.</xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:cals">
  <xsl:param name="origtable" required="yes" as="element(db:tgroup)"/>

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

<xsl:template match="db:table|db:caption|db:col|db:colgroup
                     |db:thead|db:tfoot|db:tbody|db:tr
		     |db:th|db:td" mode="m:html">
  <xsl:message terminate="yes">HTML tables not supported yet.</xsl:message>
</xsl:template>

<xsl:template match="db:informaltable" mode="m:html">
  <xsl:message terminate="yes">HTML tables not supported yet.</xsl:message>
</xsl:template>

</xsl:stylesheet>
