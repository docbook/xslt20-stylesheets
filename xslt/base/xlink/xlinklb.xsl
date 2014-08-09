<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="2.0">

<xsl:output method="xml" indent="no"/>

<xsl:variable name="lb" select="'http://www.w3.org/1999/xlink/properties/linkbase'"/>

<xsl:template match="db:info/db:extendedlink[db:link[@xlink:type='arc'
                                                     and @xlink:arcrole=$lb]]">
  <xsl:apply-templates select="db:link[@xlink:type='arc' and @xlink:arcrole=$lb
                                       and @xlink:actuate='onLoad'
                                       and @xlink:from and @xlink:to]"
                       mode="load-linkbase"/>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="db:link" mode="load-linkbase">
  <xsl:variable name="from" select="@xlink:from"/>
  <xsl:variable name="to" select="@xlink:to"/>

  <xsl:variable name="lfrom" select="(../*[@xlink:type='locator' and @xlink:label=$from])[1]"/>
  <xsl:variable name="lto" select="(../*[@xlink:type='locator' and @xlink:label=$to])[1]"/>

  <xsl:if test="$lfrom and $lto and $lfrom/@xlink:href=''">
    <xsl:sequence select="doc(resolve-uri($lto/@xlink:href, base-uri($lto)))/*/*[@xlink:type='extended']"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
