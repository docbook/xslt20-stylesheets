<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:fp="http://docbook.org/xslt/ns/extension/private"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fp m mp xs"
                version="2.0">

<!-- This stylesheet profiles the DocBook document according to its
     effectivity attributes -->

<xsl:output method="xml" encoding="utf-8" indent="no" omit-xml-declaration="yes"/>

<xsl:template match="/">
  <xsl:param name="profile.separator" select="';'"/>
  <xsl:param name="profile.arch" select="''"/>
  <xsl:param name="profile.condition" select="''"/>
  <xsl:param name="profile.conformance" select="''"/>
  <xsl:param name="profile.lang" select="''"/>
  <xsl:param name="profile.os" select="''"/>
  <xsl:param name="profile.revision" select="''"/>
  <xsl:param name="profile.revisionflag" select="''"/>
  <xsl:param name="profile.role" select="''"/>
  <xsl:param name="profile.security" select="''"/>
  <xsl:param name="profile.userlevel" select="''"/>
  <xsl:param name="profile.vendor" select="''"/>

  <xsl:sequence select="f:profile(/,
                                  $profile.separator, $profile.arch, $profile.condition,
                                  $profile.conformance,
                                  $profile.lang, $profile.os, $profile.revision,
                                  $profile.revisionflag,
                                  $profile.role, $profile.security, $profile.userlevel,
                                  $profile.vendor)"/>
</xsl:template>

<xsl:function name="f:profile" as="document-node()">
  <xsl:param name="root" as="document-node()"/>
  <xsl:param name="profile.separator"/>
  <xsl:param name="profile.arch"/>
  <xsl:param name="profile.condition"/>
  <xsl:param name="profile.conformance"/>
  <xsl:param name="profile.lang"/>
  <xsl:param name="profile.os"/>
  <xsl:param name="profile.revision"/>
  <xsl:param name="profile.revisionflag"/>
  <xsl:param name="profile.role"/>
  <xsl:param name="profile.security"/>
  <xsl:param name="profile.userlevel"/>
  <xsl:param name="profile.vendor"/>

  <xsl:apply-templates select="$root" mode="mp:profile">
    <xsl:with-param name="profile.separator" select="$profile.separator"/>
    <xsl:with-param name="profile.arch" select="$profile.arch"/>
    <xsl:with-param name="profile.condition" select="$profile.condition"/>
    <xsl:with-param name="profile.conformance" select="$profile.conformance"/>
    <xsl:with-param name="profile.lang" select="$profile.lang"/>
    <xsl:with-param name="profile.os" select="$profile.os"/>
    <xsl:with-param name="profile.revision" select="$profile.revision"/>
    <xsl:with-param name="profile.revisionflag" select="$profile.revisionflag"/>
    <xsl:with-param name="profile.role" select="$profile.role"/>
    <xsl:with-param name="profile.security" select="$profile.security"/>
    <xsl:with-param name="profile.userlevel" select="$profile.userlevel"/>
    <xsl:with-param name="profile.vendor" select="$profile.vendor"/>
  </xsl:apply-templates>
</xsl:function>

<xsl:template match="/" mode="mp:profile">
  <xsl:param name="profile.separator" select="';'"/>
  <xsl:param name="profile.arch" select="''"/>
  <xsl:param name="profile.condition" select="''"/>
  <xsl:param name="profile.conformance" select="''"/>
  <xsl:param name="profile.lang" select="''"/>
  <xsl:param name="profile.os" select="''"/>
  <xsl:param name="profile.revision" select="''"/>
  <xsl:param name="profile.revisionflag" select="''"/>
  <xsl:param name="profile.role" select="''"/>
  <xsl:param name="profile.security" select="''"/>
  <xsl:param name="profile.userlevel" select="''"/>
  <xsl:param name="profile.vendor" select="''"/>

  <xsl:copy>
    <xsl:apply-templates mode="mp:profile">
      <xsl:with-param name="profile.separator" select="$profile.separator"/>
      <xsl:with-param name="profile.arch" select="$profile.arch"/>
      <xsl:with-param name="profile.condition" select="$profile.condition"/>
      <xsl:with-param name="profile.conformance" select="$profile.conformance"/>
      <xsl:with-param name="profile.lang" select="$profile.lang"/>
      <xsl:with-param name="profile.os" select="$profile.os"/>
      <xsl:with-param name="profile.revision" select="$profile.revision"/>
      <xsl:with-param name="profile.revisionflag" select="$profile.revisionflag"/>
      <xsl:with-param name="profile.role" select="$profile.role"/>
      <xsl:with-param name="profile.security" select="$profile.security"/>
      <xsl:with-param name="profile.userlevel" select="$profile.userlevel"/>
      <xsl:with-param name="profile.vendor" select="$profile.vendor"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<xsl:template match="*" mode="mp:profile">
  <xsl:param name="profile.separator" select="';'"/>
  <xsl:param name="profile.arch" select="''"/>
  <xsl:param name="profile.condition" select="''"/>
  <xsl:param name="profile.conformance" select="''"/>
  <xsl:param name="profile.lang" select="''"/>
  <xsl:param name="profile.os" select="''"/>
  <xsl:param name="profile.revision" select="''"/>
  <xsl:param name="profile.revisionflag" select="''"/>
  <xsl:param name="profile.role" select="''"/>
  <xsl:param name="profile.security" select="''"/>
  <xsl:param name="profile.userlevel" select="''"/>
  <xsl:param name="profile.vendor" select="''"/>

  <xsl:if test="fp:profile-ok(@arch, $profile.arch, $profile.separator)
                and fp:profile-ok(@condition, $profile.condition, $profile.separator)
                and fp:profile-ok(@conformance, $profile.conformance, $profile.separator)
                and fp:profile-ok(@lang, $profile.lang, $profile.separator)
                and fp:profile-ok(@os, $profile.os, $profile.separator)
                and fp:profile-ok(@revision, $profile.revision, $profile.separator)
                and fp:profile-ok(@revisionflag, $profile.revisionflag, $profile.separator)
                and fp:profile-ok(@role, $profile.role, $profile.separator)
                and fp:profile-ok(@security, $profile.security, $profile.separator)
                and fp:profile-ok(@userlevel, $profile.userlevel, $profile.separator)
                and fp:profile-ok(@vendor, $profile.vendor, $profile.separator)">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="mp:profile">
        <xsl:with-param name="profile.separator" select="$profile.separator"/>
        <xsl:with-param name="profile.arch" select="$profile.arch"/>
        <xsl:with-param name="profile.condition" select="$profile.condition"/>
        <xsl:with-param name="profile.conformance" select="$profile.conformance"/>
        <xsl:with-param name="profile.lang" select="$profile.lang"/>
        <xsl:with-param name="profile.os" select="$profile.os"/>
        <xsl:with-param name="profile.revision" select="$profile.revision"/>
        <xsl:with-param name="profile.revisionflag" select="$profile.revisionflag"/>
        <xsl:with-param name="profile.role" select="$profile.role"/>
        <xsl:with-param name="profile.security" select="$profile.security"/>
        <xsl:with-param name="profile.userlevel" select="$profile.userlevel"/>
        <xsl:with-param name="profile.vendor" select="$profile.vendor"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()"
	      mode="mp:profile">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<doc:function name="fp:profile-ok" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns true if the specified attribute is in the specified profile
</refpurpose>

<refdescription>
<para>This function compares the profile values actually specified on
an element with the set of values being used for profiling and returns
true if the current attribute is in the specified profile.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>attr</term>
<listitem>
<para>The profiling attribute.</para>
</listitem>
</varlistentry>
<varlistentry><term>prof</term>
<listitem>
<para>The desired profile.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True or false.</para>
</refreturn>
</doc:function>

<xsl:function name="fp:profile-ok" as="xs:boolean">
  <xsl:param name="attr" as="attribute()?"/>
  <xsl:param name="prof" as="xs:string?"/>
  <xsl:param name="profile.separator" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="not($attr) or not($prof)">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="node-values"
		    select="tokenize($attr, $profile.separator)"/>
      <xsl:variable name="profile-values"
		    select="tokenize($prof, $profile.separator)"/>

      <!-- take advantage of existential semantics of "=" -->
      <xsl:value-of select="$node-values = $profile-values"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="fp:profile-attribute-ok"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns true if the context node has the specified attribute and that attribute is in the specified profile
</refpurpose>

<refdescription>
<para>This function compares the profile values actually specified in the
named attribute on the context element
with the set of values being used for profiling and returns
true if the current attribute is in the specified profile.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>context</term>
<listitem>
<para>The context element.</para>
</listitem>
</varlistentry>
<varlistentry><term>attr</term>
<listitem>
<para>The profiling attribute.</para>
</listitem>
</varlistentry>
<varlistentry><term>prof</term>
<listitem>
<para>The desired profile.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>True or false.</para>
</refreturn>
</doc:function>

<xsl:function name="fp:profile-attribute-ok" as="xs:boolean">
  <xsl:param name="context" as="element()"/>
  <xsl:param name="attrname" as="xs:string?"/>
  <xsl:param name="prof" as="xs:string?"/>
  <xsl:param name="profile.separator" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="not($attrname) or not($prof)">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:when test="not($context/@*[local-name(.) = $attrname
		                    and namespace-uri(.) = ''])">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="fp:profile-ok($context/@*[local-name(.) = $attrname
                                                     and namespace-uri(.) = ''],
					 $prof, $profile.separator)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
