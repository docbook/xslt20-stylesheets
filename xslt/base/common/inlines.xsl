<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f fn m t xlink xs"
                version="2.0">

<!-- ********************************************************************
     $Id: inlines.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- some special cases -->

<xsl:template match="db:alt">
  <!-- nop -->
</xsl:template>

<xsl:template match="db:annotation">
  <!-- nop -->
</xsl:template>

<xsl:template match="db:person">
  <xsl:apply-templates select="db:personname"/>
</xsl:template>

<xsl:template match="db:personname">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="t:person-name"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:author">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="t:person-name"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:editor">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="t:person-name"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:othercredit">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="t:person-name"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:authorinitials">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:authorgroup">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="t:person-name-list"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:accel">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:action">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:application">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:biblioid">
  <xsl:choose>
    <!-- hack? -->
    <xsl:when test="string(.) = '' and @class = 'uri' and @xlink:href">
      <xsl:call-template name="t:inline-charseq">
	<!-- if you pass the attribute, it gets copied...as an attribute! -->
	<xsl:with-param name="content" select="string(@xlink:href)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="string(.) = ''">
      <xsl:message>Warning: empty biblioid.</xsl:message>
      <xsl:call-template name="t:inline-charseq"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="t:inline-charseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:citebiblioid">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="class"
                    select="if (@class) then concat(local-name(.),'-',@class) else ()"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:classname">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:exceptionname">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:initializer">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:interfacename">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:methodname">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:command">
  <xsl:call-template name="t:inline-boldseq"/>
</xsl:template>

<xsl:template match="db:computeroutput">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:constant">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:database">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:errorcode">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:errorname">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:errortype">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:errortext">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:envar">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:filename">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:function">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:function/db:parameter" priority="2">
  <xsl:call-template name="t:inline-italicmonoseq"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:function/db:replaceable" priority="2">
  <xsl:call-template name="t:inline-italicmonoseq"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:guibutton">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:guiicon">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:guilabel">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:guimenu">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:guimenuitem">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:guisubmenu">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:hardware">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:interface">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:interfacedefinition">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:jobtitle">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:keycap">
  <xsl:variable name="node">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="t:inline-boldseq">
    <xsl:with-param name="content">
      <xsl:choose>
        <xsl:when test="string(normalize-space($node)) = ''
                        and @function='other' and @otherfunction != ''">
          <xsl:value-of select="@otherfunction"/>
        </xsl:when>
        <xsl:when test="string(normalize-space($node))= '' and @function">
          <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'keycap'"/>
          <xsl:with-param name="name" select="@function"/>
        </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$node"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:keycode">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:keysym">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:literal">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:code">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:medialabel">
  <xsl:call-template name="t:inline-italicseq"/>
</xsl:template>

<xsl:template match="db:modifier">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:shortcut">
  <xsl:call-template name="t:inline-boldseq"/>
</xsl:template>

<xsl:template match="db:mousebutton">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:option">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:package">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:pagenums">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:parameter">
  <xsl:call-template name="t:inline-italicmonoseq">
    <xsl:with-param name="class" select="@class"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:property">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:prompt">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:date|db:pubdate">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:choose>
	<xsl:when test=". castable as xs:dateTime">
	  <xsl:value-of select="format-dateTime(xs:dateTime(.),
				                $dateTime-format,
						f:l10n-language(.), (), ())"/>
	</xsl:when>
	<xsl:when test=". castable as xs:date">
	  <xsl:value-of select="format-date(xs:date(.), $date-format, f:l10n-language(.), (), ())"/>
	</xsl:when>
	<xsl:when test=". castable as xs:gYearMonth">
	  <xsl:value-of select="format-date(xs:date(concat(.,'-01')),
				            $gYearMonth-format,
					    f:l10n-language(.), (), ())"/>
	</xsl:when>
	<xsl:when test=". castable as xs:gYear">
	  <xsl:value-of select="format-date(xs:date(concat(.,'-01-01')),
				            $gYear-format,
					    f:l10n-language(.), (), ())"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:publisher">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:publishername">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:replaceable" priority="1">
  <xsl:call-template name="t:inline-italicmonoseq"/>
</xsl:template>

<xsl:template match="db:returnvalue">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:revnumber">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:revremark">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:structfield">
  <xsl:call-template name="t:inline-italicmonoseq"/>
</xsl:template>

<xsl:template match="db:structname">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:symbol">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:token">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:type">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:userinput">
  <xsl:call-template name="t:inline-boldmonoseq"/>
</xsl:template>

<xsl:template match="db:abbrev">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:acronym">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:citerefentry">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:citetitle">
  <xsl:choose>
    <xsl:when test="@pubwork = 'article'">
      <xsl:call-template name="gentext-startquote"/>
      <xsl:call-template name="t:inline-charseq"/>
      <xsl:call-template name="gentext-endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="t:inline-italicseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:edition">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:markup">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:quote">
  <xsl:variable name="depth" select="count(ancestor::db:quote)"/>
  <xsl:choose>
    <xsl:when test="$depth mod 2 = 0">
      <xsl:call-template name="gentext-startquote"/>
      <xsl:call-template name="t:inline-charseq"/>
      <xsl:call-template name="gentext-endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-nestedstartquote"/>
      <xsl:call-template name="t:inline-charseq"/>
      <xsl:call-template name="gentext-nestedendquote"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:releaseinfo">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:varname">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:wordasword">
  <xsl:call-template name="t:inline-italicseq"/>
</xsl:template>

<xsl:template match="db:superscript">
  <xsl:call-template name="t:inline-superscriptseq"/>
</xsl:template>

<xsl:template match="db:subscript">
  <xsl:call-template name="t:inline-subscriptseq"/>
</xsl:template>

<xsl:template match="db:tag">
  <xsl:choose>
    <!-- It's not legal for them to nest, but reformatting a verbatim environment
         sometimes causes it to happen, so suppress any extra markup. -->
    <xsl:when test="parent::db:tag">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="format-tag"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:keycombo">
  <xsl:variable name="action" select="@action"/>
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="$action='seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="$action='simul'">+</xsl:when>
      <xsl:when test="$action='press'">-</xsl:when>
      <xsl:when test="$action='click'">-</xsl:when>
      <xsl:when test="$action='double-click'">-</xsl:when>
      <xsl:when test="$action='other'"></xsl:when>
      <xsl:otherwise>-</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="*">
    <xsl:if test="position()>1">
      <xsl:value-of select="$joinchar"/>
    </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="db:uri">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="db:citation">
  <!-- todo: biblio-citation-check -->
  <xsl:text>[</xsl:text>
  <xsl:call-template name="t:inline-charseq"/>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="db:productnumber">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:pob|db:street|db:city|db:state
		     |db:postcode|db:country|db:otheraddr">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:phone|db:fax">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<!-- in Addresses, for example -->
<xsl:template match="db:honorific|db:firstname|db:givenname|db:surname
		     |db:lineage|db:othername">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

</xsl:stylesheet>
