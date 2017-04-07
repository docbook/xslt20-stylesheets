<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="db f fn m t xlink xs" version="2.0" xmlns:db="http://docbook.org/ns/docbook" xmlns:f="http://docbook.org/xslt/ns/extension" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:ghost="http://docbook.org/ns/docbook/ephemeral" xmlns:m="http://docbook.org/xslt/ns/mode" xmlns:t="http://docbook.org/xslt/ns/template" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="db:co" mode="m:verbatim m:callout-bug">
    <!-- pass addId=false() when processing callout links -->
    <xsl:param name="addId" select="true()"/>
    <xsl:call-template name="t:callout-bug">
      <xsl:with-param name="db:conum">
        <xsl:number count="db:co" format="1" from="db:programlisting | db:screen | db:literallayout | db:synopsis" level="any"/>
      </xsl:with-param>
      <xsl:with-param name="id">
        <xsl:if test="$addId">
          <xsl:value-of select="@xml:id"/>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="db:calloutlist">
    <fo:block text-align="{$alignment}">
      <xsl:if test="db:title | db:info/db:title">
        <xsl:apply-templates mode="list.title.mode" select="(db:title | db:info/db:title)[1]"/>
      </xsl:if>
      <fo:list-block xsl:use-attribute-sets="calloutlist.properties">
        <xsl:apply-templates select="db:callout"/>
      </fo:list-block>
    </fo:block>
  </xsl:template>

  <xsl:template match="db:callout">
    <fo:list-item xsl:use-attribute-sets="callout.properties">
      <fo:list-item-label end-indent="label-end()">
        <fo:block>
          <xsl:call-template name="callout.arearefs">
            <xsl:with-param name="arearefs" select="@arearefs"/>
          </xsl:call-template>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="db:areaset" mode="conumber">
    <xsl:number count="db:area | db:areaset" format="1"/>
  </xsl:template>

  <xsl:template match="db:area" mode="conumber">
    <xsl:number count="db:area | db:areaset" format="1"/>
  </xsl:template>

  <xsl:template name="t:callout-bug">
    <xsl:param name="db:conum" select="1"/>
    <xsl:param name="id"/>
    <xsl:choose>
      <!-- Draw callouts as images -->
      <xsl:when test="$callout.graphics != 0 and number($db:conum) le number($callout.graphics.number.limit)">
        <xsl:variable name="filename" select="concat($callout.graphics.path, $db:conum, $callout.graphics.extension)"/>
        <fo:external-graphic alignment-adjust="middle" alignment-baseline="central" content-width="{$callout.icon.size}" display-align="center" width="{$callout.icon.size}">
          <xsl:attribute name="src">
            <xsl:text>url(</xsl:text>
            <xsl:value-of select="$filename"/>
            <xsl:text>)</xsl:text>
          </xsl:attribute>
          <xsl:if test="$id != ''">
            <xsl:attribute name="id" select="$id"/>
          </xsl:if>
        </fo:external-graphic>
      </xsl:when>
      <xsl:when test="$callout.unicode != 0 and number($db:conum) le number($callout.unicode.number.limit)">
        <xsl:variable name="comarkup">
          <xsl:choose>
            <xsl:when test="$callout.unicode.start.character = 10102">
              <xsl:choose>
                <xsl:when test="$db:conum = 1">&#10102;</xsl:when>
                <xsl:when test="$db:conum = 2">&#10103;</xsl:when>
                <xsl:when test="$db:conum = 3">&#10104;</xsl:when>
                <xsl:when test="$db:conum = 4">&#10105;</xsl:when>
                <xsl:when test="$db:conum = 5">&#10106;</xsl:when>
                <xsl:when test="$db:conum = 6">&#10107;</xsl:when>
                <xsl:when test="$db:conum = 7">&#10108;</xsl:when>
                <xsl:when test="$db:conum = 8">&#10109;</xsl:when>
                <xsl:when test="$db:conum = 9">&#10110;</xsl:when>
                <xsl:when test="$db:conum = 10">&#10111;</xsl:when>
                <xsl:when test="$db:conum = 11">&#9451;</xsl:when>
                <xsl:when test="$db:conum = 12">&#9452;</xsl:when>
                <xsl:when test="$db:conum = 13">&#9453;</xsl:when>
                <xsl:when test="$db:conum = 14">&#9454;</xsl:when>
                <xsl:when test="$db:conum = 15">&#9455;</xsl:when>
                <xsl:when test="$db:conum = 16">&#9456;</xsl:when>
                <xsl:when test="$db:conum = 17">&#9457;</xsl:when>
                <xsl:when test="$db:conum = 18">&#9458;</xsl:when>
                <xsl:when test="$db:conum = 19">&#9459;</xsl:when>
                <xsl:when test="$db:conum = 20">&#9460;</xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="$callout.unicode.start.character = 9312">
              <xsl:choose>
                <xsl:when test="$db:conum = 1">&#9312;</xsl:when>
                <xsl:when test="$db:conum = 2">&#9313;</xsl:when>
                <xsl:when test="$db:conum = 3">&#9314;</xsl:when>
                <xsl:when test="$db:conum = 4">&#9315;</xsl:when>
                <xsl:when test="$db:conum = 5">&#9316;</xsl:when>
                <xsl:when test="$db:conum = 6">&#9317;</xsl:when>
                <xsl:when test="$db:conum = 7">&#9318;</xsl:when>
                <xsl:when test="$db:conum = 8">&#9319;</xsl:when>
                <xsl:when test="$db:conum = 9">&#9320;</xsl:when>
                <xsl:when test="$db:conum = 10">&#9321;</xsl:when>
                <xsl:when test="$db:conum = 11">&#9322;</xsl:when>
                <xsl:when test="$db:conum = 12">&#9323;</xsl:when>
                <xsl:when test="$db:conum = 13">&#9324;</xsl:when>
                <xsl:when test="$db:conum = 14">&#9325;</xsl:when>
                <xsl:when test="$db:conum = 15">&#9326;</xsl:when>
                <xsl:when test="$db:conum = 16">&#9327;</xsl:when>
                <xsl:when test="$db:conum = 17">&#9328;</xsl:when>
                <xsl:when test="$db:conum = 18">&#9329;</xsl:when>
                <xsl:when test="$db:conum = 19">&#9330;</xsl:when>
                <xsl:when test="$db:conum = 20">&#9331;</xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>
                <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
                <xsl:text>when $callout.unicode.start.character is </xsl:text>
                <xsl:value-of select="$callout.unicode.start.character"/>
              </xsl:message>
              <fo:inline background-color="#404040" baseline-shift="0.1em" color="white" font-family="{$body.fontset}" font-size="75%" font-weight="bold" padding-bottom="0.1em" padding-end="0.2em" padding-start="0.2em" padding-top="0.1em">
                <xsl:if test="$id != ''">
                  <xsl:attribute name="id" select="$id"/>
                </xsl:if>
                <xsl:value-of select="$db:conum"/>
              </fo:inline>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$callout.unicode.font != ''">
            <fo:inline font-family="{$callout.unicode.font}">
              <xsl:if test="$id != ''">
                <xsl:attribute name="id" select="$id"/>
              </xsl:if>
              <xsl:copy-of select="$comarkup"/>
            </fo:inline>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$comarkup"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- Most safe: draw a dark gray square with a white number inside -->
      <xsl:otherwise>
        <fo:inline background-color="#404040" baseline-shift="0.1em" color="white" font-family="{$body.fontset}" font-size="75%" font-weight="bold" padding-bottom="0.1em" padding-end="0.2em" padding-start="0.2em" padding-top="0.1em">
          <xsl:if test="$id != ''">
            <xsl:attribute name="id" select="$id"/>
          </xsl:if>
          <xsl:value-of select="$db:conum"/>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- recurse through rearefs -->
  <xsl:template name="callout.arearefs">
    <xsl:param name="arearefs"/>
    <xsl:if test="$arearefs != ''">
      <xsl:choose>
        <xsl:when test="substring-before($arearefs, ' ') = ''">
          <xsl:call-template name="callout.arearef">
            <xsl:with-param name="arearef" select="$arearefs"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="callout.arearef">
            <xsl:with-param name="arearef" select="substring-before($arearefs, ' ')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="callout.arearefs">
        <xsl:with-param name="arearefs" select="substring-after($arearefs, ' ')"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="callout.arearef">
    <xsl:param name="arearef"/>
    <xsl:variable name="targets" select="key('id', $arearef)"/>
    <xsl:variable name="target" select="$targets[1]"/>

    <xsl:choose>
      <xsl:when test="count($target) = 0">
        <xsl:value-of select="$arearef"/>
        <xsl:text>: ???</xsl:text>
      </xsl:when>
      <xsl:when test="local-name($target) = 'co'">
        <fo:basic-link internal-destination="{$arearef}">
          <xsl:apply-templates mode="m:callout-bug" select="$target">
            <xsl:with-param name="addId" select="false()"/>
          </xsl:apply-templates>
        </fo:basic-link>
      </xsl:when>
      <xsl:when test="local-name($target) = 'areaset'">
        <xsl:call-template name="t:callout-bug">
          <xsl:with-param name="db:conum">
            <xsl:apply-templates mode="conumber" select="$target"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="local-name($target) = 'area'">
        <xsl:choose>
          <xsl:when test="$target/parent::db:areaset">
            <xsl:call-template name="t:callout-bug">
              <xsl:with-param name="db:conum">
                <xsl:apply-templates mode="conumber" select="$target/parent::db:areaset"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="t:callout-bug">
              <xsl:with-param name="db:conum">
                <xsl:apply-templates mode="conumber" select="$target"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>???</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
