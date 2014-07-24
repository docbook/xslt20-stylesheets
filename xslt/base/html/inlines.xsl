<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                exclude-result-prefixes="db doc f fn m t u xlink"
                version="2.0">

<!-- ********************************************************************
     $Id: inlines.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sourceforge.net/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ============================================================ -->

<doc:template name="t:inline-charseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles simple inline elements</refpurpose>

<refdescription>
<para>This template generates simple inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>span</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>
<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the span.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>

<u:unittests template="t:inline-charseq">
  <u:test>
    <u:context as="element()">
      <db:varname xml:id="varfoo">someVarName</db:varname>
    </u:context>
    <u:result>
      <span xmlns="http://www.w3.org/1999/xhtml"
	    class="varname" id="varfoo">someVarName</span>
    </u:result>
  </u:test>
</u:unittests>

</doc:template>

<xsl:template name="t:inline-charseq">
  <xsl:param name="content">
    <xsl:call-template name="t:xlink"/>
  </xsl:param>
  <xsl:param name="class" select="()"/>

  <span>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.), ($class,@role))"/>
    <xsl:copy-of select="$content"/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-monoseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles monospace inline elements</refpurpose>

<refdescription>
<para>This template generates monospace inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>tt</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>
<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>tt</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-monoseq">
  <xsl:param name="content">
    <xsl:call-template name="t:xlink"/>
  </xsl:param>
  <xsl:param name="class" select="()"/>

  <code>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.), ($class,@role))"/>
    <xsl:copy-of select="$content"/>
  </code>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-boldseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles bold inline elements</refpurpose>

<refdescription>
<para>This template generates bold inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>strong</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>
<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>strong</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-boldseq">
  <xsl:param name="content">
    <xsl:call-template name="t:xlink"/>
  </xsl:param>
  <xsl:param name="class" select="()"/>

  <strong>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.), ($class,@role))"/>
    <xsl:copy-of select="$content"/>
  </strong>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-italicseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles italic inline elements</refpurpose>

<refdescription>
<para>This template generates italic inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>em</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>
<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>em</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-italicseq">
  <xsl:param name="content">
    <xsl:call-template name="t:xlink"/>
  </xsl:param>
  <xsl:param name="class" select="()"/>

  <em>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.), ($class,@role))"/>
    <xsl:copy-of select="$content"/>
  </em>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-boldmonoseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles bold, monospace inline elements</refpurpose>

<refdescription>
<para>This template generates bold, monospace inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>strong</tag> with a
<tag class="attribute">class</tag> attribute and possibly an
<tag class="attribute">id</tag>.</para>

<para>If the element has an
<tag>alt</tag> element among its children, the string-value of
that element will be used as the <tag
class="attribute">title</tag> of the <tag>strong</tag>.</para>

<para>Inside the <tag>strong</tag>, it generates a <tag>tt</tag> with
a <tag class="attribute">dir</tag> attribute, if
appropriate.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-boldmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="t:xlink"/>
  </xsl:param>
  <xsl:param name="class" select="()"/>

  <strong>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.), ($class,@role))"/>
    <code>
      <xsl:copy-of select="$content"/>
    </code>
  </strong>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-italicmonoseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles italic, monospace inline elements</refpurpose>

<refdescription>
<para>This template generates italic, monospace inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>em</tag> with a
<tag class="attribute">class</tag> attribute and possibly an
<tag class="attribute">id</tag>.</para>

<para>If the element has an
<tag>alt</tag> element among its children, the string-value of
that element will be used as the <tag
class="attribute">title</tag> of the <tag>em</tag>.</para>

<para>Inside the <tag>em</tag>, it generates a <tag>tt</tag> with
a <tag class="attribute">dir</tag> attribute, if
appropriate.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-italicmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="t:xlink"/>
  </xsl:param>
  <xsl:param name="class" select="()"/>

  <em>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.), ($class,@role))"/>
    <code>
      <xsl:copy-of select="$content"/>
    </code>
  </em>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-superscriptseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles superscript inline elements</refpurpose>

<refdescription>
<para>This template generates superscript inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>sup</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>

<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>sup</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-superscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="t:xlink"/>
  </xsl:param>

  <sup>
    <xsl:sequence select="f:html-attributes(., @xml:id, if (self::db:superscript) then () else local-name(.))"/>
    <xsl:copy-of select="$content"/>
  </sup>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-subscriptseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles subscript inline elements</refpurpose>

<refdescription>
<para>This template generates subscript inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>sub</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>

<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>sub</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-subscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="t:xlink"/>
  </xsl:param>

  <sub>
    <xsl:sequence select="f:html-attributes(., @xml:id, if (self::db:subscript) then () else local-name(.))"/>
    <xsl:copy-of select="$content"/>
  </sub>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="format-tag" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles markup for the DocBook <tag>tag</tag> element</refpurpose>

<refdescription>
<para>This template generates markup for the context
node, assumed to be a <tag>tag</tag> element.</para>

<para>Specifically, it generates a <tag>tt</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> attribute.</para>

<para>Depending on the value of the <tag class="attribute">class</tag>
attribute, additional generated text may be output as well.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>class</term>
<listitem>
<para>The class attribute associated with the context element. If
the context element has no <tag class="attribute">class</tag> attribute,
the default is “element”.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="format-tag">
  <xsl:param name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <code>
    <xsl:sequence select="f:html-attributes(., @xml:id, concat(local-name(.),'-',$class))"/>
    <xsl:choose>
      <xsl:when test="$class='attribute'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='attvalue'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='element'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='endtag'">
        <xsl:text>&lt;/</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='genentity'">
        <xsl:text>&amp;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='numcharref'">
        <xsl:text>&amp;#</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='paramentity'">
        <xsl:text>%</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='pi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='xmlpi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>?&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='starttag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='emptytag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='sgmlcomment'">
        <xsl:text>&lt;!--</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>--&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </code>
</xsl:template>

<u:unittests match="db:emphasis">
  <u:test>
    <u:context as="element()">
      <db:emphasis>Something emphasized</db:emphasis>
    </u:context>
    <u:result>
      <em xmlns="http://www.w3.org/1999/xhtml">Something emphasized</em>
    </u:result>
  </u:test>
  <u:test>
    <u:context as="element()">
      <db:emphasis role='strong'>Something strongly emphasized</db:emphasis>
    </u:context>
    <u:result>
      <strong xmlns="http://www.w3.org/1999/xhtml"
	      class="emphasis">Something strongly emphasized</strong>
    </u:result>
  </u:test>
</u:unittests>

<xsl:template match="db:emphasis">
  <xsl:variable name="classes" select="tokenize(@role, '\s+')"/>
  <xsl:choose>
    <xsl:when test="$classes = 'bold' or $classes = 'strong'">
      <strong>
        <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.),
                                                $classes[(. != 'bold') and (. != 'strong')])"/>
        <xsl:call-template name="t:xlink"/>
      </strong>
    </xsl:when>
    <xsl:otherwise>
      <em>
        <xsl:sequence select="f:html-attributes(., @xml:id, (), $classes)"/>
        <xsl:call-template name="t:xlink"/>
      </em>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->
<!-- HACK HACK HACK for testing framework. Delete me! -->
<!--
<u:unittests match="db:emphasis" mode="foobar">
  <u:test>
    <u:context as="element()">
      <db:emphasis>Something emphasized</db:emphasis>
    </u:context>
    <u:result>
      <b xmlns="http://www.w3.org/1999/xhtml">Something emphasized</b>
    </u:result>
  </u:test>
</u:unittests>

<xsl:template match="db:emphasis" mode="foobar">
  <b><xsl:apply-templates/></b>
</xsl:template>
-->
<!-- ============================================================ -->

<xsl:template match="db:foreignphrase">
  <xsl:call-template name="t:inline-italicseq"/>
</xsl:template>

<xsl:template match="db:phrase">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:call-template name="t:xlink"/>
  </span>
</xsl:template>

<xsl:template match="db:productname">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:apply-templates/>
      <xsl:choose>
	<xsl:when test="@class = 'copyright'">
          <sup>©</sup>
        </xsl:when>
	<xsl:when test="@class = 'registered'">
          <sup>®</sup>
        </xsl:when>
	<xsl:when test="@class = 'service'">
	  <sup>℠</sup>
	</xsl:when>
	<xsl:when test="@class = 'trade'">
          <sup>™</sup>
        </xsl:when>
        <xsl:otherwise>
	  <!-- nop -->
	</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:lineannotation">
  <xsl:call-template name="t:inline-italicseq"/>
</xsl:template>

<xsl:template match="db:trademark">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:apply-templates/>
      <xsl:choose>
	<xsl:when test="@class = 'copyright'">
          <sup>&#x00A9;</sup>
        </xsl:when>
	<xsl:when test="@class = 'registered'">
          <sup>&#x00AE;</sup>
        </xsl:when>
	<xsl:when test="@class = 'service'">
	  <sup>SM</sup>
	</xsl:when>
	<xsl:otherwise>&#x2122;</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="db:glossterm" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing glossterm elements</refpurpose>

<refdescription>
<para>The glossterm template is used to process <tag>glossterm</tag>
and <tag>firstterm</tag> elements.</para>
</refdescription>
</doc:template>

<xsl:template match="db:firstterm">
  <xsl:call-template name="db:glossterm">
    <xsl:with-param name="firstterm" select="1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:glossterm" name="db:glossterm">
  <xsl:param name="firstterm" select="0"/>

  <xsl:variable name="extra-class"
                select="if (self::db:firstterm or $firstterm = 0) then () else 'firstterm'"/>

  <em>
    <xsl:sequence select="f:html-attributes(., @xml:id, local-name(.), $extra-class)"/>

    <xsl:choose>
      <xsl:when test="($firstterm.only.link = 0 or $firstterm = 1) and @linkend">
	<xsl:variable name="target" select="key('id',@linkend)[1]"/>

	<a href="{f:href(/,$target)}">
	  <xsl:apply-templates/>
	</a>
      </xsl:when>

      <xsl:when test="not(@linkend)
		      and ($firstterm.only.link = 0 or $firstterm = 1)
		      and $glossterm.auto.link != 0">
	<xsl:variable name="term">
	  <xsl:choose>
	    <xsl:when test="@baseform">
	      <xsl:value-of select="normalize-space(@baseform)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="normalize-space(.)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>

	<xsl:variable name="targets"
		      select="//db:glossentry
			        [normalize-space(db:glossterm) = $term
			         or normalize-space(db:glossterm/@baseform)
				    = $term]"/>

	<xsl:variable name="target" select="$targets[1]"/>

	<xsl:choose>
	  <xsl:when test="count($targets)=0">
	    <xsl:message>
	      <xsl:text>Error: no glossentry for glossterm: </xsl:text>
	      <xsl:value-of select="."/>
	      <xsl:text>.</xsl:text>
	    </xsl:message>
	    <xsl:apply-templates/>
	  </xsl:when>
	  <xsl:otherwise>
	    <a href="{f:href(/,$target)}">
	      <xsl:apply-templates/>
	    </a>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>

      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </em>
</xsl:template>

<xsl:template match="db:termdef">
  <span>
    <xsl:sequence select="f:html-attributes(., f:node-id(.))"/>
    <xsl:call-template name="gentext-template">
      <xsl:with-param name="context" select="'termdef'"/>
      <xsl:with-param name="name" select="'prefix'"/>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:call-template name="gentext-template">
      <xsl:with-param name="context" select="'termdef'"/>
      <xsl:with-param name="name" select="'suffix'"/>
    </xsl:call-template>
  </span>
</xsl:template>

<xsl:template match="db:email">
  <xsl:call-template name="t:inline-monoseq">
    <xsl:with-param name="content">
      <xsl:text>&lt;</xsl:text>
      <a>
	<xsl:attribute name="href">
	  <xsl:text>mailto:</xsl:text>
	  <xsl:value-of select="."/>
	</xsl:attribute>
	<xsl:apply-templates/>
      </a>
      <xsl:text>&gt;</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:optional">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<xsl:template match="db:systemitem">
  <xsl:call-template name="t:inline-monoseq">
    <xsl:with-param name="class" select="@class"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>


