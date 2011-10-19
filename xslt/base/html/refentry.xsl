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

<xsl:template match="db:refentry">
  <article>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>

    <xsl:if test="$refentry.separator != 0 and preceding-sibling::db:refentry">
      <div class="refentry-separator">
	<hr/>
      </div>
    </xsl:if>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates/>

    <xsl:call-template name="t:process-footnotes"/>
  </article>
</xsl:template>

<xsl:template match="db:refnamediv">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:choose>
      <xsl:when test="$refentry.generate.name != 0">
	<h2>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'RefName'"/>
          </xsl:call-template>
        </h2>
      </xsl:when>

      <xsl:when test="$refentry.generate.title != 0">
	<h2>
	  <xsl:choose>
	    <xsl:when test="../db:refmeta/db:refentrytitle">
              <xsl:apply-templates select="../db:refmeta/db:refentrytitle"/>
            </xsl:when>
            <xsl:otherwise>
	      <xsl:apply-templates select="db:refname[1]"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</h2>
      </xsl:when>
    </xsl:choose>
    <p>
      <xsl:apply-templates/>
    </p>
  </div>
</xsl:template>

<xsl:template match="db:refmeta"/>

<xsl:template match="db:refentrytitle">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:refname">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:refname">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:refpurpose">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <span class="refpurpose-sep">
      <xsl:text>&#160;—&#160;</xsl:text>
    </span>
    <span class="refpurpose-text">
      <xsl:apply-templates/>
    </span>
    <span class="refpurpose-punc">
      <xsl:text>.</xsl:text>
    </span>
  </span>
</xsl:template>

<xsl:template match="db:refdescriptor">
  <!-- todo: finish this -->
</xsl:template>

<xsl:template match="db:refsynopsisdiv">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <h2>
      <xsl:choose>
	<xsl:when test="db:info/db:title">
	  <xsl:apply-templates select="db:info/db:title"
			       mode="m:titlepage-mode"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </h2>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:refsection|db:refsect1|db:refsect2|db:refsect3">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="t:titlepage"/>

    <xsl:apply-templates/>
  </div>
</xsl:template>

</xsl:stylesheet>
