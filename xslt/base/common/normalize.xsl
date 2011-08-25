<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:n="http://docbook.org/xslt/ns/normalize"
		xmlns:tp="http://docbook.org/xslt/ns/template/private"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f fn m mp n xlink xs ghost"
                version="2.0">

<xsl:param name="schemafile" select="''"/>

<!--	   select="'../../docbook/relaxng/dita4db/dita4db.rng'"/> -->

<xsl:param name="schema"
	   select="if ($schemafile = '')
		   then ()
		   else document($schemafile)"/>

<xsl:param name="schema-extensions" as="element()*" select="()"/>

<!-- ============================================================ -->
<!-- normalize content -->

<xsl:variable name="external.glossary">
  <xsl:choose>
    <xsl:when test="$glossary.collection = ''">
      <xsl:value-of select="()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="document($glossary.collection,.)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="external.bibliography">
  <xsl:choose>
    <xsl:when test="$bibliography.collection = ''">
      <xsl:value-of select="()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="document($bibliography.collection,.)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- ============================================================ -->

<doc:mode name="m:normalize" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for normalizing a DocBook document</refpurpose>

<refdescription>
<para>This mode is used to normalize an input document. Normalization
moves all <tag>title</tag>, <tag>subtitle</tag>, and
<tag>titleabbrev</tag> elements inside <tag>info</tag> wrappers,
creating the wrapper if necessary.</para>
<para>If the element being normalized has a default title (e.g.,
<tag>bibligraphy</tag> and <tag>glossary</tag>), the title is made
explicit during normalization.</para>
<para>External glossaries and bibliographies (not yet!) are also
copied by normalization.</para>
</refdescription>
</doc:mode>

<xsl:template match="/" mode="m:normalize">
  <xsl:apply-templates mode="m:normalize"/>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="n:normalize-movetitle" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Moves titles inside <tag>info</tag></refpurpose>

<refdescription>
<para>This template moves <tag>title</tag>, <tag>subtitle</tag>, and
<tag>titleabbrev</tag> elements inside an <tag>info</tag>.
</para>
</refdescription>

<refreturn>
<para>The transformed node.</para>
</refreturn>
</doc:template>

<xsl:template name="n:normalize-movetitle">
  <xsl:copy>
    <xsl:copy-of select="@*"/>

    <xsl:choose>
      <xsl:when test="db:info">
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:when>
      <xsl:when test="db:title|db:subtitle|db:titleabbrev">
	<xsl:element name="info" namespace="{$docbook-namespace}">
	  <xsl:call-template name="n:normalize-dbinfo">
	    <xsl:with-param name="copynodes"
			    select="db:title|db:subtitle|db:titleabbrev"/>
	  </xsl:call-template>
	</xsl:element>
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:copy>
</xsl:template>

<xsl:template match="db:title|db:subtitle|db:titleabbrev" mode="m:normalize">
  <xsl:if test="parent::db:info
                |parent::db:biblioentry
                |parent::db:bibliomixed
                |parent::db:bibliomset
                |parent::db:biblioset">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="m:normalize"/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="db:bibliography" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:bibliomixed|db:biblioentry" mode="m:normalize">
  <xsl:choose>
    <xsl:when test="not(node())"> <!-- totally empty -->
      <xsl:variable name="id" select="(@id|@xml:id)[1]"/>
      <xsl:choose>
	<xsl:when test="not($id)">
	  <xsl:message>
	    <xsl:text>Error: </xsl:text>
	    <xsl:text>empty </xsl:text>
	    <xsl:value-of select="local-name(.)"/>
	    <xsl:text> with no id.</xsl:text>
	  </xsl:message>
	</xsl:when>
	<xsl:when test="$external.bibliography/key('id', $id)">
	  <xsl:apply-templates select="$external.bibliography/key('id', $id)"
			       mode="m:normalize"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>
	    <xsl:text>Error: </xsl:text>
	    <xsl:text>$bibliography.collection doesn't contain </xsl:text>
	    <xsl:value-of select="$id"/>
	  </xsl:message>
	  <xsl:copy>
	    <xsl:copy-of select="@*"/>
	    <xsl:text>???</xsl:text>
	  </xsl:copy>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:glossary" mode="m:normalize">
  <xsl:variable name="glossary">
    <xsl:call-template name="n:normalize-generated-title">
      <xsl:with-param name="title-key" select="local-name(.)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$glossary/db:glossary[@role='auto']">
      <xsl:if test="not($external.glossary)">
	<xsl:message>
	  <xsl:text>Warning: processing automatic glossary </xsl:text>
	  <xsl:text>without an external glossary.</xsl:text>
	</xsl:message>
      </xsl:if>

      <xsl:element name="glossary" namespace="{$docbook-namespace}">
	<xsl:for-each select="$glossary/db:glossary/@*">
	  <xsl:if test="name(.) != 'role'">
	    <xsl:copy-of select="."/>
	  </xsl:if>
	</xsl:for-each>
	<xsl:copy-of select="$glossary/db:glossary/db:info"/>

	<xsl:variable name="seealsos" as="element()*">
	  <xsl:for-each select="$external.glossary//db:glossseealso">
	    <xsl:copy-of select="if (key('id', @otherterm))
				  then key('id', @otherterm)[1]
				  else key('glossterm', string(.))"/>
	  </xsl:for-each>
	</xsl:variable>

	<xsl:variable name="divs"
		      select="$glossary//db:glossary/db:glossdiv"/>

	<xsl:choose>
	  <xsl:when test="$divs and $external.glossary//db:glossdiv">
	    <xsl:apply-templates select="$external.glossary//db:glossdiv"
				 mode="m:copy-external-glossary">
	      <xsl:with-param name="terms"
			      select="//db:glossterm[not(parent::db:glossdef)]
				      |//db:firstterm
				      |$seealsos"/>
	      <xsl:with-param name="divs" select="$divs"/>
	    </xsl:apply-templates>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="$external.glossary//db:glossentry"
				 mode="m:copy-external-glossary">
	      <xsl:with-param name="terms"
			      select="//db:glossterm[not(parent::db:glossdef)]
				      |//db:firstterm
				      |$seealsos"/>
	      <xsl:with-param name="divs" select="$divs"/>
	    </xsl:apply-templates>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$glossary"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:index" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:setindex" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:abstract" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:legalnotice" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:note" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:tip" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:caution" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:warning" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:important" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="n:normalize-generated-title"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Generate a title, if necessary, and see that its moved into
<tag>info</tag></refpurpose>

<refdescription>
<para>If the context node does not have a title, this template will
generate one. In either case, the title will be placed or moved inside
an <tag>info</tag> which will be created if necessary.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>title-key</term>
<listitem>
<para>The key to use for creating the generated-text title if one is
necessary.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The transformed node.</para>
</refreturn>
</doc:template>

<xsl:template name="n:normalize-generated-title">
  <xsl:param name="title-key"/>

  <xsl:choose>
    <xsl:when test="db:title|db:info/db:title">
      <xsl:call-template name="n:normalize-movetitle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:copy-of select="@*"/>

	<xsl:choose>
	  <xsl:when test="db:info">
	    <xsl:element name="info" namespace="{$docbook-namespace}">
	      <xsl:copy-of select="db:info/@*"/>
	      <xsl:element name="title" namespace="{$docbook-namespace}">
		<xsl:apply-templates select="." mode="n:normalized-title">
		  <xsl:with-param name="title-key" select="$title-key"/>
		</xsl:apply-templates>
	      </xsl:element>
	      <xsl:copy-of select="db:info/preceding-sibling::node()"/>
	      <xsl:copy-of select="db:info/*"/>
	    </xsl:element>

	    <xsl:apply-templates select="db:info/following-sibling::node()"
				 mode="m:normalize"/>
	  </xsl:when>

	  <xsl:otherwise>
	    <xsl:variable name="node-tree">
	      <xsl:element name="title" namespace="{$docbook-namespace}">
		<xsl:attribute name="ghost:title" select="'yes'"/>
		<xsl:apply-templates select="." mode="n:normalized-title">
		  <xsl:with-param name="title-key" select="$title-key"/>
		</xsl:apply-templates>
	      </xsl:element>
	    </xsl:variable>

	    <xsl:element name="info" namespace="{$docbook-namespace}">
	      <xsl:call-template name="n:normalize-dbinfo">
		<xsl:with-param name="copynodes" select="$node-tree/*"/>
	      </xsl:call-template>
	    </xsl:element>
	    <xsl:apply-templates mode="m:normalize"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="n:normalized-title">
  <xsl:param name="title-key"/>
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="$title-key"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:info" mode="m:normalize">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:call-template name="n:normalize-dbinfo"/>
  </xsl:copy>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="n:normalize-dbinfo"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Copy the specified nodes, normalizing other content
if appropriate</refpurpose>

<refdescription>
<para>The specified nodes are copied. If the context node is an
<tag>info</tag> element, then the rest of its contents are also normalized.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>copynodes</term>
<listitem>
<para>The nodes to copy.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The transformed node.</para>
</refreturn>
</doc:template>

<xsl:template name="n:normalize-dbinfo">
  <xsl:param name="copynodes"/>

  <xsl:for-each select="$copynodes">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="m:normalize"/>
    </xsl:copy>
  </xsl:for-each>

  <xsl:if test="self::db:info">
    <xsl:apply-templates mode="m:normalize"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:inlinemediaobject
		     [(parent::db:programlisting
		       or parent::db:screen
		       or parent::db:literallayout
		       or parent::db:address
		       or parent::db:funcsynopsisinfo)
		     and db:imageobject
		     and db:imageobject/db:imagedata[@format='linespecific']]"
	      mode="m:normalize">

  <xsl:variable name="data"
		select="(db:imageobject
			 /db:imagedata[@format='linespecific'])[1]"/>
  <xsl:choose>
    <xsl:when test="$data/@entityref">
      <xsl:value-of select="unparsed-text(unparsed-entity-uri($data/@entityref))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="unparsed-text($data/@fileref)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:textobject
		     [parent::db:programlisting
		      or parent::db:screen
		      or parent::db:literallayout
		      or parent::db:address
		      or parent::db:funcsynopsisinfo]"
	      mode="m:normalize">
  <xsl:choose>
    <xsl:when test="db:textdata/@entityref">
      <xsl:value-of select="unparsed-text(unparsed-entity-uri(db:textdata/@entityref))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="unparsed-text(db:textdata/@fileref)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- CALS tables are normalized here so that they're in the right context later -->
<xsl:template match="db:tgroup" mode="m:normalize">
  <xsl:apply-templates select="." mode="m:cals-phase-1"/>
</xsl:template>

<!-- Verbatim environments are normalized here too -->
<xsl:template
    match="db:programlisting|db:address|db:screen|db:synopsis|db:literallayout"
    mode="m:normalize">

  <xsl:variable name="normalized" as="element()">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="m:normalize"/>
    </xsl:copy>
  </xsl:variable>

  <xsl:apply-templates select="$normalized" mode="m:verbatim-phase-1">
    <xsl:with-param name="origelem" select="."/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:programlistingco" mode="m:normalize">
  <xsl:variable name="normalized" as="element()">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="db:info"/>
      <xsl:copy-of select="db:areaspec"/>
      <db:programlisting>
        <xsl:copy-of select="db:programlisting/@*"/>
        <xsl:apply-templates select="db:programlisting/node()" mode="m:normalize"/>
      </db:programlisting>
      <xsl:copy-of select="db:calloutlist"/>
    </xsl:copy>
  </xsl:variable>

  <xsl:apply-templates select="$normalized" mode="m:verbatim-phase-1"/>
</xsl:template>

<xsl:template match="*" mode="m:normalize"
	      xmlns:r="http://nwalsh.com/xmlns/schema-remap/"
	      xmlns:rng="http://relaxng.org/ns/structure/1.0">

  <xsl:variable name="element" select="local-name(.)"/>
  <xsl:variable name="element-name" select="node-name(.)"/>
  <xsl:variable name="known" select="for $n in $schema-extensions
				     return
				        if (node-name($n) = $element-name)
					then $n
					else ()"/>


  <!-- There are some limitations here with multiple patterns that define
       the same element, with namespaced elements, and with multiple remaps.
       We can come back to them if they ever matter. -->
  <xsl:variable name="remap"
		select="$schema
			//rng:element[@name=$element and r:remap]/r:remap[1]"/>

  <!--
  <xsl:message>
    <xsl:text>normalize </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="name($remap/*[1])"/>
    <xsl:text>)</xsl:text>
  </xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="$known">
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:copy>
    </xsl:when>
    <xsl:when test="$remap">
      <xsl:variable name="mapped" as="element()">
	<xsl:choose>
	  <xsl:when test="$remap//r:content">
	    <xsl:apply-templates select="$remap/*" mode="m:remap">
	      <xsl:with-param name="attrs" select="@*"/>
	      <xsl:with-param name="content" select="node()"/>
	    </xsl:apply-templates>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:element name="{local-name($remap/*[1])}"
			 namespace="{namespace-uri($remap/*[1])}">
	      <xsl:copy-of select="$remap/*[1]/@*"/>
	      <xsl:copy-of select="@*"/>
	      <xsl:copy-of select="node()"/>
	    </xsl:element>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="$mapped" mode="m:normalize"/>
    </xsl:when>
    <xsl:when test="db:title|db:subtitle|db:titleabbrev|db:info/db:title">
      <xsl:choose>
        <xsl:when test="parent::db:biblioentry
                        |parent::db:bibliomixed
                        |parent::db:bibliomset
                        |parent::db:biblioset">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="m:normalize"/>
          </xsl:copy>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="n:normalize-movetitle"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:normalize">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="r:content" mode="m:remap"
	      xmlns:r="http://nwalsh.com/xmlns/schema-remap/">
  <xsl:param name="attrs" select="()"/>
  <xsl:param name="content" select="()"/>
  <xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template match="*" mode="m:remap">
  <xsl:param name="attrs" select="()"/>
  <xsl:param name="content" select="()"/>

  <xsl:element name="{local-name(.)}"
	       namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:if test="$attrs">
      <xsl:copy-of select="$attrs"/>
    </xsl:if>
    <xsl:apply-templates mode="m:remap">
      <xsl:with-param name="content" select="$content"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="text()|processing-instruction()|comment()" mode="m:remap">
  <xsl:param name="attrs" select="()"/>
  <xsl:param name="content" select="()"/>
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->
<!-- copy external glossary -->

<doc:mode name="m:copy-external-glossary"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for copying external glossary entries</refpurpose>

<refdescription>
<para>This mode is used to copy glossary entries from the
<parameter>glossary.collection</parameter> into the current document.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:glossdiv" mode="m:copy-external-glossary">
  <xsl:param name="terms"/>
  <xsl:param name="divs"/>

  <xsl:variable name="entries" as="element()*">
    <xsl:apply-templates select="db:glossentry" mode="m:copy-external-glossary">
      <xsl:with-param name="terms" select="$terms"/>
      <xsl:with-param name="divs" select="$divs"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="$entries">
    <xsl:choose>
      <xsl:when test="$divs">
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:copy-of select="db:info"/>
	  <xsl:copy-of select="$entries"/>
	</xsl:copy>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$entries"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:glossentry" mode="m:copy-external-glossary">
  <xsl:param name="terms"/>
  <xsl:param name="divs"/>

  <xsl:variable name="include"
                select="for $dterm in $terms
                           return 
                              for $gterm in db:glossterm
                                 return
                                    if (string($dterm) = string($gterm)
                                        or $dterm/@baseform = string($gterm))
                                    then 'x'
                                    else ()"/>

  <xsl:if test="$include != ''">
    <xsl:copy-of select="."/>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="m:copy-external-glossary">
  <xsl:param name="terms"/>
  <xsl:param name="divs"/>

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:copy-external-glossary">
      <xsl:with-param name="terms" select="$terms"/>
      <xsl:with-param name="divs" select="$divs"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
