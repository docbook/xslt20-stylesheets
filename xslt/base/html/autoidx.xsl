<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY primary   'normalize-space(concat(db:primary/@sortas, db:primary[not(@sortas)]))'>
<!ENTITY secondary 'normalize-space(concat(db:secondary/@sortas, db:secondary[not(@sortas)]))'>
<!ENTITY tertiary  'normalize-space(concat(db:tertiary/@sortas, db:tertiary[not(@sortas)]))'>

<!ENTITY section   '(ancestor-or-self::db:set
                     |ancestor-or-self::db:book
                     |ancestor-or-self::db:part
                     |ancestor-or-self::db:reference
                     |ancestor-or-self::db:partintro
                     |ancestor-or-self::db:chapter
                     |ancestor-or-self::db:appendix
                     |ancestor-or-self::db:preface
                     |ancestor-or-self::db:article
                     |ancestor-or-self::db:section
                     |ancestor-or-self::db:sect1
                     |ancestor-or-self::db:sect2
                     |ancestor-or-self::db:sect3
                     |ancestor-or-self::db:sect4
                     |ancestor-or-self::db:sect5
                     |ancestor-or-self::db:refentry
                     |ancestor-or-self::db:refsect1
                     |ancestor-or-self::db:refsect2
                     |ancestor-or-self::db:refsect3
                     |ancestor-or-self::db:simplesect
                     |ancestor-or-self::db:bibliography
                     |ancestor-or-self::db:glossary
                     |ancestor-or-self::db:index
                     |ancestor-or-self::db:webpage)[last()]'>

<!ENTITY section.id 'generate-id(&section;)'>
<!ENTITY sep '" "'>
<!ENTITY scope 'count(ancestor::node()|$scope) = count(ancestor::node())
                and ($role = @role or $type = @type or
                (string-length($role) = 0 and string-length($type) = 0))'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="h f m fn db t"
                version="2.0">


<!-- ********************************************************************
     $Id: autoidx.xsl 8562 2009-12-17 23:10:25Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:key name="primary"
         match="db:indexterm"
         use="&primary;"/>

<xsl:key name="endofrange"
         match="db:indexterm[@class='endofrange']"
         use="@startref"/>

<xsl:key name="sections" match="*[@xml:id]" use="@xml:id"/>

<xsl:template name="generate-index">
  <xsl:param name="scope" select="(ancestor::db:book|/)[last()]"/>

  <xsl:variable name="role">
    <xsl:if test="$index.on.role != 0">
      <xsl:value-of select="@role"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="type">
    <xsl:if test="$index.on.type != 0">
      <xsl:value-of select="@type"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="lang" select="f:l10n-language($scope)"/>

  <div class="generated-index">
    <xsl:for-each-group select="//db:indexterm[&scope;][not(@class = 'endofrange')]"
			group-by="f:group-index(&primary;, $lang)">
      <xsl:sort select="f:group-index(&primary;, $lang)" data-type="number"/>
      <xsl:apply-templates select="." mode="m:index-div">
	<xsl:with-param name="scope" select="$scope"/>
	<xsl:with-param name="role" select="$role"/>
	<xsl:with-param name="type" select="$type"/>
	<xsl:with-param name="lang" select="$lang"/>
	<xsl:with-param name="nodes" select="current-group()"/>
	<xsl:with-param name="group-index" select="current-grouping-key()"/>
      </xsl:apply-templates>
    </xsl:for-each-group>
  </div>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:index-div">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="lang" select="'en'"/>
  <xsl:param name="nodes" as="element()*"/>
  <xsl:param name="group-index"/>

  <xsl:if test="$nodes">
    <div class="generated-indexdiv">
      <h3>
        <xsl:value-of select="f:group-label($group-index, $lang)"/>
      </h3>
      <dl>
	<xsl:for-each-group select="$nodes" group-by="&primary;">
	  <xsl:sort select="&primary;" lang="{$lang}"/>
	  <xsl:apply-templates select="current-group()[1]" mode="m:index-primary">
	    <xsl:with-param name="scope" select="$scope"/>
	    <xsl:with-param name="role" select="$role"/>
	    <xsl:with-param name="type" select="$type"/>
	    <xsl:with-param name="lang" select="$lang"/>
	  </xsl:apply-templates>
	</xsl:for-each-group>
      </dl>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:index-primary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="lang" select="'en'"/>

  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)[&scope;]"/>
  <dt>
    <xsl:value-of select="db:primary"/>
    <xsl:for-each-group select="$refs[not(db:secondary) and not(db:see)]"
			group-by="concat(&primary;, &sep;, &section.id;)">
      <xsl:apply-templates select="." mode="m:reference">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:apply-templates>
    </xsl:for-each-group>

    <xsl:if test="$refs[not(db:secondary)]/*[self::db:see]">
      <xsl:for-each-group select="$refs[db:see]"
			  group-by="concat(&primary;, &sep;, &sep;, &sep;, db:see)">
	<xsl:apply-templates select="." mode="m:index-see">
	  <xsl:with-param name="scope" select="$scope"/>
	  <xsl:with-param name="role" select="$role"/>
	  <xsl:with-param name="type" select="$type"/>
	  <xsl:with-param name="lang" select="$lang"/>
	  <xsl:sort select="fn:upper-case(db:see)" lang="{$lang}"/>
	</xsl:apply-templates>
      </xsl:for-each-group>
    </xsl:if>
  </dt>
  <xsl:if test="$refs/db:secondary or $refs[not(db:secondary)]/*[self::db:seealso]">
    <dd>
      <dl>
	<xsl:if test="count(db:seealso) &gt; 1">
	  <xsl:message>Multiple see also's not supported: only using first</xsl:message>
	</xsl:if>

	<xsl:for-each-group select="$refs[db:seealso]"
			    group-by="concat(&primary;, &sep;, &sep;, &sep;, db:seealso[1])">
	  <xsl:apply-templates select="." mode="m:index-seealso">
	    <xsl:with-param name="scope" select="$scope"/>
	    <xsl:with-param name="role" select="$role"/>
	    <xsl:with-param name="type" select="$type"/>
	    <xsl:with-param name="lang" select="$lang"/>
	    <xsl:sort select="fn:upper-case(db:seealso[1])" lang="{$lang}"/>
	  </xsl:apply-templates>
	</xsl:for-each-group>
	<xsl:for-each-group select="$refs[db:secondary]" 
			    group-by="concat(&primary;, &sep;, &secondary;)">
	  <xsl:apply-templates select="." mode="m:index-secondary">
	    <xsl:with-param name="scope" select="$scope"/>
	    <xsl:with-param name="role" select="$role"/>
	    <xsl:with-param name="type" select="$type"/>
	    <xsl:with-param name="lang" select="$lang"/>
	    <xsl:with-param name="refs" select="current-group()"/>
	    <xsl:sort select="fn:upper-case(&secondary;)" lang="{$lang}"/>
	  </xsl:apply-templates>
	</xsl:for-each-group>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:index-secondary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="refs" as="element()*"/>
  <xsl:param name="lang" select="'en'"/>

  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <dt>
    <xsl:value-of select="db:secondary"/>
    <xsl:for-each-group select="$refs[not(db:tertiary) and not(db:see)]"
			group-by="concat($key, &sep;, &section.id;)">
      <xsl:apply-templates select="." mode="m:reference">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
	<xsl:with-param name="lang" select="$lang"/>
      </xsl:apply-templates>
    </xsl:for-each-group>

    <xsl:if test="$refs[not(db:tertiary)]/*[self::db:see]">
      <xsl:for-each-group select="$refs[db:see]"
			  group-by="concat(&primary;, &sep;, &secondary;, &sep;, &sep;, db:see)">
	<xsl:apply-templates select="." mode="m:index-see">
	  <xsl:with-param name="scope" select="$scope"/>
	  <xsl:with-param name="role" select="$role"/>
	  <xsl:with-param name="type" select="$type"/>
	  <xsl:with-param name="lang" select="$lang"/>
	  <xsl:sort select="fn:upper-case(db:see)" lang="{$lang}"/>
	</xsl:apply-templates>
      </xsl:for-each-group>
    </xsl:if>
  </dt>
  <xsl:if test="$refs/db:tertiary or $refs[not(db:tertiary)]/*[self::db:seealso]">
    <dd>
      <dl>
	<xsl:if test="count(db:seealso) &gt; 1">
	  <xsl:message>Multiple see also's not supported: only using first</xsl:message>
	</xsl:if>

	<xsl:for-each-group select="$refs[db:seealso]" 
			    group-by="concat(&primary;, &sep;, &secondary;, &sep;, &sep;, db:seealso[1])">
	  <xsl:apply-templates select="." mode="m:index-seealso">
	    <xsl:with-param name="scope" select="$scope"/>
	    <xsl:with-param name="role" select="$role"/>
	    <xsl:with-param name="type" select="$type"/>
	    <xsl:with-param name="lang" select="$lang"/>
	    <xsl:sort select="fn:upper-case(db:seealso[1])" lang="{$lang}"/>
	  </xsl:apply-templates>
	</xsl:for-each-group>

	<xsl:for-each-group select="$refs[db:tertiary]" 
			    group-by="concat($key, &sep;, &tertiary;)">
	  <xsl:apply-templates select="." mode="m:index-tertiary">
	    <xsl:with-param name="scope" select="$scope"/>
	    <xsl:with-param name="role" select="$role"/>
	    <xsl:with-param name="type" select="$type"/>
	    <xsl:with-param name="lang" select="$lang"/>
	    <xsl:with-param name="refs" select="current-group()"/>
	    <xsl:sort select="fn:upper-case(&tertiary;)" lang="{$lang}"/>
	  </xsl:apply-templates>
	</xsl:for-each-group>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:index-tertiary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="lang" select="'en'"/>
  <xsl:param name="refs" as="element()*"/>

  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <dt>
    <xsl:value-of select="db:tertiary"/>
    <xsl:for-each-group select="$refs[not(db:see)]"
			group-by="concat($key, &sep;, &section.id;)">
      <xsl:apply-templates select="." mode="m:reference">
	<xsl:with-param name="scope" select="$scope"/>
	<xsl:with-param name="role" select="$role"/>
	<xsl:with-param name="type" select="$type"/>
	<xsl:with-param name="lang" select="$lang"/>
      </xsl:apply-templates>
    </xsl:for-each-group>

    <xsl:if test="$refs/db:see">
      <xsl:for-each-group select="$refs[db:see]"
			  group-by="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, db:see)">
	<xsl:apply-templates select="." mode="m:index-see">
	  <xsl:with-param name="scope" select="$scope"/>
	  <xsl:with-param name="role" select="$role"/>
	  <xsl:with-param name="type" select="$type"/>
	  <xsl:with-param name="lang" select="$lang"/>
	  <xsl:sort select="fn:upper-case(db:see)" lang="{$lang}"/>
	</xsl:apply-templates>
      </xsl:for-each-group>
    </xsl:if>
  </dt>
  <xsl:if test="$refs/db:seealso">
    <dd>
      <dl>
	<xsl:if test="count(db:seealso) &gt; 1">
	  <xsl:message>Multiple see also's not supported: only using first</xsl:message>
	</xsl:if>

	<xsl:for-each-group select="$refs[db:seealso]"
			    group-by="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, db:seealso[1])">
	  <xsl:apply-templates select="." mode="m:index-seealso">
	    <xsl:with-param name="scope" select="$scope"/>
	    <xsl:with-param name="role" select="$role"/>
	    <xsl:with-param name="type" select="$type"/>
	    <xsl:with-param name="lang" select="$lang"/>
	    <xsl:sort select="fn:upper-case(db:seealso[1])" lang="{$lang}"/>
	  </xsl:apply-templates>
	</xsl:for-each-group>
      </dl>
    </dd>
  </xsl:if>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="lang" select="'en'"/>
  <xsl:param name="separator" select="', '"/>

  <xsl:value-of select="$separator"/>
  <xsl:choose>
    <xsl:when test="@zone and string(@zone)">
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="tobject"
                    select="ancestor::*[db:title or db:info/db:title][1]"/>
      <a href="{f:href(/,.)}">
        <xsl:attribute name="title">
          <xsl:apply-templates select="$tobject" mode="m:title-content"/>
        </xsl:attribute>
        <xsl:value-of select="position()"/>
      </a>

      <xsl:if test="key('endofrange', @xml:id)[&scope;]">
        <xsl:apply-templates select="key('endofrange', @xml:id)[&scope;][last()]"
                             mode="m:reference">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:with-param name="lang" select="$lang"/>
          <xsl:with-param name="separator" select="'-'"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="lang" select="'en'"/>
  <xsl:param name="zones"/>

  <xsl:choose>
    <xsl:when test="contains($zones, ' ')">
      <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
      <xsl:variable name="target" select="key('sections', $zone)[&scope;]"/>

      <a href="{f:href(/,$target[1])}">
        <xsl:apply-templates select="$target[1]" mode="m:index-title-content"/>
      </a>
      <xsl:text>, </xsl:text>
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="substring-after($zones, ' ')"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="zone" select="$zones"/>
      <xsl:variable name="target" select="key('sections', $zone)[&scope;]"/>
      <xsl:if test="$target">
        <a href="{f:href(/,$target[1])}">
          <xsl:apply-templates select="$target[1]" mode="m:index-title-content"/>
        </a>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:index-see">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="lang" select="'en'"/>

  <xsl:text> (</xsl:text>
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'see'"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:value-of select="db:see"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="db:indexterm" mode="m:index-seealso">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="lang" select="'en'"/>

  <xsl:for-each select="db:seealso">
    <xsl:sort select="fn:upper-case(.)" lang="{$lang}"/>
    <dt>
    <xsl:text>(</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'seealso'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>)</xsl:text>
    </dt>
  </xsl:for-each>
</xsl:template>

<xsl:template match="db:*" mode="m:index-title-content">
  <xsl:variable name="title">
    <xsl:apply-templates select="&section;" mode="m:object-title-markup"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
</xsl:template>

</xsl:stylesheet>
