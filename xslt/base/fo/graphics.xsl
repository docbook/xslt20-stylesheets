<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                exclude-result-prefixes="db doc f fn m t u xlink"
                version="2.0">

<xsl:param name="output.dir" select="''"/>

<!-- ********************************************************************
     $Id: graphics.xsl 7914 2008-03-12 11:47:38Z nwalsh $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sourceforge.net/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="db:screenshot">
  <xsl:call-template name="t:semiformal-object"/>
</xsl:template>

<xsl:template match="db:mediaobject">
  <xsl:variable name="olist" select="*[not(self::db:info)]"/>

  <xsl:variable name="object.index"
                select="f:select-mediaobject-index($olist)"/>

  <xsl:variable name="object" select="$olist[position() = $object.index]"/>

  <xsl:variable name="align">
    <xsl:value-of select="$object/descendant::db:imagedata[@align][1]/@align"/>
  </xsl:variable>

  <fo:block xsl:use-attribute-sets="mediaobject.properties">
    <xsl:call-template name="t:id"/>

    <xsl:if test="$align != '' ">
      <xsl:attribute name="text-align">
        <xsl:value-of select="$align"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates select="$object"/>
    <xsl:apply-templates select="db:caption"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:inlinemediaobject">
  <fo:inline>
    <xsl:call-template name="t:id"/>
    <xsl:call-template name="t:select-mediaobject"/>
  </fo:inline>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:imageobjectco">
  <!-- FIXME: -->
  <xsl:message>Hotspots on imageobjectco are not supported in XSL-FO</xsl:message>
  <fo:block xsl:use-attribute-sets="imageobjectco.properties">
    <xsl:call-template name="t:id"/>
    <xsl:apply-templates select="db:imageobject"/>
    <xsl:apply-templates select="db:calloutlist"/>
  </fo:block>
</xsl:template>

<xsl:template match="db:imageobject">
  <xsl:apply-templates select="db:imagedata"/>
</xsl:template>

<xsl:template match="db:imagedata">
  <xsl:variable name="filename" select="f:mediaobject-filename(..)"/>

  <xsl:choose>
    <xsl:when test="@format='linespecific' and $textdata.default.encoding != ''">
      <xsl:value-of select="unparsed-text($filename,
                                          $textdata.default.encoding)"/>
    </xsl:when>

    <xsl:when test="@format='linespecific'">
      <xsl:value-of select="unparsed-text($filename)"/>
    </xsl:when>

    <!-- Copy SVG/MathML/... content -->
    <xsl:when test="* except db:info">
      <fo:instream-foreign-object>
        <xsl:copy-of select="node()[not(self::db:info)]"/>
      </fo:instream-foreign-object>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="t:process-image"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:videoobject|db:audioobject">
  <xsl:message>Warning: audio and video objects are ignored in XSL-FO output</xsl:message>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:textobject">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:textdata">
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@entityref">
        <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@fileref"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="encoding">
    <xsl:choose>
      <xsl:when test="@encoding">
        <xsl:value-of select="@encoding"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$textdata.default.encoding"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="if ($encoding = '')
                        then unparsed-text($filename)
                        else unparsed-text($filename, $encoding)"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:caption">
  <fo:block xsl:use-attribute-sets="caption.properties">
    <xsl:call-template name="t:id"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<!-- ==================================================================== -->

<doc:template name="t:process-image" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Process an image</refpurpose>

<refdescription>
<para>FIXME:
</para>

<orderedlist>
<listitem>
<para>If only the content-area is specified, everything is fine. (If
you ask for a three inch image, that's what you'll get.)</para>
</listitem>
<listitem>
<para>If only the viewport-area is provided:</para>
<itemizedlist>
<listitem>
<para>If scalefit=1, treat it as both the content-area and the
viewport-area. (If you ask for an image in a five inch area, we'll
make the image five inches to fill that area.)</para>
</listitem>
<listitem>
<para>If scalefit=0, ignore the viewport-area specification.</para>
</listitem>
</itemizedlist>
<note>
<para>This is not quite the right semantic and has the additional
problem that it can result in anamorphic scaling, which scalefit
should never cause.</para>
</note>
</listitem>
<listitem>
<para>If both the content-area and the viewport-area is specified on a
graphic element, ignore the viewport-area. (If you ask for a three
inch image in a five inch area, we'll assume it's better to give you a
three inch image in an unspecified area than a five inch image in a
five inch area.</para>
</listitem>
</orderedlist>

<para>Relative units also cause problems. As a general rule, the
stylesheets are operating too early and too loosely coupled with the
rendering engine to know things like the current font size or the
actual dimensions of an image. Therefore:</para>

<orderedlist>
<listitem>
<para>We use a fixed size for pixels, $pixels.per.inch</para>
</listitem>
<listitem>
<para>We use a fixed size for "em"s, $points.per.em</para>
</listitem>
</orderedlist>

<para>Percentages are problematic. In the following discussion, we speak
of width and contentwidth, but the same issues apply to depth and
contentdepth</para>

<orderedlist>
<listitem>
<para>A width of 50% means "half of the available space for the
image." That's fine. But note that in HTML, this is a dynamic property
and the image size will vary if the browser window is resized.
</para>
</listitem>
<listitem>
<para>A contentwidth of 50% means "half of the actual image width".
But the stylesheets have no way to assess the image's actual size.
Treating this as a width of 50% is one possibility, but it produces
behavior (dynamic scaling) that seems entirely out of character with
the meaning.</para>
<para>Instead, the stylesheets define a $nominal.image.width and
convert percentages to actual values based on that nominal size.
</para>
</listitem>
</orderedlist>

<para>Scale can be problematic. Scale applies to the contentwidth, so
a scale of 50 when a contentwidth is not specified is analagous to a
width of 50%. (If a contentwidth is specified, the scaling factor can
be applied to that value and no problem exists.)</para>

<para>If scale is specified but contentwidth is not supplied, the
nominal.image.width is used to calculate a base size
for scaling.</para>

<warning>
<para>As a consequence of these decisions, unless the aspect ratio of
your image happens to be exactly the same as (nominal width / nominal
height), specifying contentwidth="50%" and contentdepth="50%" is NOT
going to scale the way you expect (or really, the way it should).</para>

<para>Don't do that. In fact, a percentage value is not recommended
for content size at all. Use scale instead.</para>
</warning>

<para>Finally, align and valign are troublesome. Horizontal alignment
is now supported by wrapping the image in a
<code>&lt;div align="{@align}"&gt;</code> (in
block contexts!). I can't think of anything (practical) to do about
vertical alignment.</para>
</refdescription>

<refreturn>
<para>Markup for the image.</para>
</refreturn>
</doc:template>

<xsl:template name="t:process-image">
  <!-- When this template is called, the current node should be  -->
  <!-- a graphic, inlinegraphic, imagedata, or videodata. All    -->
  <!-- those elements have the same set of attributes, so we can -->
  <!-- handle them all in one place.                             -->

  <xsl:variable name="format" xmlns:svg="http://www.w3.org/2000/svg"
                select="if (@format) then string(@format)
                        else if (svg:*) then 'svg'
                        else ''"/>

  <xsl:variable name="scalefit">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
      <xsl:when test="@contentwidth or @contentdepth">0</xsl:when>
      <xsl:when test="@scale">0</xsl:when>
      <xsl:when test="@scalefit"><xsl:value-of select="@scalefit"/></xsl:when>
      <xsl:when test="@width or @depth">1</xsl:when>
      <xsl:when test="$default.image.width != ''">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scale">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">1.0</xsl:when>
      <xsl:when test="@scale">
        <xsl:value-of select="@scale div 100.0"/>
      </xsl:when>
      <xsl:otherwise>1.0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- imagedata, videodata, audiodata -->
  <xsl:variable name="filename" select="f:mediaobject-filename(..)"/>

  <xsl:variable name="content-type">
    <!-- FIXME:
    <xsl:if test="@format">
      <xsl:call-template name="graphic.format.content-type">
        <xsl:with-param name="format" select="@format"/>
      </xsl:call-template>
    </xsl:if>
    -->
  </xsl:variable>

  <xsl:variable name="bgcolor"
     select="f:pi(../processing-instruction('dbfo'),
             'background-color')"/>

  <fo:external-graphic>
    <xsl:attribute name="src" select="f:fo-external-image($filename)"/>
    
    <xsl:attribute name="width">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
        <xsl:when test="contains(@width,'%')">
          <xsl:value-of select="@width"/>
        </xsl:when>
        <xsl:when test="@width and not(@width = '')">
	  <xsl:value-of select="f:length-spec(@width)"/>
        </xsl:when>
        <xsl:when test="not(@depth) and $default.image.width != ''">
	  <xsl:value-of select="f:length-spec($default.image.width)"/>
        </xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="height">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
        <xsl:when test="contains(@depth,'%')">
          <xsl:value-of select="@depth"/>
        </xsl:when>
        <xsl:when test="@depth">
	  <xsl:value-of select="f:length-spec(@depth)"/>
        </xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="content-width">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
        <xsl:when test="contains(@contentwidth,'%')">
          <xsl:value-of select="@contentwidth"/>
        </xsl:when>
        <xsl:when test="@contentwidth">
	  <xsl:value-of select="f:length-spec(@contentwidth)"/>
        </xsl:when>
        <xsl:when test="number($scale) != 1.0">
          <xsl:value-of select="$scale * 100"/>
          <xsl:text>%</xsl:text>
        </xsl:when>
        <xsl:when test="$scalefit = 1">scale-to-fit</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:attribute name="content-height">
      <xsl:choose>
        <xsl:when test="$ignore.image.scaling != 0">auto</xsl:when>
        <xsl:when test="contains(@contentdepth,'%')">
          <xsl:value-of select="@contentdepth"/>
        </xsl:when>
        <xsl:when test="@contentdepth">
	  <xsl:value-of select="f:length-spec(@contentdepth)"/>
        </xsl:when>
        <xsl:when test="number($scale) != 1.0">
          <xsl:value-of select="$scale * 100"/>
          <xsl:text>%</xsl:text>
        </xsl:when>
        <xsl:when test="$scalefit = 1">scale-to-fit</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:if test="$content-type != ''">
      <xsl:attribute name="content-type">
        <xsl:value-of select="concat('content-type:',$content-type)"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="$bgcolor != ''">
      <xsl:attribute name="background-color">
        <xsl:value-of select="$bgcolor"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="@align">
      <xsl:attribute name="text-align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="@valign">
      <xsl:attribute name="display-align">
        <xsl:choose>
          <xsl:when test="@valign = 'top'">before</xsl:when>
          <xsl:when test="@valign = 'middle'">center</xsl:when>
          <xsl:when test="@valign = 'bottom'">after</xsl:when>
          <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </fo:external-graphic>
</xsl:template>

<!-- ==================================================================== -->

<xsl:function name="f:fo-external-image">
  <xsl:param name="filename"/>

  <xsl:choose>
    <xsl:when test="$fo.processor = 'fop' or $fo.processor = 'passivetex'">
      <xsl:value-of select="$filename"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('url(', $filename, ')')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
