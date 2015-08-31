<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:pxp="http://exproc.org/proposed/steps"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                name="main" version="1.0"
                exclude-inline-prefixes="c cx db dbp pxp"
                type="dbp:docbook-fo-print">
<p:input port="source" sequence="true" primary="true"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true" primary="true">
  <p:pipe step="process-secondary" port="result"/>
</p:output>
<p:output port="secondary" sequence="true" primary="false">
  <p:empty/>
</p:output>
<p:serialization port="result" method="text" encoding="utf-8"/>

<p:option name="style" select="'docbook'"/>
<p:option name="postprocess" select="''"/>
<p:option name="return-secondary" select="'false'"/>
<p:option name="pdf" select="'/tmp/db-foprint.pdf'"/>

<!-- Ideally, this pipeline wouldn't rely on an XML Calabash extensions,
     but it's a lot more convenient this way. See generic.xpl for a
     version with no processor-specific extensions.
-->

<p:declare-step type="pxp:set-base-uri">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:option name="uri" required="true"/>
</p:declare-step>

<p:declare-step type="cx:message">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:xslt name="logical-structure">
  <p:input port="stylesheet">
    <p:document href="../preprocess/00-logstruct.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/00-logstruct.xml"/> -->
</p:xslt>

<p:choose name="db4to5">
  <p:when test="/db:*">
    <p:identity/>
  </p:when>
  <p:otherwise>
    <p:xslt name="run10">
      <p:input port="stylesheet">
        <p:document href="../preprocess/10-db4to5.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
      <!-- <p:log port="result" href="/tmp/10-db4to5.xml"/> -->
    </p:xslt>
  </p:otherwise>
</p:choose>

<pxp:set-base-uri>
  <p:with-option name="uri" select="base-uri(/)">
    <p:pipe step="main" port="source"/>
  </p:with-option>
  <!-- <p:log port="result" href="/tmp/s-b-u-1.xml"/> -->
</pxp:set-base-uri>

<p:xslt name="transclude">
  <p:input port="stylesheet">
    <p:document href="../preprocess/20-transclude.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/20-transclude.xml"/> -->
</p:xslt>

<p:xslt name="document-parameters">
  <p:input port="stylesheet">
    <p:document href="document-params.xsl"/>
  </p:input>
</p:xslt>

<!-- combine them with the pipeline parameters -->
<p:parameters name="all-parameters">
  <p:input port="parameters">
    <p:pipe step="main" port="parameters"/>
    <p:pipe step="document-parameters" port="result"/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/all-params.xml"/> -->
</p:parameters>

<p:xslt name="profile">
  <p:input port="source">
    <p:pipe step="transclude" port="result"/>
  </p:input>
  <p:input port="stylesheet">
    <p:document href="../preprocess/30-profile.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:pipe step="all-parameters" port="result"/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/30-profile.xml"/> -->
</p:xslt>

<p:xslt name="schemaext">
  <p:input port="stylesheet">
    <p:document href="../preprocess/40-schemaext.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/40-schemaext.xml"/> -->
</p:xslt>

<!-- Let's give up on this
<p:choose name="verbatim">
  <p:when test="$syntax-highlighter = 0">
    <p:xslt name="run45">
      <p:input port="stylesheet">
        <p:document href="../preprocess/45-verbatim.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:pipe step="all-parameters" port="result"/>
      </p:input>
      <p:log port="result" href="/tmp/45-verbatim.xml"/>
    </p:xslt>
  </p:when>
  <p:otherwise>
    <p:identity/>
  </p:otherwise>
</p:choose>
-->

<pxp:set-base-uri>
  <p:with-option name="uri" select="base-uri(/)">
    <p:pipe step="main" port="source"/>
  </p:with-option>
  <!-- <p:log port="result" href="/tmp/s-b-u-2.xml"/> -->
</pxp:set-base-uri>

<p:xslt name="normalize">
  <p:input port="stylesheet">
    <p:document href="../preprocess/50-normalize.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:pipe step="all-parameters" port="result"/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/50-normalize.xml"/> -->
</p:xslt>

<p:xslt name="expand-linkbases">
  <p:input port="stylesheet">
    <p:document href="../xlink/xlinklb.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/lb.xml"/> -->
</p:xslt>

<p:xslt name="inline-xlinks">
  <p:input port="stylesheet">
    <p:document href="../xlink/xlinkex.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/ex.xml"/> -->
</p:xslt>

<!-- There used to be a step here that deleted the ghost: attributes
     inserted earlier. You can't do that, some of the final-pass processing,
     particularly for tables and verbatim environments, relies on the
     presence of computed ghost: attributes.
-->

<p:xslt name="preprocessed">
  <p:input port="stylesheet">
    <p:pipe step="inline-xlinks" port="result"/>
  </p:input>
  <p:input port="source">
    <p:pipe step="expand-linkbases" port="result"/>
  </p:input>
  <p:input port="parameters">
    <p:pipe step="all-parameters" port="result"/>
  </p:input>
  <!--  <p:log port="result" href="/tmp/doc.xml"/> -->
</p:xslt>

<p:choose name="final-pass">
  <p:when test="$style = 'docbook'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="fo-docbook" port="secondary"/>
    </p:output>
    <p:xslt name="fo-docbook">
      <p:input port="stylesheet">
        <p:document href="../fo/final-pass.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:pipe step="all-parameters" port="result"/>
      </p:input>
    </p:xslt>
  </p:when>
  <p:when test="$style = 'slides'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="fo-slides" port="secondary"/>
    </p:output>
    <p:xslt name="fo-slides">
      <p:input port="stylesheet">
        <p:document href="../../slides/fo/plain.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:pipe step="all-parameters" port="result"/>
      </p:input>
    </p:xslt>
  </p:when>
  <p:otherwise xmlns:exf="http://exproc.org/standard/functions">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="fo-user-cwd" port="secondary"/>
    </p:output>
    <!-- This relies on an XML Calabash extension function as a user
         convenience. I'm open to suggestions... -->
    <p:load name="load-style">
      <p:with-option name="href" select="resolve-uri($style, exf:cwd())"/>
    </p:load>
    <p:xslt name="fo-user-cwd">
      <p:input port="source">
        <p:pipe step="preprocessed" port="result"/>
      </p:input>
      <p:input port="stylesheet">
        <p:pipe step="load-style" port="result"/>
      </p:input>
      <p:input port="parameters">
        <p:pipe step="all-parameters" port="result"/>
      </p:input>
    </p:xslt>
  </p:otherwise>
</p:choose>

<p:choose name="postprocess">
  <p:when test="$postprocess = ''">
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="secondary" port="result"/>
    </p:output>
    <p:identity name="secondary">
      <p:input port="source">
        <p:pipe step="final-pass" port="secondary"/>
      </p:input>
    </p:identity>
    <p:identity>
      <p:input port="source">
        <p:pipe step="final-pass" port="result"/>
      </p:input>
    </p:identity>
  </p:when>
  <p:otherwise xmlns:exf="http://exproc.org/standard/functions">
    <p:output port="result" sequence="true" primary="true">
      <p:pipe step="primary" port="result"/>
    </p:output>
    <p:output port="secondary" sequence="true">
      <p:pipe step="secondary" port="result"/>
    </p:output>

    <p:load name="load-style">
      <p:with-option name="href" select="resolve-uri($postprocess, exf:cwd())"/>
    </p:load>

    <p:xslt name="primary">
      <p:input port="stylesheet">
        <p:pipe step="load-style" port="result"/>
      </p:input>
      <p:input port="source">
        <p:pipe step="final-pass" port="result"/>
      </p:input>
    </p:xslt>

    <p:for-each name="secondary">
      <p:iteration-source>
        <p:pipe step="final-pass" port="secondary"/>
      </p:iteration-source>
      <p:output port="result"/>

      <p:xslt>
        <p:input port="stylesheet">
          <p:pipe step="load-style" port="result"/>
        </p:input>
      </p:xslt>
    </p:for-each>
  </p:otherwise>
</p:choose>

<p:xsl-formatter name="process-secondary" content-type="application/pdf">
  <p:input port="source">
    <p:pipe step="postprocess" port="result"/>
  </p:input>
  <!-- probably ought to be different set... -->
  <p:input port="parameters">
    <p:pipe step="all-parameters" port="result"/>
  </p:input>
  <p:with-option xmlns:exf="http://exproc.org/standard/functions"
                 name="href" select="resolve-uri($pdf, exf:cwd())"/>
</p:xsl-formatter>

</p:declare-step>
