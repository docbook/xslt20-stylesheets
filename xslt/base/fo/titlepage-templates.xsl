<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:db="http://docbook.org/ns/docbook"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fp="http://docbook.org/xslt/ns/extension/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:tp="http://docbook.org/xslt/ns/template/private"
                xmlns:tmpl="http://docbook.org/xslt/titlepage-templates"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="db m t tp ghost xs f fp tmpl">

<!-- ============================================================ -->
<!-- User templates -->

<xsl:template name="t:user-titlepage-templates" as="element(tmpl:templates-list)?">
  <!-- Empty by default, override for custom templates -->
</xsl:template>

<!-- ============================================================ -->
<!-- System templates -->

<xsl:template name="t:titlepage-templates" as="element(tmpl:templates-list)">
  <!-- These are explicitly inline so that we can use XSLT during their construction -->
  <!-- Don't change these, define your own in t:user-titlepage-templates -->
  <templates-list xmlns="http://docbook.org/xslt/titlepage-templates">

    <templates name="part">
      <recto>
        <fo:block>
          <fo:block font-size="{f:hsize(5)}pt"
                    space-before="{f:hsize(5)*0.75}pt"
                    text-align="center"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:title/>
          </fo:block>
          <fo:block font-size="{f:hsize(4)}pt"
                    space-before="{f:hsize(4)*0.75}pt"
                    text-align="center"
                    text-style="italic"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:subtitle/>
          </fo:block>
        </fo:block>
      </recto>
    </templates>

    <templates name="book">
      <recto>
        <fo:block text-align="center"
                  font-family="{$title.fontset}"
                  font-weight="bold">
          <fo:block font-size="{f:hsize(5)}pt"
                    space-before="{f:hsize(5)*0.75}pt">
            <db:title/>
          </fo:block>
          <fo:block font-size="{f:hsize(4)}pt"
                    space-before="{f:hsize(4)*0.75}pt">
            <db:subtitle/>
          </fo:block>
          <fo:block font-size="{f:hsize(1)}pt"
                    keep-with-next.within-column="always"
                    space-before="2in">
            <fo:block>
              <db:author/>
            </fo:block>
            <fo:block>
              <db:authorgroup/>
            </fo:block>
          </fo:block>
        </fo:block>
      </recto>

      <verso>
        <fo:block font-family="{$body.fontset}">
          <fo:block font-size="{f:hsize(2)}pt"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:title/>
          </fo:block>
          <fo:block>
            <db:author/>
          </fo:block>
          <fo:block>
            <db:authorgroup/>
          </fo:block>
          <fo:block>
            <db:othercredit/>
          </fo:block>
          <fo:block space-before="0.5em">
            <db:releaseinfo/>
          </fo:block>
          <fo:block space-before="1em">
            <db:pubdate/>
          </fo:block>
          <fo:block>
            <db:copyright/>
          </fo:block>
          <fo:block>
            <db:abstract/>
          </fo:block>
          <fo:block font-size="8pt">
            <db:legalnotice/>
          </fo:block>
        </fo:block>
      </verso>

      <before-recto/>
      <before-verso/>
      <separator>
        <fo:block break-after="page"/>
      </separator>
    </templates>

    <templates name="dedication preface chapter appendix colophon">
      <titlepage>
        <fo:block>
          <fo:block font-size="{f:hsize(5)}pt"
                    margin-left="{$title.margin.left}"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:title/>
          </fo:block>
          <fo:block font-family="{$title.fontset}">
            <db:subtitle/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="article">
      <titlepage>
        <fo:block font-family="{$title.fontset}" text-align="center">
          <fo:block font-size="{f:hsize(5)}pt">
            <db:title/>
          </fo:block>
          <fo:block>
            <db:authorgroup/>
          </fo:block>
          <fo:block>
            <db:author/>
          </fo:block>
          <fo:block>
            <db:abstract/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="article/appendix">
      <titlepage>
        <fo:block space-before="1.5em">
          <fo:block font-size="{f:hsize(4)}pt"
                    margin-left="{$title.margin.left}"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:title/>
          </fo:block>
          <fo:block font-family="{$title.fontset}">
            <db:subtitle/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="section sect1 sect2 sect3 sect4 sect5
                     refsection refsect1 refsect2 refsect3">
      <titlepage>
        <fo:block space-before="1.5em">
          <fo:block font-family="{$title.fontset}"
                    margin-left="{$title.margin.left}">
            <db:title/>
          </fo:block>
          <fo:block font-family="{$title.fontset}">
            <db:subtitle/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="itemizedlist orderedlist variablelist">
      <titlepage>
        <fo:block>
          <fo:block xsl:use-attribute-sets="list.title.properties">
            <db:title/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="abstract">
      <titlepage>
        <fo:block>
          <fo:block xsl:use-attribute-sets="list.title.properties">
            <db:title/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>
  </templates-list>
</xsl:template>

<!-- ============================================================ -->
<!--  Mechanics below. You're not expected to change these.       -->
<!-- ============================================================ -->

<xsl:template name="t:titlepage">
  <xsl:param name="node" select="."/>

  <xsl:variable name="titlepage-content"
                select="(($node/db:title,$node/db:info/db:title,$ghost:title)[1],
                         ($node/db:subtitle,$node/db:info/db:subtitle,$ghost:subtitle)[1],
                         ($node/db:titleabbrev,$node/db:info/db:titleabbrev,$ghost:titleabbrev)[1],
                         $node/db:info/*[not(self::db:title) and not(self::db:subtitle)
                                         and not(self::db:titleabbrev)])"/>

  <xsl:variable name="templates" select="fp:titlepage-templates($node)"/>

  <!--
  <xsl:message>
    <xsl:value-of select="local-name(.)"/> = <xsl:value-of select="$templates/@name"/>
  </xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="$templates/tmpl:recto">
      <xsl:call-template name="tp:titlepage">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="template" select="$templates/tmpl:before-recto"/>
        <xsl:with-param name="content" select="$titlepage-content"/>
        <xsl:with-param name="mode" select="'before-recto'"/>
      </xsl:call-template>

      <xsl:call-template name="tp:titlepage">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="template" select="$templates/tmpl:recto"/>
        <xsl:with-param name="content" select="$titlepage-content"/>
        <xsl:with-param name="mode" select="'recto'"/>
      </xsl:call-template>

      <xsl:if test="$templates/tmpl:verso">
        <xsl:call-template name="tp:titlepage">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="template" select="$templates/tmpl:separator"/>
          <xsl:with-param name="content" select="$titlepage-content"/>
          <xsl:with-param name="mode" select="'separator'"/>
        </xsl:call-template>
        <xsl:call-template name="tp:titlepage">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="template" select="$templates/tmpl:before-verso"/>
          <xsl:with-param name="content" select="$titlepage-content"/>
          <xsl:with-param name="mode" select="'before-verso'"/>
        </xsl:call-template>
        <xsl:call-template name="tp:titlepage">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="template" select="$templates/tmpl:verso"/>
          <xsl:with-param name="content" select="$titlepage-content"/>
          <xsl:with-param name="mode" select="'verso'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$templates/tmpl:titlepage">
      <xsl:call-template name="tp:titlepage">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="template" select="$templates/tmpl:titlepage"/>
        <xsl:with-param name="content" select="$titlepage-content"/>
        <xsl:with-param name="mode" select="'titlepage'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>No titlepage template for <xsl:value-of select="node-name($node)"/>.</xsl:message>
      <xsl:variable name="default-template" as="element()">
        <tmpl:titlepage>
          <fo:block>
            <db:title/>
          </fo:block>
        </tmpl:titlepage>
      </xsl:variable>
      <xsl:call-template name="tp:titlepage">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="template" select="$default-template"/>
        <xsl:with-param name="content" select="$titlepage-content"/>
        <xsl:with-param name="mode" select="'default'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:variable name="titlepage-templates" as="element()">
  <xsl:variable name="user" as="element(tmpl:templates-list)?">
    <xsl:call-template name="t:user-titlepage-templates"/>
  </xsl:variable>
  <xsl:variable name="system" as="element(tmpl:templates-list)">
    <xsl:call-template name="t:titlepage-templates"/>
  </xsl:variable>

  <tmpl:titlepage-templates>
    <tmpl:user-templates>
      <xsl:sequence select="$user/*"/>
    </tmpl:user-templates>
    <tmpl:system-templates>
      <xsl:sequence select="$system/*"/>
    </tmpl:system-templates>
  </tmpl:titlepage-templates>
</xsl:variable>

<xsl:variable name="ghost:title" as="element(db:title)">
  <db:title ghost:generated="true"/>
</xsl:variable>

<xsl:variable name="ghost:subtitle" as="element(db:subtitle)">
  <db:subtitle ghost:generated="true"/>
</xsl:variable>

<xsl:variable name="ghost:titleabbrev" as="element(db:titleabbrev)">
  <db:titleabbrev ghost:generated="true"/>
</xsl:variable>

<!-- ============================================================ -->

<xsl:function name="fp:matching-template" as="xs:boolean">
  <xsl:param name="templates" as="element(tmpl:templates)"/>
  <xsl:param name="node" as="element()"/>

  <xsl:variable name="names" select="tokenize($templates/@name, '\s+')"/>

  <xsl:choose>
    <xsl:when test="$templates/@namespace and $templates/@namespace != namespace-uri($node)">
      <xsl:value-of select="false()"/>
    </xsl:when>
    <xsl:when test="empty($templates/@namespace) and namespace-uri($node) != 'http://docbook.org/ns/docbook'">
      <xsl:value-of select="false()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="local-name($node) = $names"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="fp:matching-template" as="xs:boolean">
  <xsl:param name="templates" as="element(tmpl:templates)"/>
  <xsl:param name="node" as="element()"/>
  <xsl:param name="path" as="xs:string"/>

  <xsl:variable name="names" select="tokenize($templates/@name, '\s+')"/>

  <xsl:choose>
    <xsl:when test="$templates/@namespace and $templates/@namespace != namespace-uri($node)">
      <xsl:value-of select="false()"/>
    </xsl:when>
    <xsl:when test="empty($templates/@namespace) and namespace-uri($node) != 'http://docbook.org/ns/docbook'">
      <xsl:value-of select="false()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$path = $names"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="fp:titlepage-templates" as="element(tmpl:templates)?">
  <xsl:param name="node" as="element()"/>

  <xsl:variable name="path" as="xs:string*">
    <xsl:for-each select="($node/ancestor-or-self::*)">
      <xsl:value-of select="local-name(.)"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="templates"
                select="fp:titlepage-templates($node, $path,
                        $titlepage-templates/tmpl:user-templates/*)"/>

  <xsl:choose>
    <xsl:when test="empty($templates)">
      <xsl:sequence select="fp:titlepage-templates($node, $path,
                            $titlepage-templates/tmpl:system-templates/*)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$templates"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="fp:titlepage-templates" as="element(tmpl:templates)?">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="path" as="xs:string+"/>
  <xsl:param name="templates-list" as="element(tmpl:templates)*"/>

  <xsl:variable name="pathstr" select="string-join($path, '/')"/>
  <xsl:variable name="templates"
                select="($templates-list[fp:matching-template(.,$node,$pathstr)])[1]"/>

  <xsl:choose>
    <xsl:when test="exists($templates)">
      <xsl:sequence select="$templates"/>
    </xsl:when>
    <xsl:when test="count($path) &lt;= 1">
      <xsl:sequence select="()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="fp:titlepage-templates($node, $path[position() &gt; 1], $templates-list)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>


<xsl:template name="tp:titlepage">
  <xsl:param name="node" required="yes"/>
  <xsl:param name="template" required="yes"/>
  <xsl:param name="content" required="yes"/>
  <xsl:param name="mode" required="yes"/>

  <xsl:choose>
    <xsl:when test="empty($template)"/>
    <xsl:when test="$template//db:*">
      <xsl:apply-templates select="$template/node()" mode="m:titlepage-template">
        <xsl:with-param name="context" select="$node"/>
        <xsl:with-param name="content" select="$content"/>
        <xsl:with-param name="mode"    select="$mode"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$template/node()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:*" priority="100" mode="m:titlepage-template">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="content" as="element()*" required="yes"/>
  <xsl:param name="mode"    as="xs:string" required="yes"/>

  <xsl:apply-templates select="$content[node-name(.) = node-name(current())]"
                       mode="m:titlepage-content">
    <xsl:with-param name="context" select="$context"/>
    <xsl:with-param name="template" select="."/>
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-template">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="content" as="element()*" required="yes"/>
  <xsl:param name="mode"    as="xs:string" required="yes"/>

  <xsl:variable name="result" as="element()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="m:titlepage-template">
        <xsl:with-param name="context"  select="$context"/>
        <xsl:with-param name="content" select="$content"/>
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:variable>

  <xsl:if test="string($result) != '' or count($result//fo:block) != count($result//*)">
    <xsl:sequence select="$result"/>
  </xsl:if>
</xsl:template>

<xsl:template match="@*" mode="m:titlepage-template">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="content" as="element()*" required="yes"/>
  <xsl:param name="mode"    as="xs:string" required="yes"/>
  <xsl:copy/>
</xsl:template>

<xsl:template match="text()|processing-instruction()|comment()" mode="m:titlepage-template">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="content" as="element()*" required="yes"/>
  <xsl:param name="mode"    as="xs:string" required="yes"/>
  <xsl:copy/>
</xsl:template>

<xsl:template name="tp:dispatch-without-content">
  <xsl:param name="node" as="element()" required="yes"/>
  <xsl:param name="mode" as="xs:string" required="yes"/>

  <xsl:choose>
    <xsl:when test="$mode = 'before-recto'">
      <xsl:apply-templates select="$node" mode="m:titlepage-before-recto-mode"/>
    </xsl:when>
    <xsl:when test="$mode = 'recto'">
      <xsl:apply-templates select="$node" mode="m:titlepage-recto-mode"/>
    </xsl:when>
    <xsl:when test="$mode = 'separator'">
      <xsl:apply-templates select="$node" mode="m:titlepage-separator-mode"/>
    </xsl:when>
    <xsl:when test="$mode = 'before-verso'">
      <xsl:apply-templates select="$node" mode="m:titlepage-before-verso-mode"/>
    </xsl:when>
    <xsl:when test="$mode = 'verso'">
      <xsl:apply-templates select="$node" mode="m:titlepage-verso-mode"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$node" mode="m:titlepage-mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:title[@ghost:generated='true']" mode="m:titlepage-content">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="template" as="element()" required="yes"/>
  <xsl:param name="mode" as="xs:string" required="yes"/>

  <xsl:if test="$context/self::db:bibliography
                or $context/self::db:abstract
                or $context/self::db:preface
                or $context/self::db:dedication
                or $context/self::db:glossary
                or $context/self::db:index">
    <xsl:variable name="gentitle" as="element(db:title)">
      <db:title>
        <xsl:apply-templates select="$context" mode="m:object-title-markup"/>
      </db:title>
    </xsl:variable>

    <xsl:call-template name="tp:dispatch-without-content">
      <xsl:with-param name="node" select="$gentitle"/>
      <xsl:with-param name="mode" select="$mode"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="db:subtitle[@ghost:generated='true']" mode="m:titlepage-content">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="template" as="element()" required="yes"/>
  <xsl:param name="mode" as="xs:string" required="yes"/>
  <!-- nop; there are no generated subtitles -->
</xsl:template>

<xsl:template match="db:titleabbrev[@ghost:generated='true']" mode="m:titlepage-content">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="template" as="element()" required="yes"/>
  <xsl:param name="mode" as="xs:string" required="yes"/>
  <!-- nop; there are no generated titleabbrevs -->
</xsl:template>

<xsl:template match="db:title" mode="m:titlepage-content">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="template" as="element()" required="yes"/>
  <xsl:param name="mode" as="xs:string" required="yes"/>

  <xsl:call-template name="tp:dispatch-without-content">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:subtitle" mode="m:titlepage-content">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="template" as="element()" required="yes"/>
  <xsl:param name="mode" as="xs:string" required="yes"/>

  <xsl:call-template name="tp:dispatch-without-content">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:titleabbrev" mode="m:titlepage-content">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="template" as="element()" required="yes"/>
  <xsl:param name="mode" as="xs:string" required="yes"/>

  <xsl:call-template name="tp:dispatch-without-content">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-content">
  <xsl:param name="context" as="element()" required="yes"/>
  <xsl:param name="template" as="element()" required="yes"/>
  <xsl:param name="mode" as="xs:string" required="yes"/>

  <xsl:call-template name="tp:dispatch-without-content">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="mode" select="$mode"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
