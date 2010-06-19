<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		exclude-result-prefixes="doc f m mp fn db ghost t"
                version="2.0">

<xsl:include href="../common/verbatim.xsl"/>

<xsl:param name="shade.verbatim" select="0"/>
<xsl:param name="monospace.font.family">monospace</xsl:param>

<xsl:attribute-set name="verbatim.properties">
  <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
  <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
  <xsl:attribute name="white-space-collapse">false</xsl:attribute>
  <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
  <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
  <xsl:attribute name="text-align">start</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="monospace.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$monospace.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="monospace.verbatim.properties" use-attribute-sets="verbatim.properties monospace.properties">
  <xsl:attribute name="text-align">start</xsl:attribute>
  <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="shade.verbatim.style">
  <xsl:attribute name="background-color">#E0E0E0</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="db:programlistingco">
  <!-- FIXME: this doesn't do anything to process the areas!? -->
  <xsl:apply-templates select="db:programlisting" mode="m:verbatim"/>
  <xsl:apply-templates select="db:calloutlist"/>
</xsl:template>

<xsl:template
    match="db:programlisting|db:address|db:screen|db:synopsis|db:literallayout">
  <xsl:apply-templates select="." mode="m:verbatim"/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:verbatim" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing normalized verbatim elements</refpurpose>

<refdescription>
<para>This mode is used to format normalized verbatim elements.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:programlisting|db:screen|db:synopsis
		     |db:literallayout[@class='monospaced']"
	      mode="m:verbatim">
  <xsl:param name="suppress-numbers" select="'0'"/>
  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:choose>
    <xsl:when test="$shade.verbatim != 0">
      <fo:block id="{$id}"
		xsl:use-attribute-sets="monospace.verbatim.properties
					shade.verbatim.style">
	<xsl:apply-templates mode="m:verbatim"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                xsl:use-attribute-sets="monospace.verbatim.properties">
	<xsl:apply-templates mode="m:verbatim"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:literallayout|db:address"
	      mode="m:verbatim">
  <xsl:param name="suppress-numbers" select="'0'"/>
  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:choose>
    <xsl:when test="$shade.verbatim != 0">
      <fo:block id="{$id}"
		xsl:use-attribute-sets="verbatim.properties
					shade.verbatim.style">
	<xsl:apply-templates mode="m:verbatim"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                xsl:use-attribute-sets="verbatim.properties">
	<xsl:apply-templates mode="m:verbatim"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
<xsl:template match="ghost:co">
  <xsl:if test="@xml:id">
    <a name="{@xml:id}"/>
  </xsl:if>
  <xsl:call-template name="t:callout-bug">
    <xsl:with-param name="conum">
      <xsl:choose>
	<xsl:when test="@number">
	  <xsl:value-of select="@number"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:number count="ghost:co"
		      level="any"
		      from="db:programlisting|db:screen|db:literallayout|db:synopsis"
		      format="1"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>
-->

<xsl:template match="ghost:linenumber">
  <span class="linenumber">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="ghost:linenumber-separator">
  <xsl:variable name="content" as="node()*">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:if test="not(empty($content))">
    <span class="linenumber-separator">
      <xsl:apply-templates/>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="mp:literallayout">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="comment()|processing-instruction()"
	      mode="mp:literallayout">
  <xsl:copy/>
</xsl:template>

<xsl:template match="text()" mode="mp:literallayout">
  <xsl:analyze-string select="." regex="&#10;">
    <xsl:matching-substring>
      <br/>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:analyze-string select="." regex="[\s]">
	<xsl:matching-substring>
	  <xsl:text>&#160;</xsl:text>
	</xsl:matching-substring>
	<xsl:non-matching-substring>
	  <xsl:copy/>
	</xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:template>

</xsl:stylesheet>
