<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f l m xs ghost"
                version='2.0'>

<!-- ********************************************************************
     $Id: gentext.xsl 7870 2008-03-07 14:58:44Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ============================================================ -->

<doc:mode name="m:object-title-template" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for locating the title markup template for an element</refpurpose>

<refdescription>
<para>This mode is used to locate the title markup template. Any
element processed in this mode should return the generated text template
that should be used to generate its title.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:object-title-template">
  <xsl:call-template name="gentext-template">
    <xsl:with-param name="context" select="'title'"/>
    <xsl:with-param name="name" select="f:xpath-location(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:chapter" mode="m:object-title-template">
  <xsl:choose>
    <xsl:when test="$autolabel.elements/db:chapter">
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'title-numbered'"/>
	<xsl:with-param name="name" select="f:xpath-location(.)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
	<xsl:with-param name="name" select="f:xpath-location(.)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:appendix" mode="m:object-title-template">
  <xsl:choose>
    <xsl:when test="$autolabel.elements/db:appendix">
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'title-numbered'"/>
	<xsl:with-param name="name" select="f:xpath-location(.)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
	<xsl:with-param name="name" select="f:xpath-location(.)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:section|db:sect1|db:sect2|db:sect3|db:sect4|db:sect5
		     |db:simplesect|db:bridgehead"
	      mode="m:object-title-template">
  <xsl:choose>
    <xsl:when test="f:label-this-section(.)">
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'title-numbered'"/>
	<xsl:with-param name="name" select="f:xpath-location(.)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
	<xsl:with-param name="name" select="f:xpath-location(.)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:procedure" mode="m:object-title-template">
  <xsl:choose>
    <xsl:when test="$formal.procedures != 0 and title">
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'title'"/>
	<xsl:with-param name="name"
			select="concat(f:xpath-location(.), '.formal')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'title'"/>
	<xsl:with-param name="name" select="f:xpath-location(.)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:object-subtitle-template"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for locating the subtitle markup template for an element
</refpurpose>

<refdescription>
<para>This mode is used to locate the subtitle markup template. Any
element processed in this mode should return the generated text template
that should be used to generate its subtitle.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:itemizedlist
                     |db:orderedlist" mode="m:object-subtitle-template">
  <!-- nop, itemizedlists don't have subtitles -->
</xsl:template>

<xsl:template match="*" mode="m:object-subtitle-template">
  <xsl:call-template name="gentext-template">
    <xsl:with-param name="context" select="'subtitle'"/>
    <xsl:with-param name="name" select="f:xpath-location(.)"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:object-xref-template"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for locating the cross-reference (<tag>xref</tag>)
markup template for an element</refpurpose>

<refdescription>
<para>This mode is used to locate the <tag>xref</tag> markup template. Any
element processed in this mode should return the generated text template
that should be used to generate a cross-reference to it.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:object-xref-template">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>

  <!-- Is autonumbering on? -->
  <xsl:variable name="autonumber" as="xs:integer">
    <xsl:apply-templates select="." mode="m:autonumbered"/>
  </xsl:variable>

  <xsl:variable name="number-and-title-template">
    <xsl:call-template name="gentext-template-exists">
      <xsl:with-param name="context" select="'xref-number-and-title'"/>
      <xsl:with-param name="name" select="f:xpath-location(.)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number-template">
    <xsl:call-template name="gentext-template-exists">
      <xsl:with-param name="context" select="'xref-number'"/>
      <xsl:with-param name="name" select="f:xpath-location(.)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="context">
    <xsl:choose>
      <xsl:when test="$autonumber != 0 
                      and $number-and-title-template != 0
                      and $xref.with.number.and.title != 0">
         <xsl:value-of select="'xref-number-and-title'"/>
      </xsl:when>
      <xsl:when test="$autonumber != 0 
                      and $number-template != 0">
         <xsl:value-of select="'xref-number'"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="'xref'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="gentext-template">
    <xsl:with-param name="context" select="$context"/>
    <xsl:with-param name="name" select="f:xpath-location(.)"/>
    <xsl:with-param name="purpose" select="$purpose"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:autonumbered"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for determining if an element should be numbered</refpurpose>

<refdescription>
<para>This mode is used to determine if an element should be numbered.
Any element processed in this mode should return “1” if it should be numbered,
“0” otherwise.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:autonumbered">
  <xsl:choose>
    <xsl:when test="$autolabel.elements/*[node-name(.) = node-name(current())]">
      <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:section|db:sect1|db:sect2|db:sect3|db:sect4|db:sect5" 
              mode="m:autonumbered">
  <xsl:choose>
    <xsl:when test="f:label-this-section(.)">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:question|db:answer" mode="m:autonumbered">
  <xsl:choose>
    <xsl:when test="$qanda.defaultlabel = 'number'
                    and not(db:label)">
      <xsl:value-of select="'1'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'0'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:bridgehead" mode="m:autonumbered">
  <xsl:choose>
    <xsl:when test="$autolabel.elements/db:section">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:object-title-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting object titles</refpurpose>

<refdescription>
<para>This mode is used to format object titles.
Any element processed in this mode should return its formatted title.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:object-title-markup">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>
  <xsl:variable name="template">
    <xsl:apply-templates select="." mode="m:object-title-template"/>
  </xsl:variable>

  <!--
  <xsl:message>object title markup for <xsl:value-of select="name(.)"/></xsl:message>
  <xsl:message><xsl:value-of select="$template"/></xsl:message>
  -->

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="template" select="$template"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:object-titleabbrev-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting the abbreviated title of an element</refpurpose>

<refdescription>
<para>This mode is used to format abbreviated titles.
Any element processed in this mode should return a formatted
rendition of its abbreviated title.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:object-titleabbrev-markup">
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>

  <!-- Just for consistency in template naming -->

  <xsl:apply-templates select="." mode="m:titleabbrev-markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:object-subtitle-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting the subtitle of an element</refpurpose>

<refdescription>
<para>This mode is used to format subtitles.
Any element processed in this mode should return a formatted
rendition of its subtitle.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:object-subtitle-markup">
  <xsl:variable name="template">
    <xsl:apply-templates select="." mode="m:object-subtitle-template"/>
  </xsl:variable>
  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="template" select="$template"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:object-xref-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting cross-references to an element</refpurpose>

<refdescription>
<para>This mode is used to format cross-references.
Any element processed in this mode should return a formatted
rendition of a cross-reference to itself.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:object-xref-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="template">
    <xsl:choose>
      <xsl:when test="starts-with(normalize-space($xrefstyle), 'select:')">
        <xsl:call-template name="make-gentext-template">
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="starts-with(normalize-space($xrefstyle), 'template:')">
        <xsl:value-of select="substring-after(normalize-space($xrefstyle), 'template:')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="m:object-xref-template">
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$template = '' and $verbose != 0">
    <xsl:message>
      <xsl:text>object-xref-markup: empty xref template</xsl:text>
      <xsl:text> for linkend="</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>" and @xrefstyle="</xsl:text>
      <xsl:value-of select="$xrefstyle"/>
      <xsl:text>"</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="purpose" select="$purpose"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="template" select="$template"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:listitem" mode="m:object-xref-markup">
  <xsl:param name="verbose" select="1"/>

  <xsl:choose>
    <xsl:when test="parent::db:orderedlist">
      <xsl:variable name="template">
        <xsl:apply-templates select="." mode="m:object-xref-template"/>
      </xsl:variable>
      <xsl:call-template name="substitute-markup">
        <xsl:with-param name="template" select="$template"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$verbose != 0">
      <xsl:message>
        <xsl:text>Xref is only supported to listitems in an</xsl:text>
        <xsl:text> orderedlist: </xsl:text>
        <xsl:value-of select="@xml:id"/>
      </xsl:message>
      <xsl:text>???</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:question" mode="m:object-xref-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>

  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[@defaultlabel]">
        <xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()]
                              /@defaultlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="template">
    <xsl:choose>
      <!-- This avoids double Q: Q: in xref when defaultlabel=qanda -->
      <xsl:when test="$deflabel = 'qanda' and not(label)">%n</xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="m:object-xref-template">
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="purpose" select="$purpose"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="template" select="$template"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="substitute-markup" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Expands %d, %n, %o, %p, %s, and %t in generated text
templates</refpurpose>

<refdescription>
<para>This template expands percent-encoded variables in a generated
text template. The content of the template is passed through unchanged,
except that:</para>

<variablelist>
<varlistentry><term>%d</term>
<listitem>
<para>is replaced by the direction (above or below) that a referent is
from the current context node.
</para>
</listitem>
</varlistentry>
<varlistentry><term>%n</term>
<listitem>
<para>is replaced by the number (label) of the context node.
</para>
</listitem>
</varlistentry>
<varlistentry><term>%o</term>
<listitem>
<para>is replaced by the <tag>olink</tag> document title.
</para>
</listitem>
</varlistentry>
<varlistentry><term>%p</term>
<listitem>
<para>is replaced by the page number of the referent.
</para>
</listitem>
</varlistentry>
<varlistentry><term>%s</term>
<listitem>
<para>is replaced by the subtitle of the context node.
</para>
</listitem>
</varlistentry>
<varlistentry><term>%t</term>
<listitem>
<para>is replaced by the title of the context node.
</para>
</listitem>
</varlistentry>
</variablelist>

<para>Note that several of these only make sense in the context of
a cross-reference.</para>

</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>template</term>
<listitem>
<para>The template to expand.</para>
</listitem>
</varlistentry>
<varlistentry><term>allow-anchors</term>
<listitem>
<para>Non-zero if anchors are allowed (I think this is deprecated).</para>
</listitem>
</varlistentry>
<varlistentry><term>title</term>
<listitem>
<para>The title of the context node.</para>
</listitem>
</varlistentry>
<varlistentry><term>subtitle</term>
<listitem>
<para>The subtitle of the context node.</para>
</listitem>
</varlistentry>
<varlistentry><term>docname</term>
<listitem>
<para>???</para>
</listitem>
</varlistentry>
<varlistentry><term>label</term>
<listitem>
<para>The label of the context node.</para>
</listitem>
</varlistentry>
<varlistentry><term>pagenumber</term>
<listitem>
<para>The page number of the context node.</para>
</listitem>
</varlistentry>
<varlistentry><term>purpose</term>
<listitem>
<para>T.B.D.</para>
</listitem>
</varlistentry>
<varlistentry><term>xrefstyle</term>
<listitem>
<para>T.B.D.</para>
</listitem>
</varlistentry>
<varlistentry><term>referrer</term>
<listitem>
<para>T.B.D.</para>
</listitem>
</varlistentry>
<varlistentry><term>verbose</term>
<listitem>
<para>T.B.D.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The expanded template.</para>
</refreturn>
</doc:template>

<!-- I have to be able to distinguish between the case where no title has been
     provided and the case where it has been provided but is the empty sequence
     (because someone specified <title/>). I'm not sure this is perfect, but
     it does fix the bug: https://github.com/docbook/xslt20-stylesheets/issues/2 -->
<xsl:variable name="ghost:marker" as="element(ghost:marker)"><ghost:marker/></xsl:variable>

<xsl:template name="substitute-markup">
  <xsl:param name="template" select="''"/>
  <xsl:param name="allow-anchors" select="false()" as="xs:boolean"/>
  <xsl:param name="title" select="$ghost:marker"/>
  <xsl:param name="subtitle" select="''"/>
  <xsl:param name="docname" select="''"/>
  <xsl:param name="label" select="''"/>
  <xsl:param name="pagenumber" select="''"/>
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="verbose" select="0"/>

  <xsl:choose>
    <xsl:when test="contains($template, '%')">
      <xsl:value-of select="substring-before($template, '%')"/>
      <xsl:variable name="candidate"
             select="substring(substring-after($template, '%'), 1, 1)"/>

      <!--
      <xsl:comment>candidate: <xsl:value-of select="$candidate"/></xsl:comment>
      -->

      <xsl:choose>
        <xsl:when test="$candidate = 't'">
          <xsl:apply-templates select="." mode="m:insert-title-markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="title">
              <xsl:choose>
                <xsl:when test="$title = $ghost:marker">
                  <xsl:apply-templates select="." mode="m:title-content">
		    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
		    <xsl:with-param name="verbose" select="$verbose"/>
                    <xsl:with-param name="template" select="'%t'"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:sequence select="$title"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 's'">
          <xsl:apply-templates select="." mode="m:insert-subtitle-markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="subtitle">
              <xsl:choose>
                <xsl:when test="$subtitle != ''">
                  <xsl:copy-of select="$subtitle"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="m:subtitle-content">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 'n'">
          <xsl:apply-templates select="." mode="m:insert-label-markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="label">
              <xsl:choose>
                <xsl:when test="$label != ''">
                  <xsl:copy-of select="$label"/>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:apply-templates select="." mode="m:label-content"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 'p'">
          <xsl:apply-templates select="." mode="m:insert-pagenumber-markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="pagenumber">
              <xsl:choose>
                <xsl:when test="$pagenumber != ''">
                  <xsl:copy-of select="$pagenumber"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="m:pagenumber-markup"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 'o'">
          <!-- olink target document title -->
          <xsl:apply-templates select="." mode="m:insert-olink-docname-markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="docname">
              <xsl:choose>
                <xsl:when test="$docname != ''">
                  <xsl:copy-of select="$docname"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="m:olink.docname.markup"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 'd'">
          <xsl:apply-templates select="." mode="m:insert-direction-markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="direction">
              <xsl:choose>
                <xsl:when test="$referrer">
                  <xsl:variable name="referent-is-below">
                    <xsl:for-each select="preceding::xref">
                      <xsl:if test="generate-id(.) = generate-id($referrer)">1</xsl:if>
                    </xsl:for-each>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="$referent-is-below = ''">
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key" select="'above'"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key" select="'below'"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>Attempt to use %d in gentext with no referrer!</xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = '%' ">
          <xsl:text>%</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>%</xsl:text><xsl:value-of select="$candidate"/>
        </xsl:otherwise>
      </xsl:choose>

      <!--
      <xsl:comment>end candidate: <xsl:value-of select="$candidate"/></xsl:comment>
      -->

      <!-- recurse with the rest of the template string -->
      <xsl:variable name="rest"
            select="substring($template,
            string-length(substring-before($template, '%'))+3)"/>
      <xsl:call-template name="substitute-markup">
        <xsl:with-param name="template" select="$rest"/>
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="subtitle" select="$subtitle"/>
        <xsl:with-param name="docname" select="$docname"/>
        <xsl:with-param name="label" select="$label"/>
        <xsl:with-param name="pagenumber" select="$pagenumber"/>
        <xsl:with-param name="purpose" select="$purpose"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$template"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="make-gentext-template" xmlns="http://docbook.org/ns/docbook">
<refpurpose>???</refpurpose>

<refdescription>
<para>What does this do?</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>target.elem</term>
<listitem>
<para>The name of the target element,
defaults to the name of the context-node.</para>
</listitem>
</varlistentry>
<varlistentry><term>lang</term>
<listitem>
<para>The language to use,
defaults to the language of the context node.</para>
</listitem>
</varlistentry>
<varlistentry><term>purpose</term>
<listitem>
<para>T.B.D.</para>
</listitem>
</varlistentry>
<varlistentry><term>xrefstyle</term>
<listitem>
<para>T.B.D.</para>
</listitem>
</varlistentry>
<varlistentry><term>referrer</term>
<listitem>
<para>T.B.D.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The template?</para>
</refreturn>
</doc:template>

<xsl:template name="make-gentext-template">
  <xsl:param name="xrefstyle" select="''"/>
  <xsl:param name="purpose"/>
  <xsl:param name="referrer"/>
  <xsl:param name="lang" select="f:l10n-language(.)"/>
  <xsl:param name="target.elem" select="local-name(.)"/>

  <!-- parse xrefstyle to get parts -->
  <xsl:variable name="parts"
      select="substring-after(normalize-space($xrefstyle), 'select:')"/>

  <xsl:variable name="labeltype">
    <xsl:choose>
      <xsl:when test="contains($parts, 'labelnumber')">
         <xsl:text>labelnumber</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'labelname')">
         <xsl:text>labelname</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'label')">
         <xsl:text>label</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titletype">
    <xsl:choose>
      <xsl:when test="contains($parts, 'quotedtitle')">
         <xsl:text>quotedtitle</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'title')">
         <xsl:text>title</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pagetype">
    <xsl:choose>
      <xsl:when test="$olink.insert.page.number = 0
                      and local-name($referrer) = 'olink'">
        <!-- suppress page numbers -->
      </xsl:when>
      <xsl:when test="$insert.xref.page.number = 'no'
                      and local-name($referrer) != 'olink'">
        <!-- suppress page numbers -->
      </xsl:when>
      <xsl:when test="contains($parts, 'nopage')">
         <xsl:text>nopage</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'pagenumber')">
         <xsl:text>pagenumber</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'pageabbrev')">
         <xsl:text>pageabbrev</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'Page')">
         <xsl:text>Page</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'page')">
         <xsl:text>page</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="docnametype">
    <xsl:choose>
      <xsl:when test="$olink.doctitle = 0
                      and local-name($referrer) = 'olink'">
        <!-- suppress docname -->
      </xsl:when>
      <xsl:when test="contains($parts, 'nodocname')">
         <xsl:text>nodocname</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'docnamelong')">
         <xsl:text>docnamelong</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'docname')">
         <xsl:text>docname</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$labeltype != ''">
    <xsl:choose>
      <xsl:when test="$labeltype = 'labelname'">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">
            <xsl:choose>
              <xsl:when test="local-name($referrer) = 'olink'">
                <xsl:value-of select="$target.elem"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="local-name(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$labeltype = 'labelnumber'">
        <xsl:text>%n</xsl:text>
      </xsl:when>
      <xsl:when test="$labeltype = 'label'">
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'xref-number'"/>
          <xsl:with-param name="name">
            <xsl:choose>
              <xsl:when test="local-name($referrer) = 'olink'">
                <xsl:value-of select="$target.elem"/>
              </xsl:when>
              <xsl:otherwise>
		<xsl:value-of select="f:xpath-location(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$titletype != ''">
        <xsl:value-of select="$xref.label-title.separator"/>
      </xsl:when>
      <xsl:when test="$pagetype != ''">
        <xsl:value-of select="$xref.label-page.separator"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>

  <xsl:if test="$titletype != ''">
    <xsl:choose>
      <xsl:when test="$titletype = 'title'">
        <xsl:text>%t</xsl:text>
      </xsl:when>
      <xsl:when test="$titletype = 'quotedtitle'">
        <xsl:call-template name="gentext-dingbat">
          <xsl:with-param name="dingbat" select="'startquote'"/>
        </xsl:call-template>
        <xsl:text>%t</xsl:text>
        <xsl:call-template name="gentext-dingbat">
          <xsl:with-param name="dingbat" select="'endquote'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$pagetype != '' and $pagetype != 'nopage'">
        <xsl:value-of select="$xref.title-page.separator"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  
  <!-- special case: use regular xref template if just turning off page -->
  <xsl:if test="($pagetype = 'nopage' or $docnametype = 'nodocname')
                  and local-name($referrer) != 'olink'
                  and $labeltype = '' 
                  and $titletype = ''">
    <xsl:apply-templates select="." mode="m:object-xref-template">
      <xsl:with-param name="purpose" select="$purpose"/>
      <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      <xsl:with-param name="referrer" select="$referrer"/>
    </xsl:apply-templates>
  </xsl:if>

  <xsl:if test="$pagetype != ''">
    <xsl:choose>
      <xsl:when test="$pagetype = 'page'">
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'page'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'Page'">
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'Page'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'pageabbrev'">
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'pageabbrev'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'pagenumber'">
        <xsl:text>%p</xsl:text>
      </xsl:when>
    </xsl:choose>

  </xsl:if>

  <!-- Add reference to other document title -->
  <xsl:if test="$docnametype != '' and local-name($referrer) = 'olink'">
    <!-- Any separator should be in the gentext template -->
    <xsl:choose>
      <xsl:when test="$docnametype = 'docnamelong'">
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'docnamelong'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$docnametype = 'docname'">
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'docname'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:if>
  
</xsl:template>

</xsl:stylesheet>
