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
<p:serialization port="result" method="xml" encoding="utf-8" indent="false"/>

<p:option name="format" select="'foprint'"/>
<p:option name="style" select="'docbook'"/>
<p:option name="postprocess" select="''"/>
<p:option name="return-secondary" select="'false'"/>
<p:option name="pdf" select="'/tmp/db-foprint.pdf'"/>

<p:declare-step type="cx:message">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:choose name="final-pass">
  <p:when test="$style = 'docbook' or $style = 'publishers'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="fo-docbook" port="secondary"/>
    </p:output>
    <p:xslt name="fo-docbook">
      <p:input port="stylesheet">
        <p:document href="../fo/final-pass.xsl"/>
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
        <p:pipe step="main" port="source"/>
      </p:input>
      <p:input port="stylesheet">
        <p:pipe step="load-style" port="result"/>
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

<p:choose name="process-secondary">
  <p:when test="$format = 'fo'">
    <p:output port="result"/>
    <p:identity/>
  </p:when>
  <p:otherwise>
    <p:output port="result">
      <p:pipe step="format" port="result"/>
    </p:output>
    <p:xsl-formatter name="format" content-type="application/pdf">
      <p:input port="source">
        <p:pipe step="postprocess" port="result"/>
      </p:input>
      <p:with-option xmlns:exf="http://exproc.org/standard/functions"
                     name="href" select="resolve-uri($pdf, exf:cwd())"/>
    </p:xsl-formatter>
  </p:otherwise>
</p:choose>

</p:declare-step>
