<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:exf="http://exproc.org/standard/functions"
                exclude-inline-prefixes="cx exf"
                name="main">
<p:input port="source"/>
<p:output port="result"/>
<p:input port="parameters" kind="parameter"/>

<p:validate-with-relax-ng name="valid">
  <p:input port="schema">
    <p:document href="../build/schemas/locale.rng"/>
  </p:input>
</p:validate-with-relax-ng>

<p:xslt name="add-missing">
  <p:input port="stylesheet">
    <p:document href="../tools/build-l10n.xsl"/>
  </p:input>
  <p:with-param name="en.locale.file" select="'en.xml'"/>
</p:xslt>

</p:declare-step>
