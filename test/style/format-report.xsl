<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xs"
                version="2.0">

<xsl:output method="xhtml" encoding="utf-8" indent="no"
	    omit-xml-declaration="yes"/>

<xsl:param name="baseline" select="'0'"/>

<xsl:variable name="baseline.xml" select="resolve-uri('../diff/baseline.xml')"/>

<xsl:variable name="deltaxml" as="xs:boolean"
              select="exists(/results/result[1][@deltaxml='true'])"/>

<xsl:variable name="baseline-results" as="element()?"
              select="if (doc-available($baseline.xml))
                      then doc($baseline.xml)/*
                      else ()"/>

<xsl:template match="/">
  <xsl:if test="string($baseline) != '0' and $deltaxml">
    <xsl:result-document href="{$baseline.xml}-temp.xml" method="xml" indent="yes">
      <results xmlns="">
        <xsl:for-each select="/results/result">
          <xsl:sort select="@test" order="ascending"/>
          <result test="{@test}"
                  differences="{if (@differences = '')
                                then '0' else @differences}"/>
        </xsl:for-each>
      </results>
    </xsl:result-document>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="results">
  <html>
    <head>
      <title>Test results</title>
      <link rel="stylesheet" type="text/css"
            href="../resources/css/default.css" />
      <script type="text/javascript"
              src="../resources/js/dbmodnizr.js" />
      <link href="../resources/css/prism.css"
            rel="stylesheet" type="text/css" />
      <link href="../resources/css/db-prism.css"
            rel="stylesheet" type="text/css" />
      <link href="style/show-results.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
      <h1>DocBook XSLT 2.0 Stylesheet test results</h1>

      <xsl:if test="not($deltaxml)">
        <p>DeltaXML appears not to have been available; you will
        have to inspect the differences by hand.</p>
      </xsl:if>

      <table id="testresults">
        <thead>
          <tr>
            <th>Test result</th>
            <xsl:if test="$deltaxml">
              <th>Differences</th>
            </xsl:if>
            <th>Expected</th>
            <th>Actual</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates>
            <xsl:sort select="@test" order="ascending"/>
          </xsl:apply-templates>
        </tbody>
      </table>
      <script src="../resources/js/prism.js"></script>
    </body>
  </html>
</xsl:template>

<xsl:template match="result">
  <xsl:variable name="baseline"
                select="$baseline-results/result[@test = current()/@test]
                        /@differences/string()"/>
  <xsl:variable name="diffcount"
                select="if (@differences = '') then '0' else @differences"/>

  <tr>
    <xsl:if test="$diffcount != '0'">
      <xsl:attribute name="class" select="'diff'"/>
    </xsl:if>
    <td>
      <a href="result/{@test}">
        <xsl:value-of select="@test"/>
      </a>
    </td>
    <xsl:if test="$deltaxml">
      <td>
        <xsl:if test="exists($baseline) and $baseline != $diffcount">
          <xsl:attribute name="class" select="'basediff'"/>
        </xsl:if>
        <xsl:value-of select="@differences"/>
      </td>
    </xsl:if>
    <td>
      <a href="expected/{@test}">
        <xsl:value-of select="@test"/>
      </a>
    </td>
    <td>
      <a href="actual/{@test}">
        <xsl:value-of select="@test"/>
      </a>
    </td>
  </tr>
</xsl:template>

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
