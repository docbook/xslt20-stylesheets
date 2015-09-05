<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:exf="http://exproc.org/standard/functions"
                exclude-inline-prefixes="cx exf"
                name="main">
<p:input port="parameters" kind="parameter"/>

<p:option name="srcdir" select="'src/'"/>
<p:option name="resultdir" select="'cssprint-result/'"/>
<p:option name="actualdir" select="'cssprint-actual/'"/>
<p:option name="expecteddir" select="'cssprint-expected/'"/>
<p:option name="diffdir" select="'cssprint-diff/'"/>
<p:option name="include" select="'.*\.xml'"/>
<p:option name="format" select="'cssprint'"/>

<p:import href="../../xslt/base/pipelines/docbook.xpl"/>

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
  <p:with-option name="include-filter" select="$include"/>
  <p:with-option name="path" select="resolve-uri($srcdir, exf:cwd())"/>
</p:directory-list>

<!-- p:directory-list doesn't sort files; this stylesheet puts them
     in alphabetic order. It doesn't matter to the tests, but it
     makes the display easier to grok when they're running.
-->
<p:xslt>
  <p:input port="stylesheet">
    <p:inline>
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                      xmlns:c="http://www.w3.org/ns/xproc-step"
                      version="2.0">
        <xsl:template match="c:directory">
          <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="*">
              <xsl:sort select="@name" order="ascending"/>
            </xsl:apply-templates>
          </xsl:copy>
        </xsl:template>
        <xsl:template match="element()">
          <xsl:copy>
            <xsl:apply-templates select="@*,node()"/>
          </xsl:copy>
        </xsl:template>
        <xsl:template match="attribute()|text()">
          <xsl:copy/>
        </xsl:template>
      </xsl:stylesheet>
    </p:inline>
  </p:input>
</p:xslt>

<p:for-each name="loop">
  <p:iteration-source select="/c:directory/c:file"/>

  <cx:message>
    <p:with-option name="message" select="concat('Processing ', /*/@name)"/>
  </cx:message>

  <p:load>
    <p:with-option name="href"
                   select="resolve-uri(/*/@name, base-uri(/*))"/>
  </p:load>

  <dbp:docbook>
    <p:with-param name="resource.root"
                  select="resolve-uri('../../resources/')"/>
    <p:with-param name="bibliography.collection"
                  select="'../style/bibliography.xml'"/>
    <p:with-param name="profile.os" select="'win'"/>
    <p:with-option name="style"
                   select="if (/*/db:info/p:style)
                           then string(/*/db:info/p:style)
                           else 'docbook'"/>
    <p:with-option name="format" select="$format"/>
    <p:with-option name="pdf"
                   select="replace(resolve-uri(/*/@name,
                                   resolve-uri($actualdir, exf:cwd())),
                                   '.xml$', '.pdf')">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </dbp:docbook>
</p:for-each>

<p:sink/>

</p:declare-step>
