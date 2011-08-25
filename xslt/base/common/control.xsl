<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f m mp t xs"
                version="2.0">

<xsl:key name="id" match="*" use="@xml:id"/>
<xsl:key name="genid" match="*" use="generate-id(.)"/>

<xsl:function name="f:root-element" as="element()">
  <xsl:param name="document"/>
  <xsl:param name="rootid"/>

  <xsl:if test="$rootid != '' and not(key('id', $rootid, $document))">
    <xsl:message terminate="yes">
      <xsl:text>ID '</xsl:text>
      <xsl:value-of select="$rootid"/>
      <xsl:text>' not found in document.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="root" as="element()">
    <xsl:choose>
      <xsl:when test="$rootid != ''">
	<xsl:sequence select="key('id', $rootid, $document)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="$document/*[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:sequence select="$root"/>
</xsl:function>

<xsl:function name="f:docbook-root-element" as="element()">
  <xsl:param name="document"/>
  <xsl:param name="rootid"/>

  <xsl:variable name="root" select="f:root-element($document,$rootid)"/>

  <xsl:if test="not($root.elements/*[node-name(.) = node-name($root)])">
    <xsl:call-template name="t:root-terminate">
      <xsl:with-param name="root" select="$document"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:sequence select="$root"/>
</xsl:function>

<xsl:function name="f:docbook-root-element" as="element()">
  <xsl:param name="document"/>
  <xsl:sequence select="f:docbook-root-element($document,'')"/>
</xsl:function>

<!-- ============================================================ -->

<doc:template name="t:root-terminate" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Aborts processing if the root element is inappropriate</refpurpose>

<refdescription>
<para>This template is called if the stylesheet detects that the root
element (or the element selected for processing with
<parameter>rootid</parameter>) is not an appropriate root element.
</para>
</refdescription>

<refreturn>
<para>Does not return.</para>
</refreturn>
</doc:template>

<xsl:template name="t:root-terminate">
  <xsl:param name="root" select="/"/>

  <xsl:message terminate="yes">
    <xsl:text>Error: document root element (</xsl:text>
    <xsl:value-of select="name($root/*[1])"/>
    <xsl:if test="$rootid">
      <xsl:text>, $rootid=</xsl:text>
      <xsl:value-of select="$rootid"/>
    </xsl:if>
    <xsl:text>) </xsl:text>

    <xsl:text>must be one of the following elements: </xsl:text>
    <xsl:value-of select="for $elem in $root.elements/*[position() &lt; last()]
			  return local-name($elem)" separator=", "/>
    <xsl:text>, or </xsl:text>
    <xsl:value-of select="local-name($root.elements/*[last()])"/>
    <xsl:text>.</xsl:text>
  </xsl:message>
</xsl:template>


</xsl:stylesheet>
