<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:pxp="http://exproc.org/proposed/steps"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                name="main" version="1.0">
<p:input port="source" sequence="true" primary="true"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true" primary="true"/>
<p:serialization port="result" method="text" encoding="utf-8"/>

<p:option name="format" select="'foprint'"/>
<p:option name="style" select="'docbook'"/>
<p:option name="preprocess" select="''"/>
<p:option name="postprocess" select="''"/>
<p:option name="pdf" select="'/tmp/docbook.pdf'"/>
<p:option name="css" select="''"/>

<p:import href="docbook.xpl"/>

<dbp:docbook return-secondary="false">
  <p:with-option name="format" select="$format"/>
  <p:with-option name="style" select="$style"/>
  <p:with-option name="preprocess" select="$preprocess"/>
  <p:with-option name="postprocess" select="$postprocess"/>
  <p:with-option name="pdf" select="$pdf"/>
  <p:with-option name="css" select="$css"/>
</dbp:docbook>

</p:declare-step>
