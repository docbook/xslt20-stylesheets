<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="db f m t xs">

<!-- ============================================================ -->
<!-- Verso templates -->

<xsl:template match="db:authorgroup" mode="m:titlepage-verso-mode">
  <fo:block>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'by'"/>
    </xsl:call-template>
    <xsl:text>&#160;</xsl:text>
    <xsl:for-each select="*">
      <xsl:if test="position() &gt; 1 and last() &gt; 2">, </xsl:if>
      <xsl:if test="position() = last()">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'and'"/>
        </xsl:call-template>
        <xsl:text>&#160;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="db:orgname|db:personname"/>
    </xsl:for-each>
  </fo:block>
</xsl:template>

<xsl:template match="db:pubdate" mode="m:titlepage-verso-mode">
  <fo:block>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'pubdate'"/>
    </xsl:call-template>
    <xsl:text>&#160;</xsl:text>
    <xsl:apply-templates select="." mode="m:titlepage-mode"/>
  </fo:block>
</xsl:template>

<!-- ============================================================ -->
<!-- Titlepage templates (also used for recto) -->

<xsl:template match="db:title" mode="m:titlepage-mode">
  <fo:block font-family="{$title.fontset}">
    <xsl:choose>
      <xsl:when test="not(parent::*)">
        <xsl:apply-templates mode="m:titlepage-mode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="context"
                      select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

        <xsl:apply-templates select="$context" mode="m:object-title-markup">
          <xsl:with-param name="allow-anchors" select="true()"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template match="db:section/db:title|db:section/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="depth" select="min((count(ancestor::db:section), 5))"/>

  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block font-size="{f:hsize(5 - $depth)}pt" font-family="{$title.fontset}">
    <xsl:if test="$depth &gt;= 4">
      <xsl:attribute name="font-weight" select="'bold'"/>
    </xsl:if>
    <xsl:apply-templates select="$context" mode="m:object-title-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:refsection/db:title|db:refsection/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="depth" select="min((count(ancestor::db:refsection), 3))"/>

  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block font-size="{f:hsize(5 - $depth)}pt" font-family="{$title.fontset}">
    <xsl:apply-templates select="$context" mode="m:object-title-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:sect1/db:title|db:sect1/db:info/db:title
                     |db:refsect1/db:title|db:refsect1/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block font-size="{f:hsize(4)}pt" font-family="{$title.fontset}">
    <xsl:apply-templates select="$context" mode="m:object-title-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:sect2/db:title|db:sect2/db:info/db:title
                     |db:refsect2/db:title|db:refsect2/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block font-size="{f:hsize(3)}pt" font-family="{$title.fontset}">
    <xsl:apply-templates select="$context" mode="m:object-title-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:sect3/db:title|db:sect3/db:info/db:title
                     |db:refsect3/db:title|db:refsect3/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block font-size="{f:hsize(2)}pt" font-family="{$title.fontset}">
    <xsl:apply-templates select="$context" mode="m:object-title-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:sect4/db:title|db:sect4/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block font-size="{f:hsize(1)}pt" font-weight="bold" font-family="{$title.fontset}">
    <xsl:apply-templates select="$context" mode="m:object-title-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:sect5/db:title|db:sect5/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block font-size="{f:hsize(0)}pt" font-weight="bold" font-family="{$title.fontset}">
    <xsl:apply-templates select="$context" mode="m:object-title-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:subtitle" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block font-family="{$title.fontset}">
    <xsl:apply-templates select="$context" mode="m:object-subtitle-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:titleabbrev" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <fo:block>
    <xsl:apply-templates select="$context" mode="m:object-titleabbrev-markup"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:pubdate" mode="m:titlepage-mode">
  <xsl:choose>
    <xsl:when test=". castable as xs:dateTime">
      <xsl:variable name="format" as="xs:string">
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'datetime'"/>
          <xsl:with-param name="name" select="'format'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="format-dateTime(xs:dateTime(.), $format)"/>
    </xsl:when>
    <xsl:when test=". castable as xs:date">
      <xsl:variable name="format" as="xs:string">
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'date'"/>
          <xsl:with-param name="name" select="'format'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="format-date(xs:date(.), $format)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:titlepage-mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:titlepage-mode">
  <xsl:apply-templates mode="m:titlepage-mode"/>
</xsl:template>

<xsl:template match="db:author" mode="m:titlepage-mode">
  <xsl:choose>
    <xsl:when test="db:orgname">
      <fo:block>
        <xsl:apply-templates select="db:orgname"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block>
        <xsl:apply-templates select="db:personname"/>
        <xsl:if test="db:email">
          <xsl:text>&#160;</xsl:text>
          <xsl:apply-templates select="db:email"/>
        </xsl:if>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:editor" mode="m:titlepage-mode">
  <fo:block>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'editedby'"/>
    </xsl:call-template>
    <xsl:text>&#160;</xsl:text>

    <xsl:choose>
      <xsl:when test="db:orgname">
        <xsl:apply-templates select="db:orgname"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="db:personname"/>
        <xsl:if test="db:email">
          <xsl:text>&#160;</xsl:text>
          <xsl:apply-templates select="db:email"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template match="db:copyright" mode="m:titlepage-mode">
  <xsl:apply-templates select=".">
    <xsl:with-param name="wrapper" select="'block'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:abstract" mode="m:titlepage-mode">
  <fo:block font-family="{$body.font.family}" space-before="1em">
    <xsl:call-template name="t:titlepage"/>
    <xsl:variable name="dir" select="f:dir(.)"/>
    <fo:block text-align="{if ($dir='ltr' or $dir='lro') then 'right' else 'left'}"
              line-height="1">
      <xsl:apply-templates/>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="db:book/db:info/db:abstract" mode="m:titlepage-mode">
  <fo:block font-family="{$body.font.family}" space-before="1em">
    <fo:block text-align="center">
      <xsl:call-template name="t:titlepage"/>
    </fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="db:legalnotice" mode="m:titlepage-mode">
  <fo:block font-family="{$body.font.family}">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()" mode="m:titlepage-mode">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:titlepage-before-recto-mode">
  <xsl:apply-templates select="." mode="m:titlepage-mode"/>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-recto-mode">
  <xsl:apply-templates select="." mode="m:titlepage-mode"/>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-separator-mode">
  <xsl:apply-templates select="." mode="m:titlepage-mode"/>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-before-verso-mode">
  <xsl:apply-templates select="." mode="m:titlepage-mode"/>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-verso-mode">
  <xsl:apply-templates select="." mode="m:titlepage-mode"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:info|db:title|db:subtitle|db:titleabbrev">
  <!-- nop -->
</xsl:template>

</xsl:stylesheet>
