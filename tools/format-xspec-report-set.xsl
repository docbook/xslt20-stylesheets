<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:test="http://www.jenitennison.com/xslt/unit-test"
		exclude-result-prefixes="xs h x test"
                version="2.0">

<xsl:import href="xspec-0.3.0/src/reporter/format-xspec-report.xsl"/>

<xsl:param name="report-css-uri" select="'http://docbook.github.com/latest/css/xspec-test-report.css'"/>

<xsl:template match="/">
  <xsl:message>
    <xsl:call-template name="x:totals">
      <xsl:with-param name="tests" select="//x:scenario/x:test" />
      <xsl:with-param name="labels" select="true()" />
    </xsl:call-template>
  </xsl:message>
  <html>
    <head>
      <!-- oh bother. just assume we're going to output utf-8 -->
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <title>
         <xsl:text>XSpec Test Report </xsl:text>
         <xsl:text> (</xsl:text>
         <xsl:call-template name="x:totals">
            <xsl:with-param name="tests" select="//x:scenario/x:test"/>
         </xsl:call-template>
         <xsl:text>)</xsl:text>
      </title>
      <link rel="stylesheet" type="text/css" href="{ $report-css-uri }"/>
      <xsl:call-template name="x:html-head-callback"/>
    </head>
    <body>
      <h1>Test Report</h1>
      <xsl:apply-templates select="*"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="x:report-set">
  <div>
    <h2>
      <xsl:text>Report for </xsl:text>
      <xsl:value-of select="count(x:report)"/>
      <xsl:text> runs (</xsl:text>
      <xsl:call-template name="x:totals">
        <xsl:with-param name="tests" select="//x:scenario/x:test"/>
      </xsl:call-template>
      <xsl:text>)</xsl:text>
    </h2>
    <ol>
      <xsl:for-each select="x:report">
        <li>
          <a href="#{generate-id(.)}">
            <xsl:text>passed/pending/failed/total </xsl:text>
            <xsl:call-template name="x:totals">
              <xsl:with-param name="tests" select=".//x:scenario/x:test"/>
            </xsl:call-template>
          </a>
        </li>
      </xsl:for-each>
    </ol>
    <xsl:for-each select="x:report">
      <hr/>
      <div id="{generate-id(.)}" class="report">
        <h1>Report for run <xsl:value-of select="position()"/></h1>
        <xsl:apply-templates select="."/>
      </div>
    </xsl:for-each>
  </div>
</xsl:template>

<xsl:template match="x:report">
  <p>
    <xsl:value-of select="if ( exists(@query) ) then 'Query: ' else 'Stylesheet: '"/>
    <a href="{ @stylesheet|@query }">
      <xsl:value-of select="test:format-URI(@stylesheet|@query)"/>
    </a>
  </p>
  <p>
    <xsl:text>Tested: </xsl:text>
    <xsl:value-of select="format-dateTime(@date, '[D] [MNn] [Y] at [H01]:[m01]')" />
  </p>

  <xsl:apply-templates select="x:preamble"/>

  <h2>Contents</h2>
  <table class="xspec">
    <col width="85%" />
    <col width="15%" />
    <thead>
      <tr>
        <th style="text-align: right; font-weight: normal; ">passed/pending/failed/total</th>
        <th>
          <xsl:call-template name="x:totals">
            <xsl:with-param name="tests" select=".//x:test" />
          </xsl:call-template>
        </th>
      </tr>
    </thead>
    <tbody>
      <xsl:for-each select="x:scenario">
        <xsl:variable name="pending" as="xs:boolean"
                      select="exists(@pending)" />
        <xsl:variable name="any-failure" as="xs:boolean"
                      select="exists(.//x:test[@successful = 'false'])" />
        <tr class="{if ($pending) then 'pending' else if ($any-failure) then 'failed' else 'successful'}">
          <th>
            <xsl:copy-of select="x:pending-callback(@pending)"/>
            <a href="#{generate-id()}">
              <xsl:apply-templates select="x:label" mode="x:html-report" />
            </a>
          </th>
          <th>
            <xsl:call-template name="x:totals">
              <xsl:with-param name="tests" select=".//x:test" />
            </xsl:call-template>
          </th>
        </tr>
      </xsl:for-each>
    </tbody>
  </table>
  <xsl:for-each select="x:scenario[not(@pending)]">
    <xsl:call-template name="x:format-top-level-scenario"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="x:preamble">
  <xsl:copy-of select="node()"/>
</xsl:template>

</xsl:stylesheet>
