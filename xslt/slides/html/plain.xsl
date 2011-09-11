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

<xsl:import href="../../base/html/docbook.xsl"/>

<xsl:param name="group-toc" select="0"/>

<xsl:param name="resource-root" select="'http://docbook.github.com/latest/slides/'"/>

<xsl:param name="root.elements">
  <db:slides/>
</xsl:param>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:slides">
  <html>
    <head>
      <!-- assume we're going to serialize as utf-8 -->
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <title>
        <xsl:value-of select="db:info/db:title"/>
      </title>

      <script type="text/javascript" language="javascript"
              src="http://code.jquery.com/jquery-1.6.3.min.js"/>
      <script type="text/javascript" language="javascript"
              src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"/>
      <link type="text/css" rel="stylesheet"
            href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/themes/ui-lightness/jquery-ui.css"/>

      <script type="text/javascript" language="javascript"
              src="{$resource-root}js/jquery-timers-1.2.js" />
      <script type="text/javascript" language="javascript"
              src="{$resource-root}js/jquery.ba-hashchange.min.js" />
      <script type="text/javascript" language="javascript"
              src="{$resource-root}js/slides.js" />
      <link type="text/css" rel="stylesheet"
            href="{$resource-root}css/slides.css"/>

      <xsl:apply-templates select="db:info/h:*"/>
    </head>
    <body>
      <div class="foil titlefoil">
        <xsl:apply-templates select="db:info"/>
        <div class="footer">
          <div class="content">
            <xsl:apply-templates select="/db:slides/db:info/db:copyright"/>
          </div>
        </div>
      </div>

      <xsl:call-template name="toc"/>

      <xsl:apply-templates select="db:foil|db:foilgroup"/>
    </body>
  </html>
</xsl:template>

<xsl:template name="toc">
  <div class="foil">
    <div class="page">
      <div class="header">
        <h1>Table of contents</h1>
      </div>
      <div class="body">
        <xsl:call-template name="t:clicknav">
          <xsl:with-param name="prev" select="'#'"/>
          <xsl:with-param name="next" select="'#1'"/>
        </xsl:call-template>
        <ul class="toc">
          <xsl:for-each select="db:foil|db:foilgroup">
            <li>
              <a href="#{f:slideno(.)}">
                <xsl:value-of select="db:info/db:title|db:title"/>
              </a>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </div>
    <div class="footer">
      <div class="content">
        <xsl:apply-templates select="/db:slides/db:info/db:copyright"/>
      </div>
    </div>
  </div>
</xsl:template>

<xsl:function name="f:slideno" as="xs:integer">
  <xsl:param name="foil"/>

  <xsl:value-of select="count($foil/preceding::db:foil)
                        + count($foil/preceding::db:foilgroup)
                        + count($foil/parent::db:foilgroup)
                        + 1"/>
</xsl:function>

<xsl:template match="db:slides/db:info">
  <div class="page">
    <div class="header">
      <h1><xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/></h1>
    </div>
    <div class="body">
      <div class="shownav">
        <img src="{$resource-root}img/prev.png" alt="[Prev]"/>
        <img src="{$resource-root}img/next.png" alt="[Next]"/>
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
  <div class="foil foilgroup">
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

        <xsl:if test="$group-toc != 0">
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
  </div>

  <xsl:apply-templates select="db:foil"/>
</xsl:template>

<xsl:template match="db:foil">
  <div class="{ if (following::db:foil or parent::db:foilgroup) then 'foil' else 'foil foilgroup' }">
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
        <xsl:apply-templates select="*[not(self::db:title)]"/>
      </div>
    </div>
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
  </div>
</xsl:template>

<xsl:template match="db:tag[@class='xmlpi']">
  <span class="pi">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:text>&lt;?</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>?&gt;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:tag[@class='starttag']">
  <!-- hack -->
  <span class="{if (starts-with(., 'xsl:')) then 'xslt' else 'el'}">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:tag[@class='emptytag']">
  <span class="{if (starts-with(., 'xsl:')) then 'xslt' else 'el'}">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>/&gt;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:tag[@class='endtag']">
  <span class="{if (starts-with(., 'xsl:')) then 'xslt' else 'el'}">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:text>&lt;/</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:tag[@class='attribute']">
  <span class="att">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:tag[@class='attvalue']">
  <span class="attval">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:tag[@class='genentity']">
  <span class="ent">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:text>&amp;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:methodname">
  <span class="func">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:varname">
  <span class="var">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:parameter">
  <span class="param">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:constant">
  <span class="const">
    <xsl:if test="@xml:id"><xml:attribute name="id" select="@xml:id"/></xsl:if>
    <xsl:apply-templates/>
  </span>
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
  <div class="clicknav">
    <xsl:choose>
      <xsl:when test="exists($prev)">
        <a href="javascript:clicknav('prev')">
          <img src="{$resource-root}img/transparent.gif" alt="[Prev]"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$resource-root}img/transparent.gif" alt="[Prev]"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="exists($next)">
        <a href="javascript:clicknav('next')">
          <img src="{$resource-root}img/transparent.gif" alt="[Next]"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$resource-root}img/transparent.gif" alt="[Next]"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

</xsl:stylesheet>

