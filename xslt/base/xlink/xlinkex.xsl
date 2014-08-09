<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://example.com/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="2.0">

<xsl:namespace-alias stylesheet-prefix="t" result-prefix="xsl"/>

<xsl:output method="xml" indent="no"/>

<xsl:template match="/">
  <t:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns="http://docbook.org/ns/docbook"
                xmlns:xlink="http://www.w3.org/1999/xlink"
		exclude-result-prefixes="xs db"
                version="2.0">

    <t:output method="xml" indent="no"/>

    <t:key name="genid" match="*" use="generate-id(.)"/>

    <t:variable name="nodes" as="node()*">
      <xsl:apply-templates select="//*[@xlink:type='extended']" mode="nodes"/>
    </t:variable>

    <t:template match="element()">
      <t:variable name="id" select="generate-id(.)"/>
      <t:variable name="targets" as="element()*">
        <t:apply-templates select="key('genid', $nodes[@id = $id]/@locator)" mode="locators"/>
      </t:variable>
      <t:choose>
        <t:when test="empty($targets)">
          <t:copy>
            <t:apply-templates select="@*,node()"/>
          </t:copy>
        </t:when>
        <t:when test="count($targets) = 1">
          <t:copy>
            <t:apply-templates select="$targets/@xlink:href,@*,node()"/>
          </t:copy>
        </t:when>
        <t:otherwise>
          <t:copy>
            <t:attribute name="xlink:type" select="'extended'"/>
            <t:apply-templates select="@*"/>
            <t:for-each select="$targets">
              <link>
                <t:copy-of select="@*"/>
              </link>
            </t:for-each>
            <phrase xlink:type="resource" xlink:label="xlink-source-{generate-id(.)}">
              <t:apply-templates select="node()"/>
            </phrase>
            <link xlink:type="arc" xlink:from="xlink-source-{generate-id(.)}"
                  xlink:to="{{$targets[1]/@xlink:label}}"/>
          </t:copy>
        </t:otherwise>
      </t:choose>
    </t:template>

    <t:template match="attribute()|text()|comment()|processing-instruction()">
      <t:copy/>
    </t:template>

    <t:template match="*" mode="locators">
      <t:variable name="extended" as="element()">
        <t:copy-of select="ancestor::*[@xlink:type='extended']"/>
      </t:variable>
      <t:variable name="from" select="@xlink:label"/>
      <t:variable name="ends" as="element()*">
        <t:for-each select="$extended/*[@xlink:type='arc' and @xlink:from = $from]">
          <t:variable name="to" select="@xlink:to"/>
          <t:sequence select="$extended/*[@xlink:type='locator'
                                          and @xlink:href and @xlink:label = $to]"/>
        </t:for-each>
      </t:variable>
      <t:choose>
        <t:when test="$ends">
          <t:sequence select="$ends"/>
        </t:when>
        <t:otherwise>
          <t:for-each select="$extended/*[@xlink:type='arc' and @xlink:from = $from]">
            <t:variable name="to" select="@xlink:to"/>
            <t:if test="$extended/*[@xlink:type='resource'
                                    and @xlink:label=$to and @xml:id]">
              <x xlink:href="#{{($extended/*[@xlink:type='resource' and @xlink:label=$to])[1]/@xml:id}}"/>
            </t:if>
          </t:for-each>
        </t:otherwise>
      </t:choose>
    </t:template>

  </t:stylesheet>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="*" mode="nodes">
  <xsl:for-each select="*[@xlink:type='arc' and @xlink:from]">
    <xsl:variable name="label" select="@xlink:from"/>
    <xsl:variable name="to" select="@xlink:to"/>
    <xsl:variable name="locator" select="../*[@xlink:label = $label]"/>
    <xsl:apply-templates select="$locator[@xlink:href]" mode="nodeloc">
      <xsl:with-param name="to" select="$to"/>
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="*" mode="nodeloc"/>

<xsl:template match="*[starts-with(@xlink:href,'#')]" mode="nodeloc">
  <xsl:variable name="id" select="substring-after(@xlink:href,'#')"/>
  <t:for-each select="id('{$id}')">
    <node locator="{generate-id(.)}" id="{{generate-id(.)}}"/>
  </t:for-each>
</xsl:template>

<xsl:template match="*[matches(@xlink:href, 'xpath\s*\(')]" mode="nodeloc">
  <!-- FIXME: This does not handle namespace() schemes -->
  <!-- FIXME: This does not handle spaces before the ( -->
  <!-- FIXME: This does not handle multiple schemes -->
  <xsl:variable name="path" select="substring-before(substring-after(@xlink:href,'('),')')"/>
  <t:for-each select="{$path}">
    <node locator="{generate-id(.)}" id="{{generate-id(.)}}"/>
  </t:for-each>
</xsl:template>

</xsl:stylesheet>
