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

<xsl:include href="functions.xsl"/>

<doc:reference xmlns="http://docbook.org/ns/docbook">
<info>
<title>DocBook Functions Reference</title>
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
<para>These are functions that require the DocBook parameters.</para>
</section>
</partintro>
</doc:reference>

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
    <xsl:when test="$bibliography.numbered">
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

<!-- ================================================================== -->

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

<xsl:function name="f:length-in-points" as="xs:double">
  <xsl:param name="length" as="xs:string"/>
  <xsl:value-of select="f:length-in-points($length, 10)"/>
</xsl:function>

<xsl:function name="f:length-in-points" as="xs:double">
  <xsl:param name="length" as="xs:string"/>
  <xsl:param name="em.size" as="xs:double"/>

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

<!-- ============================================================ -->

<xsl:function name="f:findid" as="element()*">
  <xsl:param name="id" as="xs:string"/>
  <xsl:param name="context" as="node()"/>

  <xsl:sequence select="key('id', $id, root($context))"/>
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
    <xsl:when test="$persistent.generated.ids">
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

</xsl:stylesheet>
