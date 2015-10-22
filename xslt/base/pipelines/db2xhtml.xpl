<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:pxp="http://exproc.org/proposed/steps"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                name="main" version="1.0">
<p:input port="source" sequence="true" primary="true"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true" primary="true"/>
<p:serialization port="result" method="xhtml" encoding="utf-8" indent="false"/>

<p:option name="style" select="'docbook'"/>
<p:option name="preprocess" select="''"/>
<p:option name="postprocess" select="''"/>

<p:import href="docbook.xpl"/>

<dbp:docbook format="xhtml" return-secondary="false">
  <p:with-option name="style" select="$style"/>
  <p:with-option name="preprocess" select="$preprocess"/>
  <p:with-option name="postprocess" select="$postprocess"/>
</dbp:docbook>

</p:declare-step>
