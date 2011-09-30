<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:ex="http://docbook.org/xproc/step"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                name="main">
<p:input port="parameters" kind="parameter"/>
<p:output port="result"/>
<p:serialization port="result" method="xhtml"/>

<p:import href="../../tools/library.xpl"/>

<!-- N.B. The resource.root is set explicitly because it varies from release to release
     and generates spurious differences. -->

<ex:xspec name="htmlalt">
  <p:input port="source">
    <p:document href="htmlalt.xml"/>
  </p:input>
  <p:with-param name="resource.root" select="'http://docbook.github.com/latest/'"/>
</ex:xspec>

<ex:xspec name="htmlbase">
  <p:input port="source">
    <p:document href="htmlbase.xml"/>
  </p:input>
  <p:with-param name="preprocess" select="'profile'"/>
  <p:with-param name="profile.os" select="'win'"/>
  <p:with-param name="bibliography.collection" select="'etc/bibliography.collection.xml'"/>
  <p:with-param name="glossary.collection" select="'etc/glossary.collection.xml'"/>
  <p:with-param name="resource.root" select="'http://docbook.github.com/latest/'"/>
</ex:xspec>

<ex:xspec name="htmlprof1">
  <p:input port="source">
    <p:document href="htmlprof.xml"/>
  </p:input>
  <p:with-option name="result" select="'result/prof1'"/>
</ex:xspec>

<ex:xspec name="htmlprof2">
  <p:input port="source">
    <p:document href="htmlprof.xml"/>
  </p:input>
  <p:with-option name="result" select="'result/prof2'"/>
  <p:with-param name="preprocess" select="'profile'"/>
  <p:with-param name="profile.os" select="'win'"/>
</ex:xspec>

<ex:xspec name="htmlprof3">
  <p:input port="source">
    <p:document href="htmlprof.xml"/>
  </p:input>
  <p:with-option name="result" select="'result/prof3'"/>
  <p:with-param name="preprocess" select="'profile'"/>
  <p:with-param name="profile.os" select="'linux'"/>
  <p:log port="result" href="/tmp/out.xml"/>
</ex:xspec>

<p:wrap-sequence wrapper="x:report-set">
  <p:input port="source">
    <p:pipe step="htmlalt" port="result"/>
    <p:pipe step="htmlbase" port="result"/>
    <p:pipe step="htmlprof1" port="result"/>
    <p:pipe step="htmlprof2" port="result"/>
    <p:pipe step="htmlprof3" port="result"/>
  </p:input>
</p:wrap-sequence>

<p:choose>
  <p:when test="p:step-available('cx:pretty-print')">
    <cx:pretty-print/>
  </p:when>
  <p:otherwise>
    <p:identity/>
  </p:otherwise>
</p:choose>

<p:xslt>
  <p:input port="stylesheet">
    <p:document href="../../tools/format-xspec-report-set.xsl"/>
  </p:input>
</p:xslt>

</p:declare-step>
