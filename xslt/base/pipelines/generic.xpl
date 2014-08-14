<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:db="http://docbook.org/ns/docbook"
                name="main" version="1.0">
<p:input port="source" sequence="true"/>
<p:input port="parameters" kind="parameter"/>
<p:output port="result" sequence="true"/>
<p:serialization port="result" method="xhtml" encoding="utf-8" indent="false"/>

<p:option name="format" select="'html'"/>
<p:option name="style" select="'docbook'"/>
<p:option name="syntax-highlighter" select="if ($format='html') then 1 else 0"/>

<!-- This pipeline should run in any XProc processor; if the style
     parameter is the URI for a stylesheet, it must be absolute or
     must be relative to the location of *this* pipeline.
-->

<p:xslt name="logical-structure">
  <p:input port="stylesheet">
    <p:document href="../preprocess/00-logstruct.xsl"/>
  </p:input>
  <p:input port="parameters">
    <p:empty/>
  </p:input>
  <!--<p:log port="result" href="/tmp/00-logstruct.xml"/>-->
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

<p:xslt name="preprocessed">
  <p:input port="source">
    <p:pipe step="expand-linkbases" port="result"/>
  </p:input>
  <p:input port="stylesheet">
    <p:pipe step="inline-xlinks" port="result"/>
  </p:input>
  <!-- <p:log port="result" href="/tmp/doc.xml"/> -->
</p:xslt>

<p:choose>
  <p:when test="$format = 'html'">
    <p:choose>
      <p:when test="$style = 'docbook'">
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
        <p:xslt name="html-chunks">
          <p:input port="stylesheet">
            <p:document href="../html/chunk.xsl"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe step="main" port="parameters"/>
          </p:input>
          <p:with-param name="syntax-highlighter" select="$syntax-highlighter"/>
        </p:xslt>

        <p:for-each>
          <p:iteration-source>
            <p:pipe step="html-chunks" port="secondary"/>
          </p:iteration-source>
          <p:store name="store-chunk" method="html">
            <p:with-option name="href" select="base-uri(/)"/>
          </p:store>
        </p:for-each>

        <p:identity>
          <p:input port="source">
            <p:pipe step="html-chunks" port="result"/>
          </p:input>
        </p:identity>
      </p:when>
      <p:otherwise>
        <p:load name="load-style">
          <p:with-option name="href" select="$style"/>
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
    <p:choose>
      <p:when test="$style = 'docbook'">
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
      <p:otherwise>
        <p:load name="load-style">
          <p:with-option name="href" select="$style"/>
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
    <p:choose>
      <p:when test="$style = 'docbook'">
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
      <p:otherwise>
        <p:load name="load-style">
          <p:with-option name="href" select="$style"/>
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

</p:declare-step>
