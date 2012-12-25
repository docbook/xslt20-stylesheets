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
		xmlns:tp="http://docbook.org/xslt/ns/template/private"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fn h m t tp u xlink xs"
                version="2.0">

<!-- ============================================================ -->

<xsl:template name="t:xlink">
  <xsl:param name="content" select="()"/>

  <xsl:choose>
    <xsl:when test="@xlink:type = 'extended'">
      <xsl:call-template name="t:extended-xlink"/>
    </xsl:when>
    <xsl:when test="@xlink:type = 'simple' or @xlink:href">
      <xsl:call-template name="t:simple-xlink">
        <xsl:with-param name="content">
          <xsl:choose>
            <xsl:when test="empty($content)">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="$content"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- It's just a normal, unlinked element -->
      <xsl:choose>
        <xsl:when test="empty($content)">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$content"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>

  <!-- This is a convenient place to hang the annotations check.
       I'm not absolutely convinced that convenient == best. -->
  <!-- This annotation stuff only works if we're in a para. That's a bug. -->
  <xsl:if test="ancestor::db:para">
    <xsl:variable name="para" select="ancestor::db:para[1]"/>
    <xsl:variable name="annotations" as="element()*">
      <xsl:variable name="id" select="@xml:id"/>
      <xsl:sequence select="if (@annotations)
                            then key('id',tokenize(@annotations,'\s'))
                            else ()"/>
      <xsl:sequence select="if ($id)
                            then //db:annotation[tokenize(@annotates,'\s')=$id]
                            else ()"/>
    </xsl:variable>

    <xsl:for-each select="$annotations">
      <xsl:variable name="id"
                    select="concat(f:node-id(.),'-',generate-id($para))"/>
      <a style="display: inline" onclick="show_annotation('{$id}')"
         id="annot-{$id}-on">
        <img border="0" src="{$annotation.graphic.open}" alt="[A+]"/>
      </a>
      <a style="display: none" onclick="hide_annotation('{$id}')"
         id="annot-{$id}-off">
        <img border="0" src="{$annotation.graphic.close}" alt="[A-]"/>
      </a>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:simple-xlink" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handle xlink:href attributes on inlines</refpurpose>

<refdescription>
<para>This template generates XHTML anchors for inline elements that
have xlink:href attributes.</para>

<note>
<para>Nested anchors can occur this way and this code does not, at
present, “unwrap” them as it should.</para>
</note>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the link. This defaults to the result of
calling “apply templates”.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the context node.</para>
</refreturn>
</doc:template>

<xsl:template name="t:simple-xlink">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:variable name="link">
    <xsl:choose>
      <xsl:when test="@xlink:href
		      and (not(@xlink:type)
		           or @xlink:type='simple')">
	<a>
	  <xsl:if test="@xlink.title">
	    <xsl:attribute name="title" select="@xlink:title"/>
	  </xsl:if>

	  <xsl:attribute name="href">
	    <xsl:choose>
	      <!-- if the href starts with # and does not contain an "(" -->
              <!-- or if the href starts with #xpointer(id(, it's just an ID -->
              <xsl:when test="starts-with(@xlink:href,'#')
                              and (not(contains(@xlink:href,'&#40;'))
                              or starts-with(@xlink:href,
			                     '#xpointer&#40;id&#40;'))">
                <xsl:variable name="idref" select="f:xpointer-idref(@xlink:href)"/>
                <xsl:variable name="target" select="key('id',$idref)[1]"/>

                <xsl:choose>
                  <xsl:when test="not($target)">
		    <xsl:message>
		      <xsl:text>XLink to nonexistent id: </xsl:text>
		      <xsl:value-of select="$idref"/>
		    </xsl:message>
                    <xsl:text>???</xsl:text>
                  </xsl:when>
		  <xsl:otherwise>
		    <xsl:attribute name="href" select="f:href(/,$target)"/>
		  </xsl:otherwise>
		</xsl:choose>
              </xsl:when>

              <!-- otherwise it's a URI -->
              <xsl:otherwise>
		<xsl:value-of select="@xlink:href"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:copy-of select="$content"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:copy-of select="$link"/>

  <xsl:variable name="inline" select="."/>
  <xsl:variable name="id" select="@xml:id"/>

  <xsl:variable name="annotations" as="element()*">
    <xsl:sequence select="if (@annotations)
                          then key('id',tokenize(@annotations,'\s'))
			  else ()"/>
    <xsl:sequence select="if ($id)
			  then //db:annotation[tokenize(@annotates,'\s')=$id]
			  else ()"/>
  </xsl:variable>

  <xsl:for-each select="$annotations">
    <xsl:variable name="id"
		    select="concat(f:node-id(.),'-',generate-id($inline))"/>
    <a style="display: inline" onclick="show_annotation('{$id}')"
	  id="annot-{$id}-on">
      <img border="0" src="{$annotation.graphic.open}" alt="[A+]"/>
    </a>
    <a style="display: none" onclick="hide_annotation('{$id}')"
	  id="annot-{$id}-off">
      <img border="0" src="{$annotation.graphic.close}" alt="[A-]"/>
    </a>
    <div style="display: none" id="annot-{$id}">
      <xsl:apply-templates select="." mode="m:annotation"/>
    </div>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:extended-xlink" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handle inline extended XLinks</refpurpose>

<refdescription>
<para>This template generates XHTML anchors for inline elements that
are XLink extended links.</para>

<para>FIXME: does not support extended links where the <emphasis>target</emphasis>
is the local resource, only extended links where the source is the local
resource.</para>

</refdescription>

<refreturn>
<para>The result tree markup for the context node.</para>
</refreturn>
</doc:template>

<!--
<citetitle xlink:type="extended">
  <link xlink:type="locator" xlink:href="http://docbook.org/" xlink:label="target"
        xlink:title="DocBook.org"/>
  <link xlink:type="locator" xlink:href="http://en.wikipedia.org/wiki/DocBook" xlink:label="target"
          xlink:title="DocBook on Wikipedia"/>
  <phrase xlink:type="resource" xlink:label="source">DocBook</phrase>
  <link xlink:type="arc" xlink:from="source" xlink:to="target"/>
</citetitle>
-->

<!-- An "inline" extended link. Assume we have 1 resource and "n" locators. -->
<xsl:template name="t:extended-xlink">
  <xsl:variable name="resource" select="*[@xlink:type='resource']"/>
  <xsl:variable name="locator" select="*[@xlink:type='locator']"/>

  <xsl:choose>
    <xsl:when test="empty($resource)">
      <xsl:message>
        <xsl:text>Warning: inline extended link with no resource</xsl:text>
        <xsl:sequence select="."/>
      </xsl:message>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="count($resource) &gt; 1">
        <xsl:message>
          <xsl:text>Warning: inline extended links are expected to have exactly one resource</xsl:text>
          <xsl:sequence select="."/>
        </xsl:message>
      </xsl:if>

      <span class="nhrefs">
        <span class="source">
          <xsl:apply-templates select="$resource[1]"/>
        </span>

        <xsl:variable name="arcs" select="*[@xlink:type='arc' and @xlink:from=$resource[1]/@xlink:label]"/>
        <xsl:variable name="to" select="*[@xlink:type='locator' and @xlink:label=$arcs/@xlink:to]"/>

        <xsl:if test="$to">
          <xsl:text> [</xsl:text>
          <xsl:for-each select="$to">
            <xsl:if test="position() &gt; 1">, </xsl:if>
            <a href="{@xlink:href}" class="arc">
              <xsl:choose>
                <xsl:when test="*[@xlink:type='title']">
                  <xsl:apply-templates select="*[@xlink:type='title'][1]"/>
                </xsl:when>
                <xsl:when test="@xlink:title">
                  <xsl:value-of select="@xlink:title"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>
                    <xsl:text>Warning: inline extended link locator without title</xsl:text>
                    <xsl:sequence select="."/>
                  </xsl:message>
                  <xsl:text>???</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </xsl:for-each>
          <xsl:text>]</xsl:text>
        </xsl:if>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
