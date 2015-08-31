<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:pxp="http://exproc.org/proposed/steps"
                name="main" version="1.0"
                exclude-inline-prefixes="db dbp pxp"
                type="dbp:docbook">
<p:input port="source" sequence="true" primary="true"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true" primary="true">
  <p:pipe step="process" port="result"/>
</p:output>
<p:output port="secondary" sequence="true" primary="false">
  <p:pipe step="process" port="secondary"/>
</p:output>
<p:serialization port="result" method="xhtml" encoding="utf-8" indent="false"/>

<p:option name="format" select="'html'"/>
<p:option name="style" select="'docbook'"/>
<p:option name="postprocess" select="''"/>
<p:option name="return-secondary" select="'false'"/>
<p:option name="pdf" select="'/tmp/docbook.pdf'"/>
<p:option name="css" select="''"/>

<p:import href="db-xhtml.xpl"/>
<p:import href="db-cssprint.xpl"/>
<p:import href="db-foprint.xpl"/>

<p:choose name="process">
  <p:when test="$format = 'xhtml' or $format = 'html'">
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true" primary="false">
      <p:pipe step="html" port="secondary"/>
    </p:output>
    <dbp:docbook-xhtml name="html">
      <p:input port="source">
        <p:pipe step="main" port="source"/>
      </p:input>
      <p:with-option name="style" select="$style"/>
      <p:with-option name="postprocess" select="$postprocess"/>
      <p:with-option name="return-secondary" select="$return-secondary"/>
    </dbp:docbook-xhtml>
  </p:when>

  <p:when test="$format = 'cssprint' or $format = 'css' or $format = 'print'">
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true" primary="false">
      <p:pipe step="css" port="secondary"/>
    </p:output>
    <dbp:docbook-css-print name="css">
      <p:input port="source">
        <p:pipe step="main" port="source"/>
      </p:input>
      <p:with-option name="style" select="$style"/>
      <p:with-option name="postprocess" select="$postprocess"/>
      <p:with-option name="pdf" select="$pdf"/>
      <p:with-option name="css" select="$css"/>
    </dbp:docbook-css-print>
  </p:when>

  <p:when test="$format = 'foprint' or $format = 'fo'">
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true" primary="false">
      <p:pipe step="fo" port="secondary"/>
    </p:output>
    <dbp:docbook-fo-print name="fo">
      <p:input port="source">
        <p:pipe step="main" port="source"/>
      </p:input>
      <p:with-option name="style" select="$style"/>
      <p:with-option name="postprocess" select="$postprocess"/>
      <p:with-option name="pdf" select="$pdf"/>
    </dbp:docbook-fo-print>
  </p:when>

  <p:otherwise>
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true" primary="false">
      <p:empty/>
    </p:output>
    <p:identity>
      <p:input port="source">
        <p:inline><err>Error. Bad format requested.</err></p:inline>
      </p:input>
    </p:identity>
  </p:otherwise>
</p:choose>
</p:declare-step>
