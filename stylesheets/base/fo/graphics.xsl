<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                exclude-result-prefixes="db doc f fn m t u xlink"
                version="2.0">

<!-- ********************************************************************
     $Id: graphics.xsl 7914 2008-03-12 11:47:38Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sourceforge.net/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template name="t:fo-external-image">
  <xsl:param name="filename"/>

  <xsl:choose>
    <xsl:when test="$fo.processor = 'fop' or $fo.processor = 'passivetex'">
      <xsl:value-of select="$filename"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('url(', $filename, ')')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
