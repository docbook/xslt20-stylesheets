<p:pipeline xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
            xmlns:ex="http://docbook.org/xproc/step"
            type="ex:xspec" name="main">

  <p:xslt>
    <p:input port="stylesheet">
      <p:document href="xspec-v0.2/generate-xspec-tests.xsl"/>
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
