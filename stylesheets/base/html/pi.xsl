<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f ghost h m t u xs"
                version="2.0">

<xsl:function name="f:dbhtml-dir" as="xs:string">
  <xsl:param name="context" as="element()"/>

  <!-- directories are now inherited from previous levels -->

  <xsl:variable name="ppath"
		select="if ($context/parent::*)
                        then f:dbhtml-dir($context/parent::*)
			else ''"/>

  <xsl:variable name="path"
		select="f:pi($context/processing-instruction('dbhtml'),'dir')"/>

  <xsl:value-of>
    <xsl:choose>
      <xsl:when test="empty($path)">
	<xsl:value-of select="$ppath"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:if test="$ppath != ''">
	  <xsl:value-of select="$ppath"/>
	  <xsl:if test="not(ends-with($ppath, '/'))">/</xsl:if>
	</xsl:if>
	<xsl:value-of select="concat($path,'/')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:value-of>
</xsl:function>

</xsl:stylesheet>
