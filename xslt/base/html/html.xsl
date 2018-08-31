<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="db doc f fn h m mp t u xlink ghost xs"
                version="2.0">

<!-- ============================================================ -->

<xsl:param name="body.fontset">
  <!-- this isn't used by the HTML stylesheets, but it's in common/functions -->
</xsl:param>

<xsl:param name="syntax.highlight.map" as="element()*"/>

<!-- ============================================================ -->

<doc:template name="anchor" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns an XHTML anchor if appropriate</refpurpose>

<refdescription>
<para>This template returns an XHTML anchor
(<tag class="starttag">a</tag>) if the specified
node has an <tag class="attribute">id</tag>
(or <tag class="attribute">xml:id</tag>) attribute or if the
<parameter>force</parameter> parameter is non-zero.</para>

<para>If an anchor is generated, it's <tag class="attribute">id</tag>
value is <function>f:node-id()</function>.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which an anchor should be generated. It defaults to
the context item.</para>
</listitem>
</varlistentry>
<varlistentry><term>force</term>
<listitem>
<para>To force an anchor to be generated, even if the node does
not have an ID, make this parameter non-zero. It defaults to 0.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>An XHTML anchor or nothing.</para>
</refreturn>

<u:unittests template="anchor">
  <u:test>
    <u:param name="node" as="element()">
      <db:para xml:id="foo"/>
    </u:param>
    <u:result>
      <a name="foo" id="foo" xmlns="http://www.w3.org/1999/xhtml"/>
    </u:result>
  </u:test>
</u:unittests>

</doc:template>

<xsl:template name="anchor">
  <xsl:param name="node" select="."/>
  <xsl:param name="force" select="0"/>

  <xsl:if test="$force != 0 or ($node/@id or $node/@xml:id)">
    <a name="{f:node-id($node)}" id="{f:node-id($node)}"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="class" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns an “class” attribute if appropriate</refpurpose>

<refdescription>
<para>This template returns an attribute named “class” if the specified
node has an <tag class="attribute">role</tag> attribute or if the
<parameter>force</parameter> parameter is non-zero.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which an class attribute should be generated. It defaults to
the context item.</para>
</listitem>
</varlistentry>
<varlistentry><term>force</term>
<listitem>
<para>To force a “class” attribute to be generated, even if the node does
not have a <tag class="attribute">role</tag>,
make this parameter non-zero. It defaults to 0.</para>
</listitem>
</varlistentry>
<varlistentry><term>default-role</term>
<listitem>
<para>The default role that will be used if the attribute is forced
and the node has no <tag class="attribute">role</tag>.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>An “class” attribute or nothing.</para>
</refreturn>
</doc:template>

<xsl:template name="class">
  <xsl:param name="node" select="."/>
  <xsl:param name="force" select="0"/>
  <xsl:param name="default-role"/>

  <xsl:variable name="role"
		select="if ($node/@role) then $node/@role else $default-role"/>

  <xsl:if test="$force != 0 or $node/@role">
    <xsl:attribute name="class" select="$role"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="style" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns a “style” attribute if appropriate</refpurpose>

<refdescription>
<para>This template returns an attribute named “style” if the
global parameter <parameter>inline.style.attribute</parameter> is non-zero
and a CSS style is specified.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>css</term>
<listitem>
<para>The CSS style to apply.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>A “style” attribute or nothing.</para>
</refreturn>
</doc:template>

<xsl:template name="style">
  <xsl:param name="css"/>

  <xsl:if test="$inline.style.attribute and $css">
    <xsl:attribute name="style">
      <xsl:value-of select="$css"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template match="*" mode="mp:javascript-head">
  <script type="text/javascript"
          src="{concat($resource.root, 'js/dbmodnizr.js')}"/>
</xsl:template>

<xsl:template match="*" mode="m:javascript-head">
  <!-- nop -->
</xsl:template>

<xsl:template match="*" mode="mp:javascript-body">
  <xsl:if test="f:include-jquery(.)">
    <script type="text/javascript" src="{$cdn.jquery}"/>
  </xsl:if>

  <xsl:if test="f:include-jqueryui(.)">
    <script type="text/javascript" src="{$cdn.jqueryui}"/>
  </xsl:if>

  <xsl:if test="exists(.//ghost:annotation)
                or exists(.//db:mediaobject/db:textobject[not(db:phrase)])">
    <script type="text/javascript"
            src="{concat($resource.root, 'js/annotation.js')}"/>
  </xsl:if>

  <xsl:if test="exists(.//*[@xlink:type='extended'])">
    <script type="text/javascript"
            src="{concat($resource.root, 'js/nhrefs.js')}"/>
  </xsl:if>

  <xsl:if test="$syntax-highlighter">
    <script src="{concat($resource.root, 'js/prism.js')}"></script>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="m:javascript-body">
  <!-- nop -->
</xsl:template>

<xsl:function name="f:include-jquery">
  <xsl:param name="node"/>

  <xsl:sequence select="exists($node//ghost:annotation)
            or exists($node//*[@xlink:type='extended'])
            or exists($node//db:mediaobject/db:textobject[not(db:phrase)])"/>
</xsl:function>

<xsl:function name="f:include-jqueryui">
  <xsl:param name="node"/>

  <xsl:sequence select="exists($node//ghost:annotation)
            or exists($node//*[@xlink:type='extended'])
            or exists($node//db:mediaobject/db:textobject[not(db:phrase)])"/>
</xsl:function>

<xsl:function name="f:syntax-highlight" as="xs:boolean">
  <xsl:param name="node"/>

  <xsl:variable name="minlines" as="xs:decimal"
                select="(xs:decimal(f:lineNumbering($node,'minlines')),0)[1]"/>

  <!-- count the approximate number of lines... -->
  <xsl:variable name="numlines"
                select="count(tokenize(string($node), '&#10;'))"/>

  <xsl:sequence select="f:lineNumbering($node,'everyNth') != 0
                        and $minlines &lt;= $numlines"/>
</xsl:function>

<xsl:function name="f:syntax-highlight-class" as="xs:string*">
  <xsl:param name="node"/>

  <xsl:variable name="numbered" select="f:syntax-highlight($node)"/>

  <xsl:if test="$syntax-highlighter">
    <xsl:variable name="language" select="$node/@language/string()"/>
    <xsl:variable name="mapped-language"
                  select="($syntax.highlight.map[@key=$language]/@value/string(),
                           $language)[1]"/>

    <xsl:variable name="language" as="xs:string?"
                  select="if ($mapped-language)
                          then concat('language-', $mapped-language)
                          else 'language-none'"/>

    <xsl:variable name="numbers" as="xs:string?"
                  select="if ($node/ancestor::db:programlistingco
                              or $node/ancestor::db:screenco
                              or not($numbered))
                          then ()
                          else 'line-numbers'"/>

    <xsl:sequence select="($language,$numbers,$node/@role)"/>
  </xsl:if>
</xsl:function>

<!-- ====================================================================== -->

<xsl:template match="*" mode="mp:css">
  <xsl:if test=".//ghost:annotation or .//*[@xlink:type='extended']">
    <link rel="stylesheet" type="text/css" href="{$cdn.jqueryui.css}"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$syntax-highlighter">
      <link href="{concat($resource.root, 'css/prism.css')}" rel="stylesheet" 
            type="text/css"/>
      <link href="{concat($resource.root, 'css/db-prism.css')}" rel="stylesheet"
            type="text/css"/>
    </xsl:when>
    <xsl:otherwise>
      <link href="{concat($resource.root, 'css/db-noprism.css')}" rel="stylesheet"
            type="text/css"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="string($docbook.css) != ''">
    <link rel="stylesheet" type="text/css" href="{$docbook.css}"/>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="m:css">
  <!-- nop -->
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="mp:html-head" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for generating the head element</refpurpose>

<refdescription>
<para>This mode is called on an element when it is the root of an
HTML document. It is responsible for generating the HTML <tag>head</tag> element
and its content.</para>
</refdescription>
</doc:template>

<xsl:template match="*" mode="mp:html-head">
  <title>
    <xsl:value-of select="f:title(.)"/>
  </title>

  <xsl:if test="$html.base != ''">
    <base href="{$html.base}"/>
  </xsl:if>

  <xsl:apply-templates select="." mode="mp:head-content"/>
  <xsl:apply-templates select="." mode="m:head-content"/>

  <xsl:apply-templates select="." mode="m:head-meta"/>
  <xsl:apply-templates select="." mode="m:head-links"/>

  <xsl:if test="$html.stylesheets != ''">
    <xsl:for-each select="tokenize($html.stylesheets, '\s+')">
      <link rel="stylesheet" href="{.}">
        <xsl:choose>
          <xsl:when test="ends-with(.,'.css')">
            <xsl:attribute name="type" select="'text/css'"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- ??? what type is this ??? -->
          </xsl:otherwise>
        </xsl:choose>
      </link>
    </xsl:for-each>
  </xsl:if>

  <xsl:apply-templates select="." mode="mp:javascript-head"/>
  <xsl:apply-templates select="." mode="m:javascript-head"/>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="m:head-meta" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting metadata in the head</refpurpose>

<refdescription>
<para>This mode is called on an element when it is the root of an
HTML document. It is responsible for generating any necessary
<tag>meta</tag> elements into the <tag>head</tag>.
</para>
</refdescription>
</doc:template>

<xsl:template match="*" mode="m:head-meta">
  <xsl:if test="string($generate.meta.generator) != '0'">
    <meta name="generator" content="DocBook XSL 2.0 Stylesheets V{$VERSION}"/>
  </xsl:if>

  <xsl:if test="string($generate.meta.abstract) != '0'
                and db:info/db:abstract">
    <meta name="description">
      <xsl:attribute name="content">
        <xsl:for-each select="db:info/db:abstract[1]/*">
          <xsl:value-of select="."/>
          <xsl:if test="position() &lt; last()">
            <xsl:text> </xsl:text>
	  </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
    </meta>
  </xsl:if>

  <xsl:apply-templates select="." mode="m:head-keywords-content"/>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="m:head-links" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting links in the head</refpurpose>

<refdescription>
<para>This mode is called on an element when it is the root of an
HTML document. It is responsible for generating any necessary
<tag>link</tag> elements in the <tag>head</tag>.
</para>
</refdescription>
</doc:template>

<xsl:template match="*" mode="m:head-links">
  <xsl:apply-templates select="." mode="mp:css"/>
  <xsl:apply-templates select="." mode="m:css"/>

  <xsl:if test="$link.madeby.uri != ''">
    <link rev="made"
          href="{$link.madeby.uri}"/>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="t:body-attributes" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for inserting attributes on the HTML body</refpurpose>

<refdescription>
<para>T.B.D.</para>
</refdescription>
</doc:template>

<xsl:template name="t:body-attributes">
  <!-- nop -->
</xsl:template>

<!-- ====================================================================== -->

<doc:function name="f:href" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns a URI for the node</refpurpose>

<refdescription>
<para>This function returns a URI suitable for use in a hypertext link
for the specified node.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>context</term>
<listitem>
<para>The context in which the link will be used. (This is necessary
when chunking.)</para>
</listitem>
</varlistentry>
<varlistentry><term>node</term>
<listitem>
<para>The node for which a URI will be generated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The hypertext anchor URI for the node.</para>
</refreturn>

<u:unittests function="f:href">
  <u:test>
    <u:param select="/"/>
    <u:param>
      <para id="foo"/>
    </u:param>
    <u:result>'#foo'</u:result>
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
    <u:param select="$mydoc"/>
    <u:param select="$mydoc//db:chapter[1]"/>
    <u:result>'#R.1.2'</u:result>
  </u:test>
</u:unittests>

</doc:function>

<xsl:function name="f:href" as="xs:string">
  <xsl:param name="context" as="node()"/>
  <xsl:param name="node" as="element()"/>
  <xsl:value-of select="concat('#', f:node-id($node))"/>
</xsl:function>

<!-- ====================================================================== -->

<doc:function name="f:href-target-uri" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns a URI for the node</refpurpose>

<refdescription>
<para>This function returns a URI suitable for use in a hypertext link
for the specified node.</para>
<note>
<para>The difference between <function>href-target-uri</function> and
<function>href</function> is only apparent when chunking is used.
</para>
</note>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which a URI will be generated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The hypertext anchor URI for the node.</para>
</refreturn>

<u:unittests function="f:href-target-uri">
  <u:test>
    <u:param>
      <para id="foo"/>
    </u:param>
    <u:result>'#foo'</u:result>
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
    <u:param select="$mydoc//db:chapter[1]"/>
    <u:result>'#R.1.2'</u:result>
  </u:test>
</u:unittests>

</doc:function>

<xsl:function name="f:href-target-uri" as="xs:string">
  <xsl:param name="node" as="element()"/>
  <xsl:value-of select="concat('#', f:node-id($node))"/>
</xsl:function>

<!-- ====================================================================== -->

<xsl:function name="f:keep-titlepage-fragment" as="xs:boolean">
  <xsl:param name="fragment" as="node()*"/>

  <xsl:value-of select="string($fragment) != ''
                        or count($fragment//h:div) != count($fragment//*)"/>
</xsl:function>

<xsl:template name="t:default-titlepage-template" as="element()">
  <div>
    <db:title/>
  </div>
</xsl:template>

<!-- ====================================================================== -->

<doc:mode name="m:strip-anchors" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for stripping anchors from XHTML</refpurpose>

<refdescription>
<para>This mode performs an identity transform except that all XHTML
anchors (<tag>a</tag>) elements are removed. The content of each anchor
is preserved, only the wrapping <tag>a</tag> is stripped away.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:strip-anchors">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:strip-anchors"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="h:a" mode="m:strip-anchors" priority="100">
  <xsl:apply-templates mode="m:strip-anchors"/>
</xsl:template>

<xsl:template match="h:sup[@class='footnote']"
	      mode="m:strip-anchors" priority="100">
  <!-- strip it -->
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()"
	      mode="m:strip-anchors">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:pre-root">
  <!-- Pre-root output, can be used to output comments and PIs. -->
  <!-- This must not output any element content! -->
</xsl:template>

<xsl:template match="*" mode="mp:head-content">
  <!-- system.head.content is like user.head.content, except that
       it is called before head.content. This is important because it
       means, for example, that <style> elements output by system-head-content
       have a lower CSS precedence than the users stylesheet. -->

  <meta charset="utf-8"/>
</xsl:template>

<xsl:template match="*" mode="m:head-content">
  <!-- nop -->
</xsl:template>

<xsl:template match="*" mode="m:user-header-content">
  <xsl:param name="node" select="."/>
  <xsl:param name="next" select="()"/>
  <xsl:param name="prev" select="()"/>
  <xsl:param name="up" select="()"/>
</xsl:template>

<xsl:template match="*" mode="m:user-footer-content">
  <xsl:param name="node" select="."/>
  <xsl:param name="next" select="()"/>
  <xsl:param name="prev" select="()"/>
  <xsl:param name="up" select="()"/>
</xsl:template>

<!-- ====================================================================== -->
<doc:template name="m:head-keywords-content" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for generating keyword metadata in the head</refpurpose>

<refdescription>
<para>This mode is called on an element when it is the root of an
HTML document. It is responsible for generating the keyword-related
<tag>meta</tag> elements in the <tag>head</tag>.</para>
</refdescription>
</doc:template>

<xsl:template match="*" mode="m:head-keywords-content">
  <xsl:apply-templates select="db:info/db:keywordset"
                       mode="m:head-keywords-content"/>
  <xsl:if test="string($inherit.keywords) != '0' and parent::*">
    <xsl:apply-templates select="parent::*" mode="m:head-keywords-content"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:keywordset" mode="m:head-keywords-content">
  <meta name="keywords" content="{string-join(db:keyword, ', ')}"/>
</xsl:template>

<!-- ====================================================================== -->

<xsl:param name="omit-names-from-class"
           select="('phrase', 'link')"/>

<!-- ====================================================================== -->

<xsl:function name="f:html-class" as="attribute()*">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="class" as="xs:string?"/>
  <xsl:param name="extra-classes" as="xs:string*"/>

  <xsl:if test="exists($class) or exists($extra-classes)">
    <xsl:attribute name="class"
                   select="string-join(distinct-values(($class,$extra-classes)), ' ')"/>
  </xsl:if>
</xsl:function>

<xsl:function name="f:html-extra-class-values" as="xs:string?">
  <xsl:param name="node" as="element()"/>
  <xsl:sequence select="f:html-extra-class-values($node, ())"/>
</xsl:function>

<xsl:function name="f:html-extra-class-values" as="xs:string?">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="extra" as="xs:string*"/>

  <xsl:variable name="classes" as="xs:string*">
    <xsl:if test="$node/@role">
      <xsl:sequence select="tokenize($node/@role, '\s+')"/>
    </xsl:if>
    <xsl:if test="$node/@revision">
      <xsl:value-of select="concat('rf-', $node/@revision)"/>
    </xsl:if>
    <xsl:sequence select="$extra"/>
  </xsl:variable>

  <xsl:if test="exists($classes)">
    <xsl:value-of select="string-join(distinct-values($classes), ' ')"/>
  </xsl:if>
</xsl:function>

<xsl:function name="f:html-attributes" as="attribute()*">
  <xsl:param name="node" as="element()"/>

  <xsl:variable name="class" select="if (local-name($node) = $omit-names-from-class)
                                     then ()
                                     else local-name($node)"/>

  <xsl:variable name="extra-classes"
                select="f:html-extra-class-values($node)"/>

  <xsl:sequence select="f:html-attributes($node, $node/@xml:id, $class, $extra-classes, $node/@h:*)"/>
</xsl:function>

<xsl:function name="f:html-attributes" as="attribute()*">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="id" as="xs:string?"/>

  <xsl:variable name="class" select="if (local-name($node) = $omit-names-from-class)
                                     then ()
                                     else local-name($node)"/>

  <xsl:variable name="extra-classes"
                select="f:html-extra-class-values($node)"/>

  <xsl:sequence select="f:html-attributes($node, $id, $class, $extra-classes, $node/@h:*)"/>
</xsl:function>

<xsl:function name="f:html-attributes" as="attribute()*">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="id" as="xs:string?"/>
  <xsl:param name="class" as="xs:string?"/>

  <xsl:variable name="extra-classes"
                select="f:html-extra-class-values($node)"/>

  <xsl:sequence select="f:html-attributes($node, $id, $class, $extra-classes, $node/@h:*)"/>
</xsl:function>

<xsl:function name="f:html-attributes" as="attribute()*">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="id" as="xs:string?"/>
  <xsl:param name="class" as="xs:string?"/>
  <xsl:param name="extra-classes" as="xs:string*"/>
  <xsl:sequence select="f:html-attributes($node, $id, $class, $extra-classes, $node/@h:*)"/>
</xsl:function>

<xsl:function name="f:html-attributes" as="attribute()*">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="id" as="xs:string?"/>
  <xsl:param name="class" as="xs:string?"/>
  <xsl:param name="extra-classes" as="xs:string*"/>
  <xsl:param name="extra-attrs" as="attribute()*"/>

  <xsl:if test="exists($id)">
    <xsl:attribute name="id" select="$id"/>
  </xsl:if>

  <!-- Copy the writing direction and the RDFa attributes through, if they're present -->
  <xsl:for-each select="($node/@dir, $node/@vocab, $node/@typeof, $node/@property,
                         $node/@resource, $node/@prefix)">
    <xsl:copy/>
  </xsl:for-each>

  <xsl:if test="$node/@xml:lang">
    <xsl:call-template name="lang-attribute">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$node/db:alt">
    <xsl:attribute name="title" select="string($node/db:alt[1])"/>
  </xsl:if>

  <xsl:sequence select="f:html-class($node, $class, $extra-classes)"/>

  <xsl:for-each select="$extra-attrs">
    <xsl:choose>
      <xsl:when test="namespace-uri(.) = 'http://www.w3.org/1999/xhtml'">
        <xsl:attribute name="{local-name(.)}" select="string(.)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="{node-name(.)}" select="string(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:function>

</xsl:stylesheet>
