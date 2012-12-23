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

<xsl:import href="../preprocess/1-logstruct.xsl"/>
<xsl:import href="../preprocess/1-db4to5.xsl"/>
<xsl:import href="../preprocess/15-transclude.xsl"/>
<xsl:import href="../preprocess/2-profile.xsl"/>
<xsl:import href="../preprocess/3-schemaext.xsl"/>
<xsl:import href="../preprocess/4-normalize.xsl"/>

<doc:function name="f:preprocess" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns result of preprocessing of input document by set of steps defined in 
<parameter>preprocess</parameter> parameter.</refpurpose>

<refdescription>
<para>This function applies preprocessing steps defined in
<parameter>preprocess</parameter> parameter to input in the fixed
oreder.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>root</term>
<listitem>
<para>Input document to be preprocessed.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Preprocessed document.</para>
</refreturn>
</doc:function>

<xsl:function name="f:preprocess" as="document-node()">
  <xsl:param name="root" as="document-node()"/>

  <xsl:variable name="steps" select="tokenize(normalize-space($preprocess), '\s')"/>

  <xsl:choose>
    <xsl:when test="empty($steps)">
      <xsl:sequence select="$root"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="$steps">
        <xsl:if test="not(. = ('db4to5', 'transclude', 'preprofile', 'profile', 'postprofile',
                               'schemaext', 'normalize'))">
          <xsl:message>
            <xsl:text>Warning: Preprocessing step "</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>" is not supported. Ignoring.</xsl:text>
          </xsl:message>
        </xsl:if>
      </xsl:for-each>

      <!-- We must always perform this step in order to retain base URI -->
      <xsl:variable name="logstruct" select="f:explicit-logical-structure($root)"/>

      <xsl:variable name="db4to5"
                    select="if (index-of($steps, 'db4to5'))
                            then f:convert-to-docbook5($logstruct)
                            else $logstruct"/>

      <xsl:variable name="transclude"
                    select="if (index-of($steps, 'transclude'))
                            then f:transclude-and-adjust-idrefs($db4to5)
                            else $db4to5"/>

      <xsl:variable name="preprofile"
                    select="if (index-of($steps, 'preprofile'))
                            then f:preprofile($transclude)
                            else $transclude"/>

      <xsl:variable name="profile"
                    select="if (index-of($steps, 'profile'))
			    then f:profile($preprofile, $profile.separator, $profile.lang,
                                           $profile.revisionflag, $profile.role,
                                           $profile.arch,
                                           $profile.audience,
                                           $profile.condition,
                                           $profile.conformance,
                                           $profile.os,
                                           $profile.outputformat,
                                           $profile.revision,
                                           $profile.security,
                                           $profile.userlevel,
                                           $profile.vendor,
                                           $profile.wordsize
                                          )
                            else $preprofile"/>

      <xsl:variable name="postprofile"
                    select="if (index-of($steps, 'postprofile'))
                            then f:postprofile($profile)
                            else $profile"/>

      <xsl:variable name="schemaext"
                    select="if (index-of($steps, 'schemaext'))
                            then f:resolve-schema-extensions($postprofile)
                            else $postprofile"/>

      <xsl:variable name="normalize"
                    select="if (index-of($steps, 'normalize'))
                            then f:normalize($schemaext)
                            else $schemaext"/>

      <xsl:sequence select="$normalize"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:preprofile" as="document-node()">
  <xsl:param name="root" as="document-node()"/>

  <xsl:sequence select="$root"/>
</xsl:function>

<xsl:function name="f:postprofile" as="document-node()">
  <xsl:param name="root" as="document-node()"/>

  <xsl:sequence select="$root"/>
</xsl:function>


</xsl:stylesheet>
