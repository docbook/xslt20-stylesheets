<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:pxp="http://exproc.org/proposed/steps"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                name="main" version="1.0"
                exclude-inline-prefixes="cx db dbp pxp"
                type="dbp:docbook-xhtml">
<p:input port="source" sequence="true" primary="true"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true" primary="true">
  <p:pipe step="process-secondary" port="result"/>
</p:output>
<p:output port="secondary" sequence="true" primary="false">
  <p:pipe step="process-secondary" port="secondary"/>
</p:output>

<p:option name="style" select="'docbook'"/>
<p:option name="format" select="'html'"/>
<p:option name="postprocess" select="''"/>
<p:option name="return-secondary" select="'false'"/>

<p:declare-step type="cx:message">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:choose name="final-pass">
  <p:when test="$style = 'docbook'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="html-docbook" port="secondary"/>
    </p:output>
    <p:xslt name="html-docbook">
      <p:input port="stylesheet">
        <p:document href="../html/final-pass.xsl"/>
      </p:input>
    </p:xslt>
  </p:when>
  <p:when test="$style = 'slides'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="html-slides" port="secondary"/>
    </p:output>
    <p:xslt name="html-slides">
      <p:input port="stylesheet">
        <p:document href="../../slides/html/plain.xsl"/>
      </p:input>
    </p:xslt>
  </p:when>
  <p:when test="$style = 'slide-notes'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="html-slides-notes" port="secondary"/>
    </p:output>
    <p:xslt name="html-slides-notes">
      <p:input port="stylesheet">
        <p:document href="../../slides/html/plain-notes.xsl"/>
      </p:input>
    </p:xslt>
  </p:when>
  <p:when test="$style = 'publishers'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="html-publishers" port="secondary"/>
    </p:output>
    <p:xslt name="html-publishers">
      <p:input port="stylesheet">
        <p:document href="../../publishers/html/publishers.xsl"/>
      </p:input>
    </p:xslt>
  </p:when>
  <p:when test="$style = 'chunk'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="html-chunk" port="secondary"/>
    </p:output>
    <p:xslt name="html-chunk">
      <p:input port="stylesheet">
        <p:document href="../html/chunk.xsl"/>
      </p:input>
    </p:xslt>
  </p:when>
  <p:otherwise xmlns:exf="http://exproc.org/standard/functions">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="html-user-cwd" port="secondary"/>
    </p:output>
    <!-- This relies on an XML Calabash extension function as a user
         convenience. I'm open to suggestions... -->
    <p:load name="load-style">
      <p:with-option name="href" select="resolve-uri($style, exf:cwd())"/>
    </p:load>
    <p:xslt name="html-user-cwd">
      <p:input port="source">
        <p:pipe step="main" port="source"/>
      </p:input>
      <p:input port="stylesheet">
        <p:pipe step="load-style" port="result"/>
      </p:input>
    </p:xslt>
  </p:otherwise>
</p:choose>

<p:choose name="postprocess">
  <p:when test="$postprocess = ''">
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="secondary" port="result"/>
    </p:output>
    <p:identity name="secondary">
      <p:input port="source">
        <p:pipe step="final-pass" port="secondary"/>
      </p:input>
    </p:identity>
    <p:identity>
      <p:input port="source">
        <p:pipe step="final-pass" port="result"/>
      </p:input>
    </p:identity>
  </p:when>
  <p:otherwise xmlns:exf="http://exproc.org/standard/functions">
    <p:output port="result" sequence="true" primary="true">
      <p:pipe step="primary" port="result"/>
    </p:output>
    <p:output port="secondary" sequence="true">
      <p:pipe step="secondary" port="result"/>
    </p:output>

    <p:load name="load-style">
      <p:with-option name="href" select="resolve-uri($postprocess, exf:cwd())"/>
    </p:load>

    <p:xslt name="primary">
      <p:input port="stylesheet">
        <p:pipe step="load-style" port="result"/>
      </p:input>
      <p:input port="source">
        <p:pipe step="final-pass" port="result"/>
      </p:input>
    </p:xslt>

    <p:for-each name="secondary">
      <p:iteration-source>
        <p:pipe step="final-pass" port="secondary"/>
      </p:iteration-source>
      <p:output port="result"/>

      <p:xslt>
        <p:input port="stylesheet">
          <p:pipe step="load-style" port="result"/>
        </p:input>
      </p:xslt>
    </p:for-each>
  </p:otherwise>
</p:choose>

<p:choose name="process-secondary">
  <p:when test="$return-secondary = 'true'">
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="secondary" port="result"/>
    </p:output>
    <p:identity name="secondary">
      <p:input port="source">
        <p:pipe step="postprocess" port="secondary"/>
      </p:input>
    </p:identity>
    <p:identity>
      <p:input port="source">
        <p:pipe step="postprocess" port="result"/>
      </p:input>
    </p:identity>
  </p:when>
  <p:otherwise>
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:empty/>
    </p:output>
    <p:for-each>
      <p:iteration-source>
        <p:pipe step="postprocess" port="secondary"/>
      </p:iteration-source>
      <p:store name="store-chunk" encoding="utf-8" indent="false">
        <p:with-option name="method" select="$format"/>
        <p:with-option name="version"
                       select="if ($format = 'html') then '5' else '1.0'"/>
        <p:with-option name="href" select="base-uri(/)"/>
      </p:store>
      <cx:message xmlns:cx="http://xmlcalabash.com/ns/extensions">
        <p:input port="source">
          <p:pipe step="store-chunk" port="result"/>
        </p:input>
        <p:with-option name="message" select="concat('Chunk: ', .)">
          <p:pipe step="store-chunk" port="result"/>
        </p:with-option>
      </cx:message>
    </p:for-each>
    <p:sink/>
    <p:identity>
      <p:input port="source">
        <p:pipe step="postprocess" port="result"/>
      </p:input>
    </p:identity>
  </p:otherwise>
</p:choose>

</p:declare-step>
