<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f h m t xs"
                version="2.0">

<xsl:import href="plain.xsl"/>

<xsl:template match="/">
  <xsl:variable name="deck">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:variable name="head" select="$deck/h:html/h:head"/>
  <xsl:variable name="foil" select="$deck/h:html/h:body/h:div[tokenize(@class,'\s+') = 'foil']"/>

  <xsl:variable name="totslides" select="count($foil)"/>

  <xsl:for-each select="$foil">
    <xsl:variable name="curslide" select="position()"/>

    <xsl:variable name="thisslide"
                  select="if (position() = 1)
                          then 'index.html'
                          else if (position() = 2)
                               then 'toc.html'
                               else concat('foil',format-number(position()-2,'000'), '.html')"/>

    <xsl:variable name="prevslide"
                  select="if (position() = 1)
                          then ''
                          else if (position() = 2)
                               then 'index.html'
                               else if (position() = 3)
                                    then 'toc.html'
                                    else concat('foil',format-number(position()-3,'000'), '.html')"/>

    <xsl:variable name="nextslide"
                  select="if (position() = 1)
                          then 'toc.html'
                          else if (position() &lt; last())
                               then concat('foil',format-number(position()-1,'000'), '.html')
                               else ''"/>

    <xsl:result-document href="{$thisslide}">
      <html>
        <head>
          <meta name="curslide" content="{$curslide}"/>
          <meta name="totslides" content="{$totslides}"/>
          <meta name="prevslide" content="{$prevslide}"/>
          <meta name="nextslide" content="{$nextslide}"/>
          <xsl:copy-of select="$head/node()"/>
        </head>
        <body>
          <xsl:copy-of select="."/>
        </body>
      </html>
    </xsl:result-document>
  </xsl:for-each>

  <xsl:result-document method="text">
    <xsl:text>index.xml&#10;</xsl:text>
    <xsl:text>toc.xml&#10;</xsl:text>
    <xsl:for-each select="$foil[position() &gt; 2]">
      <xsl:value-of select="concat('foil', format-number(position(), '000'), '.html')"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:result-document>
</xsl:template>

</xsl:stylesheet>
