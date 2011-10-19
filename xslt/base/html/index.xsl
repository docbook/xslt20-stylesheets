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

<xsl:template match="db:index|db:setindex">
  <article>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates select="*[not(self::db:indexdiv)
                                   and not(self::db:indexentry)]"/>

    <!-- An empty index element indicates that the index -->
    <!-- should be generated automatically -->
    <xsl:choose>
      <xsl:when test="not(db:indexentry) and not(db:indexdiv)">
	<xsl:call-template name="generate-index">
	  <xsl:with-param name="scope" select="parent::*"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="db:indexentry">
	<div class="indexdiv">
	  <dl>
	    <xsl:apply-templates select="db:indexentry"/>
	  </dl>
	</div>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="db:indexdiv"/>
      </xsl:otherwise>
    </xsl:choose>
  </article>
</xsl:template>

<xsl:template match="db:indexterm">
  <a class="indexterm" name="{f:node-id(.)}"/>
</xsl:template>

<xsl:template match="db:primary|db:secondary|db:tertiary|db:see|db:seealso">
</xsl:template>

<xsl:template match="db:indexdiv">
  <div>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates select="node()[not(self::db:indexentry)]"/>

    <dl>
      <xsl:apply-templates select="db:indexentry"/>
    </dl>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:indexentry">
  <xsl:apply-templates select="db:primaryie"/>
</xsl:template>

<xsl:template match="db:primaryie">
  <dt>
    <xsl:apply-templates/>
  </dt>
  <xsl:choose>
    <xsl:when test="following-sibling::db:secondaryie">
      <dd>
        <dl>
          <xsl:apply-templates select="following-sibling::db:secondaryie"/>
        </dl>
      </dd>
    </xsl:when>
    <xsl:when test="following-sibling::db:seeie
                    |following-sibling::db:seealsoie">
      <dd>
        <dl>
          <xsl:apply-templates select="following-sibling::db:seeie
                                       |following-sibling::db:seealsoie"/>
        </dl>
      </dd>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:secondaryie">
  <dt>
    <xsl:apply-templates/>
  </dt>
  <xsl:choose>
    <xsl:when test="following-sibling::db:tertiaryie">
      <dd>
        <dl>
          <xsl:apply-templates select="following-sibling::db:tertiaryie"/>
        </dl>
      </dd>
    </xsl:when>
    <xsl:when test="following-sibling::db:seeie
                    |following-sibling::db:seealsoie">
      <dd>
        <dl>
          <xsl:apply-templates select="following-sibling::db:seeie
                                       |following-sibling::db:seealsoie"/>
        </dl>
      </dd>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:tertiaryie">
  <dt>
    <xsl:apply-templates/>
  </dt>
  <xsl:if test="following-sibling::db:seeie
                |following-sibling::db:seealsoie">
    <dd>
      <dl>
        <xsl:apply-templates select="following-sibling::db:seeie
                                     |following-sibling::db:seealsoie"/>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template match="db:seeie|db:seealsoie">
  <dt>
    <xsl:apply-templates/>
  </dt>
</xsl:template>

</xsl:stylesheet>
