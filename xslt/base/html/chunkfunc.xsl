<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:ch="http://docbook.sf.net/xmlns/chunk"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="ch db f fn h m t xs"
                version="2.0">

  <xsl:param name="html.ext" select="'.html'"/>
  <xsl:param name="base.dir" select="''"/>

  <!-- ====================================================================== -->

  <xsl:function name="f:chunk-filename" as="xs:string">
    <xsl:param name="chunk" as="element()"/>

    <xsl:variable name="pifn" select="f:pi($chunk/processing-instruction('dbhtml'), 'filename')"/>

    <xsl:choose>
      <xsl:when test="string($pifn) != ''">
	<xsl:value-of select="$pifn"/>
      </xsl:when>
      <xsl:when test="$chunk/@xml:id and $use.id.as.filename != '0'">
	<xsl:value-of select="concat($chunk/@xml:id,$html.ext)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('chunk-', local-name($chunk),
                                     '-', generate-id($chunk), $html.ext)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- ====================================================================== -->

  <xsl:function name="f:href" as="xs:string">
    <xsl:param name="context" as="node()"/>
    <xsl:param name="node" as="element()"/>

    <xsl:variable name="context-chunk" select="f:find-chunk($context)"/>
    <xsl:variable name="node-chunk" select="f:find-chunk($node)"/>

    <xsl:choose>
      <xsl:when test="$context-chunk = $node-chunk">
        <xsl:value-of select="concat('#', f:node-id($node))"/>
      </xsl:when>
      <xsl:when test="$node-chunk = $node">
        <xsl:value-of select="f:chunk-filename($node-chunk)"/>
      </xsl:when>
      <xsl:when test="empty($node-chunk)">
        <xsl:message>
          <xsl:text>Warning: broken link to </xsl:text>
          <xsl:value-of select="f:node-id($node)"/>
          <xsl:text>; not in output.</xsl:text>
        </xsl:message>
        <xsl:value-of select="concat('#',f:node-id($node))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(f:chunk-filename($node-chunk),'#',f:node-id($node))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="f:find-chunk" as="element()?">
    <xsl:param name="node" as="node()"/>
    <xsl:sequence select="$node/ancestor-or-self::*[. intersect $chunks][1]"/>
  </xsl:function>

</xsl:stylesheet>
