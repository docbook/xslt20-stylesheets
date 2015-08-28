<p:declare-step version='1.0' xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:pos="http://exproc.org/proposed/steps/os"
		xmlns:cx="http://xmlcalabash.com/ns/extensions">
  <p:output port="result" />
  <p:serialization port="result" method="xhtml" indent="false" encoding="utf-8"/>

  <p:import href="recursive.xpl"/>

  <p:declare-step type="pos:env">
    <p:output port="result"/>
  </p:declare-step>

  <cx:recursive-directory-list path="../build/distributions"
                               exclude-filter="^.*~$"/>

  <p:delete match="/c:directory/c:directory[@name='.git']"/>
  <p:delete match="/c:directory/c:directory[@name='css']"/>
  <p:delete match="/c:directory/c:directory[@name='js']"/>
  <p:delete match="/c:directory/c:directory[@name='test-results']/c:directory"/>
  <p:delete match="/c:directory/c:directory[@name='test-results']
                      /c:file[@name != 'index.html']"/>
  <p:delete match="/c:directory/c:file[@name='index.html']"/>

  <p:xslt name="list">
    <p:input port="stylesheet">
      <p:document href="formatdir.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

  <pos:env name="env"/>

  <p:xslt>
    <p:input port="source">
      <p:document href="distindex/index.html"/>
    </p:input>
    <p:input port="stylesheet">
      <p:inline>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        version="2.0">

          <xsl:param name="repo"/>

          <xsl:preserve-space elements="*"/>

          <xsl:template match="/">
            <xsl:apply-templates/>
          </xsl:template>

          <xsl:template match="*">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
            </xsl:copy>
          </xsl:template>

          <xsl:template match="processing-instruction('pubdate')" priority="100">
            <xsl:value-of select="format-dateTime(current-dateTime(), '[D] [MNn] [Y]')"/>
          </xsl:template>

          <xsl:template match="processing-instruction('gh-pages')" priority="100">
            <xsl:value-of select="$repo"/>
          </xsl:template>

          <xsl:template match="comment()|processing-instruction()|text()">
            <xsl:copy/>
          </xsl:template>
        </xsl:stylesheet>
      </p:inline>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
    <p:with-param name="repo"
                  select="/c:result/c:env[@name='TRAVIS_REPO_SLUG']/@value">
      <p:pipe step="env" port="result"/>
    </p:with-param>
  </p:xslt>

  <p:insert name="insert"
            match="h:html/h:body" position="last-child"
            xmlns:h="http://www.w3.org/1999/xhtml">
    <p:input port="insertion">
      <p:pipe step="list" port="result"/>
    </p:input>
  </p:insert>
</p:declare-step>
