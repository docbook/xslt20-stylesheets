<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:exf="http://exproc.org/standard/functions"
                exclude-inline-prefixes="cx exf"
                name="main">
<p:input port="parameters" kind="parameter"/>

<p:option name="name" required="true"/>

<!-- N.B. The path names are *relative to this pipeline document*.   -->
<!-- If you provide different paths as runtime options, make sure    -->
<!-- they are absolute, or make sure that they're correctly relative -->
<!-- to the location of this pipeline document.                      -->

<p:option name="srcdir" select="'../../src/test/xml/'"/>
<p:option name="resultdir" select="'../../build/test/css-print-result/'"/>
<p:option name="actualdir" select="'../../build/test/css-print-actual/'"/>
<p:option name="expecteddir" select="'../../src/test/css-print-expected/'"/>
<p:option name="diffdir" select="'../../build/test/css-print-diff/'"/>

<p:option name="format" select="'cssprint'"/>
<p:option name="css" select="''"/>
<p:option name="preprocess" select="''"/>
<p:option name="postprocess" select="''"/>

<p:import href="../../build/xslt/base/pipelines/docbook.xpl"/>

<p:declare-step type="cx:message" xmlns:cx="http://xmlcalabash.com/ns/extensions">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:declare-step type="cx:pretty-print">
   <p:input port="source"/>
   <p:output port="result"/>
</p:declare-step>

<p:directory-list>
  <p:with-option name="include-filter" select="concat($name, '.xml')"/>
  <p:with-option name="path" select="resolve-uri($srcdir)"/>
</p:directory-list>

<p:for-each name="loop">
  <p:iteration-source select="/c:directory/c:file"/>

  <p:load>
    <p:with-option name="href"
                   select="resolve-uri(/*/@name, base-uri(/*))"/>
  </p:load>

  <dbp:docbook>
    <p:with-param name="resource.root" select="resolve-uri('../../build/test/resources/')"/>
    <p:with-param name="bibliography.collection"
                  select="'../../build/test/resources/bibliography.xml'"/>
    <p:with-param name="profile.os" select="'win'"/>
    <p:with-option name="style"
                   select="if (/*/db:info/p:style)
                           then string(/*/db:info/p:style)
                           else 'docbook'"/>
    <p:with-option name="format" select="$format"/>
    <p:with-option name="preprocess" select="$preprocess"/>
    <p:with-option name="postprocess" select="$postprocess"/>
    <p:with-option name="css"
                   select="if ($css = '') then $css
                           else resolve-uri($css, exf:cwd())"/>
    <p:with-option name="pdf"
                   select="replace(resolve-uri(/*/@name, resolve-uri($actualdir)),
                                   '.xml$', '.pdf')">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </dbp:docbook>
</p:for-each>

<p:sink/>

</p:declare-step>
