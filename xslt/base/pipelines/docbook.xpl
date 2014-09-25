<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:pxp="http://exproc.org/proposed/steps"
                name="main" version="1.0"
                exclude-inline-prefixes="db dbp pxp"
                type="dbp:docbook">
<p:input port="source" sequence="true"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true" primary="true">
  <p:pipe step="process-secondary" port="result"/>
</p:output>
<p:output port="secondary" sequence="true" primary="false">
  <p:pipe step="process-secondary" port="secondary"/>
</p:output>
<p:serialization port="result" method="xhtml" encoding="utf-8" indent="false"/>

<p:option name="format" select="'html'"/>
<p:option name="style" select="'docbook'"/>
<p:option name="return-secondary" select="'false'"/>
<p:option name="syntax-highlighter" select="if ($format='html') then 1 else 0"/>

<!-- Ideally, this pipeline wouldn't rely on an XML Calabash extensions,
     but it's a lot more convenient this way. See generic.xpl for a
     version with no processor-specific extensions.
-->

<p:declare-step type="pxp:set-base-uri">
  <p:input port="source"/>
  <p:output port="result"/>
  <p:option name="uri" required="true"/>
</p:declare-step>

<p:declare-step type="cx:message" xmlns:cx="http://xmlcalabash.com/ns/extensions">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:xslt name="logical-structure">
  <p:input port="stylesheet">
    <p:document href="../preprocess/00-logstruct.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/00-logstruct.xml"/> -->
</p:xslt>

<p:choose name="db4to5">
  <p:when test="/db:*">
    <p:identity/>
  </p:when>
  <p:otherwise>
    <p:xslt name="run10">
      <p:input port="stylesheet">
        <p:document href="../preprocess/10-db4to5.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
      <!-- <p:log port="result" href="/tmp/10-db4to5.xml"/> -->
    </p:xslt>
  </p:otherwise>
</p:choose>

<pxp:set-base-uri>
  <p:with-option name="uri" select="base-uri(/)">
    <p:pipe step="main" port="source"/>
  </p:with-option>
  <!-- <p:log port="result" href="/tmp/s-b-u-1.xml"/> -->
</pxp:set-base-uri>

<p:xslt name="transclude">
  <p:input port="stylesheet">
    <p:document href="../preprocess/20-transclude.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/20-transclude.xml"/> -->
</p:xslt>

<p:xslt name="profile">
  <p:input port="stylesheet">
    <p:document href="../preprocess/30-profile.xsl"/>
  </p:input>
  <!-- Use the parameters passed to the pipeline -->
  <!-- <p:log port="result" href="/tmp/30-profile.xml"/> -->
</p:xslt>

<p:xslt name="schemaext">
  <p:input port="stylesheet">
    <p:document href="../preprocess/40-schemaext.xsl"/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/40-schemaext.xml"/> -->
</p:xslt>

<p:choose name="verbatim">
  <p:when test="$syntax-highlighter = 0">
    <p:xslt name="run45">
      <p:input port="stylesheet">
        <p:document href="../preprocess/45-verbatim.xsl"/>
      </p:input>
      <!-- <p:log port="result" href="/tmp/45-verbatim.xml"/> -->
    </p:xslt>
  </p:when>
  <p:otherwise>
    <p:identity/>
  </p:otherwise>
</p:choose>

<pxp:set-base-uri>
  <p:with-option name="uri" select="base-uri(/)">
    <p:pipe step="main" port="source"/>
  </p:with-option>
  <!-- <p:log port="result" href="/tmp/s-b-u-2.xml"/> -->
</pxp:set-base-uri>

<p:xslt name="normalize">
  <p:input port="stylesheet">
    <p:document href="../preprocess/50-normalize.xsl"/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/50-normalize.xml"/> -->
</p:xslt>

<p:xslt name="expand-linkbases">
  <p:input port="stylesheet">
    <p:document href="../xlink/xlinklb.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/lb.xml"/> -->
</p:xslt>

<p:xslt name="inline-xlinks">
  <p:input port="stylesheet">
    <p:document href="../xlink/xlinkex.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/ex.xml"/> -->
</p:xslt>

<p:delete match="@ghost:*"
          xmlns:ghost="http://docbook.org/ns/docbook/ephemeral">
  <p:input port="source">
    <p:pipe step="expand-linkbases" port="result"/>
  </p:input>
</p:delete>

<p:xslt name="preprocessed">
  <p:input port="stylesheet">
    <p:pipe step="inline-xlinks" port="result"/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/doc.xml"/> -->
</p:xslt>

<p:choose name="final-pass">
  <p:when test="$format = 'html'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="format-html" port="secondary"/>
    </p:output>
    <p:choose name="format-html">
      <p:when test="$style = 'docbook'">
        <p:output port="result" primary="true"/>
        <p:output port="secondary" sequence="true">
          <p:pipe step="html-docbook" port="secondary"/>
        </p:output>
        <p:xslt name="html-docbook">
          <p:input port="stylesheet">
            <p:document href="../html/final-pass.xsl"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
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
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
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
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
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
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
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
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
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
            <p:pipe step="preprocessed" port="result"/>
          </p:input>
          <p:input port="stylesheet">
            <p:pipe step="load-style" port="result"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter"
                        select="$syntax-highlighter"/>
        </p:xslt>
      </p:otherwise>
    </p:choose>
  </p:when>
  <p:when test="$format = 'print'">
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="format-print" port="secondary"/>
    </p:output>
    <p:choose name="format-print">
      <p:when test="$style = 'docbook'">
        <p:output port="result" primary="true"/>
        <p:output port="secondary" sequence="true">
          <p:pipe step="print-docbook" port="secondary"/>
        </p:output>
        <p:xslt name="print-docbook">
          <p:input port="stylesheet">
            <p:document href="../print/final-pass.xsl"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
        </p:xslt>
      </p:when>
      <p:otherwise xmlns:exf="http://exproc.org/standard/functions">
        <p:output port="result" primary="true"/>
        <p:output port="secondary" sequence="true">
          <p:pipe step="print-user-cwd" port="secondary"/>
        </p:output>
        <!-- This relies on an XML Calabash extension function as a user
             convenience. I'm open to suggestions... -->
        <p:load name="load-style">
          <p:with-option name="href" select="resolve-uri($style, exf:cwd())"/>
        </p:load>
        <p:xslt name="print-user-cwd">
          <p:input port="source">
            <p:pipe step="preprocessed" port="result"/>
          </p:input>
          <p:input port="stylesheet">
            <p:pipe step="load-style" port="result"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter"
                        select="$syntax-highlighter"/>
        </p:xslt>
      </p:otherwise>
    </p:choose>
  </p:when>
  <!-- Assume legacy FO -->
  <p:otherwise>
    <p:output port="result" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:pipe step="print-fo" port="secondary"/>
    </p:output>
    <p:choose name="print-fo">
      <p:when test="$style = 'docbook'">
        <p:output port="result" primary="true"/>
        <p:output port="secondary" sequence="true">
          <p:pipe step="fo-docbook" port="secondary"/>
        </p:output>
        <p:xslt name="fo-docbook">
          <p:input port="stylesheet">
            <p:document href="../fo/final-pass.xsl"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
        </p:xslt>
      </p:when>
      <p:when test="$style = 'slides'">
        <p:output port="result" primary="true"/>
        <p:output port="secondary" sequence="true">
          <p:pipe step="fo-slides" port="secondary"/>
        </p:output>
        <p:xslt name="fo-slides">
          <p:input port="stylesheet">
            <p:document href="../../slides/fo/plain.xsl"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
        </p:xslt>
      </p:when>
      <p:otherwise xmlns:exf="http://exproc.org/standard/functions">
        <p:output port="result" primary="true"/>
        <p:output port="secondary" sequence="true">
          <p:pipe step="fo-user-cwd" port="secondary"/>
        </p:output>
        <!-- This relies on an XML Calabash extension function as a user
             convenience. I'm open to suggestions... -->
        <p:load name="load-style">
          <p:with-option name="href" select="resolve-uri($style, exf:cwd())"/>
        </p:load>
        <p:xslt name="fo-user-cwd">
          <p:input port="source">
            <p:pipe step="preprocessed" port="result"/>
          </p:input>
          <p:input port="stylesheet">
            <p:pipe step="load-style" port="result"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter"
                        select="$syntax-highlighter"/>
        </p:xslt>
      </p:otherwise>
    </p:choose>
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
        <p:pipe step="final-pass" port="secondary"/>
      </p:input>
    </p:identity>
    <p:identity>
      <p:input port="source">
        <p:pipe step="final-pass" port="result"/>
      </p:input>
    </p:identity>
  </p:when>
  <p:when test="$format = 'html' or $format = 'print'">
    <p:output port="result" sequence="true" primary="true"/>
    <p:output port="secondary" sequence="true">
      <p:empty/>
    </p:output>
    <p:for-each>
      <p:iteration-source>
        <p:pipe step="final-pass" port="secondary"/>
      </p:iteration-source>
      <p:store name="store-chunk" method="html">
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
        <p:pipe step="final-pass" port="result"/>
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
        <p:pipe step="final-pass" port="secondary"/>
      </p:iteration-source>
      <p:store name="store-chunk" method="xml">
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
        <p:pipe step="final-pass" port="result"/>
      </p:input>
    </p:identity>
  </p:otherwise>
</p:choose>

</p:declare-step>
