<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                exclude-result-prefixes="db f h m t"
                version="2.0">

<!-- ============================================================ -->

<xsl:template match="db:para|db:simpara">
  <xsl:param name="runin" select="()" tunnel="yes"/>
  <xsl:param name="class" select="()" tunnel="yes"/>

  <xsl:variable name="para" select="."/>

  <xsl:variable name="annotations" as="element()*">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:variable name="id" select="@xml:id"/>
      <xsl:if test="f:first-in-context($para,.)">
        <xsl:sequence select="if (@annotations)
                              then key('id',tokenize(@annotations,'\s'))
                              else ()"/>
        <xsl:sequence select="if ($id)
                              then //db:annotation[tokenize(@annotates,'\s')=$id]
                              else ()"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="descendant-annotations" as="element()*">
    <xsl:for-each select=".//*">
      <xsl:variable name="id" select="@xml:id"/>
      <xsl:sequence select="if (@annotations)
                            then key('id',tokenize(@annotations,'\s'))
                            else ()"/>
      <xsl:sequence select="if ($id)
                            then //db:annotation[tokenize(@annotates,'\s')=$id]
                            else ()"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="annotmarkup">
    <xsl:for-each select="$annotations">
      <xsl:variable name="id"
                    select="concat(f:node-id(.),'-',generate-id($para))"/>
      <a style="display: inline" onclick="show_annotation('{$id}')"
         id="annot-{$id}-on">
        <img border="0" src="{$annotation.graphic.open}" alt="[A+]"/>
      </a>
      <a style="display: none" onclick="hide_annotation('{$id}')"
         id="annot-{$id}-off">
        <img border="0" src="{$annotation.graphic.close}" alt="[A-]"/>
      </a>
    </xsl:for-each>
    <xsl:for-each select="($annotations, $descendant-annotations)">
      <xsl:variable name="id"
                    select="concat(f:node-id(.),'-',generate-id($para))"/>
      <div style="display: none" id="annot-{$id}">
        <xsl:apply-templates select="." mode="m:annotation"/>
      </div>
    </xsl:for-each>
  </xsl:variable>

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
            <xsl:copy-of select="$annotmarkup"/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <p>
        <xsl:sequence select="f:html-attributes(., @xml:id, $class)"/>
        <xsl:copy-of select="$runin"/>
        <xsl:apply-templates/>
        <xsl:copy-of select="$annotmarkup"/>
      </p>
    </xsl:otherwise>
  </xsl:choose>

  <!--
  <xsl:for-each select="$annotations">
    <xsl:variable name="id"
                    select="concat(f:node-id(.),'-',generate-id($para))"/>
    <div style="display: none" id="annot-{$id}">
      <xsl:apply-templates select="." mode="m:annotation"/>
    </div>
  </xsl:for-each>
  -->
</xsl:template>

<xsl:template match="db:epigraph">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates select="*[not(self::db:attribution)]"/>
    <xsl:apply-templates select="db:attribution"/>
  </div>
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
    <xsl:apply-templates select="db:attribution"/>
  </blockquote>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:remark">
  <xsl:if test="$show.comments != 0">
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

<xsl:template match="db:annotation" mode="m:annotation">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:call-template name="t:titlepage"/>
    <div class="annotation-content">
      <xsl:apply-templates/>
    </div>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<!-- FIXME: this can't be right... -->
<xsl:template match="db:acknowledgements">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
