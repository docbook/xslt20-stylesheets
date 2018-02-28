<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:exf="http://exproc.org/standard/functions"
                xmlns:html="http://www.w3.org/1999/xhtml"
                exclude-inline-prefixes="cx exf c html"
                name="main">
<p:input port="parameters" kind="parameter"/>
<p:output port="result">
  <p:pipe step="report" port="result"/>
</p:output>
<p:serialization port="result" method="html" version="5"/>

<!-- N.B. The path names are *relative to this pipeline document*.   -->
<!-- If you provide different paths as runtime options, make sure    -->
<!-- they are absolute, or make sure that they're correctly relative -->
<!-- to the location of this pipeline document.                      -->

<p:option name="resultdir" select="'../../build/test/result-html/'"/>
<p:option name="baseline" select="'0'"/>

<p:declare-step type="cx:message" xmlns:cx="http://xmlcalabash.com/ns/extensions">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:directory-list include-filter=".*\.html">
  <p:with-option name="path" select="resolve-uri($resultdir)"/>
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

  <p:add-attribute match="/*" attribute-name="deltaxml">
    <p:with-option name="attribute-value"
                   select="string(//html:meta[@name='deltaxml']/@content)">
      <p:pipe step="result" port="result"/>
    </p:with-option>
  </p:add-attribute>

  <p:add-attribute match="/*" attribute-name="style">
    <p:with-option name="attribute-value"
                   select="string(/*/@p:style)">
      <p:pipe step="result" port="result"/>
    </p:with-option>
  </p:add-attribute>

  <p:add-attribute match="/*" attribute-name="test">
    <p:with-option name="attribute-value" select="/*/@name">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:add-attribute>
</p:for-each>

<p:wrap-sequence wrapper="results">
  <p:log href="/tmp/out.xml" port="result"/>
</p:wrap-sequence>

<p:xslt name="report">
  <p:input port="stylesheet">
    <p:document href="format-report.xsl"/>
  </p:input>
  <p:with-param name="baseline" select="$baseline"/>
</p:xslt>

<!-- I know there's only one secondary output, baseline.xml -->
<p:for-each>
  <p:iteration-source>
    <p:pipe step="report" port="secondary"/>
  </p:iteration-source>
  <p:store method="xml" encoding="utf-8" indent="true"
           href="../diff/baseline.xml"/>
</p:for-each>

</p:declare-step>
