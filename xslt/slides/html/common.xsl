<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db f h m mp t xs"
                version="2.0">

<xsl:import href="../../base/html/final-pass.xsl"/>

<xsl:param name="speaker.notes" select="0"/>
<xsl:param name="localStorage.key" select="'slideno'"/>
<xsl:param name="group.toc" select="0"/>

<xsl:param name="root.elements">
  <db:slides/>
</xsl:param>

<xsl:template name="t:user-localization-data">
  <i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
      <l:gentext key="tableofcontents" text="Agenda"/>
    </l:l10n>
  </i18n>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:slides">
  <html>
    <head>
      <meta charset="utf-8"/>
      <meta name="localStorage.key" content="{$localStorage.key}"/>
      <title>
        <xsl:value-of select="db:info/db:title/node() except db:info/db:title/db:footnote"/>
      </title>

      <xsl:apply-templates select="." mode="mp:javascript-head"/>
      <xsl:apply-templates select="." mode="m:javascript-head"/>
      <xsl:apply-templates select="." mode="mp:css"/>
      <xsl:apply-templates select="." mode="m:css"/>

      <xsl:apply-templates select="db:info/h:*"/>
    </head>
    <body>
      <section class="foil titlefoil">
        <xsl:apply-templates select="db:info"/>
        <xsl:call-template name="t:title-footer"/>
      </section>

      <xsl:if test="not(f:pi(/processing-instruction('dbhtml'), 'toc') = 'false')">
        <xsl:call-template name="toc"/>
      </xsl:if>

      <xsl:apply-templates select="db:foil|db:foilgroup"/>

      <xsl:apply-templates select="." mode="mp:javascript-body"/>
      <xsl:apply-templates select="." mode="m:javascript-body"/>
    </body>
  </html>
</xsl:template>

<xsl:template name="t:title-footer">
  <footer>
    <div class="content">
      <xsl:apply-templates select="/db:slides/db:info/db:copyright"/>
    </div>
  </footer>
</xsl:template>

<xsl:template name="t:slide-footer">
  <footer>
    <div class="content">
      <span class="foilnumber">
        <xsl:text>Slide </xsl:text>
        <xsl:value-of select="f:slideno(.)"/>
      </span>
      <xsl:text>&#160;&#160;</xsl:text>
      <xsl:apply-templates select="/db:slides/db:info/db:copyright"/>
    </div>
  </footer>
</xsl:template>

<xsl:function name="f:include-jquery">
  <xsl:param name="node"/>

  <xsl:sequence select="true()"/>
</xsl:function>

<xsl:function name="f:include-jqueryui">
  <xsl:param name="node"/>

  <xsl:sequence select="true()"/>
</xsl:function>

<xsl:template match="*" mode="mp:javascript-body">
  <xsl:apply-imports/>
  <script type="text/javascript" language="javascript"
          src="{$resource.root}js/jquery-timers-1.2.js" />
  <script type="text/javascript" language="javascript"
          src="{$resource.root}js/jquery.ba-hashchange.min.js" />
  <script type="text/javascript" language="javascript"
          src="{$resource.root}js/slides.js" />
</xsl:template>

<xsl:template match="*" mode="mp:css">
  <xsl:apply-imports/>
  <link type="text/css" rel="stylesheet"
        href="{$cdn.jqueryui.css}" media="screen"/>
  <link type="text/css" rel="stylesheet"
        href="{$resource.root}css/slides.css"/>
</xsl:template>

<xsl:template name="toc">
  <section class="foil">
    <article class="page">
      <header class="header">
        <div class="header-content">
          <h1>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'tableofcontents'"/>
            </xsl:call-template>
          </h1>
        </div>
      </header>
      <div class="body">
        <xsl:call-template name="t:clicknav">
          <xsl:with-param name="prev" select="'#'"/>
          <xsl:with-param name="next" select="'#1'"/>
        </xsl:call-template>
        <ul class="toc">
          <xsl:for-each select="db:foil|db:foilgroup">
            <xsl:if test="f:include-in-toc(.)">
              <li>
                <a href="#{f:slideno(.)}">
                  <xsl:value-of select="(db:info/db:titleabbrev,db:titleabbrev,
                                         db:info/db:title|db:title)[1]"/>
                </a>
              </li>
            </xsl:if>
          </xsl:for-each>
        </ul>
      </div>
    </article>
    <xsl:call-template name="t:title-footer"/>
  </section>
</xsl:template>

<xsl:function name="f:slideno" as="xs:integer">
  <xsl:param name="foil"/>

  <xsl:value-of select="count($foil/preceding::db:foil)
                        + count($foil/preceding::db:foilgroup)
                        + count($foil/parent::db:foilgroup)
                        + 1"/>
</xsl:function>

<xsl:function name="f:include-in-toc" as="xs:boolean">
  <xsl:param name="foil"/>
  <xsl:variable name="pfoil" select="($foil/preceding-sibling::db:foil[1]
                                      |$foil/preceding-sibling::db:foilgroup[1])[last()]"/>

  <xsl:variable name="title"
                select="string(($foil/db:titleabbrev,$foil/db:info/db:titleabbrev,
                                $foil/db:title,$foil/db:info/db:title)[1])"/>
  <xsl:variable name="ptitle"
                select="string(($pfoil/db:titleabbrev,$pfoil/db:info/db:titleabbrev,
                                $pfoil/db:title,$pfoil/db:info/db:title)[1])"/>

  <xsl:value-of select="$title != $ptitle"/>
</xsl:function>

<xsl:template match="db:slides/db:info">
  <article class="page">
    <header>
      <div class="header-content">
        <h1><xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/></h1>
      </div>
    </header>
    <div class="body">
      <div class="shownav">
        <img src="{$resource.root}img/slides/prev.gif" alt="[Prev]"/>
        <img src="{$resource.root}img/slides/next.gif" alt="[Next]"/>
      </div>
      <xsl:call-template name="t:clicknav">
        <xsl:with-param name="next" select="'#toc'"/>
      </xsl:call-template>
      <xsl:apply-templates select="db:author/db:personname"/>
      <br/>
      <xsl:apply-templates select="db:author/db:affiliation/db:orgname"/>
      <br/>
      <xsl:apply-templates select="db:pubdate"/>
    </div>
  </article>
</xsl:template>

<xsl:template match="db:foilgroup">
  <section class="foil titlefoil foilgroup">
    <xsl:if test="@xml:id">
      <xsl:attribute name="id" select="@xml:id"/>
    </xsl:if>
    <article class="page">
      <header>
        <div class="header-content">
          <h1>
            <xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/>
          </h1>
        </div>
      </header>
      <div class="body">
        <xsl:call-template name="t:clicknav">
          <xsl:with-param name="prev" select="concat('#', f:slideno(.)-1)"/>
          <xsl:with-param name="next" select="concat('#', f:slideno(.)+1)"/>
        </xsl:call-template>
        <xsl:apply-templates select="*[not(self::db:title) and not(self::db:foil)]"/>

        <xsl:if test="$group.toc != 0">
          <ul class="toc">
            <xsl:for-each select="db:foil|db:foilgroup">
              <li>
                <a href="#{f:slideno(.)}">
                  <xsl:value-of select="db:title"/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </div>
    </article>
    <xsl:call-template name="t:slide-footer"/>
  </section>

  <xsl:apply-templates select="db:foil"/>
</xsl:template>

<xsl:template match="db:speakernotes">
  <aside class="speakernotes">
    <xsl:apply-templates/>
  </aside>
</xsl:template>

<xsl:template match="h:*">
  <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:clicknav">
  <xsl:param name="prev" select="()"/>
  <xsl:param name="next" select="()"/>
  <nav class="clicknav">
    <xsl:choose>
      <xsl:when test="exists($prev)">
        <a href="javascript:clicknav('prev')">
          <img src="{$resource.root}img/slides/transparent.gif" alt="[Prev]"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$resource.root}img/slides/transparent.gif" alt="[Prev]"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="exists($next)">
        <a href="javascript:clicknav('next')">
          <img src="{$resource.root}img/slides/transparent.gif" alt="[Next]"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$resource.root}img/slides/transparent.gif" alt="[Next]"/>
      </xsl:otherwise>
    </xsl:choose>
  </nav>
</xsl:template>

</xsl:stylesheet>

