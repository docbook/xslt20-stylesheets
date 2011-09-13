<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f ghost h m t u xs"
                version="2.0">

<xsl:attribute-set name="pgwide.properties"/>
<xsl:attribute-set name="informalfigure.properties"/>
<xsl:attribute-set name="informalexample.properties"/>
<xsl:attribute-set name="informalequation.properties"/>
<xsl:attribute-set name="equation.properties"/>
<xsl:attribute-set name="procedure.properties"/>

<xsl:param name="default.float.class" select="'before'"/>

<!-- formal.object creates a basic block containing the
     result of processing the object, including its title
     and any keep-together properties.
     The template calling formal.object may wrap these results in a
     float or pgwide block. -->

<xsl:template name="t:formal-object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:param name="object" select="()"/>

  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:variable name="content">
    <xsl:if test="$placement = 'before'">
      <xsl:call-template name="t:formal-object-heading">
        <xsl:with-param name="placement" select="$placement"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="not(empty($object))">
	<xsl:sequence select="$object"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$placement != 'before'">
      <xsl:call-template name="t:formal-object-heading">
        <xsl:with-param name="placement" select="$placement"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="keep.together"><!--
	<xsl:call-template name="pi.dbfo_keep-together"/>
   --></xsl:variable>

  <xsl:choose>
    <!-- tables have their own templates and 
         are not handled by formal-object -->
    <xsl:when test="self::db:figure">
      <fo:block id="{$id}" xsl:use-attribute-sets="figure.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column" select="$keep.together"/>
        </xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::db:example">
      <fo:block id="{$id}" xsl:use-attribute-sets="example.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column" select="$keep.together"/>
	</xsl:if>
	<xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::db:equation">
      <fo:block id="{$id}" xsl:use-attribute-sets="equation.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column" select="$keep.together"/>
        </xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::db:procedure">
      <fo:block id="{$id}" xsl:use-attribute-sets="procedure.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column" select="$keep.together"/>
        </xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}" xsl:use-attribute-sets="formal.object.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column" select="$keep.together"/>
	</xsl:if>
        <xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:formal-object-heading">
  <xsl:param name="object" select="."/>
  <xsl:param name="placement" select="'before'"/>

  <fo:block xsl:use-attribute-sets="formal.title.properties">
    <xsl:choose>
      <xsl:when test="$placement = 'before'">
        <xsl:attribute name="keep-with-next.within-column" select="'always'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="keep-with-previous.within-column" select="'always'"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="$object" mode="m:title-content">
      <xsl:with-param name="allow-anchors" select="true()"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template name="t:informal-object">
  <xsl:param name="object" select="()"/>

  <xsl:variable name="id" select="f:node-id(.)"/>

  <xsl:variable name="keep.together"><!--
    <xsl:call-template name="pi.dbfo_keep-together"/>
  --></xsl:variable>

  <!-- Some don't have a pgwide attribute, so may use a PI -->
  <xsl:variable name="pgwide.pi"><!--
    <xsl:call-template name="pi.dbfo_pgwide"/>
  --></xsl:variable>

  <xsl:variable name="pgwide">
    <xsl:choose>
      <xsl:when test="@pgwide">
        <xsl:value-of select="@pgwide"/>
      </xsl:when>
      <xsl:when test="$pgwide.pi">
        <xsl:value-of select="$pgwide.pi"/>
      </xsl:when>
      <!-- child element may set pgwide -->
      <xsl:when test="*[@pgwide]">
        <xsl:value-of select="*[@pgwide][1]/@pgwide"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="not(empty($object))">
	<xsl:sequence select="$object"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <!-- informaltables have their own templates and 
         are not handled by formal.object -->
    <xsl:when test="self::db:equation">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            equation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$content"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="equation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$content"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="self::db:procedure">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="procedure.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
	<xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:when>
    <xsl:when test="self::db:informalfigure">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalfigure.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
	    <xsl:copy-of select="$content"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="informalfigure.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
	    <xsl:copy-of select="$content"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="self::db:informalexample">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalexample.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
	    <xsl:copy-of select="$content"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="informalexample.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
	    <xsl:copy-of select="$content"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="self::db:informalequation">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalequation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
	    <xsl:copy-of select="$content"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="informalequation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
	    <xsl:copy-of select="$content"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}" 
                xsl:use-attribute-sets="informal.object.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
	<xsl:copy-of select="$content"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="t:semiformal-object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:param name="object" select="()"/>
  <xsl:choose>
    <xsl:when test="db:title|db:info/db:title">
      <xsl:call-template name="t:formal-object">
        <xsl:with-param name="placement" select="$placement"/>
	<xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="t:informal-object">
	<xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:figure">
  <xsl:variable name="placement" select="$formal.title.placement[self::db:figure]/@placement"/>

  <xsl:variable name="figure">
    <xsl:choose>
      <xsl:when test="@pgwide = '1'">
        <fo:block xsl:use-attribute-sets="pgwide.properties">
          <xsl:call-template name="t:formal-object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="t:formal-object">
          <xsl:with-param name="placement" select="$placement"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="floatstyle">
    <xsl:call-template name="t:floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="t:floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$figure"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$figure"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:example">
  <xsl:variable name="placement" select="$formal.title.placement[self::db:example]/@placement"/>

  <!-- Example doesn't have a pgwide attribute, so may use a PI -->
  <xsl:variable name="pgwide.pi"><!--
    <xsl:call-template name="pi.dbfo_pgwide"/>
  --></xsl:variable>

  <xsl:variable name="pgwide">
    <xsl:choose>
      <xsl:when test="$pgwide.pi">
        <xsl:value-of select="$pgwide.pi"/>
      </xsl:when>
      <!-- child element may set pgwide -->
      <xsl:when test="*[@pgwide]">
        <xsl:value-of select="*[@pgwide][1]/@pgwide"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- Get align value from internal mediaobject -->
  <xsl:variable name="align">
    <xsl:if test="db:mediaobject|db:mediaobjectco">
      <xsl:variable name="olist" select="db:mediaobject/db:imageobject
                     |db:mediaobjectco/db:imageobjectco
                     |db:mediaobject/db:videoobject
                     |db:mediaobject/db:audioobject
                     |db:mediaobject/db:textobject"/>

      <xsl:variable name="object.index" select="f:select-mediaobject-index($olist)"/>

      <xsl:variable name="object" select="$olist[position() = $object.index]"/>

      <xsl:value-of select="$object/descendant::db:imagedata[@align][1]/@align"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="example">
    <xsl:choose>
      <xsl:when test="$pgwide = '1'">
        <fo:block xsl:use-attribute-sets="pgwide.properties">
          <xsl:if test="$align != ''">
            <xsl:attribute name="text-align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="t:formal-object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block>
          <xsl:if test="$align != ''">
            <xsl:attribute name="text-align">
              <xsl:value-of select="$align"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:call-template name="t:formal-object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="floatstyle">
    <xsl:call-template name="t:floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="t:floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$example"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$example"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- Unified handling of CALS and HTML tables, formal and not -->
<!-- Creates a hierarchy of nested containers:
     - Outer container does a float.
     - Nested container does block-container for rotation
     - Nested block contains title, layout table and footnotes
     - Nested layout table placeholder template supports extensions.
     - fo:table is innermost.
     Created from the innermost and working out.
     Not all layers apply to every table.
-->
<xsl:template match="db:table|db:informaltable">
  <xsl:if test="db:tgroup/db:tbody/db:tr
                |db:tgroup/db:thead/db:tr
                |db:tgroup/db:tfoot/db:tr">
    <xsl:message terminate="yes">
      <xsl:text>Broken table: tr descendent of CALS Table.</xsl:text>
      <xsl:text>The text in the first tr is:&#10;</xsl:text>
      <xsl:value-of 
               select="(db:tgroup//db:tr)[1]"/>
    </xsl:message>
  </xsl:if>
  <xsl:if test="not(db:tgroup) and .//db:row">
    <xsl:message terminate="yes">
      <xsl:text>Broken table: row descendent of HTML table.</xsl:text>
      <xsl:text>The text in the first row is:&#10;</xsl:text>
      <xsl:value-of 
               select=".//db:row[1]"/>
    </xsl:message>
  </xsl:if>

  <!-- Contains fo:table, not title or footnotes -->
  <xsl:variable name="table.content">
    <xsl:call-template name="t:make.table.content"/>
  </xsl:variable>

  <!-- Optional layout table template for extensions -->
  <xsl:variable name="table.layout">
    <xsl:call-template name="t:table.layout">
      <xsl:with-param name="table.content" select="$table.content"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- fo:block contains title, layout table, and footnotes  -->
  <xsl:variable name="table.block">
    <xsl:call-template name="t:table.block">
      <xsl:with-param name="table.layout" select="$table.layout"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- pgwide or orient container -->
  <xsl:variable name="table.container">
    <xsl:call-template name="t:table.container">
      <xsl:with-param name="table.block" select="$table.block"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- float or not -->
  <xsl:variable name="floatstyle">
    <xsl:call-template name="t:floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="t:floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$table.container"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$table.container"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:equation">
  <xsl:variable name="param.placement"
              select="substring-after(normalize-space($formal.title.placement[self::db:equation]/@placement),
                                      concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Equation doesn't have a pgwide attribute, so may use a PI -->
  <xsl:variable name="pgwide"><!--
    <xsl:call-template name="pi.dbfo_pgwide"/>
  --></xsl:variable>

  <xsl:variable name="equation">
    <xsl:choose>
      <xsl:when test="$pgwide = '1'">
        <fo:block xsl:use-attribute-sets="pgwide.properties">
          <xsl:call-template name="t:semiformal-object">
            <xsl:with-param name="placement" select="$placement"/>
          </xsl:call-template>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="t:semiformal-object">
          <xsl:with-param name="placement" select="$placement"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="floatstyle">
    <xsl:call-template name="t:floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="t:floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$equation"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$equation"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:informalfigure">
  <xsl:call-template name="t:informal-object"/>
</xsl:template>

<xsl:template match="db:informalexample">
  <xsl:call-template name="t:informal-object"/>
</xsl:template>

<xsl:template match="db:informaltable/db:textobject"/>

<xsl:template match="db:informalequation">
  <xsl:call-template name="t:informal-object"/>
</xsl:template>

<xsl:template name="t:floatstyle">
  <xsl:if test="(@float and @float != '0') or @floatstyle != ''">
    <xsl:choose>
      <xsl:when test="@floatstyle != ''">
        <xsl:value-of select="@floatstyle"/>
      </xsl:when>
      <xsl:when test="@float = '1'">
        <xsl:value-of select="$default.float.class"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@float"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
