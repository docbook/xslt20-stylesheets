<p:library xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
           xmlns:cx="http://xmlcalabash.com/ns/extensions"
           xmlns:ex="http://docbook.org/xproc/step"
           exclude-inline-prefixes="cx ex">

<p:declare-step type="cx:pretty-print">
  <p:input port="source"/>
  <p:output port="result"/>
</p:declare-step>

<p:pipeline type="ex:xspec" name="main">
  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="xspec/src/compiler/generate-xspec-tests.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

  <p:xslt xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
          template-name="xspec:main">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
  </p:xslt>
</p:pipeline>

</p:library>
