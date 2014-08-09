<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">

<xsl:output method="text" encoding="utf-8"/>

<xsl:variable name="lang" select="substring-before(substring-after(base-uri(/),'gentext/build/'),'.xml')"/>

<xsl:template match="/">
  <xsl:text>xquery version "1.0-ml";

import module namespace plugin="http://marklogic.com/extension/plugin"
       at "/MarkLogic/plugin/plugin.xqy";

declare namespace dbl10n="http://docbook.org/localization";
declare namespace l="http://docbook.sourceforge.net/xmlns/l10n/1.0";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

(:~ Map of capabilities implemented by this Plugin.
:
: Required capabilities for all Transformers
: - http://docbook.org/localization
:)

declare function dbl10n:capabilities()
as map:map
{
    let $map := map:map()
</xsl:text>

<xsl:value-of select="concat('    let $_   := map:put($map, &quot;http://docbook.org/localization/',
                             $lang, '&quot;, xdmp:function(xs:QName(&quot;dbl10n:', $lang, '&quot;)))')"/>
<xsl:text>
    return $map
};

</xsl:text>

<xsl:value-of select="concat('declare function dbl10n:', $lang, '()')"/>

<xsl:text>
as element(l:l10n)
{
  let $l10n := document {
</xsl:text>

<xsl:apply-templates select="/*" mode="copy"/>

<xsl:text>
}
return
  $l10n/l:l10n
};

(:~ ----------------Main, for registration---------------- :)

</xsl:text>

<xsl:value-of select="concat('( xdmp:log(&quot;Register docbook/', $lang, '.xqy&quot;),&#10;')"/>
<xsl:value-of select="concat(' plugin:register(dbl10n:capabilities(),&quot;', $lang, '.xqy&quot;))&#10;')"/>

</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="copy">
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="node-name(.)"/>

  <xsl:if test="empty(parent::*)">
    <xsl:for-each select="namespace::*[local-name(.) != 'xml']">
      <xsl:text> xmlns:</xsl:text>
      <xsl:value-of select="local-name(.)"/>
      <xsl:text>="</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>"</xsl:text>
    </xsl:for-each>
  </xsl:if>

  <xsl:for-each select="@*">
    <xsl:text> </xsl:text>
    <xsl:value-of select="node-name(.)"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="l:escape(.)"/>
    <xsl:text>"</xsl:text>
  </xsl:for-each>

  <xsl:choose>
    <xsl:when test="node()">
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates mode="copy"/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="node-name(.)"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>/&gt;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()" mode="copy">
  <xsl:text>&lt;!-- </xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>--&gt;</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="copy">
  <xsl:value-of select="l:escape(.)"/>
</xsl:template>

<xsl:function name="l:escape" as="xs:string">
  <xsl:param name="str" as="xs:string"/>

  <xsl:variable name="r1" select="replace($str, '&amp;', '&amp;amp;')"/>
  <xsl:variable name="r2" select="replace($r1, '&lt;', '&amp;lt;')"/>
  <xsl:variable name="r3" select="replace($r2, '&gt;', '&amp;gt;')"/>
  <xsl:variable name="r4" select="replace($r3, '&quot;', '&amp;quot;')"/>
  <xsl:variable name="r5" select="replace($r4, '''', '&amp;apos;')"/>

  <xsl:value-of select="$r5"/>
</xsl:function>

</xsl:stylesheet>
