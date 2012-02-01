<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fn h m mp t u xlink xs"
                version="2.0">

<!-- Use internal variable for olink xlink role for consistency -->
<xsl:variable 
      name="xolink.role">http://docbook.org/xlink/role/olink</xsl:variable>

<!-- ============================================================ -->

<xsl:template match="db:anchor">
  <fo:inline>
    <xsl:call-template name="t:id"/>
  </fo:inline>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:xref" name="t:xref">
  <xsl:param name="xhref" select="@xlink:href"/>
  <!-- is the @xlink:href a local idref link? -->
  <xsl:param name="xlink.idref"
	     select="if (f:xpointer-idref($xhref) != '')
                     then f:xpointer-idref($xhref)
		     else ''"/>
  <xsl:param name="xlink.targets" select="key('id',$xlink.idref)"/>
  <xsl:param name="linkend.targets" select="key('id',@linkend)"/>
  <xsl:param name="target" select="($xlink.targets | $linkend.targets)[1]"/>

  <xsl:call-template name="t:check-id-unique">
    <xsl:with-param name="linkend"
		    select="if ($xlink.idref != '')
                            then $xlink.idref
			    else @linkend"/>
  </xsl:call-template>

  <xsl:variable name="xrefstyle">
    <xsl:choose>
      <xsl:when test="@role and not(@xrefstyle) 
                      and $use.role.as.xrefstyle != 0">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xrefstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="t:simple-xlink">
    <xsl:with-param name="content">
      <fo:inline xsl:use-attribute-sets="xref.properties">
	<xsl:choose>
	  <xsl:when test="@endterm">
	    <xsl:variable name="etargets" select="key('id',@endterm)"/>
	    <xsl:choose>
	      <xsl:when test="not($etargets)">
		<xsl:message>
		  <xsl:text>Endterm points to nonexistent ID: </xsl:text>
		  <xsl:value-of select="@endterm"/>
		</xsl:message>
		<xsl:text>???</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:apply-templates select="$etargets[1]" mode="m:endterm"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
  
	  <xsl:when test="$target/@xreflabel">
	    <xsl:call-template name="t:xref-xreflabel">
	      <xsl:with-param name="target" select="$target"/>
	    </xsl:call-template>
	  </xsl:when>
  
	  <xsl:when test="$target">
	    <!-- FIXME: why? -->
	    <xsl:if test="not(parent::db:citation)">
	      <xsl:apply-templates select="$target" mode="m:xref-to-prefix"/>
	    </xsl:if>
  
	    <xsl:apply-templates select="$target" mode="m:xref-to">
	      <xsl:with-param name="referrer" select="."/>
	      <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
	    </xsl:apply-templates>
  
	    <xsl:if test="not(parent::db:citation)">
	      <xsl:apply-templates select="$target" mode="m:xref-to-suffix"/>
	    </xsl:if>
	  </xsl:when>

	  <xsl:otherwise>
	    <xsl:message>
	      <xsl:text>ERROR: xref linking to </xsl:text>
	      <xsl:value-of select="@linkend|@xlink:href"/>
	      <xsl:text> has no generated link text.</xsl:text>
	    </xsl:message>
	    <xsl:text>???</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </fo:inline>
    </xsl:with-param>
  </xsl:call-template>

  <!-- Add standard page reference? -->
  <xsl:choose>
    <xsl:when test="not($target)">
      <!-- page numbers only for local targets -->
    </xsl:when>
    <xsl:when test="starts-with(normalize-space($xrefstyle), 'select:') 
		    and contains($xrefstyle, 'nopage')">
      <!-- negative xrefstyle in instance turns it off -->
    </xsl:when>
    <!-- positive xrefstyle already handles it -->
    <xsl:when test="not(starts-with(normalize-space($xrefstyle), 'select:') 
		    and (contains($xrefstyle, 'page')
                         or contains($xrefstyle, 'Page')))
                    and ($insert.xref.page.number = 'yes' 
                         or $insert.xref.page.number = '1')
                    or $target/self::db:para">
      <xsl:apply-templates select="$target" mode="m:page-citation">
	<xsl:with-param name="id" select="$target/@xml:id"/>
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<!-- Handled largely like an xref -->
<!-- To be done: add support for begin, end, and units attributes -->
<xsl:template match="db:biblioref" name="t:biblioref">
  <xsl:variable name="target" select="key('id',@linkend)[1]"/>

  <xsl:variable name="xrefstyle">
    <xsl:choose>
      <xsl:when test="@role and not(@xrefstyle) 
                      and $use.role.as.xrefstyle != 0">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xrefstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="t:check-id-unique">
    <xsl:with-param name="linkend" select="@linkend"/>
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="not($target)">
      <xsl:text>???</xsl:text>
    </xsl:when>

    <xsl:when test="@endterm">
      <fo:basic-link internal-destination="{@linkend}"
                     xsl:use-attribute-sets="xref.properties">
        <xsl:variable name="etargets" select="key('id',@endterm)"/>
        <xsl:choose>
          <xsl:when test="not($etargets)">
            <xsl:message>
	      <xsl:text>Endterm points to nonexistent ID: </xsl:text>
	      <xsl:value-of select="@endterm"/>
	    </xsl:message>
            <xsl:text>???</xsl:text>
          </xsl:when>
          <xsl:otherwise>
	    <xsl:apply-templates select="$etargets[1]" mode="m:endterm"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:basic-link>
    </xsl:when>

    <xsl:when test="$target/@xreflabel">
      <fo:basic-link internal-destination="{@linkend}"
                     xsl:use-attribute-sets="xref.properties">
        <xsl:call-template name="t:xref-xreflabel">
	  <xsl:with-param name="target" select="$target"/>
        </xsl:call-template>
      </fo:basic-link>
    </xsl:when>

    <xsl:otherwise>
      <xsl:if test="not(parent::db:citation)">
        <xsl:apply-templates select="$target" mode="m:xref-to-prefix"/>
      </xsl:if>

      <fo:basic-link internal-destination="{@linkend}"
                     xsl:use-attribute-sets="xref.properties">
        <xsl:apply-templates select="$target" mode="m:xref-to">
          <xsl:with-param name="referrer" select="."/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
	</xsl:apply-templates>
      </fo:basic-link>

      <xsl:if test="not(parent::db:citation)">
        <xsl:apply-templates select="$target" mode="m:xref-to-suffix"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="m:endterm">
  <!-- Process the children of the endterm element -->
  <xsl:variable name="endterm">
    <xsl:apply-templates/>
  </xsl:variable>

  <xsl:apply-templates select="$endterm" mode="mp:remove-ids"/>
</xsl:template>

<xsl:template match="*" mode="mp:remove-ids">
  <xsl:copy>
    <xsl:copy-of select="@*[name(.) != 'id']"/>
    <xsl:apply-templates mode="mp:remove-ids"/>
  </xsl:copy>
</xsl:template>

<!--- ==================================================================== -->

<xsl:template match="*" mode="m:xref-to-prefix"/>
<xsl:template match="*" mode="m:xref-to-suffix"/>

<xsl:template match="*" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:if test="$verbose != 0">
    <xsl:message>
      <xsl:text>Don't know what gentext to create for xref to: "</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>"</xsl:text>
    </xsl:message>
    <xsl:text>???</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:title" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <!-- for title, xref to the parent (parent of the info, that is) -->
  <xsl:apply-templates select="../.." mode="m:xref-to">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:abstract|db:article|db:bibliodiv|db:bibliomset
                     |db:biblioset|db:blockquote|db:calloutlist|db:colophon
                     |db:constraintdef|db:formalpara|db:glossdiv|db:indexdiv
                     |db:itemizedlist|db:legalnotice|db:msg|db:msgexplan|db:msgmain
                     |db:msgrel|db:msgset|db:msgsub|db:orderedlist|db:partintro
                     |db:productionset|db:qandadiv|db:refsynopsisdiv|db:segmentedlist
                     |db:set|db:setindex|db:sidebar|db:toc|db:variablelist"
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

<xsl:template match="db:caution|db:important|db:note|db:tip|db:warning"
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
  <xsl:param name="verbose" select="1"/>

  <xsl:call-template name="t:person-name"/>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:call-template name="t:person-name-list"/>
</xsl:template>

<xsl:template match="db:figure|db:example|db:table|db:equation" mode="m:xref-to">
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

<xsl:template match="db:task" mode="m:xref-to">
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
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select=".//db:command[1]" mode="m:xref"/>
</xsl:template>

<xsl:template match="db:funcsynopsis" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select=".//db:function[1]" mode="m:xref"/>
</xsl:template>

<xsl:template match="db:dedication|db:preface|db:chapter|db:appendix"
	      mode="m:xref-to">
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

<xsl:template match="db:bibliography|db:glossary|db:index" mode="m:xref-to">
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

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to-prefix">
  <xsl:text>[</xsl:text>
</xsl:template>

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to-suffix">
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:value-of select="f:biblioentry-label(.)"/>
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
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
  <!-- What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="db:bridgehead" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
  <!-- What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="db:qandaset|db:qandadiv" mode="m:xref-to">
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
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="db:question[1]" mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:question|db:answer" mode="m:xref-to">
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

<xsl:template match="db:part|db:reference" mode="m:xref-to">
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

<xsl:template match="db:refentry" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

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
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="db:refname[1]" mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:refname" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:step" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:value-of select="f:gentext(.,'Step')"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="m:number"/>
</xsl:template>

<xsl:template match="db:varlistentry" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="db:term[1]" mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:varlistentry/db:term" mode="m:xref-to">
  <xsl:param name="verbose" select="1"/>
  <!-- to avoid the comma that will be generated if there are several terms -->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:co" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="db:callout-bug"/>
</xsl:template>

<xsl:template match="db:area|db:areaset" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <!-- FIXME: 
  <xsl:call-template name="t:callout-bug">
    <xsl:with-param name="db:conum">
      <xsl:apply-templates select="." mode="db:conumber"/>
    </xsl:with-param>
  </xsl:call-template>
  -->
  <xsl:text>X</xsl:text>
</xsl:template>

<xsl:template match="db:book" mode="m:xref-to">
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

<xsl:template match="db:para" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose"/>

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

  <xsl:apply-templates select="$context" mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:link" name="t:link">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="targets" select="key('id',$linkend)"/>
  <xsl:param name="target" select="$targets[1]"/>

  <!-- FIXME: handle <link xlink:href="#foo"/> -->

  <xsl:variable name="xrefstyle">
    <xsl:choose>
      <xsl:when test="@role and not(@xrefstyle) 
                      and $use.role.as.xrefstyle != 0">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xrefstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="t:simple-xlink">
    <xsl:with-param name="content">
      <fo:inline xsl:use-attribute-sets="xref.properties">
	<xsl:choose>
	  <xsl:when test="not(empty(child::node()))">
	    <!-- If it has content, use it -->
	    <xsl:apply-templates/>
	  </xsl:when>
	  <!-- look for an endterm -->
	  <xsl:when test="@endterm">
	    <xsl:variable name="etargets" select="key('id',@endterm)"/>
	    <xsl:choose>
	      <xsl:when test="not($etargets)">
		<xsl:message>
		  <xsl:text>Endterm points to nonexistent ID: </xsl:text>
		  <xsl:value-of select="@endterm"/>
		</xsl:message>
		<xsl:text>???</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:apply-templates select="$etargets[1]" mode="m:endterm"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
	  <!-- Use the xlink:href if no other text -->
	  <xsl:when test="@xlink:href">
	    <xsl:call-template name="t:hyphenate-url">
	      <xsl:with-param name="url" select="@xlink:href"/>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message>
	      <xsl:text>Link element has no content and no endterm. </xsl:text>
	      <xsl:text>Nothing to show in the link to </xsl:text>
	      <xsl:value-of select="$target"/>
	    </xsl:message>
	    <xsl:text>???</xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
      </fo:inline>
    </xsl:with-param>
  </xsl:call-template>

  <!-- Add standard page reference? -->
  <xsl:choose>
    <!-- page numbering on link only enabled for @linkend -->
    <!-- There is no link element in DB5 with xlink:href -->
    <xsl:when test="not($linkend)">
      <!-- must have been an xlink:href -->
      <xsl:call-template name="t:hyperlink-url-display">
	<xsl:with-param name="url" select="@xlink:href"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with(normalize-space($xrefstyle), 'select:') 
                    and contains($xrefstyle, 'nopage')">
      <!-- negative xrefstyle in instance turns it off -->
    </xsl:when>
    <xsl:when test="(starts-with(normalize-space($xrefstyle), 'select:') 
                     and $insert.link.page.number = 'maybe'  
                     and (contains($xrefstyle, 'page')
                          or contains($xrefstyle, 'Page')))
                     or ($insert.link.page.number = 'yes' 
                         or $insert.link.page.number = '1')
                     or $target/self::db:para">
      <xsl:apply-templates select="$target" mode="m:page-citation">
	<xsl:with-param name="id" select="$linkend"/>
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:hyperlink-url-display">
  <!-- This template is called for all external hyperlinks;
       it determines whether the URL for the hyperlink is displayed,
       and how to display it (either inline or as a numbered footnote). -->
  <xsl:param name="url"/>

  <xsl:if test="not(empty(child::node()))
		and string(.) != $url
		and $ulink.show != 0">
    <!-- * Display the URL for this hyperlink only if it is non-empty, -->
    <!-- * and the value of its content is not a URL that is the same as -->
    <!-- * URL it links to, and if ulink.show is non-zero. -->
    <xsl:choose>
      <xsl:when test="$ulink.footnotes != 0 and not(ancestor::footnote)">
        <!-- * ulink.show and ulink.footnote are both non-zero; that -->
        <!-- * means we display the URL as a footnote (instead of inline) -->
        <fo:footnote>
          <xsl:call-template name="t:ulink-footnote-number"/>
	  <fo:footnote-body xsl:use-attribute-sets="footnote.properties">
	    <fo:block>
	      <xsl:call-template name="t:ulink-footnote-number"/>
	      <xsl:text> </xsl:text>
	      <fo:basic-link external-destination="url({$url})">
		<xsl:value-of select="$url"/>
	      </fo:basic-link>
	    </fo:block>
	  </fo:footnote-body>
	</fo:footnote>
      </xsl:when>
      <xsl:otherwise>
        <!-- * ulink.show is non-zero, but ulink.footnote is not; that -->
        <!-- * means we display the URL inline -->
	<fo:inline hyphenate="false" font-style="normal">
	  <!-- * put square brackets around the URL -->
	  <xsl:text> [</xsl:text>
	  <fo:basic-link external-destination="url({$url})">
	    <xsl:call-template name="t:hyphenate-url">
	      <xsl:with-param name="url" select="$url"/>
            </xsl:call-template>
          </fo:basic-link>
          <xsl:text>]</xsl:text>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="t:ulink-footnote-number">
  <fo:inline xsl:use-attribute-sets="footnote.mark.properties">
    <xsl:choose>
      <xsl:when test="$fo.processor = 'fop'">
	<xsl:attribute name="vertical-align">super</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="baseline-shift">super</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="fnum">
      <!-- * Determine the footnote number to display for this hyperlink, -->
      <!-- * by counting all foonotes, ulinks, and any elements that have -->
      <!-- * an xlink:href attribute that meets the following criteria: -->
      <!-- * -->
      <!-- * - the content of the element is not a URI that is the same -->
      <!-- *   URI as the value of the href attribute -->
      <!-- * - the href attribute is not an internal ID reference (does -->
      <!-- *   not start with a hash sign) -->
      <!-- * - the href is not part of an olink reference (the element -->
      <!-- * - does not have an xlink:role attribute that indicates it is -->
      <!-- *   an olink, and the href does not contain a hash sign) -->
      <!-- * - the element either has no xlink:type attribute or has -->
      <!-- *   an xlink:type attribute whose value is 'simple' -->
      <!-- FIXME: list in @from is probably not complete -->
      <xsl:number level="any" 
                  from="db:chapter|db:appendix|db:preface|db:article
			|db:refentry|db:bibliography[not(parent::db:article)]"
		  count="db:footnote[not(@label)][not(ancestor::db:tgroup)]
			 |db:link[node()][@xlink:href != .][not(ancestor::db:footnote)]
			 |*[node()][@xlink:href][not(@xlink:href = .)][not(starts-with(@xlink:href,'#'))]
                    [not(contains(@xlink:href,'#') and @xlink:role = $xolink.role)]
                    [not(@xlink:type) or @xlink:type='simple']
                    [not(ancestor::db:footnote)]"
		  format="1"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($footnote.number.symbols) &gt;= $fnum">
	<xsl:value-of select="substring($footnote.number.symbols, $fnum, 1)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:number value="$fnum" format="{$footnote.number.format}"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
</xsl:template>

<xsl:template name="t:hyphenate-url">
  <xsl:param name="url" select="''"/>

  <xsl:choose>
    <xsl:when test="$ulink.hyphenate = ''">
      <xsl:value-of select="$url"/>
    </xsl:when>
    <xsl:when test="string-length($url) &gt; 1">
      <xsl:variable name="char" select="substring($url, 1, 1)"/>
      <xsl:value-of select="$char"/>
      <xsl:if test="contains($ulink.hyphenate.chars, $char)">
        <!-- Do not hyphen in-between // -->
        <xsl:if test="not($char = '/' and substring($url,2,1) = '/')">
          <xsl:copy-of select="$ulink.hyphenate"/>
        </xsl:if>
      </xsl:if>
      <!-- recurse to the next character -->
      <xsl:call-template name="t:hyphenate-url">
        <xsl:with-param name="url" select="substring($url, 2)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$url"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- FIXME: support db:olink -->

<!-- ==================================================================== -->

<xsl:template name="t:title-xref">
  <xsl:param name="target" select="."/>
  <xsl:choose>
    <xsl:when test="$target/self::db:figure
                    or $target/self::db:example
                    or $target/self::db:equation
                    or $target/self::db:table
                    or $target/self::db:dedication
                    or $target/self::db:preface
                    or $target/self::db:bibliography
                    or $target/self::db:glossary
                    or $target/self::db:index
                    or $target/self::db:setindex
                    or $target/self::db:colophon">
      <xsl:call-template name="gentext-startquote"/>
      <xsl:text>FIXME:</xsl:text>
      <!--
      <xsl:apply-templates select="$target" mode="m:title-markup"/>
      -->
      <xsl:call-template name="gentext-endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>FIXME:</xsl:text>
      <!--
      <fo:inline font-style="italic">
        <xsl:apply-templates select="$target" mode="m:title-markup"/>
      </fo:inline>
      -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:number-xref">
  <xsl:param name="target" select="."/>
  <xsl:apply-templates select="$target" mode="m:label-markup"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="t:xref-xreflabel">
  <!-- called to process an xreflabel...you might use this to make  -->
  <!-- xreflabels come out in the right font for different targets, -->
  <!-- for example. -->
  <xsl:param name="target" select="."/>
  <xsl:value-of select="$target/@xreflabel"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:title" mode="m:xref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:command" mode="m:xref">
  <xsl:call-template name="t:inline-boldseq"/>
</xsl:template>

<xsl:template match="db:function" mode="m:xref">
  <xsl:call-template name="t:inline-monoseq"/>
</xsl:template>

<xsl:template match="*" mode="m:page-citation">
  <xsl:param name="id" select="'???'"/>

  <fo:basic-link internal-destination="{$id}"
                 xsl:use-attribute-sets="xref.properties">
    <fo:inline keep-together.within-line="always">
      <xsl:call-template name="substitute-markup">
        <xsl:with-param name="template">
          <xsl:call-template name="gentext-template">
            <xsl:with-param name="name" select="'page.citation'"/>
            <xsl:with-param name="context" select="'xref'"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </fo:inline>
  </fo:basic-link>
</xsl:template>

<xsl:template match="*" mode="m:pagenumber-markup">
  <fo:page-number-citation ref-id="{f:node-id(.)}"/>
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
      <xsl:text>FIXME:</xsl:text>
      <!--
      <xsl:apply-templates select="." mode="m:titleabbrev-markup"/>
      -->
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
      <fo:inline font-style="italic">
        <xsl:copy-of select="$title"/>
      </fo:inline>
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

</xsl:stylesheet>
