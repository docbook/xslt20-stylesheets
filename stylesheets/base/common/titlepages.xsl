<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db doc t xs"
                version="2.0">

<doc:template name="titlepage" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Processes a title page</refpurpose>

<refdescription>
<para>This template processes the title page content for an element
based on a specified template.
For each element in the template, the corresponding element from the
content is processed (with <code>apply-templates</code>).</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>info</term>
<listitem>
<para>The bibliographic metadata associated with the element. By default,
this is <tag>db:info/*</tag>.</para>
</listitem>
</varlistentry>
<varlistentry><term>content</term>
<listitem>
<para>The title page template.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted title page.</para>
</refreturn>
</doc:template>

<xsl:template name="titlepage">
  <xsl:param name="context" select="."/>
  <xsl:param name="info" select="$context/db:title
                                 |$context/db:subtitle
                                 |$context/db:titleabbrev
                                 |$context/db:info/*" as="element()*"/>
  <xsl:param name="content"/>

<!--
  <xsl:message>
    <xsl:text>titlepage for: </xsl:text>
    <xsl:value-of select="node-name($context)"/>
    <xsl:copy-of select="$content"/>
  </xsl:message>

  <xsl:message>
    <xsl:text>titlepage with: </xsl:text>
    <xsl:copy-of select="$info"/>
  </xsl:message>
-->

  <xsl:choose>
    <xsl:when test="$content instance of document-node()">
      <xsl:apply-templates select="$content" mode="m:titlepage-templates">
        <xsl:with-param name="node" select="$context" tunnel="yes"/>
        <xsl:with-param name="info" select="$info" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$content instance of element()">
      <xsl:apply-templates select="$content/*" mode="m:titlepage-templates">
        <xsl:with-param name="node" select="$context" tunnel="yes"/>
        <xsl:with-param name="info" select="$info" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="fn:empty($content)">
      <xsl:message>
        <xsl:text>Empty $content in titlepage template (for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:text>).</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unexpected $content in titlepage template (for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:text>).</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<doc:mode name="m:titlepage-templates" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing the title page template contents</refpurpose>

<refdescription>
<para>This mode is used to process the title page template contents.
For each DocBook element in the template, the corresponding element from
the metadata (if there is one) is formatted. Elements in other namespaces
are generally copied directly to the title page.</para>

<para>One exception is made if the element specifies a
<tag class="attribute">t:conditional</tag> attribute with a non-zero value
then the element is only copied if it contains (among its descendants)
an element that occurs in the source document.</para>

</refdescription>
</doc:mode>

<xsl:template match="db:*" mode="m:titlepage-templates" priority="1000">
  <xsl:param name="node" tunnel="yes"/>
  <xsl:param name="info" tunnel="yes"/>

  <xsl:variable name="this" select="."/>

  <xsl:variable name="content" select="$info[f:node-matches($this,.)]"/>

<!--
  <xsl:message>
    <xsl:text>titlepage-templates for: </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text> in the context of </xsl:text>
    <xsl:value-of select="name($node)"/>
  </xsl:message>

  <xsl:message>
    <xsl:copy-of select="$content"/>
  </xsl:message>
-->

  <!-- Title, subtitle, and titleabbrev are special because they're sometimes optional -->

  <xsl:choose>
    <xsl:when test="self::db:title
                    and ($node/self::db:bibliography
                         or $node/self::db:glossary
                         or $node/self::db:index
                         or $node/self::db:setindex
                         or $node/self::db:tip
                         or $node/self::db:note
                         or $node/self::db:important
                         or $node/self::db:warning
                         or $node/self::db:caution)">
      <xsl:apply-templates select="$node" mode="m:title-markup"/>
    </xsl:when>

    <xsl:when test="self::db:title and $content">
      <xsl:apply-templates select="$node" mode="m:title-markup"/>
    </xsl:when>

    <xsl:when test="self::db:subtitle and $content">
      <xsl:apply-templates select="$node" mode="m:subtitle-markup"/>
    </xsl:when>

    <xsl:when test="self::db:titleabbrev and $content">
      <xsl:apply-templates select="$node" mode="m:titleabbrev-markup"/>
    </xsl:when>

    <xsl:when test="$content">
      <xsl:apply-templates select="$content" mode="m:titlepage-mode"/>
    </xsl:when>

    <xsl:otherwise>
      <!-- nop -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-templates">
  <xsl:param name="node" tunnel="yes"/>
  <xsl:param name="info" tunnel="yes"/>

  <xsl:variable name="render" as="xs:boolean*">
    <xsl:choose>
      <xsl:when test="not(@t:conditional) or @t:conditional = 0">
	<xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select=".//db:*">
	  <xsl:variable name="this" select="."/>
	  <xsl:if test="$info[f:node-matches($this, .)]">
	    <xsl:value-of select="true()"/>
	  </xsl:if>
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="not(empty($render))">
    <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
      <xsl:for-each select="@*">
	<xsl:choose>
	  <xsl:when test="namespace-uri(.)
			  = 'http://docbook.org/xslt/ns/template'">
	    <!-- discard -->
	  </xsl:when>
	  <xsl:when test="contains(.,'{')">
	    <!-- there's no 'eval' in XSLT, so do this the hard way -->
	    <xsl:attribute name="{name(.)}"
			   namespace="{namespace-uri(.)}">
	      <xsl:value-of select="f:fake-eval-avt(.)"/>
	    </xsl:attribute>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:copy/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
      <xsl:apply-templates mode="m:titlepage-templates"/>
    </xsl:element>
  </xsl:if>
</xsl:template>

<xsl:template match="processing-instruction()|comment()"
	      mode="m:titlepage-templates">
  <xsl:copy/>
</xsl:template>

<xsl:template match="text()"
	      mode="m:titlepage-templates">
  <xsl:if test="fn:normalize-space(.) != ''">
    <xsl:copy/>
  </xsl:if>
</xsl:template>

<doc:function name="f:node-matches" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Tests if an element from the title page content matches an element
from the document.</refpurpose>

<refdescription>
<para>An element from the document matches an element from the title page
content if it has the same (qualified) name and if all the attributes
specified in the title page content are equal to the attributes on the
document element.</para>

<para>See also: <function>f:user-node-matches</function>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>template-node</term>
<listitem>
<para>The node from the title page content.</para>
</listitem>
</varlistentry>
<varlistentry><term>document-node</term>
<listitem>
<para>The node from the document.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True if the nodes match.</para>
</refreturn>
</doc:function>

<xsl:function name="f:node-matches" as="xs:boolean">
  <xsl:param name="template-node" as="element()"/>
  <xsl:param name="document-node" as="element()"/>

  <xsl:choose>
    <xsl:when test="fn:node-name($template-node) = fn:node-name($document-node)">
      <xsl:variable name="attrMatch">
	<xsl:for-each select="$template-node/@*[namespace-uri(.) = '']">
	  <xsl:variable name="aname" select="local-name(.)"/>
	  <xsl:variable name="attr"
			select="$document-node/@*[local-name(.) = $aname]"/>
	  <xsl:choose>
            <xsl:when test="$attr = .">1</xsl:when>
	    <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>

      <xsl:choose>
	<xsl:when test="not(contains($attrMatch, '0'))">
	  <xsl:value-of select="f:user-node-matches($template-node,
				                    $document-node)"/>
	</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<doc:function name="f:user-node-matches" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Tests if an element from the title page content matches an element
from the document.</refpurpose>

<refdescription>
<para>An element from the document matches an element from the title page
content if it has the same (qualified) name and if all the attributes
specified in the title page content are equal to the attributes on the
document element.</para>

<para>See also: <function>f:user-node-matches</function>.</para>

<para>This function is a hook to customize
<function>f:node-matches</function>. 
Customizers can make the node matching algorithm more selective by redefining
<function>f:user-node-matches</function>, which will be called for every
matching element. If <function>f:user-node-matches</function> returns
<literal>false()</literal>, the elements will be deemed not to match.</para>

<para>Note that <function>f:user-node-matches</function> can only make
the match more selective. There is no function that can force a non-matching
element to match.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>template-node</term>
<listitem>
<para>The node from the title page content.</para>
</listitem>
</varlistentry>
<varlistentry><term>document-node</term>
<listitem>
<para>The node from the document.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True if the nodes match.</para>
</refreturn>
</doc:function>

<xsl:function name="f:user-node-matches" as="xs:boolean">
  <xsl:param name="template-node" as="element()"/>
  <xsl:param name="document-node" as="element()"/>
  <xsl:value-of select="true()"/>
</xsl:function>

</xsl:stylesheet>
