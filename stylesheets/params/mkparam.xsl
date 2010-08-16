<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xsla="http://www.w3.org/1999/XSL/TransformAlias"
		version="2.0">

<xsl:param name="type"/>
<xsl:param name="name"/>

<xsl:output method="xml" indent="yes"/>

<xsl:namespace-alias stylesheet-prefix="xsla" result-prefix="xsl"/>

<xsl:template match="/" name="mkparam">
  <xsl:if test="$name != ''">
    <xsl:result-document href="{$name}.xml">
<refentry xmlns="http://docbook.org/ns/docbook"
	  xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
	  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	  xmlns:xlink="http://www.w3.org/1999/xlink"
	  version="5.0"
	  xml:id="{$name}">
<refmeta>
<refentrytitle><xsl:value-of select="$name"/></refentrytitle>
<refmiscinfo role="type"><xsl:value-of select="$type"/></refmiscinfo>
</refmeta>
<refnamediv>
<refname><xsl:value-of select="$name"/></refname>
<refpurpose>FIXME: TBA</refpurpose>
</refnamediv>

<refsynopsisdiv>
<src:fragment xml:id="{$name}.frag">
<xsl:choose>
  <xsl:when test="$type eq 'attribute set'">
    <xsla:attribute-set name="{$name}">
      <xsl:text> </xsl:text>
    </xsla:attribute-set>
  </xsl:when>
  <xsl:otherwise>
    <xsla:param name="{$name}" select="1"/>
  </xsl:otherwise>
</xsl:choose>
</src:fragment>
</refsynopsisdiv>

<refsect1><title>Description</title>

<para>FIXME: TBA</para>

</refsect1>
</refentry>
    </xsl:result-document>
  </xsl:if>


</xsl:template>

</xsl:stylesheet>
		