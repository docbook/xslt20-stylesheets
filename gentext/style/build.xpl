<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:exf="http://exproc.org/standard/functions"
                exclude-inline-prefixes="cx exf"
                name="main">
<p:input port="parameters" kind="parameter"/>

<p:option name="srcdir" select="'../src/'"/>
<p:option name="builddir" select="'../build/'"/>

<p:declare-step type="cx:message" xmlns:cx="http://xmlcalabash.com/ns/extensions">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:directory-list include-filter="..*\.xml$">
  <p:with-option name="path" select="resolve-uri($srcdir)"/>
</p:directory-list>

<p:for-each name="loop">
  <p:iteration-source select="/c:directory/c:file"/>

  <cx:message>
    <p:with-option name="message" select="concat('Processing ', /*/@name)"/>
  </cx:message>

  <p:load>
    <p:with-option name="href" select="resolve-uri(/*/@name, base-uri(/*))"/>
  </p:load>

  <p:validate-with-relax-ng name="valid">
    <p:input port="schema">
      <p:document href="../../schemas/locale.rng"/>
    </p:input>
  </p:validate-with-relax-ng>

  <p:xslt name="add-missing">
    <p:input port="stylesheet">
      <p:document href="../../tools/build-l10n.xsl"/>
    </p:input>
    <p:with-param name="en.locale.file" select="'en.xml'"/>
  </p:xslt>

  <p:store method="xml" indent="false">
    <p:input port="source">
      <p:pipe step="add-missing" port="result"/>
    </p:input>
    <p:with-option name="href" select="concat(resolve-uri($builddir),/*/@name)">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:store>
</p:for-each>

</p:declare-step>
