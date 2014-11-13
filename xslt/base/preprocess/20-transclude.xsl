<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fp="http://docbook.org/xslt/ns/extension/private"
		xmlns:mp="http://docbook.org/xslt/ns/mode/private"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:ta="http://docbook.org/xslt/ns/transclusion-annotation"
		exclude-result-prefixes="f fp mp xs">

<xsl:output method="xml" encoding="utf-8" indent="no"
            omit-xml-declaration="yes"/>

<!-- Separator for auto generated prefixes -->
<xsl:param name="psep" select="'---'"/>

<xsl:template match="/">
  <xsl:sequence select="f:transclude-and-adjust-idrefs(/)"/>
</xsl:template>

<xsl:function name="f:transclude-and-adjust-idrefs" as="node()+">
  <xsl:param name="doc" as="document-node()"/>

  <xsl:document>
    <xsl:sequence select="f:adjust-idrefs(f:transclude($doc))"/>
  </xsl:document>
</xsl:function>

<xsl:function name="f:transclude" as="node()+">
  <xsl:param name="doc" as="node()+"/>

  <xsl:variable name="expanded" select="f:expand-definitions($doc)"/>
  <xsl:variable name="resolved" select="f:resolve-references($expanded)"/>
  <xsl:sequence select="$resolved"/>
</xsl:function>

<xsl:function name="f:expand-definitions" as="node()+">
  <xsl:param name="doc" as="node()+"/>

  <xsl:apply-templates select="$doc" mode="mp:expand-definitions"/>
</xsl:function>

<xsl:template match="node()" mode="mp:expand-definitions">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="mp:expand-definitions"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="db:definitions[@definitionfile]" mode="mp:expand-definitions">
  <xsl:copy-of select="f:expand-definitions(doc(@definitionfile))"/>
  <xsl:copy>
    <xsl:copy-of select="@* except @definitionfile"/>
    <xsl:apply-templates mode="mp:expand-definitions"/>
  </xsl:copy>
</xsl:template>

<xsl:function name="f:resolve-references" as="node()+">
  <xsl:param name="doc" as="node()+"/>

  <xsl:apply-templates select="$doc" mode="mp:transclude"/>
</xsl:function>

<xsl:template match="node()" mode="mp:transclude">
  <xsl:param name="idfixup" select="'auto'" tunnel="yes"/>
  <xsl:param name="prefix" tunnel="yes"/>
  <xsl:copy>
    <xsl:copy-of select="@* except @xml:id"/>
    <xsl:if test="@xml:id">
      <xsl:choose>
	<xsl:when test="($idfixup = 'none') or @ta:linkscope">
	  <xsl:copy-of select="@xml:id"/>
	</xsl:when>
	<xsl:when test="$idfixup = 'strip'">
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="xml:id" select="concat($prefix, @xml:id)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:apply-templates mode="mp:transclude">
      <xsl:with-param name="prefix" select="if (@ta:linkscope) then '' else $prefix"/>   <!-- Prevent adding several prefixes on multi-level inclusions -->
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<!-- FIMXE: this stripping is there just to have more compact output -->
<xsl:template match="db:definitions" mode="mp:transclude" priority="1">
</xsl:template>

<xsl:template match="db:ref[@name]" mode="mp:transclude">
  <xsl:variable name="name" select="@name"/>
  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="@definitionfile">
	<xsl:variable name="defs" select="f:expand-definitions(doc(@definitionfile))"/>

	<xsl:choose>
	  <xsl:when test="$defs/db:def[@name = $name]">
	    <xsl:sequence select="($defs/db:def[@name = $name])[last()]/node()"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message>Error: definition of "<xsl:value-of select="$name"/>" was not found.</xsl:message>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="f:definition-for-name(@name, .)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="idfixup" select="if (@idfixup) then @idfixup else 'auto'"/>

  <xsl:variable name="linkscope" select="if (@linkscope) then @linkscope else 'near'"/>

  <xsl:variable name="prefix">
    <xsl:choose>
      <xsl:when test="$idfixup = 'auto'">
	<xsl:sequence select="concat(generate-id(.), $psep)"/>
      </xsl:when>
      <xsl:when test="$idfixup = 'prefix'">
	<xsl:sequence select="string(@prefix)"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ref-xmlid" select="@xml:id"/>

  <xsl:if test="count($content/(*|text()[normalize-space(.) ne ''])) > 1 and $ref-xmlid">
    <xsl:message>Error xml:id can't be added to definition without single outermost element.</xsl:message>
  </xsl:if>

  <xsl:for-each select="$content/node()">
    <xsl:copy>
      <xsl:variable name="xmlid" select="if ($ref-xmlid) then $ref-xmlid else @xml:id"/>
      <xsl:copy-of select="@* except @xml:id"/>
      <xsl:if test="self::*">
	<xsl:choose>
	  <xsl:when test="$idfixup = 'none' and $xmlid">
	    <xsl:attribute name="xml:id" select="$xmlid"/>
	  </xsl:when>
	  <xsl:when test="($idfixup = 'strip' and not($ref-xmlid)) or not($xmlid)">
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:attribute name="xml:id" select="concat($prefix, @xml:id)"/>
	  </xsl:otherwise>
	</xsl:choose>
	<!-- <xsl:attribute name="xml:base" select="$baseuri"/> -->
	<xsl:attribute name="ta:linkscope" select="$linkscope"/>
	<xsl:attribute name="ta:prefix" select="$prefix"/>
      </xsl:if>
      <xsl:apply-templates mode="mp:transclude">
	<xsl:with-param name="idfixup" select="$idfixup" tunnel="yes"/>
	<xsl:with-param name="prefix" select="$prefix" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:for-each>
</xsl:template>

<xsl:function name="f:definition-for-name" as="node()*">
  <xsl:param name="name" as="xs:string"/>
  <xsl:param name="context" as="node()"/>

  <xsl:variable name="closest-info-with-defs" select="$context/ancestor-or-self::*/db:info[db:definitions][1]"/>

  <xsl:choose>
    <xsl:when test="$closest-info-with-defs">
      <xsl:choose>
	<xsl:when test="$closest-info-with-defs/db:definitions/db:def[@name = $name]">
	  <xsl:sequence select="($closest-info-with-defs/db:definitions/db:def[@name = $name])[last()]/node()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:sequence select="f:definition-for-name($name, $closest-info-with-defs/../..)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Error: definition of "<xsl:value-of select="$name"/>" was not found.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:template match="db:ref[@parse eq 'text']" mode="mp:transclude">
  <xsl:variable name="baseuri" select="f:resolve-path(@fileref, base-uri(.))"/>

  <xsl:choose>
    <xsl:when test="@encoding">
      <xsl:sequence select="unparsed-text($baseuri, @encoding)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="unparsed-text($baseuri)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="db:ref[@fileref and (@parse eq 'xml' or not(@parse))]" mode="mp:transclude">
  <xsl:variable name="baseuri" select="f:resolve-path(@fileref, base-uri(.))"/>

  <xsl:variable name="doc">
    <xsl:choose>
      <xsl:when test="@xpointer">
	<xsl:sequence select="f:transclude(doc($baseuri)//*[@xml:id = current()/@xpointer])"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="f:transclude(doc($baseuri))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="idfixup" select="if (@idfixup) then @idfixup else 'auto'"/>

  <xsl:variable name="linkscope" select="if (@linkscope) then @linkscope else 'near'"/>

  <xsl:variable name="prefix">
    <xsl:choose>
      <xsl:when test="$idfixup = 'auto'">
	<xsl:sequence select="concat(generate-id(.), $psep)"/>
      </xsl:when>
      <xsl:when test="$idfixup = 'prefix'">
	<xsl:sequence select="string(@prefix)"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ref-xmlid" select="@xml:id"/>

  <xsl:for-each select="$doc/node()">
    <xsl:copy>
      <xsl:variable name="xmlid" select="if ($ref-xmlid) then $ref-xmlid else @xml:id"/>
      <xsl:copy-of select="@* except @xml:id"/>
      <xsl:if test="self::*">
	<xsl:choose>
	  <xsl:when test="$idfixup = 'none' and $xmlid">
	    <xsl:attribute name="xml:id" select="$xmlid"/>
	  </xsl:when>
	  <xsl:when test="($idfixup = 'strip' and not($ref-xmlid)) or not($xmlid)">
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:attribute name="xml:id" select="concat($prefix, @xml:id)"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:attribute name="xml:base" select="$baseuri"/>
	<xsl:attribute name="ta:linkscope" select="$linkscope"/>
	<xsl:attribute name="ta:prefix" select="$prefix"/>
      </xsl:if>
      <xsl:apply-templates mode="mp:transclude">
	<xsl:with-param name="idfixup" select="$idfixup" tunnel="yes"/>
	<xsl:with-param name="prefix" select="$prefix" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
    <xsl:copy-of select="following-sibling::node()"/>
  </xsl:for-each>
</xsl:template>

<xsl:function name="f:adjust-idrefs" as="node()+">
  <xsl:param name="doc" as="node()+"/>

  <xsl:apply-templates select="$doc" mode="mp:adjust-idrefs"/>
</xsl:function>

<xsl:template match="node()|@*" mode="mp:adjust-idrefs">
  <xsl:copy>
    <xsl:apply-templates select="@* | node()" mode="mp:adjust-idrefs"/>
  </xsl:copy>
</xsl:template>

<!-- FIXME: add support for @linkends, @zone, @arearefs -->
<!-- FIEMX: add support for xlink:href starting with # -->
<xsl:template match="@linkend | @endterm | @otherterm | @startref" mode="mp:adjust-idrefs">
  <xsl:variable name="idref" select="."/>

  <xsl:variable name="annotation" select="ancestor-or-self::*[@ta:linkscope][1]"/>
  <xsl:variable name="linkscope" select="($annotation/@ta:linkscope, 'near')[1]"/>
  <xsl:variable name="prefix" select="$annotation/@ta:prefix"/>

  <xsl:attribute name="{local-name(.)}">
    <xsl:choose>
      <xsl:when test="$linkscope = 'user'">
	<xsl:value-of select="$idref"/>
      </xsl:when>
      <xsl:when test="$linkscope = 'local'">
	<xsl:value-of select="concat($prefix, $idref)"/>
      </xsl:when>
      <xsl:when test="$linkscope = 'near'">
	<xsl:value-of select="f:nearest-matching-id($idref, ..)"/>
      </xsl:when>
      <xsl:when test="$linkscope = 'global'">
	<xsl:value-of select="f:nearest-matching-id($idref, root(.))"/>
      </xsl:when>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

<xsl:function name="f:nearest-matching-id" as="xs:string?">
  <xsl:param name="idref" as="xs:string"/>
  <xsl:param name="context" as="node()"/>

  <!-- FIXME: key() requires document-node() rooted subtree -->
  <!--  <xsl:variable name="targets" select="key('unprefixed-id', f:unprefixed-id($idref, $context), $context)"/> -->
  <xsl:variable name="targets" select="$context//*[@xml:id][f:unprefixed-id(@xml:id, .) eq f:unprefixed-id($idref, $context)]"/> 

  <xsl:choose>
    <xsl:when test="not($targets) and $context/..">
      <xsl:sequence select="f:nearest-matching-id($idref, $context/..)"/>
    </xsl:when>
    <xsl:when test="$targets">
      <xsl:sequence select="$targets[1]/string(@xml:id)"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- You might think we should generate a warning message here.
           The trouble is, it's possible that a downstream step
           in the pipeline knows what to do with this. So we just leave
           it alone and assume someone else will generate the error
           if it is an error.
      -->
      <xsl:value-of select="$idref"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- FIXME: type annotation should be without ?, find why it is called with empty sequence -->
<xsl:function name="f:unprefixed-id" as="xs:string?">
  <xsl:param name="id" as="xs:string?"/>
  <xsl:param name="context" as="node()"/>
  
  <xsl:variable name="prefix" select="$context/ancestor-or-self::*[@ta:prefix][1]/@ta:prefix"/>

  <xsl:sequence select="if ($prefix) then substring-after($id, $prefix) else $id"/>
</xsl:function>

<!--
<xsl:key name="unprefixed-id" match="*[@xml:id]" use="f:unprefixed-id(@xml:id, .)"/>
-->

<xsl:function name="f:resolve-path" as="xs:string">
  <xsl:param name="uri" as="xs:string"/>
  <xsl:param name="abspath" as="xs:string"/>

  <xsl:value-of select="f:resolve-path($uri, $abspath, static-base-uri())"/>
</xsl:function>

<!-- this three-argument form really only exists for testing -->
<xsl:function name="f:resolve-path" as="xs:string">
  <xsl:param name="uri" as="xs:string"/>
  <xsl:param name="abspath" as="xs:string"/>
  <xsl:param name="static-base-uri" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="matches($abspath, '^[-a-zA-Z0-9]+:')">
      <!-- $abspath is an absolute URI -->
      <xsl:value-of select="resolve-uri($uri, $abspath)"/>
    </xsl:when>
    <xsl:when test="matches($static-base-uri, '^[-a-zA-Z0-9]+:')">
      <!-- the static base uri is an absolute URI -->

      <!-- we have to make $abspath absolute (per the finicky def in XSLT 2.0) -->
      <!-- but if the static base uri is a file:// uri, we want to pull the -->
      <!-- file:// bit back off the front. -->

      <xsl:variable name="resolved-abs" select="resolve-uri($abspath, $static-base-uri)"/>
      <xsl:variable name="resolved" select="resolve-uri($uri, $resolved-abs)"/>

      <!-- strip off the leading file: -->
      <!-- this is complicated by two things, first it's not clear when we get
           file:///path and when we get file://path; second, on a Windows system
           if we get file://D:/path we have to remove both slashes -->
      <xsl:choose>
        <xsl:when test="matches($resolved, '^file://.:')">
          <xsl:value-of select="substring-after($resolved, 'file://')"/>
        </xsl:when>
        <xsl:when test="matches($resolved, '^file:/.:')">
          <xsl:value-of select="substring-after($resolved, 'file:/')"/>
        </xsl:when>
        <xsl:when test="starts-with($resolved, 'file://')">
          <xsl:value-of select="substring-after($resolved, 'file:/')"/>
        </xsl:when>
        <xsl:when test="starts-with($resolved, 'file:/')">
          <xsl:value-of select="substring-after($resolved, 'file:')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$resolved"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="matches($uri, '^[-a-zA-Z0-9]+:') or starts-with($uri, '/')">
      <!-- $uri is already absolute -->
      <xsl:value-of select="$uri"/>
    </xsl:when>
    <xsl:when test="not(starts-with($abspath, '/'))">
      <!-- if the $abspath isn't absolute, we lose -->
      <xsl:value-of select="error((), '$abspath in f:resolve-path is not absolute')"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- otherwise, resolve them together -->
      <xsl:variable name="base" select="replace($abspath, '^(.*)/[^/]*$', '$1')"/>

      <xsl:variable name="allsegs" select="(tokenize(substring-after($base, '/'), '/'),
                                         tokenize($uri, '/'))"/>
      <xsl:variable name="segs" select="$allsegs[. != '.']"/>
      <xsl:variable name="path" select="fp:resolve-dotdots($segs)"/>
      <xsl:value-of select="concat('/', string-join($path, '/'))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="fp:resolve-dotdots" as="xs:string*">
  <xsl:param name="segs" as="xs:string*"/>
  <xsl:variable name="pos" select="index-of($segs, '..')"/>
  <xsl:choose>
    <xsl:when test="empty($pos)">
      <xsl:sequence select="$segs"/>
    </xsl:when>
    <xsl:when test="$pos[1] = 1">
      <xsl:sequence select="fp:resolve-dotdots(subsequence($segs, 2))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="fp:resolve-dotdots(
                            (subsequence($segs, 1, $pos[1] - 2),
                             subsequence($segs, $pos[1] + 1)))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
