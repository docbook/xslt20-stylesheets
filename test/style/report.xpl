<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:exf="http://exproc.org/standard/functions"
                xmlns:html="http://www.w3.org/1999/xhtml"
                exclude-inline-prefixes="cx exf c html"
                name="main">
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true"/>

<p:option name="resultdir" select="'result/'"/>

<p:declare-step type="cx:message" xmlns:cx="http://xmlcalabash.com/ns/extensions">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:directory-list include-filter=".*\.html" exclude-filter="report\.html">
  <p:with-option name="path" select="resolve-uri($resultdir, exf:cwd())"/>
</p:directory-list>

<p:for-each name="loop">
  <p:iteration-source select="/c:directory/c:file"/>

  <p:load name="result">
    <p:with-option name="href"
                   select="resolve-uri(/*/@name, base-uri(/*))"/>
  </p:load>

  <p:add-attribute match="/*" attribute-name="differences">
    <p:input port="source">
      <p:inline><result/></p:inline>
    </p:input>
    <p:with-option name="attribute-value"
                   select="string(//html:span[@class='exdiff'])"/>
  </p:add-attribute>

  <p:add-attribute match="/*" attribute-name="test">
    <p:with-option name="attribute-value" select="/*/@name">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:add-attribute>
</p:for-each>

<p:wrap-sequence wrapper="results">
  <p:log port="result" href="/tmp/log.xml"/>
</p:wrap-sequence>

<p:xslt>
  <p:input port="stylesheet">
    <p:document href="format-report.xsl"/>
  </p:input>
</p:xslt>

</p:declare-step>
