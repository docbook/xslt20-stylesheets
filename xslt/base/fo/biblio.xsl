<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f m t xs"
                version='2.0'>

<!-- ********************************************************************
     $Id: biblio.xsl 7467 2007-09-27 16:10:31Z bobstayton $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="db:bibliography">
  <xsl:choose>
    <xsl:when test="not(parent::*) or parent::db:part or parent::db:book">
      <xsl:variable name="master-reference" select="f:select-pagemaster(.)"/>

      <fo:page-sequence hyphenate="{$hyphenate}"
                        master-reference="{$master-reference}">
	<xsl:call-template name="t:page-sequence-attributes"/>

	<xsl:apply-templates select="." mode="m:running-head-mode">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:apply-templates>

        <xsl:apply-templates select="." mode="m:running-foot-mode">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:apply-templates>

        <fo:flow flow-name="xsl-region-body">
          <xsl:call-template name="t:set-flow-properties">
            <xsl:with-param name="element" select="local-name(.)"/>
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>

	  <fo:block>
	    <xsl:call-template name="t:id"/>
	    <xsl:apply-templates select="db:info" mode="t:titlepage-mode"/>
          </fo:block>

          <xsl:apply-templates/>
        </fo:flow>
      </fo:page-sequence>
    </xsl:when>
    <xsl:otherwise>
      <fo:block space-before.minimum="1em"
                space-before.optimum="1.5em"
                space-before.maximum="2em">
	<xsl:call-template name="t:id"/>
	<xsl:apply-templates select="db:info" mode="t:titlepage-mode"/>
	<xsl:apply-templates/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:bibliodiv">
  <fo:block>
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:bibliolist">
  <fo:block space-before.minimum="1em"
            space-before.optimum="1.5em"
            space-before.maximum="2em">
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:biblioentry|db:bibliomixed">
  <xsl:param name="label" select="f:biblioentry-label(.)"/>

  <!-- N.B. The bibliography entry is expanded using $bibliography.collection -->
  <!-- during *normalization*, not here... -->

  <fo:block xsl:use-attribute-sets="biblioentry.properties">
    <xsl:call-template name="t:id"/>
    <xsl:text>[</xsl:text>
    <xsl:copy-of select="$label"/>
    <xsl:text>] </xsl:text>
    <xsl:choose>
      <xsl:when test="self::db:biblioentry">
	<xsl:apply-templates mode="m:biblioentry-mode"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="m:bibliomixed-mode"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="m:biblioentry-mode">
  <xsl:apply-templates select="."/><!-- try the default mode -->
</xsl:template>

<xsl:template match="abbrev" mode="m:biblioentry-mode">
  <xsl:if test="preceding-sibling::*">
    <fo:inline>
      <xsl:apply-templates mode="m:biblioentry-mode"/>
    </fo:inline>
  </xsl:if>
</xsl:template>

<xsl:template match="abstract" mode="m:biblioentry-mode">
  <!-- suppressed -->
</xsl:template>

<xsl:template match="db:address" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:affiliation" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:shortaffil" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:jobtitle" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:article/db:info" 
              mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:artpagenums" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:author" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:call-template name="t:person-name"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:personblurb" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:call-template name="t:person-name-list"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:authorinitials" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:bibliomisc" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:bibliomset" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="db:biblioset" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:biblioset/db:title|db:biblioset/db:citetitle" 
              mode="m:biblioentry-mode">
  <xsl:variable name="relation" select="../@relation"/>
  <xsl:choose>
    <xsl:when test="$relation='article' or @pubwork='article'">
      <xsl:call-template name="gentext-startquote"/>
      <xsl:apply-templates mode="m:biblioentry-mode"/>
      <xsl:call-template name="gentext-endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic">
        <xsl:apply-templates/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="$biblioentry.item.separator"/>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="db:bookbiblio" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:citetitle" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:choose>
      <xsl:when test="@pubwork = 'article'">
        <xsl:call-template name="gentext-startquote"/>
        <xsl:apply-templates mode="m:biblioentry-mode"/>
        <xsl:call-template name="gentext-endquote"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline font-style="italic">
          <xsl:apply-templates mode="m:biblioentry-mode"/>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:collab" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:confgroup" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:contractnum" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:contractsponsor" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:contrib" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="db:copyright" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:call-template name="gentext-space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext-space"/>
    <xsl:apply-templates select="year" mode="m:biblioentry-mode"/>
    <xsl:if test="holder">
      <xsl:call-template name="gentext-space"/>
      <xsl:apply-templates select="holder" mode="m:biblioentry-mode"/>
    </xsl:if>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:year" mode="m:biblioentry-mode">
  <xsl:apply-templates/><xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="db:year[position()=last()]" mode="m:biblioentry-mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:holder" mode="m:biblioentry-mode">
  <xsl:apply-templates/>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="db:corpauthor" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:corpcredit" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:corpname" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:date" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:edition" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:editor" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:call-template name="t:person-name"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:firstname" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:honorific" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:biblioentry-mode">
  <xsl:apply-templates select="."/> 
</xsl:template>

<xsl:template match="db:invpartnumber" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:isbn" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:issn" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:issuenum" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:lineage" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:orgname" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:othercredit" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:othername" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:pagenums" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:printhistory" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:productname" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:productnumber" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:pubdate" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:publisher" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:publishername" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:pubsnumber" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:releaseinfo" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:revhistory" mode="m:biblioentry-mode">
  <fo:block>
    <xsl:apply-templates select="."/> <!-- use normal mode -->
  </fo:block>
</xsl:template>

<xsl:template match="db:seriesinfo" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:seriesvolnums" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:subtitle" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:surname" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:title" mode="m:biblioentry-mode">
  <fo:inline>
    <fo:inline font-style="italic">
      <xsl:apply-templates mode="m:biblioentry-mode"/>
    </fo:inline>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:titleabbrev" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:volumenum" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:orgdiv" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:collabname" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:confdates" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:conftitle" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:confnum" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:confsponsor" mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:bibliocoverage|db:biblioid|db:bibliorelation|db:bibliosource"
              mode="m:biblioentry-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="m:bibliomixed-mode">
  <xsl:apply-templates select="."/><!-- try the default mode -->
</xsl:template>

<xsl:template match="db:abbrev" mode="m:bibliomixed-mode">
  <xsl:if test="preceding-sibling::*">
    <fo:inline>
      <xsl:apply-templates mode="m:bibliomixed-mode"/>
    </fo:inline>
  </xsl:if>
</xsl:template>

<xsl:template match="db:abstract" mode="m:bibliomixed-mode">
  <fo:block start-indent="1in">
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:para" mode="m:bibliomixed-mode">
  <fo:block>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:address" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:affiliation" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:shortaffil" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:jobtitle" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:biblioentry-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:artpagenums" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:author" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:call-template name="t:person-name"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:personblurb" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:authorinitials" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:bibliomisc" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="db:bibliomset" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:bibliomset/db:title|db:bibliomset/db:citetitle" 
              mode="m:bibliomixed-mode">
  <xsl:variable name="relation" select="../@relation"/>
  <xsl:choose>
    <xsl:when test="$relation='article' or @pubwork='article'">
      <xsl:call-template name="gentext-startquote"/>
      <xsl:apply-templates mode="m:bibliomixed-mode"/>
      <xsl:call-template name="gentext-endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic">
        <xsl:apply-templates/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="db:biblioset" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:citetitle" mode="m:bibliomixed-mode">
  <xsl:choose>
    <xsl:when test="@pubwork = 'article'">
      <xsl:call-template name="gentext-startquote"/>
      <xsl:apply-templates mode="m:bibliomixed-mode"/>
      <xsl:call-template name="gentext-endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic">
        <xsl:apply-templates mode="m:biblioentry-mode"/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:collab" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:confgroup" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:contractnum" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:contractsponsor" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:contrib" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:copyright" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:corpauthor" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:corpcredit" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:corpname" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:date" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:edition" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:editor" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:firstname" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:honorific" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:bibliomixed-mode">
  <xsl:apply-templates select="."/> 
</xsl:template>

<xsl:template match="db:invpartnumber" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:isbn" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:issn" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:issuenum" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:lineage" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:orgname" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:othercredit" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:othername" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:pagenums" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:printhistory" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:productname" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:productnumber" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:pubdate" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:publisher" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:publishername" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:pubsnumber" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:releaseinfo" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:revhistory" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:seriesvolnums" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:subtitle" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:surname" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:title" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:titleabbrev" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:volumenum" mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="db:bibliocoverage|db:biblioid|db:bibliorelation|db:bibliosource"
              mode="m:bibliomixed-mode">
  <fo:inline>
    <xsl:apply-templates mode="m:bibliomixed-mode"/>
  </fo:inline>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
