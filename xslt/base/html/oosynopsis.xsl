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
		exclude-result-prefixes="db doc f fn h m t"
                version="2.0">

<xsl:variable name="default-classsynopsis-language">java</xsl:variable>

<xsl:template match="db:classsynopsis
                     |db:fieldsynopsis
                     |db:methodsynopsis
                     |db:constructorsynopsis
                     |db:destructorsynopsis">
  <xsl:param name="language">
    <xsl:choose>
      <xsl:when test="@language">
	<xsl:value-of select="@language"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$default-classsynopsis-language"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$language='java'">
      <xsl:apply-templates select="." mode="java"/>
    </xsl:when>
    <xsl:when test="$language='perl'">
      <xsl:apply-templates select="." mode="perl"/>
    </xsl:when>
    <xsl:when test="$language='idl'">
      <xsl:apply-templates select="." mode="idl"/>
    </xsl:when>
    <xsl:when test="$language='cpp'">
      <xsl:apply-templates select="." mode="cpp"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Unrecognized language on </xsl:text>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text>: </xsl:text>
	<xsl:value-of select="$language"/>
      </xsl:message>
      <xsl:apply-templates select=".">
	<xsl:with-param name="language"
	  select="$default-classsynopsis-language"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:synop-break">
  <xsl:if test="parent::db:classsynopsis
                or (following-sibling::db:fieldsynopsis
                    |following-sibling::db:methodsynopsis
                    |following-sibling::db:constructorsynopsis
                    |following-sibling::db:destructorsynopsis)">
    <br/>
  </xsl:if>
</xsl:template>

<xsl:template name="t:synop-indent">
  <xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
</xsl:template>

<!-- ===== Java ======================================================== -->

<xsl:template match="db:classsynopsis" mode="java">
  <pre>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates select="db:ooclass[1]" mode="java"/>
    <xsl:if test="db:ooclass[position() &gt; 1]">
      <xsl:text> extends</xsl:text>
      <xsl:apply-templates select="db:ooclass[position() &gt; 1]" mode="java"/>
      <xsl:if test="db:oointerface|db:ooexception">
	<br/>
	<xsl:call-template name="t:synop-indent"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="db:oointerface">
      <xsl:text>implements</xsl:text>
      <xsl:apply-templates select="db:oointerface" mode="java"/>
      <xsl:if test="db:ooexception">
        <br/>
	<xsl:call-template name="t:synop-indent"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="db:ooexception">
      <xsl:text>throws</xsl:text>
      <xsl:apply-templates select="db:ooexception" mode="java"/>
    </xsl:if>
    <xsl:text>&#160;{</xsl:text>
    <br/>
    <xsl:apply-templates select="db:constructorsynopsis
                                 |db:destructorsynopsis
                                 |db:fieldsynopsis
                                 |db:methodsynopsis
                                 |db:classsynopsisinfo" mode="java"/>
    <xsl:text>}</xsl:text>
  </pre>
</xsl:template>

<xsl:template match="db:classsynopsisinfo" mode="java">
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="db:ooclass|db:oointerface|db:ooexception" mode="java">
  <xsl:choose>
    <xsl:when test="position() &gt; 1">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>class </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="db:modifier" mode="java">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:classname" mode="java">
  <xsl:if test="preceding-sibling::*[1]/self::db:classname">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="db:interfacename" mode="java">
  <xsl:if test="preceding-sibling::*[1]/self::db:interfacename">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="db:exceptionname" mode="java">
  <xsl:if test="preceding-sibling::*[1]/self::db:exceptionname">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="db:fieldsynopsis" mode="java">
  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:if test="parent::db:classsynopsis">
      <xsl:text>&#160;&#160;</xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="java"/>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="t:synop-break"/>
</xsl:template>

<xsl:template match="db:type" mode="java">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:varname" mode="java">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:initializer" mode="java">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>=&#160;</xsl:text>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="db:void" mode="java">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>void&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:methodname" mode="java">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="db:methodparam" mode="java">
  <xsl:param name="indent">0</xsl:param>
  <xsl:if test="position() &gt; 1">
    <xsl:text>,</xsl:text>
    <br/>
    <xsl:value-of select="string-join(for $count in (1 to $indent) return '&#160;','')"/>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template match="db:parameter" mode="java">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="java"/>
  </span>
</xsl:template>

<xsl:template mode="java"
  match="db:constructorsynopsis|db:destructorsynopsis|db:methodsynopsis">
  <xsl:variable name="modifiers" select="db:modifier"/>
  <xsl:variable name="notmod" select="*[not(self::db:modifier)]"/>
  <xsl:variable name="decl">
    <xsl:if test="parent::db:classsynopsis">
      <xsl:text>&#160;&#160;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$modifiers" mode="java"/>

    <!-- type -->
    <xsl:if test="not($notmod[1]/self::db:methodname)">
      <xsl:apply-templates select="$notmod[1]" mode="java"/>
    </xsl:if>

    <xsl:apply-templates select="db:methodname" mode="java"/>
  </xsl:variable>

  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:copy-of select="$decl"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="db:methodparam" mode="java">
      <xsl:with-param name="indent" select="string-length($decl)+1"/>
    </xsl:apply-templates>
    <xsl:text>)</xsl:text>
    <xsl:if test="db:exceptionname">
      <br/>
      <xsl:call-template name="t:synop-indent"/>
      <xsl:text>throws&#160;</xsl:text>
      <xsl:apply-templates select="db:exceptionname" mode="java"/>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="t:synop-break"/>
</xsl:template>

<!-- ===== C++ ========================================================= -->

<xsl:template match="db:classsynopsis" mode="cpp">
  <pre>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates select="db:ooclass[1]" mode="cpp"/>
    <xsl:if test="db:ooclass[position() &gt; 1]">
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="db:ooclass[position() &gt; 1]" mode="cpp"/>
      <xsl:if test="db:oointerface|db:ooexception">
        <br/>
	<xsl:call-template name="t:synop-indent"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="db:oointerface">
      <xsl:text> implements</xsl:text>
      <xsl:apply-templates select="db:oointerface" mode="cpp"/>
      <xsl:if test="db:ooexception">
        <br/>
	<xsl:call-template name="t:synop-indent"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="db:ooexception">
      <xsl:text> throws</xsl:text>
      <xsl:apply-templates select="db:ooexception" mode="cpp"/>
    </xsl:if>
    <xsl:text>&#160;{</xsl:text>
    <br/>
    <xsl:apply-templates select="db:constructorsynopsis
                                 |db:destructorsynopsis
                                 |db:fieldsynopsis
                                 |db:methodsynopsis
                                 |db:classsynopsisinfo" mode="cpp"/>
    <xsl:text>}</xsl:text>
  </pre>
</xsl:template>

<xsl:template match="db:classsynopsisinfo" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="db:ooclass|db:oointerface|db:ooexception" mode="cpp">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="db:modifier" mode="cpp">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:classname" mode="cpp">
  <xsl:if test="preceding-sibling::*[1]/self::db:classname">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="db:interfacename" mode="cpp">
  <xsl:if test="preceding-sibling::*[1]/self::db:interfacename">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="db:exceptionname" mode="cpp">
  <xsl:if test="preceding-sibling::*[1]/self::db:exceptionname">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="db:fieldsynopsis" mode="cpp">
  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:if test="parent::db:classsynopsis">
      <xsl:text>&#160;&#160;</xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="cpp"/>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="t:synop-break"/>
</xsl:template>

<xsl:template match="db:type" mode="cpp">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:varname" mode="cpp">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:initializer" mode="cpp">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>=&#160;</xsl:text>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="db:void" mode="cpp">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>void&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:methodname" mode="cpp">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="db:methodparam" mode="cpp">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template match="db:parameter" mode="cpp">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="cpp"/>
  </span>
</xsl:template>

<xsl:template mode="cpp"
  match="db:constructorsynopsis|db:destructorsynopsis|db:methodsynopsis">
  <xsl:variable name="modifiers" select="db:modifier"/>
  <xsl:variable name="notmod" select="*[not(self::db:modifier)]"/>

  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:if test="parent::db:classsynopsis">
      <xsl:text>&#160;&#160;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$modifiers" mode="cpp"/>

    <!-- type -->
    <xsl:if test="name($notmod[1]/self::db:methodname)">
      <xsl:apply-templates select="$notmod[1]" mode="cpp"/>
    </xsl:if>

    <xsl:apply-templates select="db:methodname" mode="cpp"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="db:methodparam" mode="cpp"/>
    <xsl:text>)</xsl:text>
    <xsl:if test="db:exceptionname">
      <br/>
      <xsl:call-template name="t:synop-indent"/>
      <xsl:text>throws&#160;</xsl:text>
      <xsl:apply-templates select="db:exceptionname" mode="cpp"/>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="t:synop-break"/>
</xsl:template>

<!-- ===== IDL ========================================================= -->

<xsl:template match="db:classsynopsis" mode="idl">
  <pre>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>interface </xsl:text>
    <xsl:apply-templates select="db:ooclass[1]" mode="idl"/>
    <xsl:if test="db:ooclass[position() &gt; 1]">
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="db:ooclass[position() &gt; 1]" mode="idl"/>
      <xsl:if test="db:oointerface|db:ooexception">
        <br/>
	<xsl:call-template name="t:synop-indent"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="db:oointerface">
      <xsl:text> implements</xsl:text>
      <xsl:apply-templates select="db:oointerface" mode="idl"/>
      <xsl:if test="db:ooexception">
        <br/>
	<xsl:call-template name="t:synop-indent"/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="db:ooexception">
      <xsl:text> throws</xsl:text>
      <xsl:apply-templates select="db:ooexception" mode="idl"/>
    </xsl:if>
    <xsl:text>&#160;{</xsl:text>
    <br/>
    <xsl:apply-templates select="db:constructorsynopsis
                                 |db:destructorsynopsis
                                 |db:fieldsynopsis
                                 |db:methodsynopsis
                                 |db:classsynopsisinfo" mode="idl"/>
    <xsl:text>}</xsl:text>
  </pre>
</xsl:template>

<xsl:template match="db:classsynopsisinfo" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="db:ooclass|db:oointerface|db:ooexception" mode="idl">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="db:modifier" mode="idl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:classname" mode="idl">
  <xsl:if test="preceding-sibling::*[1]/self::db:classname">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="db:interfacename" mode="idl">
  <xsl:if test="preceding-sibling::*[1]/self::db:interfacename">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="db:exceptionname" mode="idl">
  <xsl:if test="preceding-sibling::*[1]/self::db:exceptionname">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="db:fieldsynopsis" mode="idl">
  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:if test="parent::db:classsynopsis">
      <xsl:text>&#160;&#160;</xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="idl"/>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="t:synop-break"/>
</xsl:template>

<xsl:template match="db:type" mode="idl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:varname" mode="idl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:initializer" mode="idl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>=&#160;</xsl:text>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="db:void" mode="idl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>void&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:methodname" mode="idl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="db:methodparam" mode="idl">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template match="db:parameter" mode="idl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="idl"/>
  </span>
</xsl:template>

<xsl:template mode="idl"
  match="db:constructorsynopsis|db:destructorsynopsis|db:methodsynopsis">
  <xsl:variable name="modifiers" select="db:modifier"/>
  <xsl:variable name="notmod" select="*[not(self::db:modifier)]"/>

  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:if test="parent::db:classsynopsis">
      <xsl:text>&#160;&#160;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$modifiers" mode="idl"/>

    <!-- type -->
    <xsl:if test="not($notmod[1]/self::db:methodname)">
      <xsl:apply-templates select="$notmod[1]" mode="idl"/>
    </xsl:if>

    <xsl:apply-templates select="db:methodname" mode="idl"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="db:methodparam" mode="idl"/>
    <xsl:text>)</xsl:text>
    <xsl:if test="db:exceptionname">
      <br/>
      <xsl:call-template name="t:synop-indent"/>
      <xsl:text>raises(</xsl:text>
      <xsl:apply-templates select="db:exceptionname" mode="idl"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="t:synop-break"/>
</xsl:template>

<!-- ===== Perl ======================================================== -->

<xsl:template match="db:classsynopsis" mode="perl">
  <pre>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>package </xsl:text>
    <xsl:apply-templates select="db:ooclass[1]" mode="perl"/>
    <xsl:text>;</xsl:text>
    <br/>

    <xsl:if test="db:ooclass[position() &gt; 1]">
      <xsl:text>@ISA = (</xsl:text>
      <xsl:apply-templates select="db:ooclass[position() &gt; 1]" mode="perl"/>
      <xsl:text>);</xsl:text>
      <br/>
    </xsl:if>

    <xsl:apply-templates select="db:constructorsynopsis
                                 |db:destructorsynopsis
                                 |db:fieldsynopsis
                                 |db:methodsynopsis
                                 |db:classsynopsisinfo" mode="perl"/>
  </pre>
</xsl:template>

<xsl:template match="db:classsynopsisinfo" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="db:ooclass|db:oointerface|db:ooexception" mode="perl">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="db:modifier" mode="perl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:classname" mode="perl">
  <xsl:if test="preceding-sibling::*[1]/self::db:classname">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="interfacename" mode="perl">
  <xsl:if test="preceding-sibling::*[1]/self::db:interfacename">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="exceptionname" mode="perl">
  <xsl:if test="preceding-sibling::*[1]/self::db:exceptionname">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="db:fieldsynopsis" mode="perl">
  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:if test="parent::db:classsynopsis">
      <xsl:text>&#160;&#160;</xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="perl"/>
    <xsl:text>;</xsl:text>
  </code>
  <xsl:call-template name="t:synop-break"/>
</xsl:template>

<xsl:template match="db:type" mode="perl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:varname" mode="perl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
    <xsl:text>&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:initializer" mode="perl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>=&#160;</xsl:text>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="db:void" mode="perl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>void&#160;</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:methodname" mode="perl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="db:methodparam" mode="perl">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template match="db:parameter" mode="perl">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="perl"/>
  </span>
</xsl:template>

<xsl:template mode="perl"
  match="db:constructorsynopsis|db:destructorsynopsis|db:methodsynopsis">
  <xsl:variable name="modifiers" select="db:modifier"/>
  <xsl:variable name="notmod" select="*[not(self::db:modifier)]"/>

  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:text>sub </xsl:text>

    <xsl:apply-templates select="db:methodname" mode="perl"/>
    <xsl:text> { ... };</xsl:text>
  </code>
  <xsl:call-template name="t:synop-break"/>
</xsl:template>

</xsl:stylesheet>
