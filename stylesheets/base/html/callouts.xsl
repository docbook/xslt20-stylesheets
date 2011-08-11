<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f ghost h m t u xlink xs"
                version="2.0">

<!-- ********************************************************************
     $Id: callouts.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sourceforge.net/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ============================================================ -->

<xsl:template match="db:co">
  <!-- Support a single linkend in HTML -->
  <xsl:variable name="targets" select="key('id', @linkends)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:choose>
    <xsl:when test="$target">
      <a href="{f:href(/,$target)}">
        <xsl:apply-templates select="." mode="m:html-attributes"/>
        <xsl:apply-templates select="." mode="m:callout-bug"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates select="." mode="m:callout-bug"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:coref">
  <!-- tricky; this relies on the fact that we can process the "co" that's -->
  <!-- "over there" as if it were "right here" -->
  <xsl:variable name="co" select="key('id', @linkend)"/>
  <xsl:choose>
    <xsl:when test="not($co)">
      <xsl:message>
        <xsl:text>Error: coref link is broken: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
    </xsl:when>
    <xsl:when test="local-name($co) != 'co'">
      <xsl:message>
        <xsl:text>Error: coref doesn't point to a co: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$co"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:co" mode="m:callout-bug">
  <!--
  <xsl:message>
    <xsl:text>CO: </xsl:text>
    <xsl:value-of select="count(ancestor::db:programlisting)"/>
    <xsl:value-of select="count(ancestor::db:screen)"/>
    <xsl:value-of select="count(ancestor::db:synopsis)"/>
    <xsl:value-of select="count(ancestor::db:literallayout)"/>
    <xsl:value-of select="count(ancestor::db:address)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@xml:id"/>
    <xsl:text> </xsl:text>
    <xsl:number count="db:co"
		level="single"
		format="1"/>
    <xsl:text>, </xsl:text>
    <xsl:number count="db:co"
		level="any"
		from="db:programlisting|db:screen|db:synopsis
		      |db:literallayout|db:address"
		format="1"/>
  </xsl:message>
  -->

  <xsl:call-template name="t:callout-bug">
    <xsl:with-param name="conum">
      <xsl:number count="db:co"
                  level="any"
                  format="1"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:callout-bug">
  <xsl:param name="conum" select='1'/>

  <xsl:variable name="iconum"
                select="if ($conum castable as xs:decimal)
                        then xs:decimal($conum) else 1"/>

  <xsl:choose>
    <xsl:when test="$callout.graphics != 0
                    and $iconum &lt;= number($callout.graphics.number.limit)">
      <img src="{$callout.graphics.path}{$iconum}{$callout.graphics.extension}"
           alt="{$iconum}" border="0"/>
    </xsl:when>
    <xsl:when test="$callout.unicode != 0
                    and $iconum &lt;= $callout.unicode.number.limit">
      <xsl:choose>
        <xsl:when test="$callout.unicode.start.character = 10102">
          <xsl:choose>
            <xsl:when test="$iconum = 1">&#10102;</xsl:when>
            <xsl:when test="$iconum = 2">&#10103;</xsl:when>
            <xsl:when test="$iconum = 3">&#10104;</xsl:when>
            <xsl:when test="$iconum = 4">&#10105;</xsl:when>
            <xsl:when test="$iconum = 5">&#10106;</xsl:when>
            <xsl:when test="$iconum = 6">&#10107;</xsl:when>
            <xsl:when test="$iconum = 7">&#10108;</xsl:when>
            <xsl:when test="$iconum = 8">&#10109;</xsl:when>
            <xsl:when test="$iconum = 9">&#10110;</xsl:when>
            <xsl:when test="$iconum = 10">&#10111;</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
            <xsl:text>when $callout.unicode.start.character is </xsl:text>
            <xsl:value-of select="$callout.unicode.start.character"/>
          </xsl:message>
          <xsl:text>(</xsl:text>
          <xsl:value-of select="$iconum"/>
          <xsl:text>)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$iconum"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:calloutlist">
  <xsl:variable name="titlepage"
		select="$titlepages/*[node-name(.)
			              = node-name(current())][1]"/>

  <div>
    <xsl:apply-templates select="." mode="m:html-attributes"/>

    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$titlepage"/>
    </xsl:call-template>

    <xsl:apply-templates select="*[not(self::db:info)
				   and not(self::db:callout)]"/>

    <!-- If you can get CSS to do this layout right, pleaes tell me how -->
    <table border="0" summary="Callout list">
      <xsl:apply-templates select="db:callout"/>
    </table>
  </div>
</xsl:template>

<xsl:template match="db:callout">
  <xsl:variable name="doc" select="/"/>

  <tr class="callout-row">
    <td class="callout-bug" valign="baseline" align="left">
      <p>
        <xsl:apply-templates select="." mode="m:html-attributes"/>

	<xsl:for-each select="tokenize(@arearefs,'\s')">
	  <xsl:variable name="target" select="key('id',.,$doc)[1]"/>

	  <xsl:choose>
	    <xsl:when test="count($target)=0">
	      <xsl:message>
		<xsl:text>Error? callout points to non-existent id: </xsl:text>
		<xsl:value-of select="."/>
	      </xsl:message>
	      <xsl:text>???</xsl:text>
	    </xsl:when>
	    <xsl:when test="$target/self::db:co">
	      <a href="{f:href($doc,$target)}">
		<xsl:apply-templates select="$target" mode="m:callout-bug"/>
	      </a>
	      <xsl:text>&#160;</xsl:text>
	    </xsl:when>
	    <xsl:when test="$target/self::db:areaset">
	      <xsl:call-template name="t:callout-bug">
		<xsl:with-param name="conum"
				select="count($target/preceding-sibling::db:areaset
					|$target/preceding-sibling::db:area)
					+1"/>
	      </xsl:call-template>
	    </xsl:when>
	    <xsl:when test="$target/self::db:area">
	      <xsl:choose>
		<xsl:when test="$target/parent::db:areaset">
		  <xsl:call-template name="t:callout-bug">
		    <xsl:with-param name="conum"
				    select="count($target/parent::db:areaset/preceding-sibling::db:areaset
					    |$target/parent::db:areaset/preceding-sibling::db:area)
					    +1"/>
		  </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:call-template name="t:callout-bug">
		    <xsl:with-param name="conum"
				    select="count($target/preceding-sibling::db:areaset
					    |$target/preceding-sibling::db:area)
					    +1"/>
		  </xsl:call-template>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:message>
		<xsl:text>Error? callout points to </xsl:text>
		<xsl:value-of select="name($target)"/>
	      </xsl:message>
	      <xsl:text>???</xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
	<xsl:text>&#160;</xsl:text>
      </p>
    </td>
    <td class="callout-body" valign="baseline" align="left">
      <xsl:apply-templates/>
    </td>
  </tr>
</xsl:template>

</xsl:stylesheet>
