<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fp="http://docbook.org/xslt/ns/extension"
                xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:tp="http://docbook.org/xslt/ns/template/private"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f fp ghost h m mp t tp u xs"
                version="2.0">

<xsl:param name="callout.defaultcolumn" select="60"/>
<xsl:param name="verbatim.trim.blank.lines" select="1"/>

<xsl:param name="linenumbering" as="element()*">
<ln path="literallayout" everyNth="2" width="3" separator=" " padchar=" " minlines="3"/>
<ln path="programlisting" everyNth="2" width="3" separator=" " padchar=" " minlines="3"/>
<ln path="programlistingco" everyNth="2" width="3" separator=" " padchar=" " minlines="3"/>
<ln path="screen" everyNth="2" width="3" separator="" padchar=" " minlines="3"/>
<ln path="synopsis" everyNth="2" width="3" separator="" padchar=" " minlines="3"/>
<ln path="address" everyNth="0"/>
<ln path="epigraph/literallayout" everyNth="0"/>
</xsl:param>

</xsl:stylesheet>
