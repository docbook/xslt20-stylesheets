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

<xsl:include href="oosynopsis.xsl"/>

<xsl:template match="db:refsynopsis">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- ============================================================ -->
<!-- The following definitions match those given in the reference
     documentation for DocBook V3.0
-->

<xsl:variable name="arg.choice.opt.open.str">[</xsl:variable>
<xsl:variable name="arg.choice.opt.close.str">]</xsl:variable>
<xsl:variable name="arg.choice.req.open.str">{</xsl:variable>
<xsl:variable name="arg.choice.req.close.str">}</xsl:variable>
<xsl:variable name="arg.choice.plain.open.str"><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="arg.choice.plain.close.str"><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="arg.choice.def.open.str">[</xsl:variable>
<xsl:variable name="arg.choice.def.close.str">]</xsl:variable>
<xsl:variable name="arg.rep.repeat.str">...</xsl:variable>
<xsl:variable name="arg.rep.norepeat.str"></xsl:variable>
<xsl:variable name="arg.rep.def.str"></xsl:variable>
<xsl:variable name="arg.or.sep"> | </xsl:variable>
<xsl:variable name="cmdsynopsis.hanging.indent">0.66in</xsl:variable>
<xsl:variable name="cmdsynopsis.margin.top">1em</xsl:variable>

<xsl:template match="db:cmdsynopsis">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:attribute name="style">
      <xsl:text>margin-top: </xsl:text>
      <xsl:value-of select="$cmdsynopsis.margin.top"/>
      <xsl:text>; </xsl:text>
      <xsl:if test="f:length-magnitude($cmdsynopsis.hanging.indent) != 0">
        <xsl:text>text-indent: -</xsl:text>
        <xsl:value-of select="$cmdsynopsis.hanging.indent"/>
        <xsl:text>; margin-left: </xsl:text>
        <xsl:value-of select="$cmdsynopsis.hanging.indent"/>
        <xsl:text>;</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:cmdsynopsis/db:command">
  <xsl:if test="preceding-sibling::*[1]">
    <br/>
  </xsl:if>
  <xsl:call-template name="t:inline-monoseq"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="db:group|db:arg" name="t:group-or-arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:variable name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*/@sepchar">
        <xsl:value-of select="ancestor-or-self::*/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="position()>1">
    <xsl:value-of select="$sepchar"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:value-of select="$arg.choice.plain.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.open.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.open.str"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates/>

  <xsl:choose>
    <xsl:when test="$rep='repeat'">
      <xsl:value-of select="$arg.rep.repeat.str"/>
    </xsl:when>
    <xsl:when test="$rep='norepeat'">
      <xsl:value-of select="$arg.rep.norepeat.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.rep.def.str"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:value-of select="$arg.choice.plain.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.close.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.close.str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:group/db:arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:if test="position()>1">
    <xsl:value-of select="$arg.or.sep"/>
  </xsl:if>
  <xsl:call-template name="t:group-or-arg"/>
</xsl:template>

<xsl:template match="db:sbr">
  <br/>
</xsl:template>

<xsl:template match="db:synopfragmentref">
  <xsl:variable name="target" select="key('id',@linkend)"/>
  <xsl:variable name="snum">
    <xsl:apply-templates select="$target" mode="m:synopfragment.number"/>
  </xsl:variable>

  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <a href="#{@linkend}">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$snum"/>
      <xsl:text>)</xsl:text>
    </a>
    <xsl:text>&#160;</xsl:text>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:synopfragment" mode="m:synopfragment.number">
  <xsl:number format="1"/>
</xsl:template>

<xsl:template match="db:synopfragment">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:attribute name="style">
      <xsl:text>margin-top: </xsl:text>
      <xsl:value-of select="$cmdsynopsis.margin.top"/>
      <xsl:text>; </xsl:text>
    </xsl:attribute>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="." mode="m:synopfragment.number"/>
    <xsl:text>)</xsl:text>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:param name="funcsynopsis.decoration" select="1"/>
<xsl:param name="funcsynopsis.style">kr</xsl:param>
<xsl:param name="funcsynopsis.tabular.threshold" select="40"/>

<xsl:template match="db:funcsynopsis">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:funcsynopsisinfo">
  <pre>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </pre>
</xsl:template>

<!-- ============================================================ -->
<!-- funcprototype -->
<!--

funcprototype ::= (funcdef,
                   (void|varargs|paramdef+))

funcdef       ::= (#PCDATA|type|replaceable|function)*

paramdef      ::= (#PCDATA|type|replaceable|parameter|funcparams)*
-->

<xsl:template match="db:funcprototype">
  <xsl:choose>
    <xsl:when test="../@language='xslt2-function'">
      <xsl:apply-templates select="." mode="m:funcprototype-xslt2-function"/>
    </xsl:when>
    <xsl:when test="../@language='xslt2-template'">
      <xsl:apply-templates select="." mode="m:funcprototype-xslt2-template"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="pis"
		    select="ancestor::db:funcsynopsis
			    //processing-instruction('dbhtml')"/>
      <xsl:variable name="html-style" select="f:pi($pis, 'funcsynopsis-style')"/>

      <xsl:variable name="style">
	<xsl:choose>
	  <xsl:when test="$html-style != ''">
	    <xsl:value-of select="$html-style"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$funcsynopsis.style"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>

      <xsl:variable name="tabular-p"
		    select="$funcsynopsis.tabular.threshold &gt; 0
			    and string-length(.)
			    &gt; $funcsynopsis.tabular.threshold"/>

      <xsl:choose>
	<xsl:when test="$style = 'kr' and $tabular-p">
	  <xsl:apply-templates select="." mode="m:kr-tabular"/>
	</xsl:when>
	<xsl:when test="$style = 'kr'">
	  <xsl:apply-templates select="." mode="m:kr-nontabular"/>
	</xsl:when>
	<xsl:when test="$style = 'ansi' and $tabular-p">
	  <xsl:apply-templates select="." mode="m:ansi-tabular"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates select="." mode="m:ansi-nontabular"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->
<!-- funcprototype: kr, non-tabular -->

<xsl:template match="db:funcprototype" mode="m:kr-nontabular">
  <p>
    <xsl:apply-templates mode="m:kr-nontabular"/>
    <xsl:if test="db:paramdef">
      <br/>
      <xsl:apply-templates select="db:paramdef" mode="m:kr-funcsynopsis-mode"/>
    </xsl:if>
  </p>
</xsl:template>

<xsl:template match="db:funcdef" mode="m:kr-nontabular">
  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:kr-nontabular"/>
    <xsl:text>(</xsl:text>
  </code>
</xsl:template>

<xsl:template match="db:funcdef/db:function" mode="m:kr-nontabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <b class="fsfunc"><xsl:apply-templates mode="m:kr-nontabular"/></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:kr-nontabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:void" mode="m:kr-nontabular">
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="db:varargs" mode="m:kr-nontabular">
  <xsl:text>...</xsl:text>
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:kr-nontabular">
  <xsl:apply-templates select="db:parameter" mode="m:kr-nontabular"/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <code>)</code>
      <xsl:text>;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:paramdef/db:parameter" mode="m:kr-nontabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="m:kr-nontabular"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:kr-nontabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:kr-funcsynopsis-mode">
  <xsl:if test="preceding-sibling::db:paramdef"><br/></xsl:if>
  <xsl:apply-templates mode="m:kr-funcsynopsis-mode"/>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="db:paramdef/db:parameter" mode="m:kr-funcsynopsis-mode">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="m:kr-funcsynopsis-mode"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:kr-funcsynopsis-mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:funcparams" mode="m:kr-funcsynopsis-mode">
  <code>(</code>
  <xsl:apply-templates mode="m:kr-funcsynopsis-mode"/>
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<!-- ============================================================ -->
<!-- funcprototype: kr, tabular -->

<xsl:template match="db:funcprototype" mode="m:kr-tabular">
  <table border="0" summary="Function synopsis"
	 cellspacing="0" cellpadding="0"
         style="padding-bottom: 1em">
    <xsl:sequence select="f:html-attributes(.)"/>
    <tr>
      <td>
        <xsl:apply-templates select="db:funcdef" mode="m:kr-tabular"/>
      </td>
      <xsl:apply-templates select="(db:void|db:varargs|db:paramdef)[1]"
			   mode="m:kr-tabular"/>
    </tr>
    <xsl:for-each select="(db:void|db:varargs|db:paramdef)[position() &gt; 1]">
      <tr>
        <td>&#160;</td>
        <xsl:apply-templates select="." mode="m:kr-tabular"/>
      </tr>
    </xsl:for-each>
  </table>

  <xsl:if test="db:paramdef">
    <table border="0"
	   summary="Function argument synopsis"
           cellspacing="0" cellpadding="0">
      <xsl:sequence select="f:html-attributes(.)"/>
      <!--
      <xsl:if test="following-sibling::db:funcprototype">
        <xsl:attribute name="style">padding-bottom: 1em</xsl:attribute>
      </xsl:if>
      -->
      <xsl:apply-templates select="db:paramdef"
			   mode="m:kr-tabular-funcsynopsis-mode"/>
    </table>
  </xsl:if>
</xsl:template>

<xsl:template match="db:funcdef" mode="m:kr-tabular">
  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:kr-tabular"/>
    <xsl:text>(</xsl:text>
  </code>
</xsl:template>

<xsl:template match="db:funcdef/db:function" mode="m:kr-tabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <b class="fsfunc"><xsl:apply-templates mode="m:kr-nontabular"/></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:kr-tabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:void" mode="m:kr-tabular">
  <td>
    <code>)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td>&#160;</td>
</xsl:template>

<xsl:template match="db:varargs" mode="m:kr-tabular">
  <td>
    <xsl:text>...</xsl:text>
    <code>)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td>&#160;</td>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:kr-tabular">
  <td>
    <xsl:apply-templates select="db:parameter" mode="m:kr-tabular"/>
    <xsl:choose>
      <xsl:when test="following-sibling::*">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <code>)</code>
        <xsl:text>;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </td>
  <td>&#160;</td>
</xsl:template>

<xsl:template match="db:paramdef/db:parameter" mode="m:kr-tabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="m:kr-tabular"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:kr-tabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:kr-tabular-funcsynopsis-mode">
  <tr>
    <xsl:choose>
      <xsl:when test="db:type and db:funcparams">
        <td>
	  <xsl:apply-templates select="db:type"
			       mode="m:kr-tabular-funcsynopsis-mode"/>
          <xsl:text>&#160;</xsl:text>
        </td>
        <td>
          <xsl:apply-templates select="db:type/following-sibling::node()"
			       mode="m:kr-tabular-funcsynopsis-mode"/>
        </td>
      </xsl:when>
      <xsl:when test="db:funcparams">
        <td colspan="2">
          <xsl:apply-templates mode="m:kr-tabular-funcsynopsis-mode"/>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td>
          <xsl:apply-templates select="db:parameter/preceding-sibling::node()[not(self::db:parameter)]"
                               mode="m:kr-tabular-funcsynopsis-mode"/>
          <xsl:text>&#160;</xsl:text>
        </td>
        <td>
          <xsl:apply-templates select="db:parameter"
                               mode="m:kr-tabular"/>
          <xsl:apply-templates select="db:parameter/following-sibling::node()[not(self::db:parameter)]"
                               mode="m:kr-tabular-funcsynopsis-mode"/>
          <xsl:text>;</xsl:text>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </tr>
</xsl:template>

<xsl:template match="db:paramdef/db:parameter"
	      mode="m:kr-tabular-funcsynopsis-mode">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="m:kr-tabular-funcsynopsis-mode"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:kr-tabular-funcsynopsis-mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:funcparams" mode="m:kr-tabular-funcsynopsis-mode">
  <code>(</code>
  <xsl:apply-templates mode="m:kr-tabular-funcsynopsis-mode"/>
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<!-- ============================================================ -->
<!-- funcprototype: ansi, non-tabular -->

<xsl:template match="db:funcprototype" mode="m:ansi-nontabular">
  <p>
    <xsl:apply-templates mode="m:ansi-nontabular"/>
  </p>
</xsl:template>

<xsl:template match="db:funcdef" mode="m:ansi-nontabular">
  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:ansi-nontabular"/>
    <xsl:text>(</xsl:text>
  </code>
</xsl:template>

<xsl:template match="db:funcdef/db:function" mode="m:ansi-nontabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <b class="fsfunc"><xsl:apply-templates mode="m:ansi-nontabular"/></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:ansi-nontabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:void" mode="m:ansi-nontabular">
  <code>void)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="db:varargs" mode="m:ansi-nontabular">
  <xsl:text>...</xsl:text>
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:ansi-nontabular">
  <xsl:apply-templates mode="m:ansi-nontabular"/>
  <xsl:choose>
    <xsl:when test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <code>)</code>
      <xsl:text>;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:paramdef/db:parameter" mode="m:ansi-nontabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="m:ansi-nontabular"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:ansi-nontabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:funcparams" mode="m:ansi-nontabular">
  <code>(</code>
  <xsl:apply-templates mode="m:ansi-nontabular"/>
  <code>)</code>
</xsl:template>

<!-- ============================================================ -->
<!-- funcprototype: ansi, tabular -->

<xsl:template match="db:funcprototype" mode="m:ansi-tabular">
  <table border="0"
	 summary="Function synopsis"
	 cellspacing="0" cellpadding="0">
    <xsl:sequence select="f:html-attributes(.)"/>
    <!--
    <xsl:if test="following-sibling::db:funcprototype">
      <xsl:attribute name="style">padding-bottom: 1em</xsl:attribute>
    </xsl:if>
    -->
    <tr>
      <td>
        <xsl:apply-templates select="db:funcdef" mode="m:ansi-tabular"/>
      </td>
      <xsl:apply-templates select="(db:void|db:varargs|db:paramdef)[1]"
			   mode="m:ansi-tabular"/>
    </tr>
    <xsl:for-each select="(db:void|db:varargs|db:paramdef)[position() &gt; 1]">
      <tr>
        <td>&#160;</td>
        <xsl:apply-templates select="." mode="m:ansi-tabular"/>
      </tr>
    </xsl:for-each>
  </table>
</xsl:template>

<xsl:template match="db:funcdef" mode="m:ansi-tabular">
  <code>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:ansi-tabular"/>
    <xsl:text>(</xsl:text>
  </code>
</xsl:template>

<xsl:template match="db:funcdef/db:function" mode="m:ansi-tabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <b class="fsfunc"><xsl:apply-templates mode="m:ansi-nontabular"/></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:kr-tabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:void" mode="m:ansi-tabular">
  <td>
    <code>void)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td>&#160;</td>
</xsl:template>

<xsl:template match="db:varargs" mode="m:ansi-tabular">
  <td>
    <xsl:text>...</xsl:text>
    <code>)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td>&#160;</td>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:ansi-tabular">
  <xsl:choose>
    <xsl:when test="db:type and db:funcparams">
      <td>
        <xsl:apply-templates select="db:type"
			     mode="m:kr-tabular-funcsynopsis-mode"/>
        <xsl:text>&#160;</xsl:text>
      </td>
      <td>
        <xsl:apply-templates select="db:type/following-sibling::node()"
                             mode="m:kr-tabular-funcsynopsis-mode"/>
      </td>
    </xsl:when>
    <xsl:otherwise>
      <td>
        <xsl:apply-templates select="db:parameter/preceding-sibling::node()[not(self::db:parameter)]"
                             mode="m:ansi-tabular"/>
        <xsl:text>&#160;</xsl:text>
      </td>
      <td>
        <xsl:apply-templates select="db:parameter"
                             mode="m:ansi-tabular"/>
        <xsl:apply-templates select="db:parameter/following-sibling::node()[not(self::db:parameter)]"
                             mode="m:ansi-tabular"/>
        <xsl:choose>
          <xsl:when test="following-sibling::*">
            <xsl:text>, </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <code>)</code>
            <xsl:text>;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:paramdef/db:parameter" mode="m:ansi-tabular">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <var class="pdparam">
        <xsl:apply-templates mode="m:ansi-tabular"/>
      </var>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:ansi-tabular"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:funcparams" mode="m:ansi-tabular">
  <code>(</code>
  <xsl:apply-templates/>
  <code>)</code>
</xsl:template>

<!-- ============================================================ -->
<!-- XSLT2 templates and functions -->

<doc:mode name="m:funcprototype-xslt2-function"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting XSLT 2.0 function prototypes</refpurpose>

<refdescription>
<para>This mode is used to format XSLT 2.0 function prototypes.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:funcprototype" mode="m:funcprototype-xslt2-function">
  <xsl:apply-templates select="db:funcdef/db:function"
		       mode="m:funcprototype-xslt2-function"/>
  <xsl:text>(</xsl:text>
  <xsl:apply-templates select="db:paramdef" mode="m:funcprototype-xslt2-function"/>
  <xsl:text>)</xsl:text>
  <xsl:if test="db:funcdef/db:type">
    <xsl:text> as </xsl:text>
    <xsl:apply-templates select="db:funcdef/db:type"
			 mode="m:funcprototype-xslt2-function"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:function" mode="m:funcprototype-xslt2-function">
  <strong>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:funcprototype-xslt2-function"/>
  </strong>
</xsl:template>

<xsl:template match="db:type" mode="m:funcprototype-xslt2-function">
  <em>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:funcprototype-xslt2-function"/>
  </em>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:funcprototype-xslt2-function">
  <xsl:apply-templates select="db:parameter"
		       mode="m:funcprototype-xslt2-function"/>
  <xsl:if test="db:type">
    <xsl:text> as </xsl:text>
    <xsl:apply-templates select="db:type"
			 mode="m:funcprototype-xslt2-function"/>
  </xsl:if>

  <xsl:if test="following-sibling::db:paramdef">, </xsl:if>
</xsl:template>

<xsl:template match="db:parameter" mode="m:funcprototype-xslt2-function">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates mode="m:funcprototype-xslt2-function"/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:funcprototype-xslt2-template"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting XSLT 2.0 named templates</refpurpose>

<refdescription>
<para>This mode is used to format XSLT 2.0 named templates.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:funcprototype" mode="m:funcprototype-xslt2-template">
  <pre>
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:text>&lt;xsl:call-template name="</xsl:text>
    <xsl:value-of select="db:funcdef/db:function"/>
    <xsl:text>"</xsl:text>
    <xsl:if test="db:funcdef/db:type">
      <xsl:text> as="</xsl:text>
      <xsl:value-of select="db:funcdef/db:type"/>
      <xsl:text>"</xsl:text>
    </xsl:if>
    <xsl:text>&gt;&#10;</xsl:text>

    <xsl:apply-templates select="db:paramdef"
			 mode="m:funcprototype-xslt2-template"/>

    <xsl:text>&lt;/xsl:call-template&gt;</xsl:text>
  </pre>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:funcprototype-xslt2-template">
  <xsl:variable name="with-param">
    <xsl:text>&lt;xsl:with-param name="</xsl:text>
    <xsl:value-of select="db:parameter"/>
    <xsl:text>"</xsl:text>

    <xsl:if test="db:initializer[@role='select']">
      <xsl:text> select="</xsl:text>
      <xsl:value-of select="db:initializer"/>
      <xsl:text>"</xsl:text>
    </xsl:if>

    <xsl:if test="db:type">
      <xsl:text> as="</xsl:text>
      <xsl:value-of select="db:type"/>
      <xsl:text>"</xsl:text>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="db:initializer[@role='content']">
	<xsl:text>&gt;</xsl:text>
	<xsl:copy-of select="db:initializer[@role='content']/node()"/>
	<xsl:text>&lt;/xsl:with-param&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>/&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>   </xsl:text>
  <xsl:choose>
    <xsl:when test="@role = 'recursive'">
      <i>
	<xsl:copy-of select="$with-param"/>
      </i>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$with-param"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
