<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="db f m t xs h">

<!-- ============================================================ -->
<!-- Recto templates -->

<xsl:template match="db:authorgroup" mode="m:titlepage-recto-mode">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:titlepage-recto-mode"/>
  </div>
</xsl:template>

<xsl:template match="db:author" mode="m:titlepage-recto-mode">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <h3>
      <xsl:choose>
        <xsl:when test="db:orgname">
          <xsl:apply-templates select="db:orgname"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="db:personname"/>
        </xsl:otherwise>
      </xsl:choose>
    </h3>
  </div>
</xsl:template>

<xsl:template match="db:editor" mode="m:titlepage-recto-mode">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <h4 class="editedby">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'editedby'"/>
      </xsl:call-template>
    </h4>
    <h3>
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
    </h3>
  </div>
</xsl:template>

<xsl:template match="db:pubdate" mode="m:titlepage-recto-mode">
  <div>
    <p>
      <xsl:apply-templates select="." mode="m:titlepage-mode"/>
    </p>
  </div>
</xsl:template>

<xsl:template match="db:abstract" mode="m:titlepage-recto-mode">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- ============================================================ -->
<!-- Verso templates -->

<xsl:template match="db:authorgroup" mode="m:titlepage-verso-mode">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
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
  </div>
</xsl:template>

<xsl:template match="db:pubdate" mode="m:titlepage-verso-mode">
  <div>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'pubdate'"/>
    </xsl:call-template>
    <xsl:text>&#160;</xsl:text>
    <xsl:apply-templates select="." mode="m:titlepage-mode"/>
  </div>
</xsl:template>

<!-- ============================================================ -->
<!-- Titlepage templates (also used for recto) -->

<xsl:template match="db:title" mode="m:titlepage-mode">
  <xsl:param name="context" as="element()?" select="()"/>

  <!-- Auto-generated titles are not in situ, so we have to work harder -->
  <!-- But note that the content of the title is already the correctly -->
  <!-- generated text. We *don't* have to call m:object-title-markup here -->
  <xsl:choose>
    <xsl:when test="$context/self::db:bibliography
                    or $context/self::db:preface
                    or $context/self::db:dedication
                    or $context/self::db:colophon
                    or $context/self::db:dedication
                    or $context/self::db:glossary
                    or $context/self::db:setindex
                    or $context/self::db:index">
      <xsl:choose>
        <xsl:when test="$context/ancestor::db:article">
          <h3><xsl:apply-templates/></h3>
        </xsl:when>
        <xsl:when test="$context/self::db:setindex">
          <h1><xsl:apply-templates/></h1>
        </xsl:when>
        <xsl:otherwise>
          <h2><xsl:apply-templates/></h2>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$context/self::db:warning
                    or $context/self::db:caution
                    or $context/self::db:tip
                    or $context/self::db:note
                    or $context/self::db:important">
      <h3>
        <xsl:apply-templates/>
      </h3>
    </xsl:when>
    <xsl:when test="$context/self::db:abstract">
      <div class="title">
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="title">
        <xsl:apply-templates/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:set/db:title|db:set/db:info/db:title
                     |db:book/db:title|db:book/db:info/db:title
                     |db:part/db:title|db:part/db:info/db:title
                     |db:reference/db:title|db:reference/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <h1>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h1>
</xsl:template>

<xsl:template match="db:setindex/db:title|db:setindex/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <h2>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="db:preface/db:title|db:prefac/db:info/db:title
                     |db:chapter/db:title|db:chapter/db:info/db:title
                     |db:appendix/db:title|db:appendix/db:info/db:title
                     |db:dedication/db:title|db:dedication/db:info/db:title
                     |db:colophon/db:title|db:colophon/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <h2>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="db:bibliography/db:title|db:bibliography/db:info/db:title
                     |db:glossary/db:title|db:glossary/db:info/db:title
                     |db:index/db:title|db:index/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <xsl:choose>
    <xsl:when test="ancestor::db:article">
      <h3>
        <xsl:apply-templates select="$context" mode="m:object-title-markup">
          <xsl:with-param name="allow-anchors" select="true()"/>
        </xsl:apply-templates>
      </h3>
    </xsl:when>
    <xsl:otherwise>
      <h2>
        <xsl:apply-templates select="$context" mode="m:object-title-markup">
          <xsl:with-param name="allow-anchors" select="true()"/>
        </xsl:apply-templates>
      </h2>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:bibliodiv/db:title|db:bibliodiv/db:info/db:title
                     |db:glossdiv/db:title|db:glossdiv/db:info/db:title
                     |db:indexdiv/db:title|db:indexdiv/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <xsl:choose>
    <xsl:when test="ancestor::db:article">
      <h4>
        <xsl:apply-templates select="$context" mode="m:object-title-markup">
          <xsl:with-param name="allow-anchors" select="true()"/>
        </xsl:apply-templates>
      </h4>
    </xsl:when>
    <xsl:otherwise>
      <h3>
        <xsl:apply-templates select="$context" mode="m:object-title-markup">
          <xsl:with-param name="allow-anchors" select="true()"/>
        </xsl:apply-templates>
      </h3>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:bibliolist/db:title|db:bibliolist/db:info/db:title
                     |db:glosslist/db:title|db:glosslist/db:info/db:title
                     |db:blockquote/db:title|db:blockquote/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <!-- lazy -->
  <h3>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h3>
</xsl:template>

<xsl:template match="db:article/db:title|db:article/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <h2>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="db:section/db:title
                     |db:section/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="depth" select="min((count(ancestor::db:section), 5))"/>

  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <xsl:element name="h{$depth + 1}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="db:refsection/db:title|db:refsection/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="depth" select="min((count(ancestor::db:refsection), 4))"/>

  <xsl:variable name="delta" select="if (ancestor::db:article) then 2 else 1"/>

  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <xsl:element name="h{$depth + $delta}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="db:sect1/db:title|db:sect1/db:info/db:title
                     |db:refsect1/db:title|db:refsect1/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <h2>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="db:sect2/db:title|db:sect2/db:info/db:title
                     |db:refsect2/db:title|db:refsect2/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <h3>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h3>
</xsl:template>

<xsl:template match="db:sect3/db:title|db:sect3/db:info/db:title
                     |db:refsect3/db:title|db:refsect3/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <h4>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h4>
</xsl:template>

<xsl:template match="db:sect4/db:title|db:sect4/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <h5>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h5>
</xsl:template>

<xsl:template match="db:sect5/db:title|db:sect5/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <h6>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h6>
</xsl:template>

<xsl:template match="db:simplesect/db:title|db:simplesect/db:info/db:title" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <xsl:variable name="depth" as="xs:integer">
    <xsl:choose>
      <xsl:when test="ancestor::db:sect4 or ancestor::db:sect5">6</xsl:when>
      <xsl:when test="ancestor::db:sect3">5</xsl:when>
      <xsl:when test="ancestor::db:sect2">4</xsl:when>
      <xsl:when test="ancestor::db:sect1">3</xsl:when>
      <xsl:when test="ancestor::db:section">
        <xsl:value-of select="min((count(ancestor::db:section), 4)) + 2"/>
      </xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="h{$depth}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="db:figure/db:title|db:figure/db:info/db:title
                     |db:example/db:title|db:example/db:info/db:title
                     |db:table/db:title|db:table/db:info/db:title
                     |db:equation/db:title|db:equation/db:info/db:title
                     |db:procedure/db:title|db:procedure/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <div class="title">
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<xsl:template match="db:warning/db:title|db:warning/db:info/db:title
                     |db:note/db:title|db:note/db:info/db:title
                     |db:caution/db:title|db:caution/db:info/db:title
                     |db:important/db:title|db:important/db:info/db:title
                     |db:tip/db:title|db:tip/db:info/db:title
                     |db:sidebar/db:title|db:sidebar/db:info/db:title
                     |db:task/db:title|db:task/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <h3>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h3>
</xsl:template>

<xsl:template match="db:tasksummary/db:title|db:tasksummary/db:info/db:title
                     |db:taskprerequisites/db:title|db:taskprerequisites/db:info/db:title
                     |db:taskrelated/db:title|db:taskrelated/db:info/db:title
                     |db:task/db:procedure/db:title|db:task/db:procedure/db:info/db:title"
              mode="m:titlepage-mode" priority="100">
  <!-- explicit priority to disambiguate db:procedure matching -->
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <h4>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h4>
</xsl:template>

<xsl:template match="db:segmentedlist/db:title|db:segmentedlist/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <div class="title">
    <strong>
      <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
    </strong>
  </div>
</xsl:template>

<xsl:template match="db:step/db:title|db:step/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <h4>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h4>
</xsl:template>

<xsl:template match="db:qandaset/db:title|db:qandaset/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <h2>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h2>
</xsl:template>

<xsl:template match="db:qandadiv/db:title|db:qandadiv/db:info/db:title"
              mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>
  <h3>
    <xsl:apply-templates select="$context" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </h3>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:subtitle" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <xsl:variable name="depth" as="xs:integer">
    <xsl:choose>
      <xsl:when test="ancestor::db:sect4 or ancestor::db:sect5">6</xsl:when>
      <xsl:when test="ancestor::db:sect3">5</xsl:when>
      <xsl:when test="ancestor::db:sect2">4</xsl:when>
      <xsl:when test="ancestor::db:sect1">3</xsl:when>
      <xsl:when test="ancestor::db:section">
        <xsl:value-of select="min((count(ancestor::db:section), 3)) + 3"/>
      </xsl:when>
      <xsl:when test="ancestor::db:article">3</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name="h{$depth}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates select="$context" mode="m:object-subtitle-markup"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:titleabbrev" mode="m:titlepage-mode">
  <xsl:variable name="context"
                select="if (parent::db:info) then parent::db:info/parent::* else parent::*"/>

  <div class="titleabbrev">
    <xsl:apply-templates select="$context" mode="m:object-titleabbrev-markup"/>
  </div>
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
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:titlepage-mode"/>
  </div>
</xsl:template>

<!-- FIXME: othercredit deserves its own template, with gentext more like db:editor -->
<xsl:template match="db:author|db:othercredit" mode="m:titlepage-mode">
  <xsl:variable name="content" as="node()*">
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
  </xsl:variable>

  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <h3>
      <xsl:sequence select="$content"/>
    </h3>
  </div>
</xsl:template>

<xsl:template match="db:editor" mode="m:titlepage-mode">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
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
  </div>
</xsl:template>

<xsl:template match="db:copyright" mode="m:titlepage-mode">
  <xsl:apply-templates select=".">
    <xsl:with-param name="wrapper" select="'div'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:revhistory" mode="m:titlepage-mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="db:abstract" mode="m:titlepage-mode">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:choose>
      <xsl:when test="true() or parent::db:article or parent::db:info/parent::db:article">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="t:titlepage"/>
        <div>
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="db:legalnotice" mode="m:titlepage-mode">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:releaseinfo" mode="m:titlepage-mode">
  <p class="{(@role,local-name(.))[1]}">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-mode">
  <xsl:message>No m:titlepage-mode template for <xsl:value-of select="node-name(.)"/></xsl:message>
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()" mode="m:titlepage-mode">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:titlepage-before-recto-mode">
  <xsl:param name="context" as="element()?" select="()"/>
  <xsl:apply-templates select="." mode="m:titlepage-mode">
    <xsl:with-param name="context" select="$context"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-recto-mode">
  <xsl:param name="context" as="element()?" select="()"/>
  <xsl:apply-templates select="." mode="m:titlepage-mode">
    <xsl:with-param name="context" select="$context"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-separator-mode">
  <xsl:param name="context" as="element()?" select="()"/>
  <xsl:apply-templates select="." mode="m:titlepage-mode">
    <xsl:with-param name="context" select="$context"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-before-verso-mode">
  <xsl:param name="context" as="element()?" select="()"/>
  <xsl:apply-templates select="." mode="m:titlepage-mode">
    <xsl:with-param name="context" select="$context"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-verso-mode">
  <xsl:param name="context" as="element()?" select="()"/>
  <xsl:apply-templates select="." mode="m:titlepage-mode">
    <xsl:with-param name="context" select="$context"/>
  </xsl:apply-templates>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:info|db:title|db:subtitle|db:titleabbrev">
  <!-- nop -->
</xsl:template>

</xsl:stylesheet>
