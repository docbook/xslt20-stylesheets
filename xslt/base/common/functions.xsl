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

<doc:function name="f:node-id" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns an ID for the specified node</refpurpose>

<refdescription>
<para>This function returns the <tag class="attribute">id</tag> or
<tag class="attribute">xml:id</tag> of the specified node. If the
node does not have an ID, the XSLT
<function>generate-id()</function> function is used to create one.
</para>
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

<u:unittests function="f:node-id">
  <u:test>
    <u:param>
      <db:anchor xml:id='id'/>
    </u:param>
    <u:result>'id'</u:result>
  </u:test>
  <u:test>
    <u:param><db:anchor id='id'/></u:param>
    <u:result>'id'</u:result>
  </u:test>
  <u:test>
    <u:param><db:anchor/></u:param>
    <u:result>'R.1'</u:result>
  </u:test>
  <u:test>
    <u:variable name="mydoc">
      <db:book>
	<db:title>Some Title</db:title>
	<db:chapter>
	  <db:title>Some Chapter Title</db:title>
	  <db:para>My para.</db:para>
	</db:chapter>
      </db:book>
    </u:variable>
    <u:param select="$mydoc//db:para[1]"/>
    <u:result>'R.1.2.2'</u:result>
  </u:test>
  <u:test>
    <u:param select="//db:para[1]">
      <db:book>
	<db:title>Some Title</db:title>
	<db:chapter>
	  <db:title>Some Chapter Title</db:title>
	  <db:para>My para.</db:para>
	</db:chapter>
      </db:book>
    </u:param>
    <u:result>'R.1.2.2'</u:result>
  </u:test>
</u:unittests>
</doc:function>

<xsl:function name="f:node-id" as="xs:string">
  <xsl:param name="node" as="node()"/>

  <xsl:choose>
    <xsl:when test="$node/@xml:id">
      <xsl:value-of select="$node/@xml:id"/>
    </xsl:when>
    <xsl:when test="$node/@id">
      <xsl:value-of select="$node/@id"/>
    </xsl:when>
    <xsl:when test="$persistent.generated.ids != 0">
      <xsl:variable name="xpid" select="f:xptr-id($node)"/>
      <xsl:choose>
	<!-- FIXME: what if $node/key('id', $xpid)? I can't test that because
	     sometimes $node isn't in a tree and then that test causes
	     a runtime error. -->
	<xsl:when test="$xpid = ''">
	  <xsl:value-of select="generate-id($node)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$xpid"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($node)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

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

<doc:function name="f:next-orderedlist-numeration"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the next numeration style</refpurpose>

<refdescription>
<para>This function uses the <parameter>orderedlist.numeration.styles</parameter>
parameter to calculate the next numeration style. The default style
is the first style in that list.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>numeration</term>
<listitem>
<para>The current numeration style.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The next numeration style.</para>
</refreturn>
</doc:function>

<xsl:function name="f:next-orderedlist-numeration" as="xs:string">
  <xsl:param name="numeration" as="xs:string"/>

  <xsl:variable name="pos" select="index-of($orderedlist.numeration.styles,
                                            $numeration)[1]"/>

  <xsl:choose>
    <xsl:when test="not($pos)">
      <xsl:value-of select="$orderedlist.numeration.styles[1]"/>
    </xsl:when>
    <xsl:when test="subsequence($orderedlist.numeration.styles,$pos+1,1)">
      <xsl:value-of select="subsequence($orderedlist.numeration.styles,
			                $pos+1,1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$orderedlist.numeration.styles[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:orderedlist-numeration"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the next numeration style</refpurpose>

<refdescription>
<para>This function returns the <tag>orderedlist</tag> numeration style
for the specified list. If an explicit style is specified (using
<tag class="attribute">numeration</tag> on the list), that style will
be returned. Otherwise, the style returned depends on list nesting depth.
The <parameter>orderedlist.numeration.styles</parameter> parameter
controls the order and number of numeration styles that will be used.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>list</term>
<listitem>
<para>The <tag>orderedlist</tag> for which a numeration style should
be calculated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Numeration style.</para>
</refreturn>
</doc:function>

<xsl:function name="f:orderedlist-numeration" as="xs:string">
  <xsl:param name="list" as="element(db:orderedlist)"/>

  <xsl:choose>
    <xsl:when test="$list/@numeration">
      <xsl:value-of select="$list/@numeration"/>
    </xsl:when>
    <xsl:when test="$list/ancestor::db:orderedlist">
      <xsl:variable name="prevnumeration"
		    select="f:orderedlist-numeration($list/ancestor::db:orderedlist[1])"/>
      <xsl:value-of select="f:next-orderedlist-numeration($prevnumeration)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$orderedlist.numeration.styles[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:orderedlist-item-number"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the item number of the specified <tag>listitem</tag>
in an <tag>orderedlist</tag></refpurpose>

<refdescription>
<para>This function returns the number of the specified list item.
This will be:</para>

<itemizedlist>
<listitem>
<para>The value of <tag class="attribute">override</tag>, if
it is specified.</para>
</listitem>
<listitem>
<para>One more than the number of the preceding item, if there is one.</para>
</listitem>
<listitem>
<para>One more than the number of the last item in the preceding list, if
<tag class="attribute">continuation</tag> is “<literal>continues</literal>”
and this is the first item.</para>
</listitem>
<listitem>
<para>Or 1.</para>
</listitem>
</itemizedlist>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The <tag>listitem</tag> in an <tag>orderedlist</tag> for which a number
style should be calculated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The item number.</para>
</refreturn>
</doc:function>

<xsl:function name="f:orderedlist-item-number" as="xs:integer">
  <xsl:param name="node" as="element(db:listitem)"/>

  <xsl:choose>
    <xsl:when test="$node/@override">
      <xsl:value-of select="$node/@override"/>
    </xsl:when>

    <xsl:when test="$node/preceding-sibling::db:listitem">
      <xsl:value-of select="f:orderedlist-item-number($node/preceding-sibling::db:listitem[1]) + 1"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="f:orderedlist-starting-number($node/parent::db:orderedlist)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:next-itemizedlist-symbol"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the next symbol style</refpurpose>

<refdescription>
<para>This function uses the
<parameter>itemizedlist.numeration.symbols</parameter>
parameter to calculate the next symbol style. The default style
is the first style in that list.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>symbol</term>
<listitem>
<para>The current symbol style.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The next symbol style.</para>
</refreturn>
</doc:function>

<xsl:function name="f:next-itemizedlist-symbol" as="xs:string">
  <xsl:param name="symbol"/>

  <xsl:variable name="pos" select="index-of($itemizedlist.numeration.symbols,
                                            $symbol)[1]"/>

  <xsl:choose>
    <xsl:when test="not($pos)">
      <xsl:value-of select="$itemizedlist.numeration.symbols[1]"/>
    </xsl:when>
    <xsl:when test="subsequence($itemizedlist.numeration.symbols,$pos+1,1)">
      <xsl:value-of select="subsequence($itemizedlist.numeration.symbols,
			                $pos+1,1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$itemizedlist.numeration.symbols[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:itemizedlist-symbol"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the mark that should be used for the specified
<tag>listitem</tag> or <tag>itemizedlist</tag></refpurpose>

<refdescription>
<para>This function returns the mark that should be used for the
specified list item or itemized list. This will be:</para>

<itemizedlist>
<listitem>
<para>The value of <tag class="attribute">override</tag>, if
it is specified.</para>
</listitem>
<listitem>
<para>The value of <tag class="attribute">mark</tag>, if
it is specified.</para>
</listitem>
<listitem>
<para>An symbol appropriate for the list's current nesting depth.
</para>
</listitem>
<listitem>
<para>Or the default style (the first style listed in
<parameter>itemizedlist.numeration.symbols</parameter>).</para>
</listitem>
</itemizedlist>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The <tag>itemizedlist</tag> or <tag>listitem</tag> in an
<tag>itemizedlist</tag> for which a mark should be calculated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The item symbol.</para>
</refreturn>
</doc:function>

<xsl:function name="f:itemizedlist-symbol" as="xs:string">
  <xsl:param name="node" as="element()"/>

  <xsl:choose>
    <xsl:when test="$node/@mark">
      <xsl:value-of select="$node/@mark"/>
    </xsl:when>
    <xsl:when test="$node/@override">
      <xsl:value-of select="$node/@override"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$node/ancestor::itemizedlist">
	  <xsl:value-of select="f:next-itemizedlist-symbol(f:itemizedlist-symbol($node/ancestor::db:itemizedlist[1]))"/>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="f:next-itemizedlist-symbol('default')"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:procedure-step-numeration"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the numeration style for procedure steps</refpurpose>

<refdescription>
<para>This function returns the numeration style for procedure steps.
The style returned depends on procedure nesting depth.
The <parameter>procedure.step.numeration.styles</parameter> parameter
controls the order and number of numeration styles that will be used.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>context</term>
<listitem>
<para>The context element; must be <tag>substeps</tag>
or <tag>steps</tag>.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Numeration style.</para>
</refreturn>
</doc:function>

<xsl:function name="f:procedure-step-numeration" as="xs:string">
  <xsl:param name="context" as="element()"/>

  <xsl:variable name="format.length"
		select="count($procedure.step.numeration.styles)"/>

  <xsl:choose>
    <xsl:when test="$context/self::db:substeps">
      <xsl:variable name="ssdepth"
		    select="count($context/ancestor::db:substeps)"/>
      <xsl:variable name="sstype" select="($ssdepth mod $format.length)+2"/>
      <xsl:choose>
	<xsl:when test="$sstype &gt; $format.length">
	  <xsl:value-of select="$procedure.step.numeration.styles[1]"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="subsequence($procedure.step.numeration.styles,
				            $sstype,1)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$context/self::db:step">
      <xsl:variable name="sdepth"
		    select="count($context/ancestor::db:substeps)"/>
      <xsl:variable name="stype" select="($sdepth mod $format.length)+1"/>
      <xsl:value-of select="subsequence($procedure.step.numeration.styles,
			                $stype,1)"/>
    </xsl:when>
    <xsl:when test="$context/self::db:procedure">
      <xsl:value-of select="subsequence($procedure.step.numeration.styles,1,1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Unexpected context in f:procedure-step-numeration: </xsl:text>
	<xsl:value-of select="local-name($context)"/>
      </xsl:message>
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

<doc:function name="f:label-this-section" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns true if the specified section should be labelled
(numbered).</refpurpose>

<refdescription>
<para>This function return true if the specified section should be
labelled. Broadly speaking this is true if sections should be labelled
and the <function>section-level</function> of this section is less than
<parameter>section.autolabel.max.depth</parameter>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>section</term>
<listitem>
<para>The section element to test.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True if the section should be labelled, false otherwise.</para>
</refreturn>
</doc:function>

<xsl:function name="f:label-this-section" as="xs:boolean">
  <xsl:param name="section" as="element()"/>

  <xsl:choose>
    <xsl:when test="empty($autolabel.elements/*[node-name(.) = node-name($section)])">
      <!-- If sections aren't being auto-labelled, then the answer is always false. -->
      <xsl:value-of select="false()"/>
    </xsl:when>
    <xsl:when test="f:section-level($section)
		    &lt;= $section.autolabel.max.depth">
      <xsl:value-of select="not(empty($autolabel.elements/db:section))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
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

<doc:function name="f:group-index"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the ordinal number of index group to which supplied term belongs.</refpurpose>

<refdescription>
<para>Returns the ordinal number of index group to which supplied term belongs in a given language. 
This number is used to group index terms and to define order of groups.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>term</term>
<listitem>
<para>The string for which the group index should be calculated.</para>
</listitem>
</varlistentry>
<varlistentry><term>lang</term>
<listitem>
<para>Language of term.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Index of group to which specified term belongs in a given language.</para>
</refreturn>
</doc:function>

<xsl:function name="f:group-index">
  <xsl:param name="term" as="xs:string"/>
  <xsl:param name="lang" as="xs:string"/>
  
  <xsl:variable name="letters" as="element()*">
    <xsl:variable name="l10n.letters"
      select="($localization
			 //l:l10n[@language=$lang]
			 /l:letters,
               f:load-locale($lang)/l:letters)[1]"/>
    
    <xsl:choose>
      <xsl:when test="$l10n.letters">
        <xsl:copy-of select="$l10n.letters"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>No "</xsl:text>
          <xsl:value-of select="$lang"/>
          <xsl:text>" localization of index grouping letters exists</xsl:text>
          <xsl:choose>
            <xsl:when test="$lang = 'en'">
              <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>; using "en".</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:message>
        
        <xsl:copy-of select="($localization
			 //l:l10n[@language='en']
			 /l:letters,
			 f:load-locale('en')/l:letters)[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="long-letter-index" select="$letters/l:l[. = substring($term,1,2)]/@i"/>
  <xsl:variable name="short-letter-index" select="$letters/l:l[. = substring($term,1,1)]/@i"/>
  <xsl:variable name="letter-index">
    <xsl:choose>
      <xsl:when test="$long-letter-index">
        <xsl:value-of select="$long-letter-index"/>
      </xsl:when>
      <xsl:when test="$short-letter-index">
        <xsl:value-of select="$short-letter-index"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="number($letter-index)"/>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:group-label"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the label of specified index group.</refpurpose>

<refdescription>
<para>Returns the label of specified index group in a given language. 
The label is used to label corresponding index group. The label is usually just one letter, but
it can be also longer text like "Symbols" or "Ch".</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>index</term>
<listitem>
<para>The index of group for which label should be generated.</para>
</listitem>
</varlistentry>
<varlistentry><term>lang</term>
<listitem>
<para>Language of label.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Label for specified index group in a given language.</para>
</refreturn>
</doc:function>

<xsl:function name="f:group-label">
  <xsl:param name="index" as="xs:integer"/>
  <xsl:param name="lang" as="xs:string"/>
  
  <xsl:variable name="letters" as="element()*">
    <xsl:variable name="l10n.letters"
      select="($localization
			 //l:l10n[@language=$lang]
			 /l:letters,
	       f:load-locale($lang)/l:letters)[1]"/>
    
    <xsl:choose>
      <xsl:when test="$l10n.letters">
        <xsl:copy-of select="$l10n.letters"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>No "</xsl:text>
          <xsl:value-of select="$lang"/>
          <xsl:text>" localization of index grouping letters exists</xsl:text>
          <xsl:choose>
            <xsl:when test="$lang = 'en'">
              <xsl:text>.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>; using "en".</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:message>
        
        <xsl:copy-of select="($localization
			 //l:l10n[@language='en']
			 /l:letters,
			 f:load-locale('en')/l:letters)[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$letters/l:l[@i=$index][1]"/>
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

<xsl:function name="f:length-magnitude" as="xs:decimal?">
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

<xsl:function name="f:length-in-points" as="xs:decimal">
  <xsl:param name="length" as="xs:string"/>
  <xsl:value-of select="f:length-in-points($length, 10)"/>
</xsl:function>

<xsl:function name="f:length-in-points" as="xs:decimal">
  <xsl:param name="length" as="xs:string"/>
  <xsl:param name="em.size" as="xs:decimal"/>

  <xsl:variable name="magnitude" select="f:length-magnitude($length)"/>
  <xsl:variable name="units" select="f:length-units($length)"/>

  <xsl:choose>
    <xsl:when test="$units = 'pt'">
      <xsl:value-of select="$magnitude"/>
    </xsl:when>
    <xsl:when test="$units = 'cm'">
      <xsl:value-of select="$magnitude div 2.54 * 72.0"/>
    </xsl:when>
    <xsl:when test="$units = 'mm'">
      <xsl:value-of select="$magnitude div 25.4 * 72.0"/>
    </xsl:when>
    <xsl:when test="$units = 'in'">
      <xsl:value-of select="$magnitude * 72.0"/>
    </xsl:when>
    <xsl:when test="$units = 'pc'">
      <xsl:value-of select="$magnitude * 12.0"/>
    </xsl:when>
    <xsl:when test="$units = 'px'">
      <xsl:value-of select="$magnitude div $pixels.per.inch * 72.0"/>
    </xsl:when>
    <xsl:when test="$units = 'em'">
      <xsl:value-of select="$magnitude * $em.size"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unrecognized unit of measure: </xsl:text>
        <xsl:value-of select="$units"/>
        <xsl:text>; using pt.</xsl:text>
      </xsl:message>
      <xsl:value-of select="$magnitude"/>
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

<!-- ================================================================== -->

<xsl:function name="f:resolve-barename-xpointer" as="element()?">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="href" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="starts-with($href,'#')">
      <xsl:sequence select="$node/key('id',substring-after($href,'#'))"/>
    </xsl:when>
    <xsl:when test="contains($href,'#')">
      <xsl:variable name="uri" select="substring-before($href,'#')"/>
      <xsl:variable name="id" select="substring-after($href,'#')"/>
      <xsl:variable name="doc" select="document($uri, $node)"/>
      <xsl:sequence select="$doc/key('id',$id)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="doc" select="document($href, $node)"/>
      <xsl:sequence select="$doc/*[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ================================================================== -->

<xsl:function name="f:fake-eval-avt" as="xs:string">
  <xsl:param name="value" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="contains($value,'{')">
      <xsl:variable name="pre" select="substring-before($value,'{')"/>
      <xsl:variable name="var"
		    select="substring-after(substring-before($value,'}'),'{')"/>
      <xsl:variable name="rest" select="substring-after($value,'}')"/>

      <xsl:variable name="exp">
	<xsl:choose>
	  <xsl:when test="$var = '$title.font.family'">
	    <xsl:value-of select="$title.font.family"/>
	  </xsl:when>
	  <xsl:when test="$var = '$body.font.family'">
	    <xsl:value-of select="$body.font.family"/>
	  </xsl:when>
	  <xsl:when test="$var = '$body.fontset'">
	    <xsl:value-of select="$body.fontset"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message>
	      <xsl:text>Unrecognized value in f:fake-eval-avt(): </xsl:text>
	      <xsl:value-of select="$var"/>
	    </xsl:message>
	    <xsl:value-of select="''"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:value-of select="concat($pre,$exp,f:fake-eval-avt($rest))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$value"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:lineNumbering">
  <xsl:param name="context" as="element()"/>
  <xsl:param name="name" as="xs:string"/>

  <xsl:variable name="pis" as="processing-instruction()*">
    <xsl:choose>
      <xsl:when test="$stylesheet.result.type = 'fo'">
        <xsl:sequence select="$context/processing-instruction('dbfo')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$context/processing-instruction('dbhtml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="params"
		select="f:find-toc-params($context, $linenumbering)"/>

  <xsl:variable name="cfgval"
                select="if ($params/@*[local-name(.) = $name])
                        then $params/@*[local-name(.) = $name]
                        else ''"
                as="xs:string?"/>

  <xsl:variable name="pival"
                select="f:pi($pis, concat('linenumbering.', $name))"
                as="xs:string?"/>

  <xsl:variable name="value" as="xs:string?">
    <xsl:choose>
      <xsl:when test="empty($pival) or $pival = ''">
        <xsl:sequence select="$cfgval"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$pival"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- special cases... -->
  <xsl:choose>
    <xsl:when test="$name = 'everyNth' and $context/@linenumbering = 'unnumbered'">
      <xsl:value-of select="0"/>
    </xsl:when>
    <xsl:when test="$name = 'everyNth' and $value castable as xs:integer">
      <xsl:value-of select="xs:integer($value)"/>
    </xsl:when>
    <xsl:when test="$name = 'everyNth'">
      <xsl:value-of select="0"/>
    </xsl:when>

    <xsl:when test="$name = 'width' and $value castable as xs:integer">
      <xsl:value-of select="xs:integer($value)"/>
    </xsl:when>
    <xsl:when test="$name = 'width'">
      <xsl:value-of select="0"/>
    </xsl:when>

    <xsl:when test="$name = 'minlines' and $value castable as xs:integer">
      <xsl:value-of select="xs:integer($value)"/>
    </xsl:when>
    <xsl:when test="$name = 'minlines'">
      <xsl:value-of select="0"/>
    </xsl:when>

    <xsl:when test="$name = 'asTable' and $value castable as xs:boolean">
      <xsl:value-of select="xs:boolean($value)"/>
    </xsl:when>

    <xsl:when test="$name = 'asTable'">
      <xsl:value-of select="false()"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$value"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ================================================================== -->

<doc:function name="f:title" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the title element of the specified node</refpurpose>

<refdescription>
<para>This function returns the <emphasis>string value</emphasis> of the
<tag>title</tag> (or the element
that serves as the title) of the specified node. If the node does
not have a title, it returns “???”.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which the title will be extracted.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The string value of the title of the specified node.</para>
</refreturn>

<u:unittests function="f:title">
  <u:test>
    <u:variable name="mydoc">
      <db:book>
	<db:title>Some Title</db:title>
	<db:chapter>
	  <db:title>Some Chapter Title</db:title>
	  <db:para>My para.</db:para>
	</db:chapter>
      </db:book>
    </u:variable>
    <u:param select="$mydoc/db:book"/>
    <u:result>'Some Title'</u:result>
  </u:test>
</u:unittests>
</doc:function>

<xsl:function name="f:title" as="xs:string">
  <xsl:param name="node" as="node()"/>

  <xsl:variable name="title">
    <xsl:apply-templates select="$node" mode="m:title-content"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="string($title) = ''">
      <xsl:text>???</xsl:text>
      <xsl:if test="$verbosity &gt; 0">
	<xsl:message>
	  <xsl:text>Warning: no title for root element: </xsl:text>
	  <xsl:value-of select="local-name($node)"/>
	</xsl:message>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:biblioentry-label" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns the label for a bibliography entry</refpurpose>

<refdescription>
<para>This template formats the label for a bibliography entry
(<tag>biblioentry</tag> or <tag>bibliomixed</tag>).</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the bibliography entry, defaults to the current
context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The bibliography entry label.</para>
</refreturn>
</doc:function>

<xsl:function name="f:biblioentry-label">
  <xsl:param name="node"/>

  <xsl:choose>
    <xsl:when test="$bibliography.numbered != 0">
      <xsl:apply-templates select="$node" mode="mp:biblioentry-label-count"/>
    </xsl:when>
    <xsl:when test="node-name($node/child::*[1]) = xs:QName('db:abbrev')">
      <xsl:apply-templates select="$node/db:abbrev[1]"/>
    </xsl:when>
    <xsl:when test="$node/@xreflabel">
      <xsl:value-of select="$node/@xreflabel"/>
    </xsl:when>
    <xsl:when test="$node/@id or $node/@xml:id">
      <xsl:value-of select="($node/@id|$node/@xml:id)[1]"/>
    </xsl:when>
    <xsl:otherwise><!-- nop --></xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:template match="*" mode="mp:biblioentry-label-count">
  <xsl:choose>
    <xsl:when test="ancestor::db:bibliolist">
      <xsl:number from="db:bibliolist" count="db:biblioentry|db:bibliomixed"
		  level="any" format="1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number from="db:bibliography" count="db:biblioentry|db:bibliomixed"
		  level="any" format="1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

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

<xsl:function name="f:findid" as="element()*">
  <xsl:param name="id" as="xs:string"/>
  <xsl:param name="context" as="node()"/>

  <xsl:sequence select="key('id', $id, root($context))"/>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:verbatim-trim-blank-lines"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Return true if blank lines should be trimmed off the end of the verbatim element</refpurpose>

<refdescription>
<para>The <function>verbatim-trim-blank-lines</function> tests to see if trailing blank
lines should be removed from the specified verbatim environment.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>verbatim</term>
<listitem>
<para>The verbatim environment.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True if they should, false otherwise</para>
</refreturn>
</doc:function>

<xsl:function name="f:verbatim-trim-blank-lines" as="xs:boolean">
  <xsl:param name="verbatim" as="element()"/>

  <xsl:variable name="trim"
		select="f:pi(f:in-scope-pis($verbatim, 'dbhtml'), 'trim-verbatim')"/>

  <xsl:choose>
    <xsl:when test="empty($trim)">
      <xsl:value-of select="string($verbatim.trim.blank.lines) != '0'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="string($trim[last()]) != '0'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:dir"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Return the writing direction of a particular element</refpurpose>

<refdescription>
<para>The <function>dir</function> function returns the value of the nearest
<tag class="attribute">dir</tag> attribute or the <parameter>$writing-mode</parameter>
parameter if no such attribute can be found.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>element</term>
<listitem>
<para>The element for which writing direction is desired.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The writing direction.</para>
</refreturn>
</doc:function>

<xsl:function name="f:dir" as="xs:string">
  <xsl:param name="element" as="element()"/>

  <xsl:variable name="dir" select="$element/ancestor-or-self::*[@dir][1]"/>
  <xsl:choose>
    <xsl:when test="$dir">
      <xsl:value-of select="$dir/@dir"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$writing.mode"/>
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

      <!-- we have to make $abspath absolute (per the finicky def in XSLT 2.0) -->
      <!-- but if the static base uri is a file:// uri, we want to pull the -->
      <!-- file:// bit back off the front. -->

      <xsl:variable name="resolved-abs" select="resolve-uri($abspath, $static-base-uri)"/>
      <xsl:variable name="resolved" select="resolve-uri($uri, $resolved-abs)"/>

      <!-- strip off the leading file: -->
      <!-- this is complicated by two things, first it's not clear when we get
           file:///path and when we get file://path; second, on a Windows system
           if we get file://D:/path we have to remove both slashes -->
      <xsl:choose>
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

</xsl:stylesheet>
