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

  <xsl:import href="docbook.xsl"/>

  <xsl:template match="*" mode="m:root">
    <xsl:variable name="chunks">
      <xsl:apply-templates select="."/>
    </xsl:variable>

    <xsl:message>Chunking...</xsl:message>
    <xsl:apply-templates select="$chunks" mode="m:chunk"/>
  </xsl:template>

  <xsl:template match="ch:chunk" mode="m:chunk" priority="1000">
    <xsl:message>Writing <xsl:value-of select="@href"/></xsl:message>

    <xsl:variable name="next" select="following-sibling::*[1]"/>
    <xsl:if test="$next and not($next/self::ch:chunk)">
      <xsl:message>Warning: "middle chunk"</xsl:message>
    </xsl:if>

    <xsl:result-document format="final" href="{@href}">
      <xsl:apply-templates mode="m:chunk"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="h:a" mode="m:chunk" priority="1000">
    <xsl:copy>
      <xsl:for-each select="@*[name(.) != 'href']">
	<xsl:copy/>
      </xsl:for-each>

      <xsl:choose>
	<xsl:when test="not(@href)"/>
	<xsl:when test="starts-with(@href, '#')">
	  <xsl:variable name="id" select="substring-after(@href,'#')"/>
	  <xsl:variable name="node" select="key('id', $id)"/>
	  <xsl:attribute name="href">
	    <xsl:value-of select="$node/ancestor::ch:chunk[1]/@href"/>
	    <xsl:copy-of select="@href"/>
	  </xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:copy-of select="@href"/>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates mode="m:chunk"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="m:chunk">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="m:chunk"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()|processing-instruction()|comment()" mode="m:chunk">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="db:book|db:chapter|db:appendix
                       |db:index|db:bibliography|db:glossary"
		priority="100000">
    <ch:chunk href="{f:chunk-filename(.)}">
      <xsl:next-match/>
    </ch:chunk>
  </xsl:template>

  <xsl:function name="f:chunk-filename" as="xs:string">
    <xsl:param name="node" as="element()"/>

    <!-- FIXME: need to handle directory and filename PIs -->

    <xsl:variable name="basename">
      <xsl:apply-templates select="$node" mode="m:chunk-filename"/>
    </xsl:variable>

    <xsl:value-of select="$basename"/>
  </xsl:function>

  <xsl:template match="*" mode="m:chunk-filename">
    <xsl:param name="recursive" select="false()" as="xs:boolean"/>

    <xsl:variable name="dbhtml-filename"
		  select="f:pi(processing-instruction('db-xsl'), 'filename')"/>

    <xsl:variable name="filename">
      <xsl:choose>
	<xsl:when test="$dbhtml-filename != ''">
	  <xsl:value-of select="$dbhtml-filename"/>
	</xsl:when>
	<!-- if this is the root element, use the root.filename -->
	<xsl:when test="not(parent::*) and $root.filename != ''">
	  <xsl:value-of select="$root.filename"/>
	  <xsl:value-of select="$html.ext"/>
	</xsl:when>
	<!-- if there's no dbhtml filename, and if we're to use IDs as -->
	<!-- filenames, then use the ID to generate the filename. -->
	<xsl:when test="@id and $use.id.as.filename != 0">
	  <xsl:value-of select="@id"/>
	  <xsl:value-of select="$html.ext"/>
	</xsl:when>
	<xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="not($recursive) and $filename != ''">
	<!-- if this chunk has an explicit name, use it -->
	<xsl:value-of select="$filename"/>
      </xsl:when>

      <xsl:when test="self::db:set">
	<xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	  <xsl:with-param name="recursive" select="true()"/>
	</xsl:apply-templates>
	<xsl:text>st</xsl:text>
	<xsl:number level="any" format="01"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:book">
	<xsl:text>bk</xsl:text>
	<xsl:number level="any" format="01"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:article">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>

	<xsl:text>ar</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:preface">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>

	<xsl:text>pr</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:chapter">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>

	<xsl:text>ch</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:appendix">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>

	<xsl:text>ap</xsl:text>
	<xsl:number level="any" format="a" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:part">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>

	<xsl:text>pt</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:reference">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>

	<xsl:text>rn</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:refentry">
	<xsl:if test="parent::db:reference">
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>

	<xsl:text>re</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:colophon">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>

	<xsl:text>co</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:sect1
		      or self::db:sect2
		      or self::db:sect3
		      or self::db:sect4
		      or self::db:sect5
		      or self::db:section">
	<xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	  <xsl:with-param name="recursive" select="true()"/>
	</xsl:apply-templates>
	<xsl:text>s</xsl:text>
	<xsl:number format="01"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:bibliography">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
	</xsl:if>

	<xsl:text>bi</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:glossary">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
	</xsl:if>

	<xsl:text>go</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:index">
	<xsl:if test="/db:set">
          <!-- in a set, make sure we inherit the right book info... -->
          <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
            <xsl:with-param name="recursive" select="true()"/>
          </xsl:apply-templates>
	</xsl:if>

	<xsl:text>ix</xsl:text>
	<xsl:number level="any" format="01" from="book"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:when test="self::db:setindex">
	<xsl:if test="/db:set">
	  <!-- in a set, make sure we inherit the right book info... -->
	  <xsl:apply-templates mode="m:chunk-filename" select="parent::*">
	    <xsl:with-param name="recursive" select="true()"/>
	  </xsl:apply-templates>
	</xsl:if>
	<xsl:text>si</xsl:text>
	<xsl:number level="any" format="01" from="set"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:when>

      <xsl:otherwise>
	<xsl:text>chunk-filename-error-</xsl:text>
	<xsl:value-of select="name(.)"/>
	<xsl:number level="any" format="01" from="set"/>
	<xsl:if test="not($recursive)">
	  <xsl:value-of select="$html.ext"/>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
