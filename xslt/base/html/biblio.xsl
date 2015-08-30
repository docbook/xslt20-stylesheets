<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="db doc f fn h m t"
                version="2.0">

<xsl:template match="db:bibliography">
  <article>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates/>
  </article>
</xsl:template>

<xsl:template match="db:bibliodiv">
  <div>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:bibliolist">
  <div>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:biblioentry|db:bibliomixed">
  <xsl:param name="label" select="f:biblioentry-label(.)"/>

  <!-- N.B. The bibliography entry is expanded using $bibliography.collection -->
  <!-- during *normalization*, not here... -->

  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <p class="{local-name(.)}">
      <span class="label">
      <xsl:text>[</xsl:text>
      <xsl:copy-of select="$label"/>
      <xsl:text>] </xsl:text>
      </span>
      <span class="entry">
      <xsl:choose>
	<xsl:when test="self::db:biblioentry">
	  <xsl:apply-templates mode="m:biblioentry"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates mode="m:bibliomixed"/>
	</xsl:otherwise>
      </xsl:choose>
      </span>
    </p>
  </div>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:bibliomixed"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting <tag>bibliomixed</tag> elements</refpurpose>

<refdescription>
<para>This mode is used to format elements in a <tag>bibliomixed</tag>.
Any element processed in this mode should generate markup appropriate
for the content of a bibliography entry.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:bibliomixed">
  <xsl:apply-templates select="."/> <!-- try the default mode -->
</xsl:template>

<xsl:template match="db:abbrev" mode="m:bibliomixed">
  <xsl:if test="preceding-sibling::*">
    <xsl:apply-templates mode="m:bibliomixed"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:bibliomset/db:title|db:bibliomset/db:citetitle"
	      mode="m:bibliomixed">
  <xsl:variable name="relation" select="../@relation"/>

  <xsl:call-template name="t:simple-xlink">
    <xsl:with-param name="content">
      <xsl:choose>
	<xsl:when test="$relation='article' or @pubwork='article'">
	  <xsl:call-template name="gentext-startquote"/>
	  <xsl:apply-templates mode="m:bibliomixed"/>
	  <xsl:call-template name="gentext-endquote"/>
	</xsl:when>
	<xsl:otherwise>
	  <cite>
	    <xsl:apply-templates mode="m:bibliomixed"/>
	  </cite>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:citetitle|db:title" mode="m:bibliomixed">
  <xsl:call-template name="t:simple-xlink">
    <xsl:with-param name="content">
      <span class="{name(.)}">
	<xsl:choose>
	  <xsl:when test="@pubwork = 'article'">
	    <xsl:call-template name="gentext-startquote"/>
	    <xsl:apply-templates mode="m:bibliomixed"/>
	    <xsl:call-template name="gentext-endquote"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <cite>
	      <xsl:apply-templates mode="m:bibliomixed"/>
	    </cite>
	  </xsl:otherwise>
	</xsl:choose>
      </span>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:revhistory" mode="m:bibliomixed">
  <!-- suppressed; how could this be represented? -->
</xsl:template>

<xsl:template match="db:abstract
		     |db:address
		     |db:affiliation
		     |db:artpagenums
		     |db:authorblurb
		     |db:authorinitials
		     |db:bibliocoverage
		     |db:biblioid
		     |db:bibliomisc
		     |db:bibliomset
		     |db:bibliorelation
		     |db:biblioset
		     |db:bibliosource
		     |db:collab
		     |db:confgroup
		     |db:contractnum
		     |db:contractsponsor
		     |db:contrib
		     |db:corpauthor
		     |db:corpcredit
		     |db:corpname
		     |db:date
		     |db:edition
		     |db:firstname
		     |db:honorific
		     |db:invpartnumber
		     |db:isbn
		     |db:issn
		     |db:issuenum
		     |db:jobtitle
		     |db:lineage
		     |db:orgname
		     |db:othername
		     |db:pagenums
		     |db:personblurb
		     |db:printhistory
		     |db:productname
		     |db:productnumber
		     |db:pubdate
		     |db:publisher
		     |db:publishername
		     |db:pubsnumber
		     |db:releaseinfo
		     |db:seriesvolnums
		     |db:shortaffil
		     |db:subtitle
		     |db:surname
		     |db:titleabbrev
		     |db:volumenum"
	      mode="m:bibliomixed">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:bibliomixed"/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:biblioentry"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting <tag>biblioentry</tag> elements</refpurpose>

<refdescription>
<para>This mode is used to format elements in a <tag>biblioentry</tag>.
Any element processed in this mode should generate markup appropriate
for the content of a bibliography entry.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:biblioentry">
  <xsl:variable name="content">
    <xsl:apply-templates select="."/> <!-- try the default mode -->
  </xsl:variable>
  <xsl:copy-of select="$content"/>
  <xsl:if test="not(ends-with(string($content), '.'))">.</xsl:if>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="db:biblioset" mode="m:biblioentry">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:biblioentry"/>
  </span>
</xsl:template>

<xsl:template match="db:abbrev" mode="m:biblioentry">
  <xsl:if test="preceding-sibling::*">
    <xsl:apply-templates mode="m:biblioentry"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:biblioset/db:title|db:biblioset/db:citetitle
                     |db:bibliomset/db:title|db:bibliomset/db:citetitle"
	      mode="m:biblioentry">
  <xsl:variable name="relation" select="../@relation"/>
  <xsl:call-template name="t:simple-xlink">
    <xsl:with-param name="content">
      <xsl:choose>
	<xsl:when test="$relation='article' or @pubwork='article'">
	  <xsl:call-template name="gentext-startquote"/>
	  <xsl:apply-templates mode="m:biblioentry"/>
	  <xsl:call-template name="gentext-endquote"/>
	</xsl:when>
	<xsl:otherwise>
	  <cite>
	    <xsl:apply-templates mode="m:biblioentry"/>
	  </cite>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>. </xsl:text>
</xsl:template>

<xsl:template match="db:citetitle|db:title" mode="m:biblioentry">
  <xsl:call-template name="t:simple-xlink">
    <xsl:with-param name="content">
      <span class="{name(.)}">
	<xsl:choose>
	  <xsl:when test="@pubwork = 'article'">
	    <xsl:call-template name="gentext-startquote"/>
	    <xsl:apply-templates mode="m:biblioentry"/>
	    <xsl:call-template name="gentext-endquote"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <cite>
	      <xsl:apply-templates mode="m:biblioentry"/>
	    </cite>
	  </xsl:otherwise>
	</xsl:choose>
      </span>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>. </xsl:text>
</xsl:template>

<xsl:template match="db:subtitle" mode="m:biblioentry">
  <span class="{name(.)}">
    <xsl:apply-templates/>
  </span>
  <xsl:text>. </xsl:text>
</xsl:template>

<xsl:template match="db:address" mode="m:biblioentry">
  <xsl:variable name="addr" as="element(h:pre)">
    <xsl:apply-templates select="."/>
  </xsl:variable>

  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:value-of select="replace(string($addr), '&#10;', ' / ')"/>
    <xsl:if test="not(ends-with(string($addr), '.'))">.</xsl:if>
  </span>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="db:collab" mode="m:biblioentry">
  <xsl:variable name="content">
    <xsl:for-each select="*[not(self::db:affiliation)]">
      <xsl:if test="position() &gt; 1">, </xsl:if>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:copy-of select="$content"/>
  <xsl:if test="not(ends-with(string($content), '.'))">.</xsl:if>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="db:confgroup|db:publisher" mode="m:biblioentry">
  <xsl:apply-templates mode="m:biblioentry"/>
</xsl:template>

<xsl:template match="db:printhistory|db:revhistory" mode="m:biblioentry">
  <!-- suppressed; how could this be represented? -->
</xsl:template>

<xsl:template match="db:titleabbrev|db:abstract" mode="m:biblioentry">
  <!-- suppressed -->
</xsl:template>

</xsl:stylesheet>
