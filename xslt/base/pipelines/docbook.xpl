<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                name="main" version="1.0">
<p:input port="source"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>
<p:serialization port="result" method="xhtml" encoding="utf-8" indent="false"/>

<p:option name="print" select="0"/>
<p:option name="syntax-highlighter" select="if ($print=0) then 1 else 0"/>

<p:xslt name="logical-structure">
  <p:input port="stylesheet">
    <p:document href="../preprocess/00-logstruct.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <p:log port="result" href="/tmp/00-logstruct.xml"/>
</p:xslt>

<p:choose name="db4to5">
  <p:when test="/db:*">
    <p:identity/>
  </p:when>
  <p:otherwise>
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="../preprocess/10-db4to5.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
      <p:log port="result" href="/tmp/10-db4to5.xml"/>
    </p:xslt>
  </p:otherwise>
</p:choose>

<p:xslt name="transclude">
  <p:input port="stylesheet">
    <p:document href="../preprocess/20-transclude.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <p:log port="result" href="/tmp/20-transclude.xml"/>
</p:xslt>

<p:xslt name="profile">
  <p:input port="stylesheet">
    <p:document href="../preprocess/30-profile.xsl"/>
  </p:input>
  <!-- Use the parameters passed to the pipeline -->
  <p:log port="result" href="/tmp/30-profile.xml"/>
</p:xslt>

<p:xslt name="schemaext">
  <p:input port="stylesheet">
    <p:document href="../preprocess/40-schemaext.xsl"/>
  </p:input>
  <p:log port="result" href="/tmp/40-schemaext.xml"/>
</p:xslt>

<p:choose name="verbatim">
  <p:when test="$syntax-highlighter = 0">
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="../preprocess/45-verbatim.xsl"/>
      </p:input>
      <p:log port="result" href="/tmp/45-verbatim.xml"/>
    </p:xslt>
  </p:when>
  <p:otherwise>
    <p:identity/>
  </p:otherwise>
</p:choose>

<p:xslt name="normalize">
  <p:input port="stylesheet">
    <p:document href="../preprocess/50-normalize.xsl"/>
  </p:input>
  <p:log port="result" href="/tmp/50-normalize.xml"/>
</p:xslt>

<p:xslt name="expand-linkbases">
  <p:input port="stylesheet">
    <p:document href="../xlink/xlinklb.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <p:log port="result" href="/tmp/lb.xml"/>
</p:xslt>

<p:xslt name="inline-xlinks">
  <p:input port="stylesheet">
    <p:document href="../xlink/xlinkex.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <p:log port="result" href="/tmp/ex.xml"/>
</p:xslt>

<p:xslt>
  <p:input port="source">
    <p:pipe step="expand-linkbases" port="result"/>
  </p:input>
  <p:input port="stylesheet">
    <p:pipe step="inline-xlinks" port="result"/>
  </p:input>
  <p:log port="result" href="/tmp/doc.xml"/>
</p:xslt>

<p:choose>
  <p:when test="$print = 0">
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="../html/docbook.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:pipe step="main" port="parameters"/>
      </p:input>
      <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
    </p:xslt>
  </p:when>
  <p:otherwise>
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="../print/docbook.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:pipe step="main" port="parameters"/>
      </p:input>
      <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
    </p:xslt>
  </p:otherwise>
</p:choose>

</p:declare-step>
