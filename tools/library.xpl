<p:library xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
           xmlns:cx="http://xmlcalabash.com/ns/extensions"
           xmlns:ex="http://docbook.org/xproc/step"
           xmlns:x="http://www.jenitennison.com/xslt/xspec"
           exclude-inline-prefixes="cx ex">

<p:declare-step type="cx:pretty-print">
  <p:input port="source"/>
  <p:output port="result"/>
</p:declare-step>

<p:pipeline type="ex:xspec" name="main">
  <p:option name="result"/>

  <p:choose>
    <p:when test="p:value-available('result')">
      <p:xslt>
        <p:input port="stylesheet">
          <p:document href="xresultpatch.xsl"/>
        </p:input>
        <p:with-param name="result" select="$result"/>
      </p:xslt>
      <!-- transformation strips off the base URI, stick it back on -->
      <p:add-attribute match="/*" attribute-name="xml:base">
        <p:with-option name="attribute-value" select="base-uri(/)">
          <p:pipe step="main" port="source"/>
        </p:with-option>
      </p:add-attribute>
    </p:when>
    <p:otherwise>
      <p:identity/>
    </p:otherwise>
  </p:choose>

  <p:xslt name="stylesheet">
    <p:input port="stylesheet">
      <p:document href="xspec-0.3.0/src/compiler/generate-xspec-tests.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

  <p:xslt name="report" template-name="x:main">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe step="stylesheet" port="result"/>
    </p:input>
  </p:xslt>

  <p:parameters name="params">
    <p:input port="parameters">
      <p:pipe step="main" port="parameters"/>
    </p:input>
  </p:parameters>

  <p:xslt name="preamble">
    <p:input port="source">
      <p:pipe step="params" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="xresultpreamble.xsl"/>
    </p:input>
  </p:xslt>

  <p:insert match="/x:report" position="first-child">
    <p:input port="source">
      <p:pipe step="report" port="result"/>
    </p:input>
    <p:input port="insertion">
      <p:pipe step="preamble" port="result"/>
    </p:input>
  </p:insert>
</p:pipeline>

</p:library>
