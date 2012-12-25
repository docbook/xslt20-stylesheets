<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                name="main">
<p:input port="source"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>
<p:serialization port="result" method="xhtml" encoding="utf-8" indent="false"/>

<p:xslt name="expand-linkbases">
  <p:input port="stylesheet">
    <p:document href="../common/xlinklb.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
</p:xslt>

<p:xslt name="inline-xlinks">
  <p:input port="stylesheet">
    <p:document href="../common/xlinkex.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
</p:xslt>

<p:xslt>
  <p:input port="source">
    <p:pipe step="expand-linkbases" port="result"/>
  </p:input>
  <p:input port="stylesheet">
    <p:pipe step="inline-xlinks" port="result"/>
  </p:input>
</p:xslt>

<p:xslt>
  <p:input port="stylesheet">
    <p:document href="docbook.xsl"/>
  </p:input>
</p:xslt>

</p:declare-step>
