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

<xsl:template name="t:verbatim-patch-html">
  <xsl:param name="content" as="node()*"/>
  <xsl:param name="areas" as="node()*"/>

  <xsl:variable name="everyNth"  select="f:lineNumbering(.,'everyNth')" as="xs:integer?"/>
  <xsl:variable name="width"     select="f:lineNumbering(.,'width')" as="xs:integer?"/>
  <xsl:variable name="padchar"   select="f:lineNumbering(.,'padchar')"/>
  <xsl:variable name="separator" select="f:lineNumbering(.,'separator')"/>
  <xsl:variable name="minlines"  select="f:lineNumbering(.,'minlines')" as="xs:integer?"/>
  <xsl:variable name="asTable"   select="f:lineNumbering(.,'asTable')" as="xs:boolean"/>

  <xsl:variable name="pl-empty-tags" as="node()*">
    <xsl:apply-templates select="$content" mode="m:patch-empty-elements"/>
  </xsl:variable>

  <!--
  <xsl:message>
    <EMPTY xmlns:ghost="http://docbook.org/ns/docbook/ephemeral" ghost:foo='bar'>
      <xsl:copy-of select="$pl-empty-tags"/>
    </EMPTY>
  </xsl:message>
  -->

  <xsl:variable name="pl-no-lb" as="node()*">
    <xsl:apply-templates select="$pl-empty-tags"
			 mode="mp:pl-no-lb"/>
  </xsl:variable>

  <!--
  <xsl:message>
    <NOLB xmlns:ghost="http://docbook.org/ns/docbook/ephemeral" ghost:foo='bar'>
      <xsl:copy-of select="$pl-no-lb"/>
    </NOLB>
  </xsl:message>
  -->

  <xsl:variable name="pl-no-wrap-lb" as="node()*">
    <xsl:call-template name="t:unwrap">
      <xsl:with-param name="unwrap" select="xs:QName('ghost:br')"/>
      <xsl:with-param name="content" select="$pl-no-lb"/>
    </xsl:call-template>
  </xsl:variable>

  <!--
  <xsl:message>NOWRAPLB</xsl:message>
  <xsl:for-each select="$pl-no-wrap-lb">
    <xsl:message><xsl:sequence select="."/></xsl:message>
  </xsl:for-each>
  -->

  <xsl:variable name="pl-lines" as="element(ghost:line)*">
    <xsl:call-template name="tp:wrap-lines">
      <xsl:with-param name="nodes" select="$pl-no-wrap-lb"/>
    </xsl:call-template>
  </xsl:variable>

  <!--
  <xsl:message>
    <LINES>
      <xsl:copy-of select="$pl-lines"/>
    </LINES>
  </xsl:message>
  -->

  <xsl:variable name="pl-callouts" as="element(ghost:line)*">
    <xsl:apply-templates select="$pl-lines" mode="mp:pl-callouts">
      <xsl:with-param name="areas" select="$areas"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!--
  <xsl:message>
    <PL-LINES>
      <xsl:copy-of select="$pl-callouts"/>
    </PL-LINES>
  </xsl:message>
  -->

  <xsl:variable name="pl-removed-lines" as="node()*">
    <xsl:choose>
      <xsl:when test="$asTable">
        <xsl:apply-templates select="$pl-callouts" mode="mp:pl-restore-table-lines"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$everyNth &gt; 0
	                  and count($pl-lines) &gt;= $minlines">
            <xsl:apply-templates select="$pl-callouts"
                                 mode="mp:pl-restore-lines">
              <xsl:with-param name="everyNth" select="$everyNth"/>
              <xsl:with-param name="width" select="$width"/>
              <xsl:with-param name="separator" select="$separator"/>
              <xsl:with-param name="padchar" select="$padchar"/>
              <xsl:with-param name="element" select="."/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$pl-callouts"
                                 mode="mp:pl-restore-lines">
              <xsl:with-param name="everyNth" select="0"/>
              <xsl:with-param name="width" select="$width"/>
              <xsl:with-param name="separator" select="$separator"/>
              <xsl:with-param name="padchar" select="$padchar"/>
              <xsl:with-param name="element" select="."/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--
  <xsl:message>
    <REMOVEDLINES>
      <xsl:copy-of select="$pl-removed-lines"/>
    </REMOVEDLINES>
  </xsl:message>
  -->

  <!-- put the lines into a tree so that we can use preceding:: to look for ID values -->
  <xsl:variable name="content-tree" as="element()">
    <irrelevant>
      <!-- expand any embedded ghost:co elements, as appropriate -->
      <xsl:apply-templates select="$pl-removed-lines" mode="mp:expand-ghost-co">
        <xsl:with-param name="origpl" select="."/>
      </xsl:apply-templates>
    </irrelevant>
  </xsl:variable>

  <xsl:variable name="result" as="node()*">
    <xsl:apply-templates select="$content-tree" mode="mp:pl-cleanup"/>
  </xsl:variable>

  <!--
  <xsl:message>
    <RESULT>
      <xsl:sequence select="$result"/>
    </RESULT>
  </xsl:message>
  -->

  <!-- don't return the ghost:tree -->
  <xsl:sequence select="$result/node()"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="ghost:co" mode="mp:expand-ghost-co">
  <xsl:if test="@xml:id">
    <a name="{@xml:id}"/>
  </xsl:if>
  <xsl:call-template name="t:callout-bug">
    <xsl:with-param name="conum">
      <xsl:choose>
	<xsl:when test="@number">
	  <xsl:value-of select="@number"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:number count="ghost:co"
		      level="any"
		      from="db:programlisting|db:screen|db:literallayout|db:synopsis"
		      format="1"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="mp:expand-ghost-co">
  <xsl:param name="origpl"/>

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="mp:expand-ghost-co">
      <xsl:with-param name="origpl" select="$origpl"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="mp:expand-ghost-co">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->
<!--
<xsl:template match="ghost:tree" mode="mp:remove-ghost-tree">
  <xsl:apply-templates mode="mp:remove-ghost-tree"/>
</xsl:template>

<xsl:template match="*" mode="mp:remove-ghost-tree">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="mp:remove-ghost-tree"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="mp:remove-ghost-tree">
  <xsl:copy/>
</xsl:template>
-->
<!-- ============================================================ -->

<xsl:template match="*" mode="mp:pl-cleanup">
  <xsl:variable name="id" select="@id"/>

  <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*[name(.) != 'id'
                            and namespace-uri(.) != 'http://docbook.org/ns/docbook/ephemeral']"/>
    <xsl:if test="@id and not(preceding::*[@id = $id])">
      <xsl:attribute name="id" select="$id"/>
    </xsl:if>

    <xsl:apply-templates mode="mp:pl-cleanup"/>
  </xsl:element>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="mp:pl-cleanup">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:function name="f:lastLineNumber" as="xs:decimal">
  <xsl:param name="listing" as="element()"/>

  <xsl:variable name="startnum" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="$listing/@continuation != 'continues'">
        <xsl:value-of select="0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="prev"
             select="$listing/preceding::*[node-name(.)=node-name($listing)][1]"/>
        <xsl:choose>
          <xsl:when test="empty($prev)">
            <xsl:value-of select="0"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="f:lastLineNumber($prev)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="expanded-text" as="node()*">
    <xsl:for-each select="$listing/node()">
      <xsl:choose>
	<xsl:when test="self::db:inlinemediaobject
			and db:textobject/db:textdata">
	  <xsl:apply-templates select="."/>
	</xsl:when>
	<xsl:when test="self::db:textobject and db:textdata">
	  <xsl:apply-templates select="."/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:sequence select="."/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="pl-empty-tags" as="node()*">
    <xsl:apply-templates select="$expanded-text" mode="m:patch-empty-elements"/>
  </xsl:variable>

  <xsl:variable name="pl-no-lb" as="node()*">
    <xsl:apply-templates select="$pl-empty-tags"
			 mode="mp:pl-no-lb"/>
  </xsl:variable>

  <xsl:variable name="pl-no-wrap-lb" as="node()*">
    <xsl:call-template name="t:unwrap">
      <xsl:with-param name="unwrap" select="xs:QName('ghost:br')"/>
      <xsl:with-param name="content" select="$pl-no-lb"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="pl-lines" as="element(ghost:line)*">
    <xsl:call-template name="tp:wrap-lines">
      <xsl:with-param name="nodes" select="$pl-no-wrap-lb"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="count($pl-lines)"/>
</xsl:function>

<xsl:template match="ghost:line" mode="mp:pl-restore-lines">
  <xsl:param name="everyNth" required="yes"/>
  <xsl:param name="width" required="yes"/>
  <xsl:param name="padchar" required="yes"/>
  <xsl:param name="separator" required="yes"/>
  <xsl:param name="element" as="element()" required="yes"/>

  <xsl:variable name="startnum" as="xs:decimal">
    <xsl:choose>
      <xsl:when test="not($element/@continuation)
                      or $element/@continuation != 'continues'">
        <xsl:value-of select="0"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="prev"
             select="$element/preceding::*[node-name(.)=node-name($element)][1]"/>
        <xsl:choose>
          <xsl:when test="empty($prev)">
            <xsl:value-of select="0"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="f:lastLineNumber($prev)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="linenumber" select="position() + $startnum"/>

  <xsl:if test="$everyNth &gt; 0">
    <xsl:choose>
      <xsl:when test="$linenumber = 1
		      or $linenumber mod $everyNth = 0">
	<xsl:variable name="numwidth"
		      select="string-length(string($linenumber))"/>

        <span class="linenumber">
          <xsl:if test="$numwidth &lt; $width">
            <xsl:value-of select="f:pad(xs:integer($width - $numwidth), $padchar)"/>
          </xsl:if>
          <xsl:value-of select="$linenumber"/>
        </span>
        <xsl:if test="$separator != ''">
          <span class="linenumber-separator">
            <xsl:value-of select="$separator"/>
          </span>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <span class="linenumber">
          <xsl:value-of select="f:pad($width, $padchar)"/>
        </span>
        <xsl:if test="$separator != ''">
          <span class="linenumber-separator">
            <xsl:value-of select="$separator"/>
          </span>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="ghost:end">
      <xsl:call-template name="t:restore-content">
	<xsl:with-param name="nodes" select="node()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="node()"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="position() &lt; last()">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="ghost:line" mode="mp:pl-restore-table-lines">
  <xsl:variable name="linenumber" select="position()"/>

  <div class="verbatimline {if ($linenumber mod 2 = 0) then 'verbatimeven' else 'verbatimodd'}">
    <div class="vlcontent">
      <xsl:choose>
        <xsl:when test="ghost:end">
          <xsl:call-template name="t:restore-content">
            <xsl:with-param name="nodes" select="node()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="node()"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="position() &lt; last()">
        <xsl:text>&#10;</xsl:text>
      </xsl:if>
    </div>
  </div>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:restore-content" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Restores content to empty elements.</refpurpose>

<refdescription>
<para>This template reverses the flattening process performed by
the <code>m:patch-empty-elements</code> mode. It replaces pairs of
empty elements and their corresponding <tag>ghost:end</tag>s with 
an element that has content.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>nodes</term>
<listitem>
<para>The sequence of nodes containing empty elements.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The nodes with content restored.</para>
</refreturn>
</doc:template>

<xsl:template name="t:restore-content">
  <xsl:param name="nodes" select="node()"/>

  <xsl:variable name="mark" select="$nodes[@ghost:id][1]"/>

  <!-- FIXME: I totally do not understand why straight-up node comparisons fail here.
       So I'm stepping back to comparing sequences of atomic values created
       with generate-id(). -->

  <xsl:choose>
    <xsl:when test="not($mark)">
      <xsl:sequence select="$nodes"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:variable name="precmarkids"
                    select="for $node in $mark/preceding-sibling::node() return generate-id($node)"/>

      <xsl:sequence select="$nodes[generate-id(.) = $precmarkids]"/>

      <xsl:variable name="follmarkids"
                    select="for $node in ($mark, $mark/following-sibling::node()) return generate-id($node)"/>

      <xsl:variable name="rest" select="$nodes[generate-id(.) = $follmarkids]"/>

      <xsl:variable name="id" select="$mark/@ghost:id"/>
      <xsl:variable name="end" select="$rest[self::ghost:end[@idref=$id]]"/>

      <!--
      <xsl:message>
	<xsl:text>Restore </xsl:text>
	<xsl:value-of select="$id"/>
	<xsl:text>, </xsl:text>
	<xsl:value-of select="count($end)"/>
      </xsl:message>
      -->

      <xsl:variable name="endpos"
		    select="f:find-node-in-sequence($rest, $end, 2)"/>

      <xsl:element name="{name($mark)}"
		   namespace="{namespace-uri($mark)}">
	<xsl:copy-of select="$mark/@*"/>
	<xsl:call-template name="t:restore-content">
	  <xsl:with-param name="nodes"
			  select="subsequence($rest, 2, $endpos - 2)"/>
	</xsl:call-template>
      </xsl:element>
      <xsl:call-template name="t:restore-content">
	<xsl:with-param name="nodes"
			select="subsequence($rest, $endpos+1)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="ghost:line" mode="mp:pl-callouts">
  <xsl:param name="areas" as="element()*"/>
  <xsl:param name="linenumber" select="position()"/>

  <xsl:choose>
    <xsl:when test="$areas[@ghost:line = $linenumber]">
      <xsl:call-template name="tp:addcallouts">
	<xsl:with-param name="areas" select="$areas[@ghost:line = $linenumber]"/>
	<xsl:with-param name="line" select="."/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tp:addcallouts">
  <xsl:param name="areas" as="element(db:area)*"/>
  <xsl:param name="line" as="element(ghost:line)"/>

  <xsl:variable name="newline" as="element(ghost:line)">
    <ghost:line>
      <xsl:call-template name="tp:addcallout">
	<xsl:with-param name="area" select="$areas[1]"/>
	<xsl:with-param name="nodes" select="$line/node()"/>
      </xsl:call-template>
    </ghost:line>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="count($areas) = 1">
      <xsl:copy-of select="$newline"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="tp:addcallouts">
	<xsl:with-param name="areas" select="$areas[position() &gt; 1]"/>
	<xsl:with-param name="line" select="$newline"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tp:addcallout">
  <xsl:param name="area" as="element(db:area)"/>
  <xsl:param name="nodes" as="node()*"/>
  <xsl:param name="pos" as="xs:integer" select="1"/>

  <xsl:choose>
    <xsl:when test="not($nodes)">
      <xsl:if test="$pos &lt; $area/@ghost:col">
	<xsl:value-of select="f:pad(xs:integer($area/@ghost:col) - $pos, ' ')"/>
	<xsl:apply-templates select="$area" mode="mp:insert-callout"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$nodes[1] instance of text()">
      <xsl:choose>
	<xsl:when test="$pos = $area/@ghost:col">
	  <xsl:apply-templates select="$area" mode="mp:insert-callout"/>
	  <xsl:copy-of select="$nodes"/>
	</xsl:when>
	<xsl:when test="string-length($nodes[1]) = 1">
	  <xsl:copy-of select="$nodes[1]"/>
	  <xsl:call-template name="tp:addcallout">
	    <xsl:with-param name="area" select="$area"/>
	    <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
	    <xsl:with-param name="pos" select="$pos+1"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="substring($nodes[1], 1, 1)"/>
	  <xsl:variable name="rest" as="text()">
	    <xsl:value-of select="substring($nodes[1], 2)"/>
	  </xsl:variable>
	  <xsl:call-template name="tp:addcallout">
	    <xsl:with-param name="area" select="$area"/>
	    <xsl:with-param name="nodes"
			    select="($rest, $nodes[position() &gt; 1])"/>
	    <xsl:with-param name="pos" select="$pos+1"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$nodes[1]"/>
      <xsl:call-template name="tp:addcallout">
	<xsl:with-param name="area" select="$area"/>
	<xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
	<xsl:with-param name="pos" select="$pos"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:area" mode="mp:insert-callout">
  <ghost:co number="{@ghost:number}">
    <xsl:attribute name="xml:id">
      <xsl:value-of select="generate-id()"/>    
    </xsl:attribute>
  </ghost:co>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="tp:wrap-lines">
  <xsl:param name="nodes" as="node()*" required="yes"/>

  <xsl:variable name="br" as="element()">
    <ghost:br/>
  </xsl:variable>

  <xsl:variable name="wrapnodes" as="node()*">
    <xsl:choose>
      <!-- FIXME: this is where f:verbatim-trim-blink-lines() should be called,
           but sometimes there's no context item. -->
      <xsl:when test="string($verbatim.trim.blank.lines) != '0'">
	<xsl:sequence select="fp:trim-trailing-br($nodes)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="$nodes[last()][self::ghost:br]">
	    <!-- because group-by will not form a group after the last one -->
	    <xsl:sequence select="($nodes, $br)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:sequence select="$nodes"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:for-each-group select="$wrapnodes" group-ending-with="ghost:br">
    <ghost:line>
      <xsl:for-each select="current-group()">
	<xsl:if test="not(self::ghost:br)">
	  <xsl:copy-of select="."/>
	</xsl:if>
      </xsl:for-each>
    </ghost:line>
  </xsl:for-each-group>
</xsl:template>

<!-- ============================================================ -->

<xsl:function name="fp:trim-trailing-br" as="node()*">
  <xsl:param name="nodes" as="node()*"/>

  <xsl:choose>
    <xsl:when test="$nodes[last()][self::ghost:br]">
      <xsl:sequence select="fp:trim-trailing-br($nodes[position()&lt;last()])"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$nodes"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:template name="t:unwrap" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Unwraps an element with a particular name</refpurpose>

<refdescription>
<para>This template takes a sequence of nodes. It traverses that sequence
making sure that any element with the specified name occurs at the top-most
level of the sequence: it closes all open elements that the named element
is nested within, outputs the named element, then reopens all the elements
that it had been nested within.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>unwrap</term>
<listitem>
<para>The name of the element to unwrap.</para>
</listitem>
</varlistentry>
<varlistentry><term>content</term>
<listitem>
<para>The sequence of nodes.</para>
</listitem>
</varlistentry>
<varlistentry role="private"><term>stack</term>
<listitem>
<para>The stack of currently open elements.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The original content sequence modified so that all elements named
<parameter>unwrap</parameter> are at the top level.</para>
</refreturn>
</doc:template>

<xsl:template name="t:unwrap">
  <xsl:param name="unwrap" as="xs:QName"/>
  <xsl:param name="content" as="node()*"/>
  <xsl:param name="stack" as="element()*" select="()"/>

  <xsl:choose>
    <xsl:when test="not($content)"/>
    <xsl:when test="$content[1] instance of element()
                    and node-name($content[1]) = $unwrap">
      <xsl:call-template name="tp:close-stack">
	<xsl:with-param name="stack" select="$stack"/>
      </xsl:call-template>
      <xsl:copy-of select="$content[1]"/>
      <xsl:call-template name="tp:open-stack">
	<xsl:with-param name="stack" select="$stack"/>
      </xsl:call-template>
      <xsl:call-template name="t:unwrap">
	<xsl:with-param name="unwrap" select="$unwrap"/>
	<xsl:with-param name="content" select="$content[position() &gt; 1]"/>
	<xsl:with-param name="stack" select="$stack"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$content[1][self::ghost:end]">
      <xsl:copy-of select="$content[1]"/>
      <xsl:call-template name="t:unwrap">
	<xsl:with-param name="unwrap" select="$unwrap"/>
	<xsl:with-param name="content" select="$content[position() &gt; 1]"/>
	<xsl:with-param name="stack" select="$stack[position() &lt; last()]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$content[1] instance of element()">
      <xsl:copy-of select="$content[1]"/>
      <xsl:call-template name="t:unwrap">
	<xsl:with-param name="unwrap" select="$unwrap"/>
	<xsl:with-param name="content" select="$content[position() &gt; 1]"/>
	<xsl:with-param name="stack" select="($stack, $content[1])"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$content[1]"/>
      <xsl:call-template name="t:unwrap">
	<xsl:with-param name="unwrap" select="$unwrap"/>
	<xsl:with-param name="content" select="$content[position() &gt; 1]"/>
	<xsl:with-param name="stack" select="$stack"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tp:close-stack">
  <xsl:param name="stack" as="element()*" select="()"/>

  <xsl:if test="$stack">
    <ghost:end idref="{$stack[last()]/@ghost:id}"/>
    <!--
    <xsl:message>
      <xsl:text>close: </xsl:text>
      <xsl:value-of select="$stack[last()]/@ghost:id"/>
    </xsl:message>
    -->
    <xsl:call-template name="tp:close-stack">
      <xsl:with-param name="stack" select="$stack[position() &lt; last()]"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="tp:open-stack">
  <xsl:param name="stack" as="element()*" select="()"/>

  <xsl:if test="$stack">
    <xsl:apply-templates select="$stack[1]" mode="mp:stack-copy"/>
    <xsl:call-template name="tp:open-stack">
      <xsl:with-param name="stack" select="$stack[position() &gt; 1]"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="mp:stack-copy">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="ghost:copy" select="'yes'"/>
  </xsl:copy>
</xsl:template>

<xsl:template name="tp:show-stack">
  <xsl:param name="stack" as="element()*" select="()"/>

  <xsl:message>
    <xsl:text>STACK[</xsl:text>
    <xsl:value-of select="count($stack)"/>
    <xsl:text>]</xsl:text>
  </xsl:message>

  <xsl:for-each select="$stack">
    <xsl:message>
      <xsl:text>...</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>,</xsl:text>
      <xsl:value-of select="@ghost:id"/>
    </xsl:message>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="mp:pl-no-lb" as="node()*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="mp:pl-no-lb"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="text()" as="node()*"
	      mode="mp:pl-no-lb">

  <xsl:choose>
    <!-- There's a bug in MarkLogic server V4.2-1 that coalesces the nodes returned
         by xsl:analyze-string into a single node. Let's work around that. -->
    <xsl:when test="system-property('xsl:vendor') = 'MarkLogic Corporation'
                    and system-property('xsl:product-version') = '4.2-1'">
      <xsl:variable name="parts" as="item()*">
        <xsl:analyze-string select="." regex="\n">
          <xsl:matching-substring>
            <ghost:br/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <ghost:x><xsl:value-of select="."/></ghost:x>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:variable>
      <xsl:for-each select="$parts/node()">
        <xsl:choose>
          <xsl:when test="self::ghost:br">
            <xsl:sequence select="."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="./node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:when>

    <!-- In later versions of 4.2 (starting I don't know when, but at least in 4.2-6)
         there's a different bug. Not fixed in 5.0-1 either. Or 6.x -->
    <xsl:when test="system-property('xsl:vendor') = 'MarkLogic Corporation'
                    and (starts-with(system-property('xsl:product-version'), '4.2')
                         or starts-with(system-property('xsl:product-version'), '5')
                         or starts-with(system-property('xsl:product-version'), '6'))">
      <xsl:variable name="parts" as="item()*">
        <xsl:analyze-string select="." regex="\n">
          <xsl:matching-substring>
            <ghost:br/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <ghost:x><xsl:value-of select="."/></ghost:x>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:variable>
      <xsl:for-each select="$parts">
        <xsl:choose>
          <xsl:when test="self::ghost:br">
            <xsl:sequence select="."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of>
              <xsl:value-of select="."/>
            </xsl:value-of>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:when>

    <xsl:otherwise>
      <xsl:analyze-string select="." regex="\n">
        <xsl:matching-substring>
          <ghost:br/>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="."/>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()" as="node()*"
	      mode="mp:pl-no-lb">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:patch-empty-elements" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Make all elements empty</refpurpose>

<refdescription>
<para>This mode is used to completely flatten all nesting in a tree.
Every start tag is replaced with an empty tag that has a
<tag class="attribute">ghost:id</tag> attribute. Every end tag is
replaced with an empty <tag>ghost:end</tag> element that has an 
<tag class="attribute">idref</tag> attribute pointing to the
appropriate <tag class="attribute">ghost:id</tag>.</para>

<para>To reverse the process, see
<function role="named-template">t:restore-content</function>.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:patch-empty-elements">
  <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="ghost:id" select="generate-id()"/>
  </xsl:element>
  <xsl:apply-templates mode="m:patch-empty-elements"/>
  <ghost:end idref="{generate-id()}"/>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:patch-empty-elements">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:remove-lb" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Remove all newlines</refpurpose>

<refdescription>
<para>This mode is used to remove newlines from text content.
This is necessary in verbatim processing of elements such as
footnote because, although line breaks are significant in a verbatim
environment, they are not significant in the content of a footnote
in a verbatim environment.</para>

</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:remove-lb">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:remove-lb"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="text()"
	      mode="m:remove-lb">
  <xsl:value-of select="replace(.,'&#10;',' ')"/>
</xsl:template>

<xsl:template match="comment()|processing-instruction()"
	      mode="m:remove-lb">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:areaspec|db:areaset">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:areaspec/db:area">
  <db:area>
    <xsl:copy-of select="@*[name(.) != 'coords']"/>
    <xsl:if test="(not(@units)
		   or @units='linecolumn'
		   or @units='linecolumnpair')">
      <xsl:choose>
	<xsl:when test="not(contains(normalize-space(@coords), ' '))">
	  <xsl:attribute name="ghost:line" select="normalize-space(@coords)"/>
	  <xsl:attribute name="ghost:col" select="$callout.defaultcolumn"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="toks"
			select="tokenize(normalize-space(@coords), ' ')"/>
	  <xsl:attribute name="ghost:line" select="$toks[1]"/>
	  <xsl:attribute name="ghost:col" select="$toks[2]"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:attribute name="ghost:number"
		   select="count(preceding-sibling::db:area
                                 |preceding-sibling::db:areaset)+1"/>
  </db:area>
</xsl:template>

<xsl:template match="db:areaset/db:area">
  <db:area>
    <xsl:copy-of select="@*[name(.) != 'coords']"/>

    <xsl:if test="not(preceding-sibling::db:area)">
      <xsl:attribute name="xml:id" select="parent::db:areaset/@xml:id"/>
    </xsl:if>

    <xsl:if test="(not(@units)
		   or @units='linecolumn'
		   or @units='linecolumnpair')">
      <xsl:choose>
	<xsl:when test="not(contains(normalize-space(@coords), ' '))">
	  <xsl:attribute name="ghost:line" select="normalize-space(@coords)"/>
	  <xsl:attribute name="ghost:col" select="$callout.defaultcolumn"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="toks"
			select="tokenize(normalize-space(@coords), ' ')"/>
	  <xsl:attribute name="ghost:line" select="$toks[1]"/>
	  <xsl:attribute name="ghost:col" select="$toks[2]"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:attribute name="ghost:number"
		   select="count(parent::db:areaset/preceding-sibling::db:area
                             |parent::db:areaset/preceding-sibling::db:areaset)
			   + 1"/>
  </db:area>
</xsl:template>

</xsl:stylesheet>
