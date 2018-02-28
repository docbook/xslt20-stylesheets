<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
                exclude-result-prefixes="db f h m t ghost"
                version="2.0">

<!-- ============================================================ -->

<xsl:template match="db:para|db:simpara">
  <xsl:param name="runin" select="()" tunnel="yes"/>
  <xsl:param name="class" select="()" tunnel="yes"/>

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
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </xsl:when>

        <xsl:otherwise>
          <p>
            <xsl:sequence select="f:html-attributes(., @xml:id, $class)"/>
            <xsl:copy-of select="$runin"/>
            <xsl:apply-templates/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <xsl:sequence select="f:html-attributes(., @xml:id, $class)"/>
        <xsl:copy-of select="$runin"/>
        <xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:epigraph">
  <blockquote>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates select="*[not(self::db:attribution)]"/>
    <xsl:if test="db:attribution">
      <footer>
        <xsl:apply-templates select="db:attribution"/>
      </footer>
    </xsl:if>
  </blockquote>
</xsl:template>

<xsl:template match="db:attribution">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <span class="mdash">—</span>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:ackno">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:blockquote">
  <blockquote>
    <xsl:sequence select="f:html-attributes(., @xml:id, ())"/>
    <xsl:call-template name="t:titlepage"/>
    <xsl:apply-templates select="* except db:attribution"/>
    <xsl:if test="db:attribution">
      <footer>
        <xsl:apply-templates select="db:attribution"/>
      </footer>
    </xsl:if>
  </blockquote>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:remark">
  <xsl:if test="$show.comments">
    <div>
      <xsl:sequence select="f:html-attributes(.)"/>
      <xsl:apply-templates/>
    </div>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:sidebar">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:call-template name="t:titlepage"/>
    <div class="sidebar-content">
      <xsl:apply-templates/>
    </div>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="ghost:annotation">
  <xsl:variable name="id" select="@xml:id"/>
  <a class="dialog-link" href="#annotation-{$id}"
     title="Annotation link">
    <span class="ui-icon ui-icon-comment inline-icon"></span>
  </a>
</xsl:template>

<!-- ==================================================================== -->

<!-- FIXME: this can't be right... -->
<xsl:template match="db:acknowledgements">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
