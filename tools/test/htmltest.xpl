<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                exclude-inline-prefixes="cx"
                name="main">
<p:input port="parameters" kind="parameter"/>

<p:option name="name" required="true"/>

<!-- N.B. The path names are *relative to this pipeline document*.   -->
<!-- If you provide different paths as runtime options, make sure    -->
<!-- they are absolute, or make sure that they're correctly relative -->
<!-- to the location of this pipeline document.                      -->

<p:option name="srcdir" select="'../../src/test/xml/'"/>
<p:option name="resultdir" select="'../../build/test/result-html/'"/>
<p:option name="actualdir" select="'../../build/test/actual-html/'"/>
<p:option name="expecteddir" select="'../../src/test/expected-html/'"/>
<p:option name="diffdir" select="'../../build/test/diff-html/'"/>
<p:option name="ignore-head" select="0"/>
<p:option name="ignore-prism" select="0"/>
<p:option name="preprocess" select="''"/>
<p:option name="postprocess" select="''"/>

<p:import href="../../build/xslt/base/pipelines/docbook.xpl"/>

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
  <p:with-option name="include-filter" select="concat($name, '.xml')"/>
  <p:with-option name="path" select="resolve-uri($srcdir)"/>
</p:directory-list>

<p:for-each name="loop">
  <p:iteration-source select="/c:directory/c:file"/>

  <p:load>
    <p:with-option name="href"
                   select="resolve-uri(/*/@name, base-uri(/*))"/>
  </p:load>

  <dbp:docbook>
    <p:input port="parameters">
      <p:pipe step="main" port="parameters"/>
    </p:input>
    <p:with-param name="resource.root" select="'../resources/'"/>
    <p:with-param name="bibliography.collection"
                  select="'../../test/resources/bibliography.xml'"/>
    <p:with-param name="profile.os" select="'win'"/>
    <p:with-option name="style"
                   select="if (/*/db:info/p:style)
                           then string(/*/db:info/p:style)
                           else 'docbook'"/>
    <p:with-option name="preprocess" select="$preprocess"/>
    <p:with-option name="postprocess" select="$postprocess"/>
  </dbp:docbook>

  <p:xslt name="docbook">
    <p:input port="stylesheet">
      <p:document href="patch.xsl"/>
    </p:input>
  </p:xslt>

  <p:store method="xhtml">
    <p:with-option name="href"
                   select="replace(resolve-uri(/*/@name,
                                     resolve-uri($actualdir)),
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
                                         resolve-uri($expecteddir)),
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
    <p:with-param name="ignore-head" select="$ignore-head"/>
    <p:with-param name="ignore-prism" select="$ignore-prism"/>
  </p:xslt>

  <p:xslt name="Bnorm">
    <p:input port="source">
      <p:pipe step="docbook" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="normalize.xsl"/>
    </p:input>
    <p:with-param name="ignore-head" select="$ignore-head"/>
    <p:with-param name="ignore-prism" select="$ignore-prism"/>
  </p:xslt>

  <cx:pretty-print name="A">
    <p:input port="source">
      <p:pipe step="Anorm" port="result"/>
    </p:input>
    <!-- <p:log port="result" href="/tmp/A.xml"/> -->
  </cx:pretty-print>

  <cx:pretty-print name="B">
    <p:input port="source">
      <p:pipe step="Bnorm" port="result"/>
    </p:input>
    <!-- <p:log port="result" href="/tmp/B.xml"/> -->
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
                              resolve-uri($diffdir))">
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

  <p:add-attribute match="/*" attribute-name="p:style"
                   xmlns:h="http://www.w3.org/1999/xhtml">
    <p:with-option name="attribute-value"
                   select="if (/h:html/h:head/h:link[@rel='stylesheet'
                               and contains(@href,'publishers.css')])
                           then 'publishers'
                           else if (/h:html/h:head/h:link[@rel='stylesheet'
                                    and contains(@href,'slides.css')])
                                then 'slides'
                                else ''">
      <p:pipe step="docbook" port="result"/>
    </p:with-option>
  </p:add-attribute>

  <p:store method="xhtml">
    <p:with-option name="href"
                   select="replace(resolve-uri(/*/@name,
                                     resolve-uri($resultdir)),
                                   '.xml$', '.html')">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:store>
</p:for-each>

</p:declare-step>
