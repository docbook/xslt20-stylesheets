<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f h m t xs"
                version="2.0">

<xsl:import href="../../base/html/final-pass.xsl"/>

<xsl:param name="speaker.notes" select="0"/>
<xsl:param name="localStorage.key" select="'slideno'"/>
<xsl:param name="group.toc" select="0"/>
<xsl:param name="resource.slide" select="$resource.root"/>

<xsl:param name="cdn.jquery"
           select="'http://code.jquery.com/jquery-1.6.3.min.js'"/>
<xsl:param name="cdn.jqueryui"
           select="'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js'"/>
<xsl:param name="cdn.jqueryui.css"
           select="'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/ui-lightness/jquery-ui.css'"/>

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

      <xsl:call-template name="t:slides.javascript"/>
      <xsl:call-template name="t:slides.css"/>

      <xsl:apply-templates select="db:info/h:*"/>
    </head>
    <body>
      <div class="foil titlefoil">
        <xsl:apply-templates select="db:info"/>
        <xsl:call-template name="t:title-footer"/>
      </div>

      <xsl:call-template name="toc"/>

      <xsl:apply-templates select="db:foil|db:foilgroup"/>
    </body>
  </html>
</xsl:template>

<xsl:template name="t:title-footer">
  <div class="footer">
    <div class="content">
      <xsl:apply-templates select="/db:slides/db:info/db:copyright"/>
    </div>
  </div>
</xsl:template>

<xsl:template name="t:slide-footer">
  <div class="footer">
    <div class="content">
      <span class="foilnumber">
        <xsl:text>Slide </xsl:text>
        <xsl:value-of select="f:slideno(.)"/>
      </span>
      <xsl:text>&#160;&#160;</xsl:text>
      <xsl:apply-templates select="/db:slides/db:info/db:copyright"/>
    </div>
  </div>
</xsl:template>

<xsl:template name="t:slides.javascript">
  <script type="text/javascript" language="javascript"
          src="{$cdn.jquery}"/>
  <script type="text/javascript" language="javascript"
          src="{$cdn.jqueryui}"/>

  <script type="text/javascript" language="javascript"
          src="{$resource.slide}js/jquery-timers-1.2.js" />
  <script type="text/javascript" language="javascript"
          src="{$resource.slide}js/jquery.ba-hashchange.min.js" />
  <script type="text/javascript" language="javascript"
          src="{$resource.slide}../slides/js/slides.js" />
</xsl:template>

<xsl:template name="t:slides.css">
  <link type="text/css" rel="stylesheet"
        href="{$cdn.jqueryui.css}"/>
  <link type="text/css" rel="stylesheet"
        href="{$resource.slide}../slides/css/slides.css"/>
</xsl:template>

<xsl:template name="toc">
  <div class="foil">
    <div class="page">
      <div class="header">
        <h1>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'tableofcontents'"/>
          </xsl:call-template>
        </h1>
      </div>
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
    </div>
    <xsl:call-template name="t:title-footer"/>
  </div>
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
  <div class="page">
    <div class="header">
      <h1><xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/></h1>
    </div>
    <div class="body">
      <div class="shownav">
        <img src="{$resource.slide}img/prev.gif" alt="[Prev]"/>
        <img src="{$resource.slide}img/next.gif" alt="[Next]"/>
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
  </div>
</xsl:template>

<xsl:template match="db:foilgroup">
  <div class="foil titlefoil foilgroup">
    <div class="page">
      <div class="header">
        <h1>
          <xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/>
        </h1>
      </div>
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
    </div>
    <xsl:call-template name="t:slide-footer"/>
  </div>

  <xsl:apply-templates select="db:foil"/>
</xsl:template>

<xsl:template match="db:foil">
  <div class="{ if (parent::db:slides and preceding-sibling::db:foilgroup)
                then 'foil closingfoil'
                else 'foil' }">
    <div class="page">
      <div class="header">
        <h1>
          <xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/>
        </h1>
      </div>
      <div class="body">
        <xsl:call-template name="t:clicknav">
          <xsl:with-param name="prev" select="concat('#', f:slideno(.)-1)"/>
          <xsl:with-param name="next"
                          select="if (following::db:foil) then concat('#', f:slideno(.)+1) else ()"/>
        </xsl:call-template>

        <div class="foil-body">
            <xsl:apply-templates select="*[not(self::db:title) and not(self::db:speakernotes)]"/>
            <xsl:if test=".//db:footnote">
              <div class="footnote">
                <sup>*</sup>
                <xsl:apply-templates select=".//db:footnote/db:para/node()"/>
              </div>
            </xsl:if>
        </div>

        <div class="foil-notes">
          <xsl:variable name="foilinset" as="element(h:div)">
            <div class="foilinset">
              <xsl:apply-templates select="*[not(self::db:title) and not(self::db:speakernotes)]"/>
            </div>
          </xsl:variable>

          <xsl:apply-templates select="$foilinset" mode="trim-reveal"/>

          <xsl:choose>
            <xsl:when test="db:speakernotes">
              <xsl:apply-templates select="db:speakernotes"/>
            </xsl:when>
            <xsl:otherwise>
              <p>No speaker notes for this foil.</p>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
    </div>
    <xsl:call-template name="t:slide-footer"/>
  </div>
</xsl:template>

<xsl:template match="db:speakernotes">
  <div class="speakernotes">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="h:*">
  <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="element()" mode="trim-reveal">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()" mode="trim-reveal"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@class" mode="trim-reveal" priority="10">
  <xsl:attribute name="class">
    <xsl:value-of select="replace(., 'reveal1?', '')"/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()"
              mode="trim-reveal">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:clicknav">
  <xsl:param name="prev" select="()"/>
  <xsl:param name="next" select="()"/>
  <div class="clicknav">
    <xsl:choose>
      <xsl:when test="exists($prev)">
        <a href="javascript:clicknav('prev')">
          <img src="{$resource.slide}img/transparent.gif" alt="[Prev]"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$resource.slide}img/transparent.gif" alt="[Prev]"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="exists($next)">
        <a href="javascript:clicknav('next')">
          <img src="{$resource.slide}img/transparent.gif" alt="[Next]"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$resource.slide}img/transparent.gif" alt="[Next]"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

</xsl:stylesheet>

