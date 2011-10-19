<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="h f m fn db t"
                version="2.0">

<xsl:key name="glossterm" match="db:glossentry/db:glossterm" use="string(.)"/>

<!-- ==================================================================== -->

<xsl:template match="db:glossary">
  <article>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:choose>
      <xsl:when test="db:glossdiv">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<dl>
	  <xsl:apply-templates/>
	</dl>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="not(parent::db:article)">
      <xsl:call-template name="t:process-footnotes"/>
    </xsl:if>
  </article>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:glossdiv">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="t:titlepage"/>

    <dl>
      <xsl:apply-templates/>
    </dl>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:glosslist">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates select="node()[not(self::db:glossentry)]"/>

    <dl>
      <xsl:apply-templates select="db:glossentry"/>
    </dl>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<!--
GlossEntry ::=
  GlossTerm, Acronym?, Abbrev?,
  (IndexTerm)*,
  RevHistory?,
  (GlossSee | GlossDef+)
-->

<xsl:template match="db:glossary[@role='auto']">
  <xsl:if test="not($external.glossary)">
    <xsl:message>
      <xsl:text>Warning: processing automatic glossary </xsl:text>
      <xsl:text>without an external glossary.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="glossary">
    <db:glossary>
      <xsl:copy-of select="@*[name(.) != 'role']"/>

      <xsl:copy-of select="db:info"/>

      <xsl:variable name="seealsos" as="element()*">
        <xsl:for-each select="$external.glossary//db:glossseealso">
          <xsl:copy-of select="if (key('id', @otherterm))
                               then key('id', @otherterm)[1]
                               else key('glossterm', string(.))"/>
        </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="divs"
                    select="db:glossdiv"/>

      <xsl:choose>
        <xsl:when test="$divs and $external.glossary//db:glossdiv">
          <xsl:apply-templates select="$external.glossary//db:glossdiv"
                               mode="m:copy-external-glossary">
            <xsl:with-param name="terms"
                            select="//db:glossterm[not(parent::db:glossdef)]
                                    |//db:firstterm
                                    |$seealsos"/>
            <xsl:with-param name="divs" select="$divs"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$external.glossary//db:glossentry"
                               mode="m:copy-external-glossary">
            <xsl:with-param name="terms"
                            select="//db:glossterm[not(parent::db:glossdef)]
                                    |//db:firstterm
                                    |$seealsos"/>
            <xsl:with-param name="divs" select="$divs"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </db:glossary>
  </xsl:variable>

  <xsl:apply-templates select="$glossary"/>
</xsl:template>

<xsl:template match="db:glossentry">
  <dt>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>

    <xsl:choose>
      <xsl:when test="$glossentry.show.acronym = 'primary'">
	<xsl:choose>
	  <xsl:when test="db:acronym|db:abbrev">
	    <xsl:apply-templates select="db:acronym|db:abbrev"/>
	    <xsl:text> (</xsl:text>
	    <xsl:apply-templates select="db:glossterm"/>
	    <xsl:text>)</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="db:glossterm"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:when test="$glossentry.show.acronym = 'yes'">
	<xsl:apply-templates select="db:glossterm"/>

	<xsl:if test="db:acronym|db:abbrev">
          <xsl:text> (</xsl:text>
          <xsl:apply-templates select="db:acronym|db:abbrev"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="db:glossterm"/>
      </xsl:otherwise>
    </xsl:choose>
  </dt>

  <xsl:apply-templates select="db:indexterm|db:glosssee|db:glossdef"/>
</xsl:template>

<xsl:template match="db:glossentry/db:glossterm">
  <span>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:glossterm">, </xsl:if>
</xsl:template>

<xsl:template match="db:glossentry/db:acronym">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:acronym
		|following-sibling::db:abbrev">, </xsl:if>
</xsl:template>

<xsl:template match="db:glossentry/db:abbrev">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:acronym
		|following-sibling::db:abbrev">, </xsl:if>
</xsl:template>

<xsl:template match="db:glossentry/db:glosssee">
  <xsl:variable name="target" select="key('id', @otherterm)[1]"/>

  <dd>
    <xsl:sequence select="f:html-attributes(.)"/>
    <p>
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'glossary'"/>
        <xsl:with-param name="name" select="'see'"/>
      </xsl:call-template>
      <xsl:choose>
	<xsl:when test="$target">
	  <a href="{f:href(/,$target)}">
	    <xsl:apply-templates select="$target" mode="m:xref-to"/>
	  </a>
	</xsl:when>
	<xsl:when test="@otherterm and not($target)">
	  <xsl:message>
	    <xsl:text>Warning: </xsl:text>
	    <xsl:text>glosssee @otherterm reference not found: </xsl:text>
	    <xsl:value-of select="@otherterm"/>
	  </xsl:message>
	  <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.</xsl:text>
    </p>
  </dd>
</xsl:template>

<xsl:template match="db:glossentry/db:glossdef">
  <dd>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates select="*[not(self::db:glossseealso)]"/>
    <xsl:for-each select="db:glossseealso">
      <p>
        <xsl:variable name="template">
          <xsl:call-template name="gentext-template">
            <xsl:with-param name="context" select="'glossary'"/>
            <xsl:with-param name="name" select="'seealso'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="title">
          <xsl:apply-templates select="."/>
        </xsl:variable>
        <xsl:call-template name="substitute-markup">
          <xsl:with-param name="template" select="$template"/>
          <xsl:with-param name="title" select="$title"/>
        </xsl:call-template>
      </p>
    </xsl:for-each>
  </dd>
</xsl:template>

<xsl:template match="db:glossseealso">
  <xsl:variable name="target"
		select="if (key('id', @otherterm))
			then key('id', @otherterm)[1]
			else key('glossterm', string(.))"/>

  <xsl:choose>
    <xsl:when test="$target">
      <a href="{f:href(/,$target)}">
        <xsl:apply-templates select="$target" mode="m:xref-to"/>
      </a>
    </xsl:when>
    <xsl:when test="@otherterm and not($target)">
      <xsl:message>
        <xsl:text>Warning: </xsl:text>
	<xsl:text>glossseealso @otherterm reference not found: </xsl:text>
        <xsl:value-of select="@otherterm"/>
      </xsl:message>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="position() = last() and position() = 1">
      <!-- nothing -->
    </xsl:when>
    <xsl:when test="position() = last() and position() &gt; 1">
      <xsl:text>.</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>, </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
