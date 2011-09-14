<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f h m t xs"
                version='2.0'>

<!-- ********************************************************************
     $Id: footnotes.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template match="db:footnote" mode="m:footnote-number">
  <xsl:choose>
    <xsl:when test="string-length(@label) != 0">
      <xsl:value-of select="@label"/>
    </xsl:when>

    <xsl:when test="ancestor::db:table or ancestor::db:informaltable">
      <!-- choose first in document order so that we get the outer most table -->
      <xsl:variable name="table"
                    select="(ancestor::db:table|ancestor::db:informaltable)[1]"/>

      <!-- have to count by hand because xsl:number only matches by pattern -->
      <xsl:variable name="tfnum"
                    select="count($table//db:footnote intersect preceding::db:footnote) + 1"/>

      <xsl:choose>
	<xsl:when test="string-length($table.footnote.number.symbols)&gt;= $tfnum">
          <xsl:value-of select="substring($table.footnote.number.symbols, $tfnum, 1)"/>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:number value="$tfnum" format="{$table.footnote.number.format}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <xsl:variable name="pfoot" select="preceding::db:footnote[not(@label)]"/>
      <xsl:variable name="ptfoot" select="preceding::db:tgroup//db:footnote
                                          |preceding::db:tr//db:footnote"/>
      <xsl:variable name="fnum" select="count($pfoot) - count($ptfoot) + 1"/>

      <xsl:choose>
	<xsl:when test="string-length($footnote.number.symbols) &gt;= $fnum">
	  <xsl:value-of select="substring($footnote.number.symbols, $fnum, 1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number value="$fnum" format="{$footnote.number.format}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
