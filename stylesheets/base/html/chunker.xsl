<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:out="http://docbook.org/xslt/ns/output"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f ghost h m t u xs"
                version="2.0">

<!-- ********************************************************************
     $Id: chunker.xsl 5503 2005-12-28 13:44:49Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:output name="out:xhtml"
	    method="xhtml"
	    encoding="utf-8"
	    indent="no"/>

<xsl:output name="out:xml"
	    method="xml"
	    encoding="utf-8"
	    indent="no"/>

<!-- ==================================================================== -->

<xsl:template name="t:write-chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="quiet" select="0"/>
  <xsl:param name="output" select="'out:xhtml'"/>

  <xsl:param name="content"/>

  <xsl:if test="$quiet = 0">
    <xsl:message>
      <xsl:text>Writing </xsl:text>
      <xsl:value-of select="$filename"/>
      <xsl:if test="name(.) != ''">
        <xsl:text> for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:if test="@id">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:message>
  </xsl:if>

  <xsl:result-document href="{$filename}" format="{$output}">
    <xsl:sequence select="$content"/>
  </xsl:result-document>
</xsl:template>

</xsl:stylesheet>
