<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:db="http://docbook.org/ns/docbook" version="2.0">

<xsl:param name="admon.default.titles" select="1"/>

<xsl:param name="admon.graphics" select="0"/>

<xsl:param name="admon.graphics.extension" select="'.png'"/>

<xsl:param name="admon.graphics.path" select="'images/'"/>

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

<xsl:param name="base.dir" select="''"/>

<xsl:param name="bibliography.collection" select="'http://docbook.sourceforge.net/release/bibliography/bibliography.xml'"/>

<xsl:param name="bibliography.numbered" select="0"/>

<xsl:param name="body.font.family" select="'serif'"/>

<xsl:param name="bridgehead.in.toc" select="0"/>

<xsl:param name="callout.graphics" select="1"/>

<xsl:param name="callout.graphics.extension" select="'.png'"/>

<xsl:param name="callout.graphics.number.limit" select="15"/>

<xsl:param name="callout.graphics.path" select="'http://docbook.sf.net/release/xsl/current/images/callouts/'"/>

<xsl:param name="callout.unicode" select="0"/>

<xsl:param name="callout.unicode.number.limit" select="'10'"/>

<xsl:param name="callout.unicode.start.character" select="10102"/>

<xsl:param name="component.label.includes.part.label" select="0"/>

<xsl:param name="date-format" select="'[D01] [MNn,*-3] [Y0001]'"/>

<xsl:param name="dateTime-format" select="'[D01] [MNn,*-3] [Y0001]'"/>

<xsl:param name="default.image.width" select="''"/>

<xsl:param name="docbook-namespace" select="'http://docbook.org/ns/docbook'"/>

<xsl:param name="docbook.css" select="'/sourceforge/docbook/xsl2/html/default.css'"/>

<xsl:param name="docbook.css.inline" select="0"/>

<xsl:param name="firstterm.only.link" select="0"/>

<xsl:param name="footnote.number.format" select="1"/>

<xsl:param name="footnote.number.symbols" select="''"/>

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

<xsl:param name="graphicsize.extension" select="1"/>

<xsl:param name="graphicsize.use.img.src.path" select="0"/>

<xsl:param name="html.ext" select="'.html'"/>

<xsl:param name="html.longdesc" select="1"/>

<xsl:param name="html.longdesc.link" select="$html.longdesc"/>

<xsl:param name="ignore.image.scaling" select="0"/>

<xsl:param name="img.src.path"/>

<xsl:param name="index.on.role" select="0"/>

<xsl:param name="index.on.type" select="0"/>

<xsl:param name="index.prefer.titleabbrev" select="0"/>

<xsl:param name="inline.style.attribute" select="1"/>

<xsl:param name="insert.xref.page.number">no</xsl:param>

<xsl:param name="itemizedlist.numeration.symbols" select="('disc', 'round')"/>

<xsl:param name="keep.relative.image.uris" select="1"/>

<xsl:param name="l10n.gentext.default.language" select="'en'"/>

<xsl:param name="l10n.gentext.language" select="''"/>

<xsl:param name="l10n.gentext.use.xref.language" select="0"/>

<xsl:param name="l10n.xml" select="document('../common/l10n.xml')"/>

<xsl:param name="label.from.part" select="0"/>

<xsl:param name="local.l10n.xml" select="document('')"/>

<xsl:param name="make.graphic.viewport" select="1"/>

<xsl:param name="make.single.year.ranges" select="0"/>

<xsl:param name="make.year.ranges" select="0"/>

<xsl:param name="manual.toc" select="''"/>

<xsl:param name="nominal.image.depth" select="4 * $pixels.per.inch"/>

<xsl:param name="nominal.image.width" select="6 * $pixels.per.inch"/>

<xsl:param name="olink.doctitle" select="0"/>

<xsl:param name="olink.insert.page.number" select="0"/>

<xsl:attribute-set name="olink.properties">
</xsl:attribute-set>

<xsl:param name="orderedlist.numeration.styles" select="('arabic',       'loweralpha', 'lowerroman',                     'upperalpha', 'upperroman')"/>

<xsl:param name="persistent.generated.ids" select="1"/>

<xsl:param name="pixels.per.inch" select="90"/>

<xsl:param name="points.per.em" select="10"/>

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

<xsl:param name="root.filename" select="'index'"/>

<xsl:param name="rootid"/>

<xsl:param name="section.autolabel.max.depth" select="8"/>

<xsl:param name="section.label.includes.component.label" select="0"/>

<xsl:param name="segmentedlist.as.table" select="0"/>

<xsl:param name="show.comments">1</xsl:param>

<xsl:param name="symbol.font.family" select="'Symbol,ZapfDingbats'"/>

<xsl:param name="table.cell.border.color" select="''"/>

<xsl:param name="table.cell.border.style" select="'solid'"/>

<xsl:param name="table.cell.border.thickness" select="'0.5pt'"/>

<xsl:param name="table.footnote.number.format" select="'a'"/>

<xsl:param name="table.footnote.number.symbols" select="''"/>

<xsl:param name="table.frame.default" select="'all'"/>

<xsl:param name="table.html.cellpadding" select="''"/>

<xsl:param name="table.html.cellspacing" select="''"/>

<xsl:param name="table.width.default" select="''"/>

<xsl:param name="table.width.nominal" select="'6in'"/>

<xsl:param name="textdata.default.encoding" select="''"/>

<xsl:param name="title.font.family" select="'sans-serif'"/>

<xsl:param name="titlepage.templates" select="'titlepages.xml'"/>

<xsl:param name="toc.list.type">dl</xsl:param>

<xsl:param name="toc.max.depth" select="8"/>

<xsl:param name="toc.section.depth">2</xsl:param>

<xsl:param name="use.embed.for.svg" select="0"/>

<xsl:param name="use.extensions" select="'0'"/>

<xsl:param name="use.id.as.filename" select="'0'"/>

<xsl:param name="verbosity" select="0"/>

<xsl:param name="xref.label-page.separator"><xsl:text> </xsl:text></xsl:param>

<xsl:param name="xref.label-title.separator">: </xsl:param>

<xsl:param name="xref.title-page.separator"><xsl:text> </xsl:text></xsl:param>

<xsl:param name="xref.with.number.and.title" select="1"/>

</xsl:stylesheet>
