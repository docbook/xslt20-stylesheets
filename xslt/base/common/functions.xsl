<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fp="http://docbook.org/xslt/ns/extension/private"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f fp l m mp u xs"
                version="2.0">

<doc:reference xmlns="http://docbook.org/ns/docbook">
<info>
<title>Common Functions Reference</title>
<author>
  <personname>
    <surname>Walsh</surname>
    <firstname>Norman</firstname>
  </personname>
</author>
<copyright><year>2004</year>
<holder>Norman Walsh</holder>
</copyright>
<releaseinfo role="cvs">
$Id: functions.xsl 8562 2009-12-17 23:10:25Z nwalsh $
</releaseinfo>
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

<doc:function name="f:xptr-id" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns an XPointer-style ID for the specified node</refpurpose>

<refdescription>
<para>This function returns the <tag class="attribute">id</tag> or
<tag class="attribute">xml:id</tag> of the specified node. If the
node does not have an ID, an XPointer-style “tumbler” ID is used
to create one. In order to make sure that the value is a valid ID,
the root is represented by “R.” and “.”s are used between each
number.</para>
<para>The value of <function>xptr-id</function>’s over
<function>node-id</function>s is that they are stable. If the same
document is processed more than once, each pass will produce the
same XPointer IDs.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which an ID will be generated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The ID.</para>
</refreturn>
</doc:function>

<xsl:function name="f:xptr-id" as="xs:string">
  <xsl:param name="node" as="element()"/>

  <xsl:choose>
    <xsl:when test="$node/@xml:id">
      <xsl:value-of select="$node/@xml:id"/>
    </xsl:when>
    <xsl:when test="$node/@id">
      <xsl:value-of select="$node/@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of>
	<xsl:choose>
	  <xsl:when test="not($node/parent::*)">R.</xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat(f:xptr-id($node/parent::*), '.')"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="count($node/preceding-sibling::*)+1"/>
      </xsl:value-of>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:orderedlist-starting-number"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the number of the first item in an ordered list</refpurpose>

<refdescription>
<para>This function returns the number of the first item in an
<tag>orderedlist</tag>.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>list</term>
<listitem>
<para>The <tag>orderedlist</tag> element for which the starting number
is to be determined.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The starting list number.</para>
</refreturn>
</doc:function>

<xsl:function name="f:orderedlist-starting-number" as="xs:integer">
  <xsl:param name="list" as="element(db:orderedlist)"/>

  <xsl:variable name="pi-start"
		select="f:pi($list/processing-instruction('db-xsl'), 'start')"/>

  <xsl:choose>
    <xsl:when test="$list/@startingnumber">
      <xsl:value-of select="$list/@startingnumber"/>
    </xsl:when>
    <xsl:when test="$pi-start">
      <xsl:value-of select="$pi-start cast as xs:integer"/>
    </xsl:when>
    <xsl:when test="not($list/@continuation = 'continues')">
      <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="prevlist"
		    select="$list/preceding::db:orderedlist[1]"/>
      <xsl:choose>
	<xsl:when test="count($prevlist) = 0">
	  <xsl:value-of select="1"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="prevlength" select="count($prevlist/db:listitem)"/>
	  <xsl:variable name="prevstart"
			select="f:orderedlist-starting-number($prevlist)"/>
	  <xsl:value-of select="$prevstart + $prevlength"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:in-scope-pis" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the processing-instructions that are in scope</refpurpose>

<refdescription>
<para>Processing instructions can be used to control some of the behavior of
the DocBook stylesheets. This function returns the ones that are “in scope” for
any given element.</para>

<para>The general rules is that processing instructions that are the children
of the context node are in scope, as are processing instructions that appear
<emphasis>before</emphasis> the root node of the document.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>context</term>
<listitem>
<para>The context node</para>
</listitem>
</varlistentry>
<varlistentry><term>target</term>
<listitem>
<para>The PI target that is to be returned</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The sequence of in-scope PIs.</para>
</refreturn>
</doc:function>

<xsl:function name="f:in-scope-pis" as="processing-instruction()*">
  <xsl:param name="context" as="node()"/>
  <xsl:param name="target" as="xs:string"/>

  <xsl:sequence select="($context/processing-instruction()[local-name(.) = $target],
                         root($context)/processing-instruction()[local-name(.) = $target])"/>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:pi" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the value of the first matching pseudo-attribute</refpurpose>

<refdescription>
<para>This function searches a list of processing instructions for the
first psuedo-attribute matching the specified name and returns its value.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>pis</term>
<listitem>
<para>The list of processing instructions.</para>
</listitem>
</varlistentry>
<varlistentry><term>attribute</term>
<listitem>
<para>The name of the pseudo-attribute to return.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The value of the pseudo-attribute or an empty sequence if no
such attribute can be found.</para>
</refreturn>
</doc:function>

<xsl:function name="f:pi" as="xs:string?">
  <xsl:param name="pis" as="processing-instruction()*"/>
  <xsl:param name="attribute" as="xs:string"/>

  <xsl:variable name="values" as="xs:string*">
    <xsl:for-each select="$pis">
      <xsl:variable name="pivalue">
        <xsl:value-of select="concat(' ', normalize-space(.))"/>
      </xsl:variable>

      <xsl:if test="contains($pivalue,concat(' ', $attribute, '='))">
        <xsl:variable name="rest"
                      select="substring-after($pivalue, concat(' ', $attribute,'='))"/>
        <xsl:variable name="quote" select="substring($rest,1,1)"/>
        <xsl:value-of select="substring-before(substring($rest,2),$quote)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:sequence select="$values[1]"/>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:xpath-location" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns a pseudo-XPath expression locating the specified node</refpurpose>

<refdescription>
<para>This function returns a psuedo-XPath expression that navigates from
the root of the document to the specified node.</para>

<warning>
<para>The XPath returned
uses only the <function>local-name</function> of the node so it relies
on the default namespace. For a mixed-namespace document, this may simply
be impossible.</para>
</warning>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which a pseudo-XPath will be generated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The pseudo-XPath.</para>
</refreturn>
</doc:function>

<xsl:function name="f:xpath-location" as="xs:string">
  <xsl:param name="node" as="element()"/>

  <xsl:value-of select="f:xpath-location($node, '')"/>
</xsl:function>

<xsl:function name="f:xpath-location" as="xs:string">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="path" as="xs:string"/>

  <xsl:variable name="next.path">
    <xsl:value-of select="local-name($node)"/>
    <xsl:if test="$path != ''">/</xsl:if>
    <xsl:value-of select="$path"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$node/parent::*">
      <xsl:value-of select="f:xpath-location($node/parent::*, $next.path)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('/', $next.path)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ====================================================================== -->

<doc:function name="f:is-component" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns true if the specified node is a “component”</refpurpose>

<refdescription>
<para>This function return true if the specified node is a “component,” that
is a <tag>appendix</tag>, <tag>article</tag>, <tag>chapter</tag>,
<tag>preface</tag>, <tag>bibliography</tag>, <tag>glossary</tag>,
or <tag>index</tag>.</para>
<para>It is defined as a function so that customizers can add other
elements to the list of components, if necessary.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node to test.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True if the node is a component, false otherwise.</para>
</refreturn>
</doc:function>

<xsl:function name="f:is-component" as="xs:boolean">
  <xsl:param name="node" as="element()"/>

  <xsl:value-of select="if ($node/self::db:appendix
			    | $node/self::db:article
			    | $node/self::db:chapter
			    | $node/self::db:preface
			    | $node/self::db:bibliography
			    | $node/self::db:glossary
			    | $node/self::db:index)
			then true()
			else false()"/>
</xsl:function>

<!-- ====================================================================== -->

<doc:function name="f:is-section" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns true if the specified node is a “section”</refpurpose>

<refdescription>
<para>This function return true if the specified node is a “section,” that
is a <tag>section</tag>, <tag>sect<replaceable>1-5</replaceable></tag>,
<tag>refsect<replaceable>1-3</replaceable></tag>, or
<tag>simplesect</tag>.</para>
<para>It is defined as a function so that customizers can add other
elements to the list of sections, if necessary.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node to test.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True if the node is a section, false otherwise.</para>
</refreturn>
</doc:function>

<xsl:function name="f:is-section" as="xs:boolean">
  <xsl:param name="node" as="element()"/>

  <xsl:value-of select="if ($node/self::db:section
			    | $node/self::db:sect1
			    | $node/self::db:sect2
			    | $node/self::db:sect3
			    | $node/self::db:sect4
			    | $node/self::db:sect5
			    | $node/self::db:refsect1
			    | $node/self::db:refsect2
			    | $node/self::db:refsect3
			    | $node/self::db:refsection
			    | $node/self::db:simplesect)
			 then true()
			 else false()"/>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:section-level" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the nesting depth of the specified section</refpurpose>

<refdescription>
<para>This function return the nesting depth of the specified section.
Top level sections are at level “1”.</para>
<para>If the section belongs to a <tag>refentry</tag>, the value of
<function>refentry-section-level</function> is returned.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>section</term>
<listitem>
<para>The section element for which the depth should be calculated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The section level.</para>
</refreturn>
</doc:function>

<xsl:function name="f:section-level" as="xs:integer">
  <xsl:param name="node" as="element()"/>

  <xsl:variable name="level" as="xs:integer">
    <xsl:choose>
      <xsl:when test="$node/self::db:sect1">1</xsl:when>
      <xsl:when test="$node/self::db:sect2">2</xsl:when>
      <xsl:when test="$node/self::db:sect3">3</xsl:when>
      <xsl:when test="$node/self::db:sect4">4</xsl:when>
      <xsl:when test="$node/self::db:sect5">5</xsl:when>
      <xsl:when test="$node/self::db:section">
	<xsl:value-of select="count($node/ancestor::db:section)+1"/>
      </xsl:when>
      <xsl:when test="$node/self::db:refsect1 or
		      $node/self::db:refsect2 or
		      $node/self::db:refsect3 or
		      $node/self::db:refsection or
		      $node/self::db:refsynopsisdiv">
	<xsl:value-of select="f:refentry-section-level($node)"/>
      </xsl:when>
      <xsl:when test="$node/self::db:simplesect">
	<xsl:choose>
	  <xsl:when test="$node/parent::db:sect1">2</xsl:when>
	  <xsl:when test="$node/parent::db:sect2">3</xsl:when>
	  <xsl:when test="$node/parent::db:sect3">4</xsl:when>
	  <xsl:when test="$node/parent::db:sect4">5</xsl:when>
	  <xsl:when test="$node/parent::db:sect5">6</xsl:when>
	  <xsl:when test="$node/parent::db:section">
	    <xsl:value-of select="count($node/ancestor::db:section)+2"/>
	  </xsl:when>
	  <xsl:otherwise>1</xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$node/ancestor::db:appendix[parent::db:article]">
      <xsl:value-of select="$level + 1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$level"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:pseudo-section-level"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the nesting depth of the specified element</refpurpose>

<refdescription>
<para>This function return the nesting depth of the specified element.
The purpose of this function is to calculate the effective depth of an
element, as if it were a section. (If it really is a section, use
<function>section-level</function> instead.)</para>

<para>This can be used to calculate the appropriate size for the titles
of elements such as <tag>qanda</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The element for which the depth should be calculated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The element's pseudo section level.</para>
</refreturn>
</doc:function>

<xsl:function name="f:pseudo-section-level" as="xs:integer">
  <xsl:param name="node" as="element()"/>

  <xsl:choose>
    <xsl:when test="f:is-section($node)">
      <xsl:value-of select="f:section-level($node)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="section"
		    select="($node/ancestor::db:section
			    |$node/ancestor::db:simplesect
			    |$node/ancestor::db:sect5
			    |$node/ancestor::db:sect4
			    |$node/ancestor::db:sect3
			    |$node/ancestor::db:sect2
			    |$node/ancestor::db:sect1
			    |$node/ancestor::db:refsection
			    |$node/ancestor::db:refsect3
			    |$node/ancestor::db:refsect2
			    |$node/ancestor::db:refsect1)[last()]"/>
      <xsl:choose>
	<xsl:when test="not($section)">1</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="f:section-level($section) + 1"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:refentry-section-level"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the nesting depth of the specified <tag>refentry</tag>
section</refpurpose>

<refdescription>
<para>This function return the nesting depth of the specified section in
a <tag>refentry</tag>.
Top level sections are at level 1 greater than the level of the
enclosing <tag>refentry</tag>; see <function>refentry-level</function>.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>section</term>
<listitem>
<para>The section element for which the depth should be calculated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The section level.</para>
</refreturn>
</doc:function>

<xsl:function name="f:refentry-section-level" as="xs:integer">
  <xsl:param name="section" as="element()"/>

  <xsl:variable name="RElevel"
		select="f:refentry-level($section/ancestor::db:refentry[1])"/>

  <xsl:variable name="levelinRE" as="xs:integer">
    <xsl:choose>
      <xsl:when test="$section/self::db:refsynopsisdiv">1</xsl:when>
      <xsl:when test="$section/self::db:refsect1">1</xsl:when>
      <xsl:when test="$section/self::db:refsect2">2</xsl:when>
      <xsl:when test="$section/self::db:refsect3">3</xsl:when>
      <xsl:when test="$section/self::db:refsection">
	<xsl:value-of select="count($section/ancestor::db:refsection)+1"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise> <!-- this can't happen -->
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$levelinRE + $RElevel"/>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:refentry-level"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the nesting depth of the specified <tag>refentry</tag>
</refpurpose>

<refdescription>
<para>This function return the nesting depth of the specified
<tag>refentry</tag>. The level of a <tag>refentry</tag> depends on the
context in which it occurs. They are at level 1 greater than the level of
the section that contains them, if they occur in a section, and at level
“1” otherwise.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>refentry</term>
<listitem>
<para>The <tag>refentry</tag> element for which the depth should
be calculated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The <tag>refentry</tag> level.</para>
</refreturn>
</doc:function>

<xsl:function name="f:refentry-level" as="xs:integer">
  <xsl:param name="refentry" as="element(db:refentry)"/>

  <xsl:variable name="container"
                select="($refentry/ancestor::db:section
                         | $refentry/ancestor::db:sect1
			 | $refentry/ancestor::db:sect2
			 | $refentry/ancestor::db:sect3
			 | $refentry/ancestor::db:sect4
			 | $refentry/ancestor::db:sect5)[last()]"/>

  <xsl:choose>
    <xsl:when test="$container">
      <xsl:value-of select="f:section-level($container) + 1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:pad" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Constructs a string of the specified length</refpurpose>

<refdescription>
<para>Returns a string of <parameter>char</parameter> characters
that is <parameter>count</parameter> characters long.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>count</term>
<listitem>
<para>The desired string length.</para>
</listitem>
</varlistentry>
<varlistentry><term>char</term>
<listitem>
<para>The single character that should be repeated to construct the string.
</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The string of the specified length.</para>
</refreturn>
</doc:function>

<xsl:function name="f:pad">
  <xsl:param name="count" as="xs:integer"/>
  <xsl:param name="char" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="$count &gt; 4">
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="f:pad($count - 4, $char)"/>
    </xsl:when>
    <xsl:when test="$count &gt; 3">
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="f:pad($count - 3, $char)"/>
    </xsl:when>
    <xsl:when test="$count &gt; 2">
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="f:pad($count - 2, $char)"/>
    </xsl:when>
    <xsl:when test="$count &gt; 1">
      <xsl:value-of select="$char"/>
      <xsl:value-of select="f:pad($count - 1, $char)"/>
    </xsl:when>
    <xsl:when test="$count &gt; 0">
      <xsl:value-of select="$char"/>
    </xsl:when>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:find-node-in-sequence"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Finds a particular node in a sequence of nodes</refpurpose>

<refdescription>
<para>This function searches a sequence of nodes and returns the position
of a particular node in that sequence. The function returns 0 if the
node is not found.</para>
<para>Note that this function searches based on node identity, the target
node must literally be in the sequence; it is not sufficient, for example,
for another node with the same name to appear in the sequence.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>nodes</term>
<listitem>
<para>The sequence to search.</para>
</listitem>
</varlistentry>
<varlistentry><term>target</term>
<listitem>
<para>The node to find.
</para>
</listitem>
</varlistentry>
<varlistentry><term>start</term>
<listitem>
<para>The position at which to begin searching.
</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The ordinal position of the node, or 0 if it is not found.</para>
</refreturn>
</doc:function>

<xsl:function name="f:find-node-in-sequence" as="xs:integer">
  <xsl:param name="nodes" as="node()*"/>
  <xsl:param name="target" as="node()"/>
  <xsl:param name="start" as="xs:integer"/>

  <xsl:choose>
    <xsl:when test="$start &gt; count($nodes)">0</xsl:when>
    <xsl:when test="$nodes[$start] is $target">
      <xsl:value-of select="$start"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="f:find-node-in-sequence($nodes, $target,
			                            $start+1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:find-toc-params"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Finds the TOC parameters for an element</refpurpose>

<refdescription>
<para>This function returns the matching TOC parameter element in the
specified list. The matching parameter is the one with the longest
matching path.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node to use for matching, usually the context node.</para>
</listitem>
</varlistentry>
<varlistentry><term>toc</term>
<listitem>
<para>The TOC parameter list.
</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The matching node or the empty sequence if no node matches.</para>
</refreturn>
</doc:function>

<xsl:function name="f:find-toc-params" as="element()?">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="toc" as="element()*"/>
  <xsl:variable name="location" select="f:xpath-location($node)"/>

  <xsl:sequence select="fp:find-toc-params($node, $toc, $location)"/>
</xsl:function>

<xsl:function name="fp:find-toc-params" as="element()?">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="toc" as="element()*"/>
  <xsl:param name="location" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="$toc[@path=$location]">
      <xsl:sequence select="$toc[@path=$location][1]"/>
    </xsl:when>
    <xsl:when test="not(contains($location, '/'))">
      <xsl:sequence select="()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="fp:find-toc-params($node, $toc,
			         substring-after($location, '/'))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:trim-common-uri-paths"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Trim common leading path information from a URI</refpurpose>

<refdescription>
<para>This function trims common leading path components from a
relative URI.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>uriA</term>
<listitem>
<para>The first URI.</para>
</listitem>
</varlistentry>
<varlistentry><term>uriB</term>
<listitem>
<para>The second URI.
</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The <parameter>uriA</parameter> trimmed of all the initial path
components that it has in common with <parameter>uriB</parameter>.</para>
</refreturn>
</doc:function>

<xsl:function name="f:trim-common-uri-paths" as="xs:string">
  <xsl:param name="uriA" as="xs:string?"/>
  <xsl:param name="uriB" as="xs:string?"/>

  <xsl:choose>
    <xsl:when test="empty($uriA)">
      <xsl:value-of select="$uriB"/>
    </xsl:when>
    <xsl:when test="not(contains($uriA, '/'))
                    or not(contains($uriB, '/'))
		    or substring-before($uriA, '/') 
		       != substring-before($uriB, '/')">
      <xsl:value-of select="$uriA"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="f:trim-common-uri-paths(
			        substring-after($uriA, '/'),
			        substring-after($uriB, '/'))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:filename-basename"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Return the filename part of a directory name</refpurpose>

<refdescription>
<para>This function returns the last path component of a directory name
or URI in a hierarchical URI scheme.
</para>
<para>This function assumes all filenames are really URIs and always
expects “/” to be the component separator.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>filename</term>
<listitem>
<para>The full filename with path or other components.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The last path component.</para>
</refreturn>

<u:unittests function="f:filename-basename">
  <u:test>
    <u:param>/path/to/my/file.ext</u:param>
    <u:result>'file.ext'</u:result>
  </u:test>
  <u:test>
    <u:param>http://path/spec/to/here</u:param>
    <u:result>'here'</u:result>
  </u:test>
  <u:test>
    <u:param>noslashes</u:param>
    <u:result>'noslashes'</u:result>
  </u:test>
</u:unittests>

</doc:function>

<xsl:function name="f:filename-basename" as="xs:string">
  <xsl:param name="filename" as="xs:string"/>

  <xsl:value-of select="tokenize($filename,'/')[last()]"/>
</xsl:function>

<xsl:function name="f:filename-extension" as="xs:string">
  <xsl:param name="filename" as="xs:string"/>

  <!-- Make sure we only look at the base name... -->
  <xsl:variable name="basefn" select="f:filename-basename($filename)"/>

  <xsl:choose>
    <xsl:when test="contains($basefn, '.')">
      <xsl:value-of select="tokenize($basefn,'\.')[last()]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="''"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:length-magnitude" as="xs:double?">
  <xsl:param name="length" as="xs:string"/>

  <xsl:if test="matches(normalize-space($length), '^[0-9\.]+')">
    <xsl:value-of select="replace(normalize-space($length),
			          '(^[0-9\.]+).*',
				  '$1')"/>
  </xsl:if>
</xsl:function>

<!-- ================================================================== -->

<xsl:function name="f:length-units">
  <xsl:param name="length" as="xs:string"/>
  <xsl:value-of select="f:length-units($length, 'px')"/>
</xsl:function>

<xsl:function name="f:length-units">
  <xsl:param name="length" as="xs:string"/>
  <xsl:param name="default.units" as="xs:string"/>

  <xsl:variable name="units"
                select="if (matches(normalize-space($length), '^[0-9\.]+.*?'))
                        then replace(normalize-space($length),'^[0-9\.]+(.*?)$','$1')
                        else ''"/>

  <xsl:choose>
    <xsl:when test="$units = ''">
      <xsl:value-of select="$default.units"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$units"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ================================================================== -->

<xsl:function name="f:length-spec">
  <xsl:param name="length" as="xs:string"/>
  <xsl:value-of select="f:length-spec($length, 'px')"/>
</xsl:function>

<xsl:function name="f:length-spec">
  <xsl:param name="length" as="xs:string"/>
  <xsl:param name="default.units" as="xs:string"/>

  <xsl:variable name="magnitude" select="f:length-magnitude($length)"/>
  <xsl:variable name="units" select="f:length-units($length)"/>

  <xsl:value-of select="$magnitude"/>

  <xsl:choose>
    <xsl:when test="$units='cm'
                    or $units='mm'
                    or $units='in'
                    or $units='pt'
                    or $units='pc'
                    or $units='px'
                    or $units='em'">
      <xsl:value-of select="$units"/>
    </xsl:when>
    <xsl:when test="$units = ''">
      <xsl:value-of select="$default.units"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unrecognized unit of measure: </xsl:text>
        <xsl:value-of select="$units"/>
        <xsl:text>; using </xsl:text>
        <xsl:value-of select="$default.units"/>
      </xsl:message>
      <xsl:value-of select="$default.units"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ================================================================== -->

<xsl:function name="f:first-in-context" as="xs:boolean">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="context" as="element()"/>

  <xsl:variable name="pnode"
		select="$node/preceding::*[node-name(.)=node-name($node)][1]"/>

  <xsl:value-of select="if ($pnode)
			then ($pnode &lt;&lt; $context) or ($pnode eq $context)
			else true()"/>
</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:pi-attribute" as="xs:string">
  <xsl:param name="pis"/>
  <xsl:param name="attribute"/>
  <xsl:value-of select="f:pi-attribute($pis,$attribute,1)"/>
</xsl:function>

<xsl:function name="f:pi-attribute" as="xs:string">
  <xsl:param name="pis"/>
  <xsl:param name="attribute"/>
  <xsl:param name="count"/>

  <xsl:choose>
    <xsl:when test="empty($pis)">
      <!-- no pis -->
      <xsl:value-of select="''"/>
    </xsl:when>
    <xsl:when test="$count &gt; count($pis)">
      <!-- not found -->
      <xsl:value-of select="''"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="pi">
        <xsl:value-of select="$pis[$count]"/>
      </xsl:variable>
      <xsl:variable name="pivalue">
        <xsl:value-of select="concat(' ', normalize-space($pi))"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($pivalue,concat(' ', $attribute, '='))">
          <xsl:variable name="rest" select="substring-after($pivalue,concat(' ', $attribute,'='))"/>
          <xsl:variable name="quote" select="substring($rest,1,1)"/>
          <xsl:value-of select="substring-before(substring($rest,2),$quote)"/>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="f:pi-attribute($pis,$attribute,$count + 1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:xpointer-idref"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the ID portion of an XPointer</refpurpose>

<refdescription>
<para>The <function role="template">xpointer-idref</function> template
returns the
ID portion of an XPointer which is a pointer to an ID within the current
document, or the empty string if it is not.</para>

<para>In other words, <function>xpointer-idref</function> returns
<quote>foo</quote> when passed either <literal>#foo</literal>
or <literal>#xpointer(id('foo'))</literal>, otherwise it returns
the empty string.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>xpointer</term>
<listitem>
<para>The string containing the XPointer.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The ID portion of the XPointer or an empty string.</para>
</refreturn>
</doc:function>

<xsl:function name="f:xpointer-idref">
  <xsl:param name="xpointer"/>

  <xsl:choose>
    <xsl:when test="starts-with($xpointer, '#xpointer(id(')">
      <xsl:variable name="rest"
		    select="substring-after($xpointer, '#xpointer(id(')"/>
      <xsl:variable name="quote" select="substring($rest, 1, 1)"/>
      <xsl:value-of select="substring-before(substring-after($xpointer, $quote), $quote)"/>
    </xsl:when>
    <xsl:when test="starts-with($xpointer, '#')">
      <xsl:value-of select="substring-after($xpointer, '#')"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- otherwise it's a pointer to some other document -->
      <xsl:value-of select="''"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:resolve-path"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Resolves a relative URI against an absolute path</refpurpose>

<refdescription>
<para>The <function>resolve-path</function> resolves the <parameter>uri</parameter>
against the <parameter>abspath</parameter> and returns the resulting path.
This function avoids the problem that <function>fn:resolve-uri</function> requires
an absolute URI (including a scheme!).</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>uri</term>
<listitem>
<para>The relative URI to be resolved.</para>
</listitem>
</varlistentry>
<varlistentry><term>abspath</term>
<listitem>
<para>The base URI (or absolute path) against which to resolve <parameter>uri</parameter>.
</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The resolved path.</para>
</refreturn>
</doc:function>

<xsl:function name="f:resolve-path" as="xs:string">
  <xsl:param name="uri" as="xs:string"/>
  <xsl:param name="abspath" as="xs:string"/>

  <xsl:value-of select="f:resolve-path($uri, $abspath, static-base-uri())"/>
</xsl:function>

<!-- this three-argument form really only exists for testing -->
<xsl:function name="f:resolve-path" as="xs:string">
  <xsl:param name="uri" as="xs:string"/>
  <xsl:param name="abspath" as="xs:string"/>
  <xsl:param name="static-base-uri" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="matches($abspath, '^[-a-zA-Z0-9]+:')">
      <!-- $abspath is an absolute URI -->
      <xsl:value-of select="resolve-uri($uri, $abspath)"/>
    </xsl:when>
    <xsl:when test="matches($static-base-uri, '^[-a-zA-Z0-9]+:')">
      <!-- the static base uri is an absolute URI -->

      <!-- We have to make $abspath absolute (per the finicky def in
           XSLT 2.0) but if the static base uri is a file:// uri, we
           want to pull the file:// bit back off the front. (So that
           the files can be copied to a web server.)

           This is especially tricky in the Windows case, which I can't
           test especially well. If the absolute URI is file:///D:/path
           then stripping off file:/// leaves D:/path which looks like
           an the "D" scheme.

           New plan: strip off the drive as well. This means you won't
           be able to have files on different drives, but leaving in
           the drives means you can't copy to a web server anyway.
      -->

      <xsl:variable name="resolved-abs"
                    select="resolve-uri($abspath, $static-base-uri)"/>
      <xsl:variable name="resolved"
                    select="resolve-uri($uri, $resolved-abs)"/>

      <!-- strip off the leading file: -->
      <!-- this is complicated by two things, first it's not clear when we get
           file:///path and when we get file://path; second, on a Windows system
           if we get file://D:/path we have to remove the drive -->
      <xsl:choose>
        <xsl:when test="matches($resolved, '^file:///?[A-Za-z]:')">
          <xsl:value-of select="replace($resolved,
                                        '^file:///?[A-Za-z]:(.*)$', '$1')"/>
        </xsl:when>
        <xsl:when test="matches($resolved, '^file://.:')">
          <xsl:value-of select="substring-after($resolved, 'file://')"/>
        </xsl:when>
        <xsl:when test="matches($resolved, '^file:/.:')">
          <xsl:value-of select="substring-after($resolved, 'file:/')"/>
        </xsl:when>
        <xsl:when test="starts-with($resolved, 'file://')">
          <xsl:value-of select="substring-after($resolved, 'file:/')"/>
        </xsl:when>
        <xsl:when test="starts-with($resolved, 'file:/')">
          <xsl:value-of select="substring-after($resolved, 'file:')"/>
        </xsl:when>
        <xsl:when test="starts-with($resolved, '[A-Za-z]:/')">
          <xsl:value-of select="substring($resolved, 3)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$resolved"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="matches($uri, '^[-a-zA-Z0-9]+:') or starts-with($uri, '/')">
      <!-- $uri is already absolute -->
      <xsl:value-of select="$uri"/>
    </xsl:when>
    <xsl:when test="not(starts-with($abspath, '/'))">
      <!-- if the $abspath isn't absolute, we lose -->
      <xsl:value-of select="error((), '$abspath in f:resolve-path is not absolute')"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- otherwise, resolve them together -->
      <xsl:variable name="base" select="replace($abspath, '^(.*)/[^/]*$', '$1')"/>

      <xsl:variable name="allsegs" select="(tokenize(substring-after($base, '/'), '/'),
                                         tokenize($uri, '/'))"/>
      <xsl:variable name="segs" select="$allsegs[. != '.']"/>
      <xsl:variable name="path" select="fp:resolve-dotdots($segs)"/>
      <xsl:value-of select="concat('/', string-join($path, '/'))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="fp:resolve-dotdots" as="xs:string*">
  <xsl:param name="segs" as="xs:string*"/>
  <xsl:variable name="pos" select="index-of($segs, '..')"/>
  <xsl:choose>
    <xsl:when test="empty($pos)">
      <xsl:sequence select="$segs"/>
    </xsl:when>
    <xsl:when test="$pos[1] = 1">
      <xsl:sequence select="fp:resolve-dotdots(subsequence($segs, 2))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="fp:resolve-dotdots(
                            (subsequence($segs, 1, $pos[1] - 2),
                             subsequence($segs, $pos[1] + 1)))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:strip-file-uri-scheme"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Strip file: URI shemes off URIs</refpurpose>

<refdescription>
<para>The <function>strip-file-uri-scheme</function> removes any leading
<code>file:</code> URI schemes from the URI.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>uri</term>
<listitem>
<para>The URI to be stripped.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The uri without the leading scheme.</para>
</refreturn>
</doc:function>

<xsl:function name="f:strip-file-uri-scheme" as="xs:string">
  <xsl:param name="uri" as="xs:string"/>

  <!-- Stripping is complicated by two things, first it's not
       clear when we get file:///path and when we get file://path;
       second, on a Windows system, if we get file://D:/path we
       have to remove the drive as well. -->

  <xsl:choose>
    <xsl:when test="matches($uri, '^file:///?[A-Za-z]:')">
      <xsl:value-of select="replace($uri, '^file:///?[A-Za-z]:(.*)$', '$1')"/>
    </xsl:when>
    <xsl:when test="matches($uri, '^file://.:')">
      <xsl:value-of select="substring-after($uri, 'file://')"/>
    </xsl:when>
    <xsl:when test="matches($uri, '^file:/.:')">
      <xsl:value-of select="substring-after($uri, 'file:/')"/>
    </xsl:when>
    <xsl:when test="starts-with($uri, 'file://')">
      <xsl:value-of select="substring-after($uri, 'file:/')"/>
    </xsl:when>
    <xsl:when test="starts-with($uri, 'file:/')">
      <xsl:value-of select="substring-after($uri, 'file:')"/>
    </xsl:when>
    <xsl:when test="starts-with($uri, '[A-Za-z]:/')">
      <xsl:value-of select="substring($uri, 3)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$uri"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

</xsl:stylesheet>
