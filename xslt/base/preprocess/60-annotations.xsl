<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:db="http://docbook.org/ns/docbook"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		exclude-result-prefixes="xs db"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:key name="id" match="*" use="@xml:id"/>
<xsl:key name="genid" match="*" use="generate-id(.)"/>
<xsl:key name="annot" match="db:annotation" use="generate-id(.)"/>

<xsl:template match="*[@xml:id] | *[@annotations]">
  <xsl:variable name="points-to-me"
                select="//db:annotation[tokenize(@annotates, '\s+')
                                        = current()/@xml:id]"/>
  <xsl:variable name="i-point-to"
                select="//db:annotation[@xml:id
                                  = tokenize(current()/@annotations, '\s+')]"/>

  <xsl:variable name="annotations" select="($points-to-me union $i-point-to)"/>

  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
    <xsl:for-each select="$annotations">
      <xsl:variable name="unique-id" as="element()"><doc/></xsl:variable>
      <ghost:annotation xml:id="{generate-id($unique-id)}">
        <xsl:copy-of select="node()"/>
      </ghost:annotation>
    </xsl:for-each>
  </xsl:copy>
</xsl:template>

<xsl:template match="db:annotation"/>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
