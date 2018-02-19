<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		exclude-result-prefixes="f m fn db t"
                version="2.0">

<!-- ============================================================ -->

<xsl:template match="db:para|db:simpara">
  <xsl:param name="runin" select="()" tunnel="yes"/>
  <xsl:param name="class" select="''" tunnel="yes"/>

  <xsl:variable name="para" select="."/>

  <xsl:choose>
    <xsl:when test="parent::db:listitem
		    and not(preceding-sibling::*)
		    and not(@role)">
      <xsl:variable name="list"
		    select="(ancestor::db:orderedlist
			     |ancestor::db:itemizedlist
			     |ancestor::db:variablelist)[last()]"/>
      <xsl:choose>
	<xsl:when test="$list/@spacing='compact'">
	  <xsl:apply-templates/>
	</xsl:when>

	<xsl:otherwise>
	  <fo:block>
	    <xsl:call-template name="t:id"/>
	    <xsl:copy-of select="$runin"/>
	    <xsl:apply-templates/>
	  </fo:block>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <fo:block xsl:use-attribute-sets="normal.para.spacing">
	<xsl:call-template name="t:id"/>
	<xsl:copy-of select="$runin"/>
	<xsl:apply-templates/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:formalpara">
  <xsl:variable name="title">
    <xsl:apply-templates select="db:info/db:title"/>
  </xsl:variable>

  <fo:block>
    <xsl:apply-templates select="db:indexterm"/>
    <xsl:apply-templates select="db:para">
      <xsl:with-param name="runin" select="$title/node()" tunnel="yes"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="db:formalpara/db:info/db:title" priority="1000">
  <fo:block font-weight="bold">
    <xsl:apply-templates/>
  </fo:block>
  <xsl:text>&#160;&#160;</xsl:text>
</xsl:template>

<xsl:template match="db:epigraph">
  <fo:block>
    <xsl:apply-templates select="*[not(self::db:attribution)]"/>
    <xsl:apply-templates select="db:attribution"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:attribution">
  <fo:block>
    <fo:inline>—</fo:inline>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:ackno">
  <fo:block><xsl:apply-templates/></fo:block>
</xsl:template>

<xsl:template match="db:blockquote">
  <fo:block>
    <xsl:if test="db:info/db:title">
      <fo:block>
	<xsl:apply-templates select="db:info/db:title/node()"/>
      </fo:block>
    </xsl:if>
    <xsl:apply-templates select="* except (db:info|db:attribution)"/>
    <xsl:apply-templates select="db:attribution"/>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:remark">
  <xsl:if test="$show.comments != 0">
    <fo:block>
      <xsl:call-template name="t:id"/>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="t:floater">
  <xsl:param name="position" select="'none'"/>
  <xsl:param name="clear" select="'both'"/>
  <xsl:param name="width"/>
  <xsl:param name="content"/>
  <xsl:param name="start.indent">0pt</xsl:param>
  <xsl:param name="end.indent">0pt</xsl:param>

  <!-- FIXME: -->
  <xsl:copy-of select="$content"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:sidebar">
  <fo:block>
    <xsl:call-template name="t:id"/>

    <!-- FIXME: titlepage -->

    <fo:block>
      <xsl:apply-templates select="*[not(self::db:info)]"/>
    </fo:block>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<!-- FIXME: this can't be right... -->
<xsl:template match="db:acknowledgements">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
