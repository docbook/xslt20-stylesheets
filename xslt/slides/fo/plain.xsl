<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                exclude-result-prefixes="f t db xs m"
                version="2.0">

<xsl:import href="../../base/fo/final-pass.xsl"/>

<xsl:param name="group-toc" select="0"/>

<xsl:param name="slide.font.family">sans-serif</xsl:param>
<xsl:param name="slide.title.font.family">sans-serif</xsl:param>
<xsl:param name="foil.title.master">28</xsl:param>
<xsl:param name="body.font.size">24pt</xsl:param>
<xsl:param name="resource.slide" select="$resource.root"/>

<xsl:param name="footnote.number.symbols" select="'*†'"/>

<xsl:attribute-set name="footnote.properties">
  <xsl:attribute name="font-size" select="'10pt'"/>
</xsl:attribute-set>

<xsl:attribute-set name="footnote.block.properties">
  <xsl:attribute name="margin-left" select="'0.5in'"/>
</xsl:attribute-set>

<!-- Inconsistant use of point size? -->
<xsl:param name="foil.title.size">
  <xsl:value-of select="$foil.title.master"/><xsl:text>pt</xsl:text>
</xsl:param>

<xsl:attribute-set name="foilgroup.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="foil.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
  <xsl:attribute name="margin-{$direction.align.start}">1in</xsl:attribute>
  <xsl:attribute name="margin-{$direction.align.end}">1in</xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.size"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="foil.subtitle.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.title.font.family"/>
  </xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:value-of select="$foil.title.master * 0.8"/><xsl:text>pt</xsl:text>
  </xsl:attribute>
  <xsl:attribute name="space-after">12pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="running.foot.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
  <xsl:attribute name="font-size">14pt</xsl:attribute>
  <xsl:attribute name="color">#9F9F9F</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="speakernote.properties">
  <xsl:attribute name="font-family">Times Roman</xsl:attribute>
  <xsl:attribute name="font-style">italic</xsl:attribute>
  <xsl:attribute name="font-size">12pt</xsl:attribute>
  <xsl:attribute name="font-weight">normal</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="slides.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$slide.font.family"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:param name="alignment" select="'start'"/>

<xsl:param name="preferred.mediaobject.role" select="'print'"/>

<xsl:param name="page.orientation" select="'landscape'"/>

<xsl:param name="body.font.master" select="24"/>

<xsl:attribute-set name="formal.title.properties"
                   use-attribute-sets="normal.para.spacing">
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.2"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
  <xsl:attribute name="space-after.minimum">8pt</xsl:attribute>
  <xsl:attribute name="space-after.optimum">6pt</xsl:attribute>
  <xsl:attribute name="space-after.maximum">10pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="list.block.spacing">
  <xsl:attribute name="space-before.optimum">12pt</xsl:attribute>
  <xsl:attribute name="space-before.minimum">8pt</xsl:attribute>
  <xsl:attribute name="space-before.maximum">14pt</xsl:attribute>
  <xsl:attribute name="space-after.optimum">0pt</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
  <xsl:attribute name="space-after.maximum">0pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="list.item.spacing">
  <xsl:attribute name="space-before.optimum">6pt</xsl:attribute>
  <xsl:attribute name="space-before.minimum">4pt</xsl:attribute>
  <xsl:attribute name="space-before.maximum">8pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="normal.para.spacing">
  <xsl:attribute name="space-before.optimum">8pt</xsl:attribute>
  <xsl:attribute name="space-before.minimum">6pt</xsl:attribute>
  <xsl:attribute name="space-before.maximum">10pt</xsl:attribute>
</xsl:attribute-set>

<!-- ============================================================ -->

<xsl:param name="page.margin.top" select="'0in'"/>
<xsl:param name="region.before.extent" select="'0.75in'"/>
<xsl:param name="body.margin.top" select="'1in'"/>

<xsl:param name="region.after.extent" select="'0.75in'"/>
<xsl:param name="body.margin.bottom" select="'0.5in'"/>
<xsl:param name="page.margin.bottom" select="'0in'"/>

<xsl:param name="page.margin.inner" select="'0in'"/>
<xsl:param name="page.margin.outer" select="'0in'"/>
<xsl:param name="column.count.body" select="1"/>

<!-- ============================================================ -->

<xsl:template name="t:user-localization-data">
  <i18n xmlns="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0" language="en">
      <l:gentext key="Continued" text="(Continued)"/>
      <l:context name="title">
        <l:template name="slides" text="%t"/>
        <l:template name="foilgroup" text="%t"/>
        <l:template name="foil" text="%t"/>
      </l:context>
      <l:context name="subtitle">
        <l:template name="slides" text="%s"/>
        <l:template name="foilgroup" text="%s"/>
        <l:template name="foil" text="%s"/>
      </l:context>
      <l:context name="datetime">
        <l:template name="format">[D01] [MNn] [Y0001]</l:template>
      </l:context>
    </l:l10n>
  </i18n>
</xsl:template>

<xsl:param name="root.elements">
  <db:slides/>
</xsl:param>

<xsl:template name="t:user-titlepage-templates" as="element()">
  <templates-list xmlns="http://docbook.org/xslt/titlepage-templates">

    <templates name="slides">
      <titlepage>
        <fo:block font-family="sans-serif" text-align="center" font-size="20pt">
          <fo:block margin-top="3in" line-height="2" font-size="36pt">
            <db:title/>
          </fo:block>
          <fo:block>
            <db:pubdate/>
          </fo:block>
          <fo:block margin-top="1in">
            <db:subtitle/>
          </fo:block>
          <fo:block>
            <db:author/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="foilgroup">
      <titlepage/>
    </templates>

    <templates name="foil">
      <titlepage/>
    </templates>
  </templates-list>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:user-pagemasters">
  <fo:simple-page-master master-name="slides-titlepage-master"
                         page-width="{$page.width}"
                         page-height="{$page.height}"
                         margin-top="{$page.margin.top}"
                         margin-bottom="{$page.margin.bottom}"
                         margin-left="{$page.margin.inner}"
                         margin-right="{$page.margin.outer}">
    <fo:region-body margin-bottom="0pt"
                    margin-top="0pt"
                    column-count="{$column.count.body}"
                    background-image="url({$resource.slide}print/title.png)"
                    background-attachment="fixed"
                    background-repeat="no-repeat"
                    background-position-horizontal="left"
                    background-position-vertical="top">
    </fo:region-body>
    <fo:region-after region-name="xsl-region-after-foil"
                     extent="{$region.after.extent}"
                     display-align="after"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="slides-foil-master"
                         page-width="{$page.width}"
                         page-height="{$page.height}"
                         margin-top="{$page.margin.top}"
                         margin-bottom="{$page.margin.bottom}"
                         margin-left="{$page.margin.inner}"
                         margin-right="{$page.margin.outer}">
    <fo:region-body margin-bottom="0.75in"
                    margin-top="1.75in"
                    column-count="{$column.count.body}">
    </fo:region-body>
    <fo:region-before region-name="xsl-region-before-foil"
                      extent="1.5in"
                      display-align="before"
                      background-image="url({$resource.slide}print/foil.png)"
                      background-attachment="fixed"
                      background-repeat="no-repeat"
                      background-position-horizontal="left"
                      background-position-vertical="top"/>
    <fo:region-after region-name="xsl-region-after-foil"
                     extent="{$region.after.extent}"
                     display-align="after"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="slides-foil-continued-master"
                         page-width="{$page.width}"
                         page-height="{$page.height}"
                         margin-top="{$page.margin.top}"
                         margin-bottom="{$page.margin.bottom}"
                         margin-left="{$page.margin.inner}"
                         margin-right="{$page.margin.outer}">
    <fo:region-body margin-bottom="0.75in"
                    margin-top="1.75in"
                    column-count="{$column.count.body}">
    </fo:region-body>
    <fo:region-before region-name="xsl-region-before-foil-continued"
                      extent="1.5in"
                      display-align="before"
                      background-image="url({$resource.slide}print/foil.png)"
                      background-attachment="fixed"
                      background-repeat="no-repeat"
                      background-position-horizontal="left"
                      background-position-vertical="top"/>
    <fo:region-after region-name="xsl-region-after-foil-continued"
                     extent="{$region.after.extent}"
                     display-align="after"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="slides-break-master"
                         page-width="{$page.width}"
                         page-height="{$page.height}"
                         margin-top="{$page.margin.top}"
                         margin-bottom="{$page.margin.bottom}"
                         margin-left="{$page.margin.inner}"
                         margin-right="{$page.margin.outer}">
    <fo:region-body margin-bottom="0pt"
                    margin-top="0pt"
                    column-count="{$column.count.body}"
                    background-image="url({$resource.slide}print/group.png)"
                    background-attachment="fixed"
                    background-repeat="no-repeat"
                    background-position-horizontal="left"
                    background-position-vertical="top"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="slides-titlepage">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="slides-titlepage-master"
                                            odd-or-even="any"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <fo:page-sequence-master master-name="slides-foil">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="slides-foil-master"
                                            page-position="first"
                                            odd-or-even="any"/>
      <fo:conditional-page-master-reference master-reference="slides-foil-continued-master"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <fo:page-sequence-master master-name="slides-foilgroup">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference master-reference="slides-break-master"
                                            page-position="first"
                                            odd-or-even="any"/>
      <fo:conditional-page-master-reference master-reference="slides-foil-continued-master"
                                            page-position="rest"
                                            odd-or-even="any"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>
</xsl:template>

<xsl:template match="*" mode="m:running-head-mode">
  <xsl:param name="master-reference" select="'unknown'"/>
  <!-- use the foilgroup title if there is one -->
  <fo:static-content flow-name="xsl-region-before-foil">
    <fo:block font-size="{$foil.title.size}"
              margin-top="0.5in"
              text-align="center"
              font-family="{$slide.title.font.family}">
      <xsl:apply-templates select="db:title" mode="m:titlepage-mode"/>
    </fo:block>
  </fo:static-content>

  <fo:static-content flow-name="xsl-region-before-foil-continued">
    <fo:block font-size="{$foil.title.size}"
              margin-top="0.5in"
              text-align="center"
              font-family="{$slide.title.font.family}">
      <fo:block>
        <xsl:apply-templates select="db:title" mode="m:titlepage-mode"/>
      </fo:block>
      <fo:block font-size="16pt">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Continued'"/>
        </xsl:call-template>
      </fo:block>
    </fo:block>
  </fo:static-content>

  <xsl:call-template name="t:footnote-separator"/>
</xsl:template>

<xsl:template match="*" mode="m:running-foot-mode">
  <xsl:param name="master-reference" select="'unknown'"/>

  <xsl:variable name="content">
    <fo:block>
      <fo:block-container height="0.75in"
                          background-image="url({$resource.slide}print/footer.png)"
                          background-attachment="fixed"
                          background-repeat="no-repeat"
                          background-position-horizontal="left"
                          background-position-vertical="top">
        <fo:block font-size="10pt" margin-left="0.5in" padding-top="0.25in">
          <xsl:text>Slide </xsl:text>
          <fo:page-number/>
          <xsl:text>&#160;&#160;</xsl:text>
          <xsl:apply-templates select="/db:slides/db:info/db:copyright"/>
        </fo:block>
      </fo:block-container>
    </fo:block>
  </xsl:variable>

  <fo:static-content flow-name="xsl-region-after-foil">
    <xsl:sequence select="$content"/>
  </fo:static-content>

  <fo:static-content flow-name="xsl-region-after-foil-continued">
    <xsl:sequence select="$content"/>
  </fo:static-content>
</xsl:template>

<xsl:template match="db:slides">
  <xsl:variable name="master-reference" select="'slides-titlepage'"/>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}"
                    force-page-count="no-force">
    <xsl:attribute name="language" select="f:l10n-language(.)"/>

    <fo:static-content flow-name="xsl-region-after-foil">
      <fo:block>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-number="1" column-width="33%"/>
          <fo:table-column column-number="2" column-width="34%"/>
          <fo:table-column column-number="3" column-width="33%"/>
          <fo:table-body>
            <fo:table-row height="0.5in">
              <fo:table-cell text-align="left" display-align="center">
                <fo:block>
                  <!-- nop -->
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left" display-align="center">
                <fo:block>
                  <!-- nop -->
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="right" display-align="center">
                <fo:block font-size="10pt" margin-right="0.25in">
                  <!-- nop -->
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:static-content>

    <fo:flow flow-name="xsl-region-body">
      <fo:block>
        <xsl:call-template name="t:id">
          <xsl:with-param name="force" select="1"/>
        </xsl:call-template>

        <xsl:call-template name="t:titlepage"/>
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
  <xsl:apply-templates select="db:foil|db:foilgroup"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:author" mode="m:titlepage-mode">
  <fo:block>
    <xsl:apply-templates select="db:personname"/>
  </fo:block>
  <fo:block>
    <xsl:value-of select="db:affiliation/db:orgname"/>
  </fo:block>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:foilgroup">
  <xsl:variable name="master-reference" select="'slides-foilgroup'"/>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}">
    <xsl:if test="empty(preceding-sibling::db:foilgroup) and empty(preceding-sibling::db:foil)">
      <xsl:attribute name="initial-page-number" select="1"/>
    </xsl:if>

    <xsl:call-template name="t:id">
      <xsl:with-param name="force" select="1"/>
    </xsl:call-template>
    <xsl:attribute name="language" select="f:l10n-language(.)"/>

    <xsl:apply-templates select="." mode="m:running-head-mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="m:running-foot-mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>

    <fo:flow flow-name="xsl-region-body">
      <fo:block xsl:use-attribute-sets="foil.properties" padding-top="3.25in">
        <fo:block font-size="30pt">
          <xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/>
        </fo:block>
        <xsl:apply-templates select="* except db:foil"/>

        <xsl:if test="$group-toc != 0">
          <xsl:variable name="toc" as="element(db:itemizedlist)">
            <db:itemizedlist>
              <xsl:for-each select="db:foil">
                <db:listitem>
                  <db:para>
                    <xsl:apply-templates select="(db:title|db:info/db:title)[1]/node()"/>
                  </db:para>
                </db:listitem>
              </xsl:for-each>
            </db:itemizedlist>
          </xsl:variable>
          <xsl:apply-templates select="$toc"/>
        </xsl:if>
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
  <xsl:apply-templates select="db:foil"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:foil[following::db:foil]" priority="100">
  <xsl:variable name="master-reference" select="'slides-foil'"/>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}">
    <xsl:if test="empty(preceding::db:foil) and empty(parent::db:foilgroup)">
      <xsl:attribute name="initial-page-number" select="1"/>
    </xsl:if>

    <xsl:call-template name="t:id">
      <xsl:with-param name="force" select="1"/>
    </xsl:call-template>
    <xsl:attribute name="language" select="f:l10n-language(.)"/>

    <xsl:apply-templates select="." mode="m:running-head-mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="m:running-foot-mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>

    <fo:flow flow-name="xsl-region-body">
      <fo:block>
        <xsl:call-template name="t:titlepage"/>
	<fo:block xsl:use-attribute-sets="foil.properties">
          <xsl:apply-templates/>
        </fo:block>
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="db:foil">
  <!-- the last foil -->
  <xsl:variable name="master-reference" select="'slides-foilgroup'"/>

  <fo:page-sequence hyphenate="{$hyphenate}"
                    master-reference="{$master-reference}">
    <xsl:if test="empty(preceding-sibling::db:foilgroup) and empty(preceding-sibling::db:foil)">
      <xsl:attribute name="initial-page-number" select="1"/>
    </xsl:if>

    <xsl:call-template name="t:id">
      <xsl:with-param name="force" select="1"/>
    </xsl:call-template>
    <xsl:attribute name="language" select="f:l10n-language(.)"/>

    <xsl:apply-templates select="." mode="m:running-head-mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="m:running-foot-mode">
      <xsl:with-param name="master-reference" select="$master-reference"/>
    </xsl:apply-templates>

    <fo:flow flow-name="xsl-region-body">
      <fo:block xsl:use-attribute-sets="foil.properties" padding-top="3.25in">
        <fo:block font-size="30pt">
          <xsl:apply-templates select="db:info/db:title/node()|db:title/node()"/>
        </fo:block>
        <xsl:apply-templates select="* except db:foil"/>
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:slides" mode="m:label-markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:speakernotes">
  <fo:block xsl:use-attribute-sets="speakernote.properties">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- ============================================================ -->
<!-- Bookmarks -->

<!-- XEP -->

<xsl:template match="db:slides|db:foilgroup|db:foil[not(@role) or @role != 'ENDTITLE']"
              mode="xep.outline">
  <xsl:variable name="id" as="xs:string">
    <xsl:call-template name="t:id"/>
  </xsl:variable>
  <xsl:variable name="bookmark-label">
    <xsl:apply-templates select="." mode="m:object-title-markup"/>
  </xsl:variable>

  <!-- Put the root element bookmark at the same level as its children -->
  <!-- If the object is a set or book, generate a bookmark for the toc -->

  <xsl:choose>
    <xsl:when test="parent::*">
      <rx:bookmark internal-destination="{$id}">
        <rx:bookmark-label>
          <xsl:value-of select="$bookmark-label"/>
        </rx:bookmark-label>
        <xsl:apply-templates select="*" mode="xep.outline"/>
      </rx:bookmark>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$bookmark-label != ''">
        <rx:bookmark internal-destination="{$id}">
          <rx:bookmark-label>
            <xsl:value-of select="$bookmark-label"/>
          </rx:bookmark-label>
        </rx:bookmark>
      </xsl:if>

      <xsl:apply-templates select="*" mode="xep.outline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Handling of xrefs -->

<xsl:template match="db:foil|db:foilgroup" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*[@role='reveal1']" priority="1000">
  <xsl:if test="not(following-sibling::*[@role='reveal1'])">
    <xsl:next-match/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:footnote" mode="m:footnote-number">
  <xsl:choose>
    <xsl:when test="ancestor::db:table|ancestor::db:informaltable">
      <xsl:next-match/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="relevant" as="element(db:footnote)+">
        <xsl:choose>
          <xsl:when test="ancestor::db:foil">
            <xsl:sequence select="ancestor::db:foil[1]//db:footnote"/>
          </xsl:when>
          <xsl:when test="ancestor::db:foilgroup">
            <xsl:sequence select="ancestor::db:foilgroup[1]//db:footnote"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="//db:footnote"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="pfoot" select="preceding::db:footnote[not(@label)] intersect $relevant"/>
      <xsl:variable name="ptfoot" select="(preceding::db:tgroup//db:footnote
                                          |preceding::db:tr//db:footnote) intersect $relevant"/>
      <xsl:variable name="fnum" select="count($pfoot) - count($ptfoot) + 1"/>

      <xsl:choose>
	<xsl:when test="string-length($footnote.number.symbols) &gt;= $fnum">
	  <xsl:value-of select="substring($footnote.number.symbols, $fnum, 1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number value="$fnum" format="{$footnote.number.format}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
