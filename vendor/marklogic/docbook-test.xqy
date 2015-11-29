xquery version "1.0-ml";

import module namespace mldb="http://docbook.org/vendor/marklogic/docbook"
    at "/DocBook/vendor/marklogic/docbook.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

let $doc := document {
  <article xmlns="http://docbook.org/ns/docbook"
           xmlns:c="http://www.w3.org/ns/xproc-step">
  <info>
    <c:param name="profile.condition" value="web"/>
    <title>Article title</title>
  </info>
  <para>This is a paragraph.</para>
  <para condition="print">If you see this, something has gone wrong.</para>
  <para>If you see this paragraph, everything is ok.</para>
  </article>
}

let $style := document {
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xs db"
                version="2.0">

<xsl:import href="/DocBook/base/html/final-pass.xsl"/>

<xsl:template match="db:para">
  <p class="custom">
    <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>
}

return
  mldb:to-html($doc, map:map(), (), $style)

