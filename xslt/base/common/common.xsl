<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fp="http://docbook.org/xslt/ns/extension/private"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ext="http://docbook.org/extensions/xslt20"
                exclude-result-prefixes="db doc f fp m t xs ext"
                version="2.0">

<xsl:param name="use.role.for.mediaobject" select="1"/>
<xsl:param name="preferred.mediaobject.role" select="''"/>
<xsl:param name="tex.math.in.alt" select="0"/>
<xsl:param name="use.svg" select="1"/>
<xsl:param name="graphic.default.extension" select="''"/>

<doc:reference xmlns="http://docbook.org/ns/docbook">
<info>
<title>Common Templates Reference</title>
<author>
  <personname>
    <surname>Walsh</surname>
    <firstname>Norman</firstname>
  </personname>
</author>
<copyright><year>2004</year>
<holder>Norman Walsh</holder>
</copyright>
</info>

<partintro>
<section><title>Introduction</title>

<para>This is technical reference documentation for the DocBook XSL
Stylesheets; it documents (some of) the parameters, templates, and
other elements of the stylesheets.</para>

<para>This is not intended to be <quote>user</quote> documentation.
It is provided for developers writing customization layers for the
stylesheets, and for anyone who's interested in <quote>how it
works</quote>.</para>

<para>Although I am trying to be thorough, this documentation is known
to be incomplete. Don't forget to read the source, too :-)</para>
</section>
</partintro>
</doc:reference>

<!-- ============================================================ -->

<doc:template name="person-name" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Formats a personal name</refpurpose>

<refdescription>
<para>This template formats a personal name. It supports several styles
that may be specified with a <tag class="attribute">role</tag> attribute
on the element (<tag>personname</tag>, <tag>author</tag>, <tag>editor</tag>,
and <tag>othercredit</tag>) or with the locale.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="t:person-name">
  <xsl:param name="node" select="."/>

  <xsl:variable name="personname"
                select="if ($node/self::db:personname)
                        then $node
                        else $node/db:personname"/>

  <xsl:variable name="style">
    <xsl:choose>
      <xsl:when test="$node/@role">
        <xsl:value-of select="$node/@role"/>
      </xsl:when>
      <xsl:when test="($node/parent::db:author or $node/parent::db:editor
                       or $node/parent::db:othercredit) and $node/parent::*/@role">
        <xsl:value-of select="$node/parent::*/@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'styles'"/>
          <xsl:with-param name="name" select="'person-name'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$node/db:orgname">
      <xsl:apply-templates select="$node/db:orgname"/>
    </xsl:when>

    <xsl:otherwise>
      <!-- $node/db:personname -->
      <xsl:choose>
        <xsl:when test="not($personname/*)">
          <xsl:value-of select="$personname"/>
        </xsl:when>
        <xsl:when test="$style = 'family-given'">
          <xsl:call-template name="t:person-name-family-given">
            <xsl:with-param name="node" select="$personname"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$style = 'last-first'">
          <xsl:call-template name="t:person-name-last-first">
            <xsl:with-param name="node" select="$personname"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="t:person-name-first-last">
            <xsl:with-param name="node" select="$personname"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="person-name-family-given"
              xmlns="http://docbook.org/ns/docbook">
<refpurpose>Formats a personal name in the “family given” style</refpurpose>

<refdescription>
<para>This template formats a personal name in the “family given” style.
It is generally called by <function role="template">person-name</function>
template.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="t:person-name-family-given">
  <xsl:param name="node" select="."/>

  <!-- The family-given style applies a convention for identifying given -->
  <!-- and family names in locales where it may be ambiguous -->
  <xsl:variable name="surname">
    <xsl:apply-templates select="$node/db:surname[1]"/>
  </xsl:variable>

  <xsl:apply-templates select="$surname/node()" mode="m:to-uppercase"/>

  <xsl:if test="$node/db:surname and ($node/db:firstname or $node/db:givenname)">
    <xsl:text> </xsl:text>
  </xsl:if>

  <xsl:apply-templates select="($node/db:firstname|$node/db:givenname)[1]"/>

  <xsl:text> [FAMILY Given]</xsl:text>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:to-uppercase" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for converting text to upper-case</refpurpose>

<refdescription>
<para>This mode is used to convert the text in a subtree to upper-case.
It returns a copy of the subtree with all <code>text()</code> nodes
converted to upper-case.</para>
</refdescription>
</doc:mode>

<xsl:template match="/" mode="m:to-uppercase">
  <xsl:apply-templates mode="m:to-uppercase"/>
</xsl:template>

<xsl:template match="*" mode="m:to-uppercase">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:to-uppercase"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="processing-instruction()|comment()" mode="m:to-uppercase">
  <xsl:copy/>
</xsl:template>

<xsl:template match="text()" mode="m:to-uppercase">
  <xsl:value-of select="upper-case(.)"/>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="person-name-last-first"
              xmlns="http://docbook.org/ns/docbook">
<refpurpose>Formats a personal name in the “last, first” style</refpurpose>

<refdescription>
<para>This template formats a personal name in the “last, first” style.
It is generally called by <function role="template">person-name</function>
template.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="t:person-name-last-first">
  <xsl:param name="node" select="."/>

  <xsl:apply-templates select="$node/db:surname[1]"/>

  <xsl:if test="$node/db:surname and ($node/db:firstname or $node/db:givenname)">
    <xsl:text>, </xsl:text>
  </xsl:if>

  <xsl:apply-templates select="($node/db:firstname|$node/db:givenname)[1]"/>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="person-name-first-last"
              xmlns="http://docbook.org/ns/docbook">
<refpurpose>Formats a personal name in the “first last” style</refpurpose>

<refdescription>
<para>This template formats a personal name in the “first last” style.
It is generally called by <function role="template">person-name</function>
template.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="t:person-name-first-last">
  <xsl:param name="node" select="."/>

  <xsl:if test="$node/db:honorific">
    <xsl:apply-templates select="$node/db:honorific[1]"/>
    <xsl:value-of select="$punct.honorific"/>
  </xsl:if>

  <xsl:if test="$node/db:firstname or $node/db:givenname">
    <xsl:if test="$node/db:honorific">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="($node/db:firstname|$node/db:givenname)[1]"/>
  </xsl:if>

  <xsl:if test="$node/db:othername and $author.othername.in.middle != 0">
    <xsl:if test="$node/db:honorific or $node/db:firstname or $node/db:givenname">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node/db:othername[1]"/>
  </xsl:if>

  <xsl:if test="$node/db:surname">
    <xsl:if test="$node/db:honorific or $node/db:firstname or $node/db:givenname
                  or ($node/db:othername and $author.othername.in.middle != 0)">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node/db:surname[1]"/>
  </xsl:if>

  <xsl:if test="$node/db:lineage">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="$node/db:lineage[1]"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="person-name-list"
              xmlns="http://docbook.org/ns/docbook">
<refpurpose>Formats a list of personal names</refpurpose>

<refdescription>
<para>This template formats a list of personal names, for example in
an <tag>authorgroup</tag>.</para>
<para>The list of names is assumed to be in the current context node.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="t:person-name-list">
  <!-- Return a formatted string representation of the contents of
       the current element. The current element must contain one or
       more AUTHORs, CORPAUTHORs, OTHERCREDITs, and/or EDITORs.

       John Doe
     or
       John Doe and Jane Doe
     or
       John Doe, Jane Doe, and A. Nonymous
  -->
  <xsl:param name="person.list"
             select="db:author|db:corpauthor|db:othercredit|db:editor"/>
  <xsl:param name="person.count" select="count($person.list)"/>
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count &gt; $person.count"></xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="t:person-name">
        <xsl:with-param name="node" select="$person.list[position()=$count]"/>
      </xsl:call-template>

      <xsl:choose>
        <xsl:when test="$person.count = 2 and $count = 1">
          <xsl:call-template name="gentext-template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'sep2'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$person.count &gt; 2 and $count+1 = $person.count">
          <xsl:call-template name="gentext-template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'seplast'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$count &lt; $person.count">
          <xsl:call-template name="gentext-template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'sep'"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>

      <xsl:call-template name="t:person-name-list">
        <xsl:with-param name="person.list" select="$person.list"/>
        <xsl:with-param name="person.count" select="$person.count"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:number" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting element labels (numbers)</refpurpose>

<refdescription>
<para>This mode is used to insert numbers for numbered elements.
Any element processed in this mode should generate its number.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:qandadiv" mode="m:number">
  <xsl:number level="multiple" from="db:qandaset" format="1."/>
</xsl:template>

<xsl:template match="db:qandaentry" mode="m:number">
  <xsl:choose>
    <xsl:when test="ancestor::db:qandadiv">
      <xsl:number level="single" from="db:qandadiv" format="1."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number level="single" from="db:qandaset" format="1."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:step" mode="m:number">
  <xsl:param name="rest" select="''"/>
  <xsl:param name="recursive" select="1"/>
  <xsl:variable name="format" select="f:procedure-step-numeration(.)"/>

  <xsl:variable name="num">
    <xsl:choose>
      <xsl:when test="$format = 'arabic'">
        <xsl:number count="db:step" format="1"/>
      </xsl:when>
      <xsl:when test="$format = 'loweralpha'">
        <xsl:number count="db:step" format="a"/>
      </xsl:when>
      <xsl:when test="$format = 'lowerroman'">
        <xsl:number count="db:step" format="i"/>
      </xsl:when>
      <xsl:when test="$format = 'upperalpha'">
        <xsl:number count="db:step" format="A"/>
      </xsl:when>
      <xsl:when test="$format = 'upperroman'">
        <xsl:number count="db:step" format="I"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number count="db:step" format="i"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$recursive != 0 and ancestor::db:step">
      <xsl:apply-templates select="ancestor::db:step[1]" mode="m:number">
        <xsl:with-param name="rest" select="concat('.', $num, $rest)"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($num, $rest)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:copyright-years" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Print a set of years with collapsed ranges</refpurpose>

<refdescription>
<para>This template prints a list of year elements with consecutive
years printed as a range. In other words:</para>

<screen><![CDATA[<year>1992</year>
<year>1993</year>
<year>1994</year>]]></screen>

<para>is printed <quote>1992-1994</quote>, whereas:</para>

<screen><![CDATA[<year>1992</year>
<year>1994</year>]]></screen>

<para>is printed <quote>1992, 1994</quote>.</para>

<para>This template assumes that all the year elements contain only
decimal year numbers, that the elements are sorted in increasing
numerical order, that there are no duplicates, and that all the years
are expressed in full <quote>century+year</quote>
(<quote>1999</quote> not <quote>99</quote>) notation.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>years</term>
<listitem>
<para>The initial set of year elements.</para>
</listitem>
</varlistentry>
<varlistentry><term>print.ranges</term>
<listitem>
<para>If non-zero, multi-year ranges are collapsed. If zero, all years
are printed discretely.</para>
</listitem>
</varlistentry>
<varlistentry><term>single.year.ranges</term>
<listitem>
<para>If non-zero, two consecutive years will be printed as a range,
otherwise, they will be printed discretely. In other words, a single
year range is <quote>1991-1992</quote> but discretely it's
<quote>1991, 1992</quote>.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>This template returns the formatted list of years.</para>
</refreturn>
</doc:template>

<xsl:template name="t:copyright-years">
  <xsl:param name="years"/>
  <xsl:param name="print.ranges" select="1"/>
  <xsl:param name="single.year.ranges" select="0"/>
  <xsl:param name="firstyear" select="0"/>
  <xsl:param name="nextyear" select="0"/>

  <!--
  <xsl:message terminate="no">
    <xsl:text>CY: </xsl:text>
    <xsl:value-of select="count($years)"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$firstyear"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$nextyear"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$print.ranges"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$single.year.ranges"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="$years[1]"/>
    <xsl:text>)</xsl:text>
  </xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="$print.ranges = 0 and exists($years)">
      <xsl:choose>
        <xsl:when test="count($years) = 1">
          <xsl:apply-templates select="$years[1]" mode="titlepage.mode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$years[1]" mode="titlepage.mode"/>
          <xsl:text>, </xsl:text>
          <xsl:call-template name="t:copyright-years">
            <xsl:with-param name="years"
                            select="$years[position() &gt; 1]"/>
            <xsl:with-param name="print.ranges" select="$print.ranges"/>
            <xsl:with-param name="single.year.ranges"
                            select="$single.year.ranges"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="count($years) = 0">
      <xsl:variable name="lastyear" select="$nextyear - 1"/>
      <xsl:choose>
        <xsl:when test="$firstyear = 0">
          <!-- there weren't any years at all -->
        </xsl:when>
        <xsl:when test="$firstyear = $lastyear">
          <xsl:value-of select="$firstyear"/>
        </xsl:when>
        <xsl:when test="$single.year.ranges = 0
                        and $lastyear = $firstyear + 1">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$lastyear"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$firstyear"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="$lastyear"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$firstyear = 0">
      <xsl:call-template name="t:copyright-years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$years[1]"/>
        <xsl:with-param name="nextyear" select="$years[1] + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$nextyear = $years[1]">
      <xsl:call-template name="t:copyright-years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$firstyear"/>
        <xsl:with-param name="nextyear" select="$nextyear + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- we have years left, but they aren't in the current range -->
      <xsl:choose>
        <xsl:when test="$nextyear = $firstyear + 1">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:when test="$single.year.ranges = 0
                        and $nextyear = $firstyear + 2">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$nextyear - 1"/>
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$firstyear"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="$nextyear - 1"/>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="t:copyright-years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$years[1]"/>
        <xsl:with-param name="nextyear" select="$years[1] + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="t:select-mediaobject" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Selects and processes an appropriate media object from a list</refpurpose>

<refdescription>
<para>This template takes a list of media objects (usually the
children of a mediaobject or inlinemediaobject) and processes
the "right" object.</para>

<para>This template relies on <function>f:select-mediaobject-index</function>
to determine which object in the list is appropriate.</para>

<para>If no acceptable object is located, nothing happens.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>olist</term>
<listitem>
<para>The node list of potential objects to examine.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Calls &lt;xsl:apply-templates&gt; on the selected object.</para>
</refreturn>
</doc:template>

<xsl:template name="t:select-mediaobject">
  <xsl:variable name="olist" select="*[not(self::db:info) and not(self::db:alt)]"/>

  <xsl:variable name="mediaobject.index"
                select="f:select-mediaobject-index($olist)"/>

  <xsl:if test="$mediaobject.index != 0">
    <xsl:apply-templates select="$olist[position() = $mediaobject.index]"/>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<doc:function name="f:select-mediaobject-index"
              xmlns="http://docbook.org/ns/docbook">
<refpurpose>Selects the position of the appropriate media object from a list</refpurpose>

<refdescription>
<para>This function takes a list of media objects (usually the
children of a mediaobject or inlinemediaobject) and determines
the "right" object. It returns the position of that object
to be used by the calling template.</para>

<para>If the global parameter
<parameter>use.role.for.mediaobject</parameter> is nonzero, then it
first checks for an object with a role attribute of the appropriate
value. It takes the first of those. Otherwise, it takes the first
acceptable object in the list.</para>

<para>This template relies on a <function>f:is-acceptable-mediaobject</function>
to determine if a given object is an acceptable graphic. The semantics
of media objects is that the first acceptable graphic should be used.
</para>

<para>If no acceptable object is located, no index is returned.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>olist</term>
<listitem>
<para>The node list of potential objects to examine.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Returns the position of the selected object in the original list
or 0 if no object is selected.</para>
</refreturn>
</doc:function>

<xsl:function name="f:select-mediaobject-index" as="xs:integer">
  <xsl:param name="olist" as="element()*"/>

  <xsl:choose>
    <!-- Test for objects preferred by role -->
    <xsl:when test="$use.role.for.mediaobject != 0
                    and $preferred.mediaobject.role != ''
                    and $olist[@role = $preferred.mediaobject.role]">

      <!-- Get the first hit's position index -->
      <xsl:for-each select="$olist">
        <xsl:if test="@role = $preferred.mediaobject.role and
                      not(preceding-sibling::*
                          [@role = $preferred.mediaobject.role])">
          <xsl:value-of select="position()"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:when>

    <xsl:when test="$use.role.for.mediaobject != 0
                    and $olist[@role = $stylesheet.result.type]">
      <!-- Get the first hit's position index -->
      <xsl:for-each select="$olist">
        <xsl:if test="@role = $stylesheet.result.type and
                      not(preceding-sibling::*
                          [@role = $stylesheet.result.type])">
          <xsl:value-of select="position()"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:when>

    <!-- Accept 'html' for $stylesheet.result.type = 'xhtml' -->
    <xsl:when test="$use.role.for.mediaobject != 0
                    and $stylesheet.result.type = 'xhtml'
                    and $olist[@role = 'html']">
      <!-- Get the first hit's position index -->
      <xsl:for-each select="$olist">
        <xsl:if test="@role = 'html' and
                      not(preceding-sibling::*[@role = 'html'])">
          <xsl:value-of select="position()"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="fp:select-mediaobject-index($olist,1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="fp:select-mediaobject-index" as="xs:integer">
  <xsl:param name="olist" as="element()*"/>
  <xsl:param name="count" as="xs:integer"/>

  <xsl:choose>
    <xsl:when test="$count &gt; count($olist)">
      <xsl:value-of select="0"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="object" select="$olist[position()=$count]"/>

      <xsl:variable name="useobject">
        <xsl:choose>
          <!-- Phrase is used only for TeX Math when the output is FO -->
          <xsl:when test="$object/self::db:textobject
                          and $object/db:phrase
                          and $object/@role='tex'
                          and $stylesheet.result.type = 'fo'
                          and $tex.math.in.alt != ''">
            <xsl:value-of select="1"/>
          </xsl:when>

          <!-- Otherwise, phrase is never used -->
          <xsl:when test="$object/self::db:textobject and $object/db:phrase">
            <xsl:value-of select="0"/>
          </xsl:when>

          <!-- The first textobject is a reasonable fallback -->
          <xsl:when test="$object/self::db:textobject
                          and $object[not(@role) or @role != 'tex']">
            <xsl:value-of select="1"/>
          </xsl:when>

          <!-- don't use graphic when output is FO, TeX Math is used
               and there is math in alt element -->
          <xsl:when test="$object/ancestor::db:equation
                          and $object/ancestor::db:equation/db:alt[@role='tex']
                          and $stylesheet.result.type = 'fo'
                          and $tex.math.in.alt != ''">
            <xsl:value-of select="0"/>
          </xsl:when>

          <!-- If there's only one object, use it -->
          <xsl:when test="$count = 1 and count($olist) = 1">
            <xsl:value-of select="1"/>
          </xsl:when>

          <!-- Otherwise, see if this one is a useable graphic -->
          <xsl:otherwise>
            <xsl:choose>
              <!-- peek inside imageobjectco to simplify the test -->
              <xsl:when test="$object/self::db:imageobjectco">
                <xsl:value-of select="f:is-acceptable-mediaobject
                                      ($object/db:imageobject)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="f:is-acceptable-mediaobject($object)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$useobject != '0'">
          <xsl:value-of select="$count"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="fp:select-mediaobject-index($olist, $count+1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<doc:function name="f:is-acceptable-mediaobject" xmlns="">
<refpurpose>Returns '1' if the specified media object is recognized.</refpurpose>

<refdescription>
<para>This template examines a media object and returns '1' if the
object is recognized as a graphic.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>object</term>
<listitem>
<para>The media object to consider.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>0 or 1</para>
</refreturn>
</doc:function>

<xsl:function name="f:is-acceptable-mediaobject" as="xs:integer">
  <xsl:param name="object" as="element()"/>

  <xsl:variable name="filename"
                select="f:mediaobject-filename($object)"/>

  <xsl:variable name="ext"
                select="f:filename-extension($filename)"/>

  <xsl:variable name="data" select="$object/db:videodata
                                    |$object/db:imagedata
                                    |$object/db:audiodata"/>

  <xsl:variable name="explicit-format" select="lower-case($data/@format)"/>

  <xsl:variable name="format" xmlns:svg="http://www.w3.org/2000/svg"
                select="if ($explicit-format)
                        then $explicit-format
                        else
                          if ($data/svg:*)
                          then 'svg'
                          else ''"/>

  <xsl:choose>
    <xsl:when test="$use.svg = 0 and $format = 'svg'">0</xsl:when>
    <xsl:when xmlns:svg="http://www.w3.org/2000/svg"
              test="$use.svg != 0 and $format = 'svg'">1</xsl:when>
    <xsl:when test="index-of($graphic.formats, $format)">1</xsl:when>
    <xsl:when test="index-of($graphic.extensions, $ext)">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:mediaobject-filename">
  <xsl:param name="object" as="element()"/>

  <xsl:variable name="data" select="$object/db:videodata
                                    |$object/db:imagedata
                                    |$object/db:audiodata
                                    |$object"/>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="$data[@fileref]">
        <xsl:apply-templates select="$data/@fileref"/>
      </xsl:when>
      <xsl:when test="$data[@entityref]">
        <xsl:value-of select="$data/unparsed-entity-uri($data/@entityref)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="real.ext" select="f:filename-extension($filename)"/>

  <xsl:variable name="ext">
    <xsl:choose>
      <xsl:when test="$real.ext != ''">
        <xsl:value-of select="$real.ext"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$graphic.default.extension"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$real.ext = ''">
      <xsl:choose>
        <xsl:when test="$ext != ''">
          <xsl:value-of select="$filename"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$ext"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$filename"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="not(index-of($graphic.extensions, $ext))">
      <xsl:choose>
        <xsl:when test="$graphic.default.extension != ''">
          <xsl:value-of select="$filename"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$graphic.default.extension"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$filename"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:mediaobject-href" as="xs:string">
  <xsl:param name="filename" as="xs:string"/>

  <xsl:variable name="outdir" as="xs:string">
    <xsl:choose>
      <xsl:when test="function-available('ext:cwd') and $output.dir = ''">
        <xsl:value-of use-when="function-available('ext:cwd')" select="ext:cwd()"/>
        <xsl:value-of use-when="not(function-available('ext:cwd'))" select="$output.dir"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$output.dir"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--
  <xsl:message>
    <xsl:text>mediaobject-href: </xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>against base uri: </xsl:text>
    <xsl:value-of select="$outdir"/>
  </xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="$outdir != ''">
      <xsl:value-of select="f:relative-uri($filename, $outdir)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:relative-uri" as="xs:string">
  <xsl:param name="absuri" as="xs:string"/>
  <xsl:param name="destdir" as="xs:string"/>

  <xsl:variable name="srcurl">
    <xsl:call-template name="t:strippath">
      <xsl:with-param name="filename"
                      select="if (starts-with($absuri, 'file:/'))
                              then substring-after($absuri, 'file:')
                              else $absuri"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="srcurl.trimmed"
                select="f:trim-common-uri-paths($srcurl, $destdir)"/>

  <xsl:variable name="destdir.trimmed"
                select="f:trim-common-uri-paths($destdir, $srcurl)"/>

  <xsl:variable name="depth"
                select="count(tokenize($destdir.trimmed, '/')[. ne ''])"/>

  <xsl:variable name="prefix" as="xs:string*">
    <xsl:if test="$srcurl ne $srcurl.trimmed">
      <!-- common start of URLs was trimmed we have to 
           use ../ to reach proper level in directory structure -->
      <xsl:for-each select="(1 to $depth)">
        <xsl:value-of select="'../'"/>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="reluri" select="string-join(($prefix, $srcurl.trimmed), '')"/>

  <xsl:value-of select="$reluri"/>
</xsl:function>

<xsl:template name="t:xml-base-dirs">
  <xsl:param name="base.elem" select="()"/>

  <!-- Recursively resolve xml:base attributes -->
  <xsl:if test="$base.elem/ancestor::*[@xml:base != '']">
    <xsl:call-template name="t:xml-base-dirs">
      <xsl:with-param name="base.elem"
                      select="$base.elem/ancestor::*[@xml:base != ''][1]"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:call-template name="t:getdir">
    <xsl:with-param name="filename" select="$base.elem/@xml:base"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:strippath">
  <xsl:param name="filename" select="''"/>

  <xsl:choose>
    <!-- ./ can be ignored -->
    <xsl:when test="starts-with($filename, './')">
      <xsl:call-template name="t:strippath">
        <xsl:with-param name="filename"
          select="substring-after($filename, './')"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Leading .. are not eliminated -->
    <xsl:when test="starts-with($filename, '../')">
      <xsl:value-of select="'../'"/>
      <xsl:call-template name="t:strippath">
        <xsl:with-param name="filename"
                        select="substring-after($filename, '../')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($filename, '/../')">
      <xsl:call-template name="t:strippath">
        <xsl:with-param name="filename">
          <xsl:call-template name="t:getdir">
            <xsl:with-param name="filename"
                            select="substring-before($filename, '/../')"/>
          </xsl:call-template>
          <xsl:value-of select="substring-after($filename, '/../')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:getdir">
  <xsl:param name="filename" select="''"/>
  <xsl:if test="contains($filename, '/')">
    <xsl:value-of select="substring-before($filename, '/')"/>
    <xsl:text>/</xsl:text>
    <xsl:call-template name="t:getdir">
      <xsl:with-param name="filename"
                      select="substring-after($filename, '/')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="t:root-messages">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<doc:template name="id" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns an “id” attribute if appropriate</refpurpose>

<refdescription>
<para>This template returns an attribute named “id” if the specified
node has an <tag class="attribute">id</tag>
(or <tag class="attribute">xml:id</tag>) attribute or if the
<parameter>force</parameter> parameter is non-zero.</para>

<para>If an ID is generated, it's value is <function>f:node-id()</function>.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which an ID should be generated. It defaults to
the context item.</para>
</listitem>
</varlistentry>
<varlistentry><term>force</term>
<listitem>
<para>To force an “id” attribute to be generated, even if the node does
not have an ID, make this parameter non-zero. It defaults to 0.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>An “id” attribute or nothing.</para>
</refreturn>

</doc:template>

<xsl:template name="t:id" as="attribute(id)?">
  <xsl:param name="node" select="."/>
  <xsl:param name="force" select="0"/>

  <xsl:if test="($force != 0) or ($node/@id or $node/@xml:id)">
    <xsl:attribute name="id" select="f:node-id($node)"/>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="t:check-id-unique" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Warn users about references to non-unique IDs</refpurpose>
<refdescription id="check.id.unique-desc">
<para>If passed an ID in <varname>linkend</varname>,
<function>t:check-id-unique</function> prints
a warning message to the user if either the ID does not exist or
the ID is not unique.</para>
</refdescription>
</doc:template>

<xsl:template name="t:check-id-unique">
  <xsl:param name="linkend"/>

  <xsl:if test="$linkend != ''">
    <xsl:variable name="targets" select="key('id',$linkend)"/>

    <xsl:if test="not($targets)">
      <xsl:message>
        <xsl:text>Error: no ID for constraint linkend: </xsl:text>
        <xsl:value-of select="$linkend"/>
        <xsl:text>.</xsl:text>
      </xsl:message>
    </xsl:if>

    <xsl:if test="count($targets) &gt; 1">
      <xsl:message>
        <xsl:text>Warning: multiple "IDs" for constraint linkend: </xsl:text>
        <xsl:value-of select="$linkend"/>
        <xsl:text>.</xsl:text>
      </xsl:message>
    </xsl:if>
  </xsl:if>
</xsl:template>

<doc:template name="t:check-idref-targets" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Warn users about incorrectly typed references</refpurpose>
<refdescription id="check.idref.targets-desc">
<para>If passed an ID in <varname>linkend</varname>,
<function>t:check-idref-targets</function> makes sure that the element
pointed to by the link is one of the elements listed in
<varname>element-list</varname> and warns the user otherwise.</para>
<para>The <varname>element-list</varname> is a list of QNames.</para>
</refdescription>
</doc:template>

<xsl:template name="t:check-idref-targets">
  <xsl:param name="linkend"/>
  <xsl:param name="element-list" as="xs:QName*"/>

  <xsl:if test="$linkend != ''">
    <xsl:variable name="targets" select="key('id',$linkend)"/>

    <xsl:if test="$targets
                  and empty(index-of($element-list,node-name($targets[1])))">
      <xsl:message>
        <xsl:text>Error: linkend (</xsl:text>
        <xsl:value-of select="$linkend"/>
        <xsl:text>) points to "</xsl:text>
        <xsl:value-of select="local-name($targets[1])"/>
        <xsl:text>" not (one of): </xsl:text>
        <xsl:value-of select="$element-list" separator=", "/>
      </xsl:message>
    </xsl:if>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
