<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs src" version="2.0"
  xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
  xmlns:db="http://docbook.org/ns/docbook"
  xmlns:fp="http://docbook.org/xslt/ns/extension/private"
  >
  
<xsl:param name="xslt1-fo-params-file"/>
<xsl:param name="xslt1-html-params-file"/>
<xsl:param name="xslt2-fo-params-file"/>
<xsl:param name="xslt2-html-params-file"/>

<xsl:param name="xslt1-fo-doc" select="doc($xslt1-fo-params-file)"/>
<xsl:param name="xslt1-html-doc" select="doc($xslt1-html-params-file)"/>
<xsl:param name="xslt2-fo-doc" select="doc($xslt2-fo-params-file)"/>
<xsl:param name="xslt2-html-doc" select="doc($xslt2-html-params-file)"/>

<xsl:param name="xslt1-fo-params" select="$xslt1-fo-doc//src:fragref/substring-before(@linkend, '.frag')"/>
<xsl:param name="xslt1-html-params" select="$xslt1-html-doc//src:fragref/substring-before(@linkend, '.frag')"/>
<xsl:param name="xslt2-fo-params" select="$xslt2-fo-doc//db:refentry/string(@xml:id)"/>
<xsl:param name="xslt2-html-params" select="$xslt2-html-doc//db:refentry/string(@xml:id)"/>
  
<xsl:param name="all" select="distinct-values(($xslt1-fo-params, $xslt1-html-params, $xslt2-fo-params, $xslt2-html-params))"/>  
  
<xsl:template name="main">
  <html>
    <head>
      <title>Parametr overview</title>
    </head>
    <body>
      <h1>XSLT1 vs XSLT2 parameters overview</h1>
      <table border="1">
        <tr>
          <th rowspan="2">Name</th>
          <th colspan="2">XSLT 2.0</th>
          <th colspan="2">XSLT 1.0</th>
        </tr>
        <tr>
          <th>HTML</th>
          <th>FO</th>
          <th>HTML</th>
          <th>FO</th>
        </tr>
        <xsl:for-each select="$all">
          <xsl:sort select="."/>
          <tr>
            <td><xsl:value-of select="."/></td>
            <xsl:sequence select="fp:cell(index-of($xslt2-html-params, .), index-of($xslt1-html-params, .))"/>
            <xsl:sequence select="fp:cell(index-of($xslt2-fo-params, .), index-of($xslt1-fo-params, .))"/>
            <xsl:sequence select="fp:cell(index-of($xslt1-html-params, .))"/>
            <xsl:sequence select="fp:cell(index-of($xslt1-fo-params, .))"/>
          </tr>
        </xsl:for-each>
      </table>
    </body>
  </html>
</xsl:template>
  
<xsl:function name="fp:cell">
  <xsl:param name="index" as="xs:integer*"/>
  <xsl:param name="index1" as="xs:integer*"/>
  
  <xsl:choose>
    <xsl:when test="empty($index1) and empty($index)">
      <td style="background-color: yellow; width: 80px" align="center">N</td>
    </xsl:when>
    <xsl:when test="empty($index)">
      <td style="background-color: red; width: 80px" align="center">N</td>
    </xsl:when>
    <xsl:otherwise>
      <td style="background-color: green; width: 80px" align="center">Y</td>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>  
  
<xsl:function name="fp:cell">
  <xsl:param name="index" as="xs:integer*"/>

  <xsl:sequence select="fp:cell($index, 1)"/>
</xsl:function>  

</xsl:stylesheet>
