<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:deltaxml="http://www.deltaxml.com/ns/well-formed-delta-v1"
                xmlns:dxa="http://www.deltaxml.com/ns/non-namespaced-attribute"
                xmlns:dxx="http://www.deltaxml.com/ns/xml-namespaced-attribute"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:f="http://nwalsh.com/ns/xslt-functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xs html deltaxml dxa dxx f"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:param name="testname"/>

<xsl:template match="/">
  <xsl:variable name="A" as="element()">
    <pre class="show-diff">
      <xsl:apply-templates select="/" mode="prettyprint">
        <xsl:with-param name="version" select="'A'"/>
      </xsl:apply-templates>
    </pre>
  </xsl:variable>

  <xsl:variable name="B" as="element()">
    <pre class="show-diff">
      <xsl:apply-templates select="/" mode="prettyprint">
        <xsl:with-param name="version" select="'B'"/>
      </xsl:apply-templates>
    </pre>
  </xsl:variable>

  <xsl:variable name="adiff"
                select="count($A//html:span[contains(@class,'del')])
                        + count($A//html:span[contains(@class,'txtchg')])
                        + count($A//html:span[contains(@class,'attchg')])"/>
  <xsl:variable name="bdiff"
                select="count($B//html:span[contains(@class,'add')])
                        + count($B//html:span[contains(@class,'txtchg')])
                        + count($B//html:span[contains(@class,'attchg')])"/>

<!--
  <xsl:message><xsl:sequence select="$A"/></xsl:message>
  <xsl:message><xsl:sequence select="$B"/></xsl:message>
  <xsl:message><xsl:sequence select="$adiff"/></xsl:message>
  <xsl:message><xsl:sequence select="$bdiff"/></xsl:message>
-->

  <html>
    <head>
      <title>Results for <xsl:value-of select="$testname"/></title>
      <link rel="stylesheet" type="text/css"
            href="../resources/css/default.css" />
      <script type="text/javascript"
              src="../resources/js/dbmodnizr.js"></script>

      <link rel="stylesheet" type="text/css"
            href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/start/jquery-ui.css"/>

      <link rel="stylesheet" type="text/css"
            href="../resources/css/prism.css" />
      <link rel="stylesheet" type="text/css"
            href="../resources/css/db-prism.css" />
      <link href="../resources/show-results.css" rel="stylesheet" type="text/css"/>
      <meta name="deltaxml"
            content="{if (/*/@deltaxml:version) then 'true' else 'false'}"/>
    </head>
    <body>
      <h1>
        <xsl:text>DocBook XSLT 2.0 Stylesheet output: </xsl:text>
        <xsl:value-of select="$testname"/>
      </h1>

      <xsl:variable name="html"
                    select="replace($testname, '.xml', '.html')"/>
      <xsl:variable name="ac-html"
                    select="concat('../actual/', $html)"/>
      <xsl:variable name="actual"
                    select="if (doc-available($ac-html))
                            then doc($ac-html)
                            else ()"/>

      <xsl:choose>
        <xsl:when test="$adiff = $bdiff and $adiff = 0
                        and /*/@deltaxml:version">
          <p>No changes.</p>
          <xsl:sequence select="$actual//html:body/node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="not(/*/@deltaxml:version)">
            <p>
              DeltaXML appears not to have been available; you will
              have to inspect the differences by hand.
            </p>
          </xsl:if>

          <table class="diffs">
            <tbody>
              <tr>
                <th>
                  <xsl:text>Expected </xsl:text>
                  <xsl:if test="/*/@deltaxml:version">
                    <xsl:text>(</xsl:text>
                    <span class="exdiff"><xsl:value-of select="$adiff"/></span>
                    <xsl:text> differences)</xsl:text>
                  </xsl:if>
                </th>
                <th>
                  <xsl:text>Actual </xsl:text>
                  <xsl:if test="/*/@deltaxml:version">
                    <xsl:text>(</xsl:text>
                    <span class="adiff"><xsl:value-of select="$bdiff"/></span>
                    <xsl:text> differences)</xsl:text>
                  </xsl:if>
                </th>
              </tr>

              <xsl:if test="/*/@deltaxml:version">
                <tr>
                  <td>
                    <xsl:sequence select="$A"/>
                  </td>
                  <td>
                    <xsl:sequence select="$B"/>
                  </td>
                </tr>
              </xsl:if>

              <tr>
                <td>
                  <em>The “current” CSS styling is applied
                  to the this entire document; the results in this
                  column may be anomalous. Also, image links are broken
                  in this column.</em>
                </td>
                <td>&#160;</td>
              </tr>
              <tr>
                <xsl:variable name="ex-html"
                              select="concat('../expected/', $html)"/>
                <xsl:variable name="expected"
                              select="if (doc-available($ex-html))
                                      then doc($ex-html)
                                      else ()"/>
                <td>
                  <xsl:sequence select="$expected//html:body/node()"/>
                </td>
                <td>
                  <xsl:sequence select="$actual//html:body/node()"/>
                </td>
              </tr>
            </tbody>
          </table>
        </xsl:otherwise>
      </xsl:choose>

      <h2>XML source</h2>
      <pre data-src="../src/{$testname}"/>
    </body>

    <script type="text/javascript"
            src="https://code.jquery.com/jquery-1.6.4.min.js"></script>
    <script type="text/javascript"
            src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
    <script type="text/javascript"
            src="../resources/js/annotation.js"></script>
    <script type="text/javascript"
            src="../resources/js/prism.js"></script>
  </html>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="/" mode="prettyprint">
  <xsl:param name="version" select="'A'"/>
  <xsl:apply-templates mode="prettyprint">
    <xsl:with-param name="version" select="$version"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*[@deltaxml:deltaV2]" mode="prettyprint"
              priority="100">
  <xsl:param name="version" required="yes"/>
  <xsl:choose>
    <xsl:when test="@deltaxml:deltaV2='A' and $version='B'"/>
    <xsl:when test="@deltaxml:deltaV2='B' and $version='A'"/>
    <xsl:otherwise>
      <xsl:next-match>
        <xsl:with-param name="version" select="$version"/>
      </xsl:next-match>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="deltaxml:attributes" mode="prettyprint">
  <xsl:param name="version" required="yes"/>
</xsl:template>

<xsl:template match="deltaxml:textGroup" mode="prettyprint">
  <xsl:param name="version" required="yes"/>
  <span class="diff txtchg">
    <xsl:value-of select="deltaxml:text[@deltaxml:deltaV2=$version]"/>
  </span>
</xsl:template>

<xsl:template match="element()" mode="prettyprint">
  <xsl:param name="version" required="no"/>

  <span class="{f:class(.)}">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="node-name(.)"/>
    <xsl:apply-templates select="deltaxml:attributes/*" mode="ppa">
      <xsl:with-param name="version" select="$version"/>
    </xsl:apply-templates>
    <xsl:for-each select="@* except @deltaxml:*">
      <xsl:sort select="local-name(.)" order="ascending"/>
      <xsl:text> </xsl:text>
      <span class="att">
        <xsl:value-of select="node-name(.)"/>
        <xsl:text>="</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
      </span>
    </xsl:for-each>

    <xsl:choose>
      <xsl:when test="empty(node())">
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="*">
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates select="node()" mode="prettyprint">
          <xsl:with-param name="version" select="$version"/>
        </xsl:apply-templates>
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="node-name(.)"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="count(node()) = count(text()) and not(*)">
        <xsl:text>&gt;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="node-name(.)"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates select="node()" mode="prettyprint">
          <xsl:with-param name="version" select="$version"/>
        </xsl:apply-templates>
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="node-name(.)"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()"
              mode="prettyprint">
  <xsl:copy/>
</xsl:template>

<xsl:template match="*" mode="ppa">
  <xsl:param name="version" required="yes"/>

  <xsl:text> </xsl:text>
  <span>
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="@deltaxml:deltaV2=$version">
          <xsl:text>att add</xsl:text>
        </xsl:when>
        <xsl:when test="@deltaxml:deltaV2 != 'A!=B'">
          <xsl:text>att del</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>att</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="self::dxa:*">
        <xsl:value-of select="local-name(.)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="node-name(.)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>="</xsl:text>
    <span>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@deltaxml:deltaV2
                          and @deltaxml:deltaV2 != 'A!=B'">
            <xsl:text>att</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="deltaxml:attributeValue[@deltaxml:deltaV2='A']
                              and deltaxml:attributeValue[@deltaxml:deltaV2='B']">
                <xsl:text>att attchg</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>att</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="deltaxml:attributeValue[@deltaxml:deltaV2=$version]"/>
    </span>
    <xsl:text>"</xsl:text>
  </span>
</xsl:template>

<xsl:function name="f:class">
  <xsl:param name="node" as="element()"/>
  <xsl:sequence select="f:class($node,'tag')"/>
</xsl:function>

<xsl:function name="f:class">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="base" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="$node/@deltaxml:deltaV2 = 'A'">
      <xsl:attribute name="class" select="concat($base,' diff del')"/>
    </xsl:when>
    <xsl:when test="$node/@deltaxml:deltaV2 = 'B'">
      <xsl:attribute name="class" select="concat($base,' diff add')"/>
    </xsl:when>
    <xsl:when test="$node/@deltaxml:deltaV2 = 'A!=B'">
      <xsl:attribute name="class" select="concat($base,' diff')"/>
    </xsl:when>
    <xsl:when test="$node/@deltaxml:deltaV2 = 'A=B'">
      <xsl:attribute name="class" select="concat($base,' nodiff')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="class" select="$base"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
