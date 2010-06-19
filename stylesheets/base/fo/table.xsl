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

<xsl:include href="../common/table.xsl"/>

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

  <xsl:variable name="id">
    <xsl:call-template name="id"/>
  </xsl:variable>

  <xsl:variable name="param.placement"
                select="substring-after(normalize-space(
                   $formal.title.placement), concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

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
<!-- CALS tables -->

<xsl:template match="db:tgroup">
  <xsl:if test="not(@cols) or @cols = ''">
    <xsl:message terminate="yes">
      <xsl:text>Error: CALS tables must specify the number of columns.</xsl:text>
    </xsl:message>
  </xsl:if>

  <!-- We used to do a two-phase process here, phase1 is now part of
       normalization. Otherwise xref's in the table were in the "wrong tree"
       when we came to processing the entries -->

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

    <!-- FIXME: handle frame -->
    <!-- FIXME: handle table width -->

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

<!-- ============================================================ -->

<doc:mode name="m:cals" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing normalized CALS tables</refpurpose>

<refdescription>
<para>This mode is used to format normalized CALS tables.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:thead" mode="m:cals">
  <fo:table-header>
    <xsl:apply-templates mode="m:cals"/>
  </fo:table-header>
</xsl:template>

<xsl:template match="db:tbody" mode="m:cals">
  <fo:table-body>
    <xsl:apply-templates mode="m:cals"/>
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
  <fo:table-row>
    <xsl:apply-templates mode="m:cals"/>
  </fo:table-row>
</xsl:template>

<xsl:template match="db:entry" mode="m:cals">
  <xsl:variable name="empty.cell" select="not(node())"/>

  <fo:table-cell>
    <!-- FIXME: handle @revisionflag -->
    <xsl:if test="@ghost:morerows &gt; 0">
      <xsl:attribute name="number-rows-spanned" select="@ghost:morerows + 1"/>
    </xsl:if>

    <xsl:if test="@ghost:width &gt; 1">
      <xsl:attribute name="number-columns-spanned" select="@ghost:width"/>
    </xsl:if>

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
  <table-cell/>
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

<xsl:template match="db:table|db:caption|db:col|db:colgroup
                     |db:thead|db:tfoot|db:tbody|db:tr
		     |db:th|db:td" mode="m:html">
  <xsl:message terminate="yes">HTML tables not supported yet.</xsl:message>
</xsl:template>

<xsl:template match="db:informaltable" mode="m:html">
  <xsl:message terminate="yes">HTML tables not supported yet.</xsl:message>
</xsl:template>

</xsl:stylesheet>
