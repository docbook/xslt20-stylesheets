<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fn h m t u xlink xs"
                version="2.0">

<xsl:param name="use.role.as.xrefstyle" select="0"/>

<!-- ==================================================================== -->

<xsl:template match="db:anchor">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<doc:template match="db:link" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing link elements</refpurpose>

<refdescription>
<para>This template matches <tag>link</tag> elements. There are four
possibilities to consider: the link may have content or it may be
empty and the link may have an <tag class="attribute">xlink:href</tag>
attribute or a <tag class="attribute">linkend</tag> attribute:</para>

<informaltable rowheader="firstcol">
<tgroup cols="3">
<thead>
<row>
<entry/>
<entry>Has Content</entry>
<entry>Is Empty</entry>
</row>
</thead>
<tbody>
<row>
<entry>Has <tag class="attribute">xlink:href</tag></entry>
<entry>Content is a link to the specified URI.</entry>
<entry>The specified URI is used as the content. It is a link to the
specified URI.</entry>
</row>
<row>
<entry>Has <tag class="attribute">linkend</tag></entry>
<entry>Content is a link to the element identified.</entry>
<entry>Semantically equivalent to an <tag>xref</tag> to the element
identified.</entry>
</row>
</tbody>
</tgroup>
</informaltable>
</refdescription>
</doc:template>

<xsl:template match="db:link" name="db:link">
  <xsl:param name="title" select="string(db:alt[1])" as="xs:string"/>
  <xsl:param name="href" select="iri-to-uri(string(@xlink:href))" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="node()">
      <xsl:choose>
	<xsl:when test="$href != ''">
	  <a href="{$href}">
            <xsl:sequence select="f:html-attributes(.)"/>
	    <xsl:if test="$title != ''">
	      <xsl:attribute name="title" select="$title"/>
	    </xsl:if>
	    <xsl:apply-templates/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
          <xsl:if test="not(f:findid(@linkend,.))">
            <xsl:message>
              <xsl:text>Attempt to link to undefined ID: </xsl:text>
              <xsl:value-of select="@linkend"/>
            </xsl:message>
          </xsl:if>
	  <a href="{f:href(., f:findid(@linkend,.))}">
            <xsl:sequence select="f:html-attributes(.)"/>
	    <xsl:if test="$title != ''">
	      <xsl:attribute name="title" select="$title"/>
	    </xsl:if>
	    <xsl:apply-templates/>
	  </a>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
	<xsl:when test="$href != ''">
	  <a href="{$href}">
            <xsl:sequence select="f:html-attributes(.)"/>
	    <xsl:value-of select="$href"/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="db:xref"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="db:xref" match="db:xref"
	      xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing xref elements</refpurpose>

<refdescription>
<para>This template matches <tag>xref</tag> elements. There are two
possibilities to consider: the <tag>xref</tag> may have an
<tag class="attribute">xlink:href</tag>
attribute or a <tag class="attribute">linkend</tag> attribute</para>

<para>For the moment, I don't know what to do about the href case.</para>
</refdescription>
</doc:template>

<xsl:template match="db:xref" name="db:xref">
  <xsl:param name="linkend" select="(@linkend, if (starts-with(@xlink:href, '#')) then substring-after(@xlink:href, '#') else ())[1]"/>

  <xsl:variable name="target" select="f:findid($linkend,.)[1]"/>
  <xsl:variable name="refelem" select="node-name($target)"/>

  <xsl:if test="count(f:findid($linkend,.)) &gt; 1">
    <xsl:message>
      <xsl:text>Warning: the ID '</xsl:text>
      <xsl:value-of select="$linkend"/>
      <xsl:text>' is not unique.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="count($target) = 0">
      <xsl:message>
        <xsl:text>XRef to nonexistent id: </xsl:text>
        <xsl:value-of select="$linkend"/>
      </xsl:message>
      <span class="formatting-error">
        <xsl:sequence select="f:html-attributes(., @xml:id, ())"/>
	<xsl:text>???</xsl:text>
      </span>
    </xsl:when>

    <xsl:when test="@endterm">
      <xsl:variable name="etarget" select="f:findid(@endterm,.)[1]"/>

      <xsl:if test="count(f:findid(@endterm,.)) &gt; 1">
	<xsl:message>
	  <xsl:text>Warning: the ID '</xsl:text>
	  <xsl:value-of select="@endterm"/>
	  <xsl:text>' is not unique.</xsl:text>
	</xsl:message>
      </xsl:if>

      <xsl:choose>
	<xsl:when test="count($etarget) = 0">
          <xsl:message>
            <xsl:text>Endterm points to nonexistent id: </xsl:text>
	    <xsl:value-of select="@endterm"/>
          </xsl:message>
	  <a href="{f:href(/,$target)}">
            <xsl:sequence select="f:html-attributes(., @xml:id, ())"/>
	    <span class="formatting-error">
	      <xsl:text>???</xsl:text>
	    </span>
	  </a>
        </xsl:when>
        <xsl:otherwise>
	  <a href="{f:href(/,$target)}">
            <xsl:sequence select="f:html-attributes(., @xml:id, ())"/>
	    <xsl:apply-templates select="$etarget" mode="m:endterm"/>
	  </a>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="$target/@xreflabel">
      <a href="{f:href(/,$target)}">
	<xsl:call-template name="t:xref-xreflabel">
	  <xsl:with-param name="target" select="$target"/>
	</xsl:call-template>
      </a>
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-templates select="$target" mode="m:xref-to-prefix"/>

      <a href="{f:href(/,$target)}">
	<xsl:if test="$target/db:info/db:title">
	  <xsl:attribute name="title" select="string($target/db:info/db:title)"/>
	</xsl:if>
	<xsl:apply-templates select="$target" mode="m:xref-to">
	  <xsl:with-param name="referrer" select="."/>
	  <xsl:with-param name="xrefstyle">
	    <xsl:choose>
	      <xsl:when test="@role and not(@xrefstyle)
			      and $use.role.as.xrefstyle != 0">
		<xsl:value-of select="@role"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@xrefstyle"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:with-param>
	</xsl:apply-templates>
	</a>

      <xsl:apply-templates select="$target" mode="m:xref-to-suffix"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:biblioref">
  <!-- FIXME: handle the things that are special about biblioref! -->
  <xsl:call-template name="db:xref"/>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:xref-xreflabel" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing xreflabels</refpurpose>

<refdescription>
<para>This template is used to insert the markup associated with an
<tag class='attribute'>xreflabel</tag>.</para>
</refdescription>

<u:unittests template="xreflabel">
  <u:test>
    <u:param name="target" as="element()">
      <para xreflabel="LabelMe"/>
    </u:param>
    <u:result>'LabelMe'</u:result>
  </u:test>
  <u:test>
    <u:param name="target" as="element()">
      <para role="I-Have-No-XRefLabel"/>
    </u:param>
    <u:result>''</u:result>
  </u:test>
</u:unittests>

</doc:template>

<xsl:template name="t:xref-xreflabel" as="xs:string">
  <!-- called to process an xreflabel...you might use this to make  -->
  <!-- xreflabels come out in the right font for different targets, -->
  <!-- for example. -->
  <xsl:param name="target" select="."/>
  <xsl:value-of select="$target/@xreflabel"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:olink" name="t:olink">
  <xsl:variable name="localinfo" select="@localinfo"/>

  <!-- olinks resolved by stylesheet and target database -->
  <xsl:variable name="targetdoc.att" select="@targetdoc"/>
  <xsl:variable name="targetptr.att" select="@targetptr"/>

  <xsl:variable name="olink.lang" select="f:l10n-language(.,true())"/>
    
  <xsl:variable name="target.database.filename">
    <xsl:call-template name="t:select-target-database">
      <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
      <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
    </xsl:call-template>
  </xsl:variable>
    
  <xsl:variable name="target.database" 
		select="document($target.database.filename,/)"/>
    
  <xsl:if test="$olink.debug != 0">
    <xsl:message>
      <xsl:text>Olink debug: root element of target.database '</xsl:text>
      <xsl:value-of select="$target.database.filename"/>
      <xsl:text>' is '</xsl:text>
      <xsl:value-of select="local-name($target.database/*[1])"/>
      <xsl:text>'.</xsl:text>
    </xsl:message>
  </xsl:if>
    
  <xsl:variable name="olink.key">
    <xsl:call-template name="t:select-olink-key">
      <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
      <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
      <xsl:with-param name="target.database" select="$target.database"/>
    </xsl:call-template>
  </xsl:variable>
    
  <xsl:if test="string-length($olink.key) = 0">
    <xsl:message>
      <xsl:text>Error: unresolved olink: </xsl:text>
      <xsl:text>targetdoc/targetptr = '</xsl:text>
      <xsl:value-of select="$targetdoc.att"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$targetptr.att"/>
      <xsl:text>'.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="href">
    <xsl:call-template name="t:make-olink-href">
      <xsl:with-param name="olink.key" select="$olink.key"/>
      <xsl:with-param name="target.database" select="$target.database"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="hottext">
    <xsl:call-template name="t:olink-hottext">
      <xsl:with-param name="target.database" select="$target.database"/>
      <xsl:with-param name="olink.key" select="$olink.key"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="olink.docname.citation">
    <xsl:call-template name="t:olink-document-citation">
      <xsl:with-param name="olink.key" select="$olink.key"/>
      <xsl:with-param name="target.database" select="$target.database"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="olink.page.citation">
    <xsl:call-template name="t:olink-page-citation">
      <xsl:with-param name="olink.key" select="$olink.key"/>
      <xsl:with-param name="target.database" select="$target.database"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$href != ''">
      <a href="{$href}" class="olink">
	<xsl:copy-of select="$hottext"/>
      </a>
      <xsl:copy-of select="$olink.page.citation"/>
      <xsl:copy-of select="$olink.docname.citation"/>
    </xsl:when>
    <xsl:otherwise>
      <span class="olink"><xsl:copy-of select="$hottext"/></span>
      <xsl:copy-of select="$olink.page.citation"/>
      <xsl:copy-of select="$olink.docname.citation"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="pagenumber.markup">
  <!-- no-op in HTML -->
</xsl:template>

<xsl:template name="t:olink-outline">
  <xsl:param name="outline.base.uri"/>
  <xsl:param name="localinfo"/>
  <xsl:param name="return" select="href"/>

  <xsl:variable name="outline-file"
                select="concat($outline.base.uri,
                               $olink.outline.ext)"/>

  <xsl:variable name="outline" select="document($outline-file,.)/div"/>

  <xsl:variable name="node-href">
    <xsl:choose>
      <xsl:when test="$localinfo != ''">
        <xsl:variable name="node" select="$outline//*[@id=$localinfo]"/>
        <xsl:value-of select="$node/@href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$outline/@href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="node-xref">
    <xsl:choose>
      <xsl:when test="$localinfo != ''">
        <xsl:variable name="node" select="$outline//*[@id=$localinfo]"/>
        <xsl:copy-of select="$node/xref"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$outline/xref"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$return = 'href'">
      <xsl:value-of select="$node-href"/>
    </xsl:when>
    <xsl:when test="$return = 'xref'">
      <xsl:value-of select="$node-xref"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$node-xref"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:insert-title-markup" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting title markup</refpurpose>

<refdescription>
<para>This mode is used to insert title markup. Any element processed
in this mode should generate its title.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-title-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>

  <xsl:choose>
    <xsl:when test="$purpose = 'xref' and db:info/db:titleabbrev">
      <xsl:apply-templates select="." mode="m:titleabbrev-content"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:chapter|db:appendix" mode="m:insert-title-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>

  <xsl:choose>
    <xsl:when test="$purpose = 'xref'">
      <i>
        <xsl:copy-of select="$title"/>
      </i>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-subtitle-markup" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting subtitle markup</refpurpose>

<refdescription>
<para>This mode is used to insert subtitle markup. Any element processed
in this mode should generate its subtitle.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-subtitle-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="subtitle"/>

  <xsl:copy-of select="$subtitle"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-label-markup" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting label markup</refpurpose>

<refdescription>
<para>This mode is used to insert label markup. Any element processed
in this mode should generate its label (number).</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-label-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="label"/>

  <xsl:copy-of select="$label"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-pagenumber-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting page number markup</refpurpose>

<refdescription>
<para>This mode is used to insert page number markup. Any element processed
in this mode should generate its page number.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-pagenumber-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="pagenumber"/>

  <xsl:copy-of select="$pagenumber"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-direction-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting “direction” markup</refpurpose>

<refdescription>
<para>This mode is used to insert “direction”. Any element processed
in this mode should generate its direction number. The direction is
calculated from a reference and a referent (above or below, for example).</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-direction-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="direction"/>

  <xsl:copy-of select="$direction"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-olink-docname-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting <tag>olink</tag> document name markup</refpurpose>

<refdescription>
<para>This mode is used to insert <tag>olink</tag> document name markup.
Any element processed in this mode should generate its document name.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-olink-docname-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="docname"/>

  <span class="olinkdocname">
    <xsl:copy-of select="$docname"/>
  </span>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:endterm" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing endterms</refpurpose>

<refdescription>
<para>This mode is used to insert the markup associated with an
<tag class='attribute'>endterm</tag>.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:endterm">
  <!-- Process the children of the endterm element -->
  <xsl:variable name="endterm">
    <span>
      <xsl:apply-templates select="child::node()"/>
    </span>
  </xsl:variable>

  <xsl:apply-templates select="$endterm/*" mode="m:remove-ids"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:remove-ids" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for removing IDs</refpurpose>

<refdescription>
<para>This mode processes result (XHTML) markup, removing all ID
attributes.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:remove-ids">
  <xsl:choose>
    <xsl:when test="node-name(.) = h:a">
      <xsl:choose>
	<xsl:when test="(@name and count(@*) = 1)
			or (@id and count(@*) = 1)
			or (@id and @name and count(@*) = 2)">
	  <xsl:apply-templates mode="m:remove-ids"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:copy>
	    <xsl:for-each select="@*">
	      <xsl:choose>
		<xsl:when test="name(.) != 'name' and name(.) != 'id'">
		  <xsl:copy/>
		</xsl:when>
		<xsl:otherwise>
		  <!-- nop -->
		</xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
	  </xsl:copy>
	  <xsl:apply-templates mode="m:remove-ids"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:for-each select="@*">
          <xsl:choose>
            <xsl:when test="name(.) != 'id'">
              <xsl:copy/>
            </xsl:when>
	    <xsl:otherwise>
	      <!-- nop -->
	    </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:apply-templates mode="m:remove-ids"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:xref-to-prefix"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting cross reference prefixes</refpurpose>

<refdescription>
<para>This mode is used to insert prefixes before a cross reference.
Any element processed in this mode should generate the prefix appropriate
to cross references to that element.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to-prefix"
	      priority="100">
  <xsl:text>[</xsl:text>
</xsl:template>

<xsl:template match="*" mode="m:xref-to-prefix"/>

<!-- ==================================================================== -->

<doc:mode name="m:xref-to-suffix"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting cross reference suffixes</refpurpose>

<refdescription>
<para>This mode is used to insert suffixes after a cross reference.
Any element processed in this mode should generate the suffix appropriate
to cross references to that element.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to-suffix"
	      priority="100">
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="*" mode="m:xref-to-suffix"/>

<!-- ==================================================================== -->

<doc:mode name="m:xref-to"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting cross references</refpurpose>

<refdescription>
<para>This mode is used to insert cross references.
Any element processed in this mode should generate the text of a
cross references to that element.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:if test="$verbose">
    <xsl:message>
      <xsl:text>Don't know what gentext to create for xref to: "</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>", ("</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>")</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="db:title" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <!-- if you xref to a title, xref to the parent... -->
  <xsl:apply-templates select="parent::*[2]" mode="m:xref-to">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:abstract|db:authorblurb|db:personblurb|db:bibliodiv
		     |db:bibliomset|db:biblioset|db:blockquote|db:calloutlist
		     |db:caution|db:colophon|db:constraintdef|db:formalpara
		     |db:glossdiv|db:important|db:indexdiv|db:itemizedlist
		     |db:legalnotice|db:lot|db:msg|db:msgexplan|db:msgmain
		     |db:msgrel|db:msgset|db:msgsub|db:note|db:orderedlist
		     |db:partintro|db:productionset|db:qandadiv
		     |db:refsynopsisdiv|db:segmentedlist|db:set|db:setindex
		     |db:sidebar|db:tip|db:toc|db:variablelist|db:warning"
              mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <!-- catch-all for things with (possibly optional) titles -->
  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:author|db:editor|db:othercredit|db:personname"
	      mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:call-template name="t:person-name"/>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:call-template name="t:person-name-list"/>
</xsl:template>

<xsl:template match="db:figure|db:example|db:table|db:equation" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:procedure" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:cmdsynopsis" mode="m:xref-to">
  <xsl:apply-templates select="(.//db:command)[1]" mode="m:xref"/>
</xsl:template>

<xsl:template match="db:funcsynopsis" mode="m:xref-to">
  <xsl:apply-templates select="(.//db:function)[1]" mode="m:xref"/>
</xsl:template>

<xsl:template match="db:dedication|db:preface
		     |db:chapter|db:appendix|db:article" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:bibliography" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:variable name="context" select="(ancestor::db:bibliography
				       |ancestor::db:bibliolist)[last()]"/>

  <!-- handles both biblioentry and bibliomixed -->
  <xsl:choose>
    <xsl:when test="$bibliography.numbered != 0">
      <xsl:choose>
	<xsl:when test="$context/self::db:bibliography">
	  <xsl:number from="db:bibliography"
		      count="db:biblioentry|db:bibliomixed"
		      level="any" format="1"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:number from="db:bibliolist"
		      count="db:biblioentry|db:bibliomixed"
		      level="any" format="1"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="*[1]/self::db:abbrev">
      <xsl:apply-templates select="*[1]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@id"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:glossary" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:glossentry" mode="m:xref-to">
  <xsl:choose>
    <xsl:when test="$glossentry.show.acronym = 'primary'">
      <xsl:choose>
        <xsl:when test="db:acronym|db:abbrev">
          <xsl:apply-templates select="(db:acronym|db:abbrev)[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="db:glossterm[1]" mode="m:xref-to"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="db:glossterm[1]" mode="m:xref-to"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:glossterm" mode="m:xref-to">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:index" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:listitem" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:section|db:simplesect
                     |db:sect1|db:sect2|db:sect3|db:sect4|db:sect5
                     |db:refsect1|db:refsect2|db:refsect3|db:refsection"
	      mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
  <!-- FIXME: What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="db:bridgehead" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
  <!-- FIXME: What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="db:qandaset" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:qandadiv" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:qandaentry" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="db:question[1]" mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:question|db:answer" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:part|db:reference" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:refentry" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:choose>
    <xsl:when test="db:refmeta/db:refentrytitle">
      <xsl:apply-templates select="db:refmeta/db:refentrytitle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="db:refnamediv/db:refname[1]"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="db:refmeta/db:manvolnum"/>
</xsl:template>

<xsl:template match="db:refnamediv" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="db:refname[1]" mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:refname" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:step" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Step'"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="m:number"/>
</xsl:template>

<xsl:template match="db:varlistentry" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="db:term[1]" mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:varlistentry/db:term" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <!-- to avoid the comma that will be generated if there are several terms -->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:co" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:apply-templates select="." mode="m:callout-bug"/>
</xsl:template>

<xsl:template match="db:areaset" mode="m:xref-to">
  <xsl:call-template name="t:callout-bug">
    <xsl:with-param name="conum"
		    select="count(preceding-sibling::db:areaset
			    |preceding-sibling::db:area)
			    +1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:area" mode="m:xref-to">
  <xsl:call-template name="t:callout-bug">
    <xsl:with-param name="conum"
		    select="count(parent::db:areaset/preceding-sibling::db:areaset
			          |parent::db:areaset/preceding-sibling::db:area
				  |preceding-sibling::db:area)
			    +1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:book" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:para" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:variable name="context" select="(ancestor::db:simplesect
                                       |ancestor::db:section
                                       |ancestor::db:sect1
                                       |ancestor::db:sect2
                                       |ancestor::db:sect3
                                       |ancestor::db:sect4
                                       |ancestor::db:sect5
                                       |ancestor::db:refsection
                                       |ancestor::db:refsect1
                                       |ancestor::db:refsect2
                                       |ancestor::db:refsect3
                                       |ancestor::db:chapter
                                       |ancestor::db:appendix
                                       |ancestor::db:preface
                                       |ancestor::db:partintro
                                       |ancestor::db:dedication
                                       |ancestor::db:colophon
                                       |ancestor::db:bibliography
                                       |ancestor::db:index
                                       |ancestor::db:glossary
                                       |ancestor::db:glossentry
                                       |ancestor::db:listitem
                                       |ancestor::db:varlistentry)[last()]"/>

  <xsl:apply-templates select="$context" mode="m:xref-to"/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:xref" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting markup in an xref</refpurpose>

<refdescription>
<para>This mode is (sometimes) used when generating cross references.
Any element processed
in this mode should generate markup appropriate to appear in a
cross-reference.</para>
</refdescription>
</doc:mode>

<xsl:template match="title" mode="m:xref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="command" mode="m:xref">
  <xsl:call-template name="t:inline-boldseq"/>
</xsl:template>

<xsl:template match="function" mode="m:xref">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

</xsl:stylesheet>
