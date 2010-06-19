<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:db="http://docbook.org/ns/docbook" version="2.0">

<xsl:param name="alignment" select="'justify'"/>

<xsl:param name="annotate.toc" select="1"/>

<xsl:param name="annotation.graphic.close" select="'../images/annot-close.png'"/>

<xsl:param name="annotation.graphic.open" select="'../images/annot-open.png'"/>

<xsl:param name="annotation.js" select="'http://docbook.sourceforge.net/release/script/AnchorPosition.js             http://docbook.sourceforge.net/release/script/PopupWindow.js'"/>

<xsl:param name="author.othername.in.middle" select="1"/>

<xsl:param name="autolabel.elements">
  <db:appendix format="A"/>
  <db:chapter/>
  <db:figure/>
  <db:example/>
  <db:table/>
  <db:equation/>
  <db:part format="I"/>
  <db:reference format="I"/>
  <db:preface/>
  <db:qandadiv/>
  <db:section/>
  <db:refsection/>
</xsl:param>

<xsl:param name="autotoc.label.separator" select="'. '"/>

<xsl:param name="biblioentry.item.separator">. </xsl:param>

<xsl:attribute-set name="biblioentry.properties" use-attribute-sets="normal.para.spacing">
  <xsl:attribute name="start-indent">0.5in</xsl:attribute>
  <xsl:attribute name="text-indent">-0.5in</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="bibliography.collection" select="'http://docbook.sourceforge.net/release/bibliography/bibliography.xml'"/>

<xsl:param name="bibliography.numbered" select="0"/>

<xsl:param name="bibliography.style">normal</xsl:param>

<xsl:param name="body.end.indent" select="'0pt'"/>

<xsl:param name="body.font.family" select="'serif'"/>

<xsl:param name="body.font.master" select="10"/>

<xsl:param name="body.font.size">
  <xsl:value-of select="$body.font.master"/>
  <xsl:text>pt</xsl:text>
</xsl:param>

<xsl:param name="body.margin.bottom" select="'0.5in'"/>

<xsl:param name="body.margin.top" select="'0.5in'"/>

<xsl:param name="body.start.indent" select="'0pt'"/>

<xsl:param name="bridgehead.in.toc" select="0"/>

<xsl:param name="callout.graphics" select="1"/>

<xsl:param name="callout.graphics.extension" select="'.png'"/>

<xsl:param name="callout.graphics.number.limit" select="15"/>

<xsl:param name="callout.graphics.path" select="'http://docbook.sf.net/release/xsl/current/images/callouts/'"/>

<xsl:param name="callout.unicode" select="0"/>

<xsl:param name="callout.unicode.number.limit" select="'10'"/>

<xsl:param name="callout.unicode.start.character" select="10102"/>

<xsl:param name="column.count.back" select="1"/>

<xsl:param name="column.count.body" select="1"/>

<xsl:param name="column.count.front" select="1"/>

<xsl:param name="column.count.index" select="2"/>

<xsl:param name="column.count.lot" select="1"/>

<xsl:param name="column.count.titlepage" select="1"/>

<xsl:param name="column.gap.back" select="'12pt'"/>

<xsl:param name="column.gap.body" select="'12pt'"/>

<xsl:param name="column.gap.front" select="'12pt'"/>

<xsl:param name="column.gap.index" select="'12pt'"/>

<xsl:param name="column.gap.lot" select="'12pt'"/>

<xsl:param name="column.gap.titlepage" select="'12pt'"/>

<xsl:attribute-set name="compact.list.item.spacing">
  <xsl:attribute name="space-before.optimum">0em</xsl:attribute>
  <xsl:attribute name="space-before.minimum">0em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">0.2em</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="component.label.includes.part.label" select="0"/>

<xsl:attribute-set name="component.title.properties">
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  <xsl:attribute name="space-before.optimum"><xsl:value-of select="concat($body.font.master, 'pt')"/></xsl:attribute>
  <xsl:attribute name="space-before.minimum"><xsl:value-of select="concat($body.font.master, 'pt * 0.8')"/></xsl:attribute>
  <xsl:attribute name="space-before.maximum"><xsl:value-of select="concat($body.font.master, 'pt * 1.2')"/></xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
  <xsl:attribute name="text-align">
    <xsl:choose>
      <xsl:when test="((parent::article | parent::articleinfo | parent::info/parent::article) and not(ancestor::book) and not(self::bibliography))         or (parent::slides | parent::slidesinfo)">center</xsl:when>
      <xsl:otherwise>left</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="start-indent"><xsl:value-of select="$title.margin.left"/></xsl:attribute>
</xsl:attribute-set>

<xsl:param name="date-format" select="'[D01] [MNn,*-3] [Y0001]'"/>

<xsl:param name="dateTime-format" select="'[D01] [MNn,*-3] [Y0001]'"/>

<xsl:param name="default.table.width"/>

<xsl:param name="dingbat.font.family">serif</xsl:param>

<xsl:param name="docbook-namespace" select="'http://docbook.org/ns/docbook'"/>

<xsl:param name="docbook.css" select="'/sourceforge/docbook/xsl2/html/default.css'"/>

<xsl:param name="docbook.css.inline" select="0"/>

<xsl:param name="double.sided" select="0"/>

<xsl:param name="draft.mode" select="'maybe'"/>

<xsl:param name="draft.watermark.image" select="'http://docbook.sourceforge.net/release/images/draft.png'"/>

<xsl:param name="firstterm.only.link" select="0"/>

<xsl:param name="fo.processor" select="'xep'"/>

<xsl:param name="footer.column.widths" select="'1 1 1'"/>

<xsl:attribute-set name="footer.content.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$body.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="margin-left">
    <xsl:value-of select="$title.margin.left"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:param name="footer.rule" select="1"/>

<xsl:param name="footers.on.blank.pages" select="1"/>

<xsl:param name="footnote.font.size">
 <xsl:value-of select="$body.font.master * 0.8"/><xsl:text>pt</xsl:text>
</xsl:param>

<xsl:attribute-set name="footnote.mark.properties">
  <xsl:attribute name="font-size">75%</xsl:attribute>
  <xsl:attribute name="font-weight">normal</xsl:attribute>
  <xsl:attribute name="font-style">normal</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="footnote.number.format" select="1"/>

<xsl:param name="footnote.number.symbols" select="''"/>

<xsl:attribute-set name="footnote.properties">
  <xsl:attribute name="font-family"><xsl:value-of select="$body.fontset"/></xsl:attribute>
  <xsl:attribute name="font-size"><xsl:value-of select="$footnote.font.size"/></xsl:attribute>
  <xsl:attribute name="font-weight">normal</xsl:attribute>
  <xsl:attribute name="font-style">normal</xsl:attribute>
  <xsl:attribute name="text-align"><xsl:value-of select="$alignment"/></xsl:attribute>
  <xsl:attribute name="start-indent">0pt</xsl:attribute>
  <xsl:attribute name="text-indent">0pt</xsl:attribute>
  <xsl:attribute name="hyphenate"><xsl:value-of select="$hyphenate"/></xsl:attribute>
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  <xsl:attribute name="linefeed-treatment">treat-as-space</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="footnote.sep.leader.properties">
  <xsl:attribute name="color">black</xsl:attribute>
  <xsl:attribute name="leader-pattern">rule</xsl:attribute>
  <xsl:attribute name="leader-length">1in</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="formal.object.properties">
  <xsl:attribute name="space-before.minimum">0.5em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">2em</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.5em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">2em</xsl:attribute>
  <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="formal.procedures" select="1"/>

<xsl:param name="formal.title.placement" as="element()*">
  <db:figure placement="after"/>
  <db:example placement="before"/>
  <db:equation placement="after"/>
  <db:table placement="before"/>
  <db:procedure placement="before"/>
  <db:task placement="before"/>
</xsl:param>

<xsl:param name="gYear-format" select="'[Y0001]'"/>

<xsl:param name="gYearMonth-format" select="'[MNn,*-3] [Y0001]'"/>

<xsl:param name="generate.index" select="1"/>

<xsl:param name="generate.toc" as="element()*">
<tocparam xmlns="http://docbook.org/ns/docbook" path="appendix" toc="1" title="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="article/appendix" toc="1" title="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="article" toc="1" title="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="book" toc="1" title="1" figure="1" table="1" example="1" equation="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="chapter" toc="1" title="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="part" toc="1" title="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="preface" toc="1" title="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="qandadiv" toc="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="qandaset" toc="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="reference" toc="1" title="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="sect1" toc="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="sect2" toc="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="sect3" toc="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="sect4" toc="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="sect5" toc="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="section" toc="1"/>
<tocparam xmlns="http://docbook.org/ns/docbook" path="set" toc="1" title="1"/>
</xsl:param>

<xsl:param name="glossary.collection" select="''"/>

<xsl:param name="glossentry.show.acronym" select="'no'"/>

<xsl:param name="glossterm.auto.link" select="0"/>

<xsl:param name="graphic.extensions" select="('svg','png','jpg','jpeg','gif','bmp',       'avi', 'mpg', 'mpeg', 'qt')"/>

<xsl:param name="graphic.formats" select="('svg','png','jpg','jpeg','gif','gif87a','gif89a','bmp',                     'linespecific')"/>

<xsl:param name="header.column.widths" select="'1 1 1'"/>

<xsl:attribute-set name="header.content.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$body.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="margin-left">
    <xsl:value-of select="$title.margin.left"/>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:param name="header.rule" select="1"/>

<xsl:param name="headers.on.blank.pages" select="1"/>

<xsl:param name="hyphenate" select="'true'"/>

<xsl:param name="index.on.role" select="0"/>

<xsl:param name="index.on.type" select="0"/>

<xsl:param name="index.prefer.titleabbrev" select="0"/>

<xsl:attribute-set name="informal.object.properties">
  <xsl:attribute name="space-before.minimum">0.5em</xsl:attribute>
  <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">2em</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.5em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">2em</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="inline.style.attribute" select="1"/>

<xsl:param name="insert.link.page.number">no</xsl:param>

<xsl:param name="insert.xref.page.number">no</xsl:param>

<xsl:attribute-set name="itemizedlist.label.properties">
</xsl:attribute-set>

<xsl:param name="itemizedlist.label.width">1.0em</xsl:param>

<xsl:param name="itemizedlist.numeration.symbols" select="('disc', 'round')"/>

<xsl:attribute-set name="itemizedlist.properties" use-attribute-sets="list.block.properties">
</xsl:attribute-set>

<xsl:param name="l10n.gentext.default.language" select="'en'"/>

<xsl:param name="l10n.gentext.language" select="''"/>

<xsl:param name="l10n.gentext.use.xref.language" select="0"/>

<xsl:param name="l10n.xml" select="document('../common/l10n.xml')"/>

<xsl:param name="label.from.part" select="0"/>

<xsl:param name="line.height" select="'normal'"/>

<xsl:attribute-set name="list.block.properties">
  <xsl:attribute name="provisional-label-separation">0.2em</xsl:attribute>
  <xsl:attribute name="provisional-distance-between-starts">1.5em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="list.block.spacing">
  <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="list.item.spacing">
  <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="local.l10n.xml" select="document('')"/>

<xsl:param name="make.single.year.ranges" select="0"/>

<xsl:param name="make.year.ranges" select="0"/>

<xsl:param name="manual.toc" select="''"/>

<xsl:attribute-set name="normal.para.spacing">
  <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
  <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
  <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="olink.doctitle" select="0"/>

<xsl:param name="olink.insert.page.number" select="0"/>

<xsl:attribute-set name="olink.properties">
</xsl:attribute-set>

<xsl:attribute-set name="orderedlist.label.properties">
</xsl:attribute-set>

<xsl:param name="orderedlist.numeration.styles" select="('arabic',       'loweralpha', 'lowerroman',                     'upperalpha', 'upperroman')"/>

<xsl:param name="page.height">
  <xsl:choose>
    <xsl:when test="$page.orientation = 'portrait'">
      <xsl:value-of select="$page.height.portrait"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$page.width.portrait"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="page.height.portrait">
  <xsl:choose>
    <xsl:when test="$paper.type = 'A4landscape'">210mm</xsl:when>
    <xsl:when test="$paper.type = 'USletter'">11in</xsl:when>
    <xsl:when test="$paper.type = 'USlandscape'">8.5in</xsl:when>
    <xsl:when test="$paper.type = '4A0'">2378mm</xsl:when>
    <xsl:when test="$paper.type = '2A0'">1682mm</xsl:when>
    <xsl:when test="$paper.type = 'A0'">1189mm</xsl:when>
    <xsl:when test="$paper.type = 'A1'">841mm</xsl:when>
    <xsl:when test="$paper.type = 'A2'">594mm</xsl:when>
    <xsl:when test="$paper.type = 'A3'">420mm</xsl:when>
    <xsl:when test="$paper.type = 'A4'">297mm</xsl:when>
    <xsl:when test="$paper.type = 'A5'">210mm</xsl:when>
    <xsl:when test="$paper.type = 'A6'">148mm</xsl:when>
    <xsl:when test="$paper.type = 'A7'">105mm</xsl:when>
    <xsl:when test="$paper.type = 'A8'">74mm</xsl:when>
    <xsl:when test="$paper.type = 'A9'">52mm</xsl:when>
    <xsl:when test="$paper.type = 'A10'">37mm</xsl:when>
    <xsl:when test="$paper.type = 'B0'">1414mm</xsl:when>
    <xsl:when test="$paper.type = 'B1'">1000mm</xsl:when>
    <xsl:when test="$paper.type = 'B2'">707mm</xsl:when>
    <xsl:when test="$paper.type = 'B3'">500mm</xsl:when>
    <xsl:when test="$paper.type = 'B4'">353mm</xsl:when>
    <xsl:when test="$paper.type = 'B5'">250mm</xsl:when>
    <xsl:when test="$paper.type = 'B6'">176mm</xsl:when>
    <xsl:when test="$paper.type = 'B7'">125mm</xsl:when>
    <xsl:when test="$paper.type = 'B8'">88mm</xsl:when>
    <xsl:when test="$paper.type = 'B9'">62mm</xsl:when>
    <xsl:when test="$paper.type = 'B10'">44mm</xsl:when>
    <xsl:when test="$paper.type = 'C0'">1297mm</xsl:when>
    <xsl:when test="$paper.type = 'C1'">917mm</xsl:when>
    <xsl:when test="$paper.type = 'C2'">648mm</xsl:when>
    <xsl:when test="$paper.type = 'C3'">458mm</xsl:when>
    <xsl:when test="$paper.type = 'C4'">324mm</xsl:when>
    <xsl:when test="$paper.type = 'C5'">229mm</xsl:when>
    <xsl:when test="$paper.type = 'C6'">162mm</xsl:when>
    <xsl:when test="$paper.type = 'C7'">114mm</xsl:when>
    <xsl:when test="$paper.type = 'C8'">81mm</xsl:when>
    <xsl:when test="$paper.type = 'C9'">57mm</xsl:when>
    <xsl:when test="$paper.type = 'C10'">40mm</xsl:when>
    <xsl:otherwise>11in</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="page.margin.bottom" select="'0.5in'"/>

<xsl:param name="page.margin.inner">
  <xsl:choose>
    <xsl:when test="$double.sided != 0">1.25in</xsl:when>
    <xsl:otherwise>1in</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="page.margin.outer">
  <xsl:choose>
    <xsl:when test="$double.sided != 0">0.75in</xsl:when>
    <xsl:otherwise>1in</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="page.margin.top" select="'0.5in'"/>

<xsl:param name="page.orientation" select="'portrait'"/>

<xsl:param name="page.width">
  <xsl:choose>
    <xsl:when test="$page.orientation = 'portrait'">
      <xsl:value-of select="$page.width.portrait"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$page.height.portrait"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="page.width.portrait">
  <xsl:choose>
    <xsl:when test="$paper.type = 'USletter'">8.5in</xsl:when>
    <xsl:when test="$paper.type = '4A0'">1682mm</xsl:when>
    <xsl:when test="$paper.type = '2A0'">1189mm</xsl:when>
    <xsl:when test="$paper.type = 'A0'">841mm</xsl:when>
    <xsl:when test="$paper.type = 'A1'">594mm</xsl:when>
    <xsl:when test="$paper.type = 'A2'">420mm</xsl:when>
    <xsl:when test="$paper.type = 'A3'">297mm</xsl:when>
    <xsl:when test="$paper.type = 'A4'">210mm</xsl:when>
    <xsl:when test="$paper.type = 'A5'">148mm</xsl:when>
    <xsl:when test="$paper.type = 'A6'">105mm</xsl:when>
    <xsl:when test="$paper.type = 'A7'">74mm</xsl:when>
    <xsl:when test="$paper.type = 'A8'">52mm</xsl:when>
    <xsl:when test="$paper.type = 'A9'">37mm</xsl:when>
    <xsl:when test="$paper.type = 'A10'">26mm</xsl:when>
    <xsl:when test="$paper.type = 'B0'">1000mm</xsl:when>
    <xsl:when test="$paper.type = 'B1'">707mm</xsl:when>
    <xsl:when test="$paper.type = 'B2'">500mm</xsl:when>
    <xsl:when test="$paper.type = 'B3'">353mm</xsl:when>
    <xsl:when test="$paper.type = 'B4'">250mm</xsl:when>
    <xsl:when test="$paper.type = 'B5'">176mm</xsl:when>
    <xsl:when test="$paper.type = 'B6'">125mm</xsl:when>
    <xsl:when test="$paper.type = 'B7'">88mm</xsl:when>
    <xsl:when test="$paper.type = 'B8'">62mm</xsl:when>
    <xsl:when test="$paper.type = 'B9'">44mm</xsl:when>
    <xsl:when test="$paper.type = 'B10'">31mm</xsl:when>
    <xsl:when test="$paper.type = 'C0'">917mm</xsl:when>
    <xsl:when test="$paper.type = 'C1'">648mm</xsl:when>
    <xsl:when test="$paper.type = 'C2'">458mm</xsl:when>
    <xsl:when test="$paper.type = 'C3'">324mm</xsl:when>
    <xsl:when test="$paper.type = 'C4'">229mm</xsl:when>
    <xsl:when test="$paper.type = 'C5'">162mm</xsl:when>
    <xsl:when test="$paper.type = 'C6'">114mm</xsl:when>
    <xsl:when test="$paper.type = 'C7'">81mm</xsl:when>
    <xsl:when test="$paper.type = 'C8'">57mm</xsl:when>
    <xsl:when test="$paper.type = 'C9'">40mm</xsl:when>
    <xsl:when test="$paper.type = 'C10'">28mm</xsl:when>
    <xsl:otherwise>8.5in</xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="paper.type" select="'USletter'"/>

<xsl:param name="persistent.generated.ids" select="1"/>

<xsl:param name="pixels.per.inch" select="90"/>

<xsl:param name="procedure.step.numeration.styles" select="('arabic',       'loweralpha', 'lowerroman',                     'upperalpha', 'upperroman')"/>

<xsl:param name="profile.arch" select="''"/>

<xsl:param name="profile.attribute" select="''"/>

<xsl:param name="profile.condition" select="''"/>

<xsl:param name="profile.conformance" select="''"/>

<xsl:param name="profile.lang" select="''"/>

<xsl:param name="profile.os" select="''"/>

<xsl:param name="profile.revision" select="''"/>

<xsl:param name="profile.revisionflag" select="''"/>

<xsl:param name="profile.role" select="''"/>

<xsl:param name="profile.security" select="''"/>

<xsl:param name="profile.separator" select="';'"/>

<xsl:param name="profile.userlevel" select="''"/>

<xsl:param name="profile.value" select="''"/>

<xsl:param name="profile.vendor" select="''"/>

<xsl:param name="punct.honorific" select="'.'"/>

<xsl:param name="qanda.defaultlabel">number</xsl:param>

<xsl:param name="qanda.inherit.numeration" select="1"/>

<xsl:param name="refentry.generate.name" select="1"/>

<xsl:param name="refentry.generate.title" select="0"/>

<xsl:param name="refentry.separator" select="1"/>

<xsl:param name="region.after.extent" select="'0.4in'"/>

<xsl:param name="region.before.extent" select="'0.4in'"/>

<xsl:param name="root.elements">
  <db:appendix/>
  <db:article/>
  <db:bibliography/>
  <db:book/>
  <db:chapter/>
  <db:colophon/>
  <db:dedication/>
  <db:glossary/>
  <db:index/>
  <db:part/>
  <db:preface/>
  <db:refentry/>
  <db:reference/>
  <db:sect1/>
  <db:section/>
  <db:set/>
  <db:setindex/>
</xsl:param>

<xsl:attribute-set name="root.properties">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$body.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.size"/>
  </xsl:attribute>
  <xsl:attribute name="text-align">
    <xsl:value-of select="$alignment"/>
  </xsl:attribute>
  <xsl:attribute name="line-height">
    <xsl:value-of select="$line.height"/>
  </xsl:attribute>
  <xsl:attribute name="font-selection-strategy">character-by-character</xsl:attribute>
  <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="rootid"/>

<xsl:param name="section.autolabel.max.depth" select="8"/>

<xsl:param name="section.label.includes.component.label" select="0"/>

<xsl:param name="segmentedlist.as.table" select="0"/>

<xsl:param name="show.comments">1</xsl:param>

<xsl:attribute-set name="subscript.properties">
  <xsl:attribute name="font-size">75%</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="superscript.properties">
  <xsl:attribute name="font-size">75%</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="symbol.font.family" select="'Symbol,ZapfDingbats'"/>

<xsl:param name="table.footnote.number.format" select="'a'"/>

<xsl:param name="table.footnote.number.symbols" select="''"/>

<xsl:param name="title.font.family" select="'sans-serif'"/>

<xsl:param name="title.margin.left" select="'0pt'"/>

<xsl:param name="titlepage.templates" select="'titlepages.xml'"/>

<xsl:param name="toc.list.type">dl</xsl:param>

<xsl:param name="toc.max.depth" select="8"/>

<xsl:param name="toc.section.depth">2</xsl:param>

<xsl:param name="ulink.footnotes" select="0"/>

<xsl:param name="ulink.hyphenate" select="''"/>

<xsl:param name="ulink.hyphenate.chars" select="'/'"/>

<xsl:param name="ulink.show" select="1"/>

<xsl:param name="use.role.as.xrefstyle" select="1"/>

<xsl:param name="variablelist.as.blocks" select="0"/>

<xsl:param name="variablelist.max.termlength">24</xsl:param>

<xsl:param name="variablelist.term.break.after">0</xsl:param>

<xsl:param name="variablelist.term.separator">, </xsl:param>

<xsl:param name="verbosity" select="0"/>

<xsl:param name="xref.label-page.separator"><xsl:text> </xsl:text></xsl:param>

<xsl:param name="xref.label-title.separator">: </xsl:param>

<xsl:attribute-set name="xref.properties">
</xsl:attribute-set>

<xsl:param name="xref.title-page.separator"><xsl:text> </xsl:text></xsl:param>

<xsl:param name="xref.with.number.and.title" select="1"/>

</xsl:stylesheet>
