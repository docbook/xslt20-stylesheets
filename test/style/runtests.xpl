<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:exf="http://exproc.org/standard/functions"
                exclude-inline-prefixes="cx exf"
                name="main">
<p:input port="parameters" kind="parameter"/>

<p:option name="srcdir" select="'src/'"/>
<p:option name="resultdir" select="'result/'"/>
<p:option name="actualdir" select="'actual/'"/>
<p:option name="expecteddir" select="'expected/'"/>
<p:option name="diffdir" select="'diff/'"/>
<p:option name="include" select="'.*\.xml'"/>
<p:option name="ignore-head" select="0"/>
<p:option name="ignore-prism" select="0"/>

<p:import href="../../xslt/base/pipelines/docbook.xpl"/>

<p:declare-step type="cx:message" xmlns:cx="http://xmlcalabash.com/ns/extensions">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:declare-step type="cx:delta-xml">
  <p:input port="source"/>
  <p:input port="alternate"/>
  <p:input port="dxp"/>
  <p:output port="result"/>
</p:declare-step>

<p:declare-step type="cx:pretty-print">
   <p:input port="source"/>
   <p:output port="result"/>
</p:declare-step>

<p:directory-list>
  <p:with-option name="include-filter" select="$include"/>
  <p:with-option name="path" select="resolve-uri($srcdir, exf:cwd())"/>
</p:directory-list>

<!-- p:directory-list doesn't sort files; this stylesheet puts them
     in alphabetic order. It doesn't matter to the tests, but it
     makes the display easier to grok when they're running.
-->
<p:xslt>
  <p:input port="stylesheet">
    <p:inline>
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                      xmlns:c="http://www.w3.org/ns/xproc-step"
                      version="2.0">
        <xsl:template match="c:directory">
          <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*">
              <xsl:sort select="@name" order="ascending"/>
            </xsl:apply-templates>
          </xsl:copy>
        </xsl:template>
        <xsl:template match="element()">
          <xsl:copy>
            <xsl:apply-templates select="@*,node()"/>
          </xsl:copy>
        </xsl:template>
        <xsl:template match="attribute()|text()">
          <xsl:copy/>
        </xsl:template>
      </xsl:stylesheet>
    </p:inline>
  </p:input>
</p:xslt>

<p:for-each name="loop">
  <p:iteration-source select="/c:directory/c:file"/>

  <cx:message>
    <p:with-option name="message" select="concat('Processing ', /*/@name)"/>
  </cx:message>

  <p:load>
    <p:with-option name="href"
                   select="resolve-uri(/*/@name, base-uri(/*))"/>
  </p:load>

  <dbp:docbook>
    <p:with-param name="resource.root" select="'../../resources/base/'"/>
    <p:with-param name="bibliography.collection"
                  select="'../style/bibliography.xml'"/>
    <p:with-param name="profile.os" select="'win'"/>
  </dbp:docbook>

  <p:xslt name="docbook">
    <p:input port="stylesheet">
      <p:document href="patch.xsl"/>
    </p:input>
  </p:xslt>

  <p:store method="xhtml">
    <p:with-option name="href"
                   select="replace(resolve-uri(/*/@name,
                                     resolve-uri($actualdir, exf:cwd())),
                                   '.xml$', '.html')">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:store>

  <p:try name="expected">
    <p:group>
      <p:output port="result"/>
      <p:load>
        <p:with-option name="href"
                       select="replace(resolve-uri(/*/@name,
                                         resolve-uri($expecteddir, exf:cwd())),
                                       '.xml$', '.html')">
          <p:pipe step="loop" port="current"/>
        </p:with-option>
      </p:load>
    </p:group>
    <p:catch>
      <p:output port="result"/>
      <p:identity>
        <p:input port="source">
          <p:inline>
            <html xmlns="http://www.w3.org/1999/xhtml">
              <head>
                <title>Error</title>
              </head>
              <body>
                <p>No expected result exists.</p>
              </body>
            </html>
          </p:inline>
        </p:input>
      </p:identity>
    </p:catch>
  </p:try>

  <p:xslt name="Anorm">
    <p:input port="source">
      <p:pipe step="expected" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="normalize.xsl"/>
    </p:input>
    <p:with-param name="ignore-head" select="$ignore-head != 0"/>
    <p:with-param name="ignore-prism" select="$ignore-prism != 0"/>
  </p:xslt>

  <p:xslt name="Bnorm">
    <p:input port="source">
      <p:pipe step="docbook" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="normalize.xsl"/>
    </p:input>
    <p:with-param name="ignore-head" select="$ignore-head != 0"/>
    <p:with-param name="ignore-prism" select="$ignore-prism != 0"/>
  </p:xslt>

  <cx:pretty-print name="A">
    <p:input port="source">
      <p:pipe step="Anorm" port="result"/>
    </p:input>
  </cx:pretty-print>

  <cx:pretty-print name="B">
    <p:input port="source">
      <p:pipe step="Bnorm" port="result"/>
    </p:input>
  </cx:pretty-print>

  <p:choose name="diff">
    <p:when test="p:step-available('cx:delta-xml')">
      <p:output port="result"/>
      <cx:delta-xml>
        <p:input port="source">
          <p:pipe step="A" port="result"/>
        </p:input>
        <p:input port="alternate">
          <p:pipe step="B" port="result"/>
        </p:input>
        <p:input port="dxp">
          <p:inline>
            <comparatorPipeline>
              <outputProperties>
                <property name="indent" literalValue="no"/>
              </outputProperties>
              <outputFileExtension extension="xml"/>
              <comparatorFeatures>
                <feature name="http://deltaxml.com/api/feature/deltaV2"
                         literalValue="true"/>
                <feature name="http://deltaxml.com/api/feature/isFullDelta"
                         literalValue="true"/>
                <feature name="http://deltaxml.com/api/feature/enhancedMatch1"
                         literalValue="true"/>
              </comparatorFeatures>
            </comparatorPipeline>
          </p:inline>
        </p:input>
      </cx:delta-xml>
    </p:when>
    <p:otherwise>
      <p:output port="result"/>
      <p:identity>
        <p:input port="source">
          <p:pipe step="B" port="result"/>
        </p:input>
      </p:identity>
    </p:otherwise>
  </p:choose>

  <p:store method="xml">
    <p:with-option name="href"
                   select="resolve-uri(/*/@name,
                              resolve-uri($diffdir, exf:cwd()))">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:store>

  <p:xslt>
    <p:input port="source">
      <p:pipe step="diff" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="show-results.xsl"/>
    </p:input>
    <p:with-param name="testname" select="/*/@name">
      <p:pipe step="loop" port="current"/>
    </p:with-param>
  </p:xslt>

  <p:store method="xhtml">
    <p:with-option name="href"
                   select="replace(resolve-uri(/*/@name,
                                     resolve-uri($resultdir, exf:cwd())),
                                   '.xml$', '.html')">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:store>
</p:for-each>

</p:declare-step>
