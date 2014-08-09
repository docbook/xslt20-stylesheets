<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ext="http://docbook.org/extensions/xslt20"
                exclude-result-prefixes="db doc f ghost h m t u xlink xs ext"
                version="2.0">

<xsl:param name="output.dir" select="''"/>

<!-- ==================================================================== -->

<xsl:template match="db:screenshot">
  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-attributes(.)"/>
        <xsl:apply-templates/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<doc:template name="t:process-image" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Process an image</refpurpose>

<refdescription>
<para>The HTML <tag>img</tag> element only supports the notion of
content-area scaling; it doesn't support the distinction between a
content-area and a viewport-area, so we have to make some compromises.
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

<refparameter>
<variablelist>
<varlistentry><term>tag</term>
<listitem>
<para>The name of the HTML element to create (img, object, etc.).
</para></listitem>
</varlistentry>
<varlistentry><term>alt</term>
<listitem>
<para>The alt text.
</para></listitem>
</varlistentry>
<varlistentry><term>longdesc</term>
<listitem>
<para>A pointer to the long description (textobject) for this element.
</para></listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Markup for the image.</para>
</refreturn>
</doc:template>

<xsl:template name="t:image-properties" as="xs:integer*">
  <xsl:param name="image" as="xs:string" required="yes"/>

  <xsl:sequence use-when="function-available('ext:image-properties')"
                select="ext:image-properties($image)"/>

  <xsl:message use-when="not(function-available('ext:image-properties'))">
    <xsl:text>Cannot read image properties for </xsl:text>
    <xsl:value-of select="$image"/>
    <xsl:text>. (No extension)</xsl:text>
  </xsl:message>

  <xsl:sequence use-when="not(function-available('ext:image-properties'))"
                select="()"/>
</xsl:template>

<xsl:function use-when="function-available('magick:wand')"
              name="ext:image-properties"
              xmlns:magick="http://marklogic.com/magick"
              as="xs:unsignedLong*">
  <xsl:param name="image" as="xs:string"/>

  <xsl:variable name="wand"       select="magick:wand()"/>
  <xsl:variable name="image-wand" select="magick:read-image($wand,doc($image))"/>
  <xsl:sequence select="(magick:get-image-width($image-wand), magick:get-image-height($image-wand))"/>
</xsl:function>

<xsl:template name="t:process-image">
  <!-- When this template is called, the current node should be  -->
  <!-- a graphic, inlinegraphic, imagedata, or videodata. All    -->
  <!-- those elements have the same set of attributes, so we can -->
  <!-- handle them all in one place.                             -->
  <xsl:param name="tag" select="'img'"/>
  <xsl:param name="alt"/>
  <xsl:param name="longdesc"/>
  <xsl:param name="tag-attributes" as="attribute()*"/>

  <xsl:variable name="format" xmlns:svg="http://www.w3.org/2000/svg"
                select="if (@format) then string(@format)
                        else if (svg:*) then 'svg'
                        else ''"/>

  <xsl:variable name="width-units">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="@width">
        <xsl:value-of select="f:length-units(@width)"/>
      </xsl:when>
      <xsl:when test="not(@depth) and $default.image.width != ''">
        <xsl:value-of select="f:length-units($default.image.width)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="@width">
        <xsl:choose>
          <xsl:when test="$width-units = '%'">
            <xsl:value-of select="@width"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="f:length-spec(@width)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="not(@depth) and $default.image.width != ''">
        <xsl:value-of select="$default.image.width"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scalefit">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
      <xsl:when test="@contentwidth or @contentdepth">0</xsl:when>
      <xsl:when test="@scale">0</xsl:when>
      <xsl:when test="@scalefit"><xsl:value-of select="@scalefit"/></xsl:when>
      <xsl:when test="$width != '' or @depth">1</xsl:when>
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

  <!--
  <xsl:message><xsl:copy-of select="."/></xsl:message>
  <xsl:message>
    <xsl:value-of select="$ignore.image.scaling"/>,
    <xsl:value-of select="$width-units"/>,
    <xsl:value-of select="@width"/>,
    <xsl:value-of select="if (@width) then f:length-spec(@width) else '!@width'"/>,
    <xsl:value-of select="$default.image.width"/>,
    <xsl:value-of select="$scalefit"/>,
    <xsl:value-of select="$scale"/>,
  </xsl:message>
  -->

  <!-- imagedata, videodata, audiodata -->
  <xsl:variable name="filename" select="f:mediaobject-filename(..)"/>

  <xsl:variable name="imageproperties" as="xs:integer*">
    <xsl:if test="$filename != ''">
      <xsl:call-template name="t:image-properties">
        <xsl:with-param name="image" select="$filename"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="intrinsicwidth"
                select="if (exists($imageproperties))
                        then $imageproperties[1]
                        else $nominal.image.width"/>

  <xsl:variable name="intrinsicdepth"
                select="if (exists($imageproperties))
                        then $imageproperties[2]
                        else $nominal.image.depth"/>

  <xsl:variable name="contentwidth">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="@contentwidth">
        <xsl:variable name="units">
          <xsl:value-of select="f:length-units(@contentwidth)"/>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$units = '%'">
            <xsl:variable name="cmagnitude">
              <xsl:value-of select="f:length-magnitude(@contentwidth)"/>
            </xsl:variable>
            <xsl:value-of select="$intrinsicwidth * $cmagnitude div 100.0"/>
            <xsl:text>px</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="f:length-spec(@contentwidth)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$intrinsicwidth"/>
        <xsl:text>px</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scaled.contentwidth">
    <xsl:if test="$contentwidth != ''">
      <xsl:variable name="cwidth.in.points"
                    select="f:length-in-points($contentwidth,$points.per.em)"/>
      <xsl:value-of select="$cwidth.in.points div 72.0
                            * $pixels.per.inch * $scale"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="html.width">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="$width-units = '%'">
        <xsl:value-of select="$width"/>
      </xsl:when>
      <xsl:when test="$width != ''">
        <xsl:variable name="width.in.points"
                      select="f:length-in-points($width,$points.per.em)"/>
        <xsl:value-of select="round($width.in.points * ($pixels.per.inch div 72.0))"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="contentdepth">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="@contentdepth">
        <xsl:variable name="units" select="f:length-units(@contentdepth)"/>

        <xsl:choose>
          <xsl:when test="$units = '%'">
            <xsl:variable name="cmagnitude"
                          select="f:length-magnitude(@contentdepth)"/>
            <xsl:value-of select="$intrinsicdepth * $cmagnitude div 100.0"/>
            <xsl:text>px</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="f:length-spec(@contentdepth)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$intrinsicdepth"/>
        <xsl:text>px</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scaled.contentdepth">
    <xsl:if test="$contentdepth != ''">
      <xsl:variable name="cdepth.in.points"
                    select="f:length-in-points($contentdepth,$points.per.em)"/>
      <xsl:value-of select="$cdepth.in.points div 72.0
                            * $pixels.per.inch * $scale"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="depth-units">
    <xsl:if test="@depth">
      <xsl:value-of select="f:length-units(@depth)"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="depth" as="xs:string">
    <xsl:choose>
      <xsl:when test="@depth">
        <xsl:choose>
          <xsl:when test="$depth-units = '%'">
            <xsl:value-of select="@depth"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="f:length-spec(@depth)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="html.depth">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="$depth-units = '%'">
        <xsl:value-of select="$depth"/>
      </xsl:when>
      <xsl:when test="@depth and @depth != ''">
        <xsl:variable name="depth.in.points"
                      select="f:length-in-points($depth,$points.per.em)"/>
        <xsl:value-of select="round($depth.in.points div 72.0
                                    * $pixels.per.inch)"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="viewport">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
      <xsl:when test="ancestor::db:inlinemediaobject
                      or ancestor::db:inlineequation">0</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$make.graphic.viewport"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!--
  <xsl:message>=====================================
scale: <xsl:value-of select="$scale"/>, <xsl:value-of select="$scalefit"/>
@contentwidth <xsl:value-of select="@contentwidth"/>
$contentwidth <xsl:value-of select="$contentwidth"/>
scaled.contentwidth: <xsl:value-of select="$scaled.contentwidth"/>
@width: <xsl:value-of select="@width"/>
width: <xsl:value-of select="$width"/>
html.width: <xsl:value-of select="$html.width"/>
@contentdepth <xsl:value-of select="@contentdepth"/>
$contentdepth <xsl:value-of select="$contentdepth"/>
scaled.contentdepth: <xsl:value-of select="$scaled.contentdepth"/>
@depth: <xsl:value-of select="@depth"/>
depth: <xsl:value-of select="$depth"/>
html.depth: <xsl:value-of select="$html.depth"/>
align: <xsl:value-of select="@align"/>
valign: <xsl:value-of select="@valign"/></xsl:message>
-->

  <xsl:variable name="scaled"
                select="@width|@depth|@contentwidth|@contentdepth
                        |@scale|@scalefit"/>

  <xsl:variable name="href"
                select="f:mediaobject-href($filename)"/>

  <xsl:variable name="img">
    <xsl:choose>
      <!-- attempt to handle audio data -->
      <xsl:when test="self::db:audiodata">
        <object data="{$href}">
          <!-- this is a complete hack; DocBook needs more markup -->
          <xsl:if test="@condition = 'hidden'">
            <param name="hidden" value="true"/>
          </xsl:if>
          <xsl:if test="@role = 'autostart'">
            <param name="autostart" value="true"/>
          </xsl:if>
        </object>
      </xsl:when>

      <xsl:when xmlns:svg="http://www.w3.org/2000/svg"
                test="$format = 'svg' and svg:*">
        <xsl:apply-templates/>
      </xsl:when>

      <xsl:when test="lower-case($format) = 'svg'">
        <object data="{$href}" type="image/svg+xml">
          <xsl:call-template name="t:process-image-attributes">
            <xsl:with-param name="alt" select="$alt"/>
            <xsl:with-param name="html.depth" select="$html.depth"/>
            <xsl:with-param name="html.width" select="$html.width"/>
            <xsl:with-param name="longdesc" select="$longdesc"/>
            <xsl:with-param name="scale" select="$scale"/>
            <xsl:with-param name="scalefit" select="$scalefit"/>
            <xsl:with-param name="scaled.contentdepth"
                            select="$scaled.contentdepth"/>
            <xsl:with-param name="scaled.contentwidth"
                            select="$scaled.contentwidth"/>
            <xsl:with-param name="viewport" select="$viewport"/>
          </xsl:call-template>
          <xsl:if test="@align and @align != 'center'">
            <xsl:attribute name="align" select="@align"/>
          </xsl:if>
          <xsl:if test="$use.embed.for.svg != 0">
            <embed src="{$href}" type="image/svg+xml">
              <xsl:call-template name="t:process-image-attributes">
                <xsl:with-param name="alt" select="$alt"/>
                <xsl:with-param name="html.depth" select="$html.depth"/>
                <xsl:with-param name="html.width" select="$html.width"/>
                <xsl:with-param name="longdesc" select="$longdesc"/>
                <xsl:with-param name="scale" select="$scale"/>
                <xsl:with-param name="scalefit" select="$scalefit"/>
                <xsl:with-param name="scaled.contentdepth"
                                select="$scaled.contentdepth"/>
                <xsl:with-param name="scaled.contentwidth"
                                select="$scaled.contentwidth"/>
                <xsl:with-param name="viewport" select="$viewport"/>
              </xsl:call-template>
            </embed>
          </xsl:if>
        </object>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$tag}">
          <xsl:if test="@role or ../@role">
            <xsl:variable name="values"
                          select="tokenize(concat(@role, ' ', ../@role), '\s+')"/>
            <xsl:attribute name="class">
              <xsl:value-of select="normalize-space(string-join($values, ' '))"/>
            </xsl:attribute>
          </xsl:if>

          <xsl:copy-of select="$tag-attributes"/>
          <xsl:if test="$tag = 'img' and ancestor::db:imageobjectco">
            <xsl:choose>
              <xsl:when test="$scaled">
                <!-- It might be possible to handle some scaling; needs -->
                <!-- more investigation -->
                <xsl:message>
                  <xsl:text>Warning: imagemaps not supported </xsl:text>
                  <xsl:text>on scaled images</xsl:text>
                </xsl:message>
              </xsl:when>
              <xsl:when test="empty($imageproperties)">
                <xsl:message>
                  <xsl:text>Warning: imagemaps require image </xsl:text>
                  <xsl:text>intrinsics extension</xsl:text>
                </xsl:message>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="border" select="0"/>
                <xsl:attribute name="usemap" select="concat('#',f:imagemap-name(ancestor::db:imageobjectco))"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

          <xsl:attribute name="src" select="$href"/>

          <xsl:if test="@align">
            <xsl:attribute name="align">
              <xsl:choose>
                <xsl:when test="@align = 'center'">middle</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@align"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>

          <xsl:call-template name="t:process-image-attributes">
            <xsl:with-param name="alt">
              <xsl:choose>
                <xsl:when test="$alt != ''">
                  <xsl:copy-of select="$alt"/>
                </xsl:when>
                <xsl:when test="ancestor::db:figure">
                  <xsl:value-of select="normalize-space(ancestor::db:figure/db:info/db:title)"/>
                </xsl:when>
              </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="html.depth" select="$html.depth"/>
            <xsl:with-param name="html.width" select="$html.width"/>
            <xsl:with-param name="longdesc" select="$longdesc"/>
            <xsl:with-param name="scale" select="$scale"/>
            <xsl:with-param name="scalefit" select="$scalefit"/>
            <xsl:with-param name="scaled.contentdepth"
                            select="$scaled.contentdepth"/>
            <xsl:with-param name="scaled.contentwidth"
                            select="$scaled.contentwidth"/>
            <xsl:with-param name="viewport" select="$viewport"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="bgcolor"
     select="f:pi(ancestor-or-self::db:imageobject/processing-instruction('dbhtml'),
             'background-color')"/>

  <xsl:variable name="use.viewport"
                select="$viewport != 0
                        and ($html.width != ''
                             or ($html.depth != '' and $depth-units != '%')
                             or $bgcolor != ''
                             or @valign)"/>

  <xsl:choose>
    <xsl:when test="$use.viewport">
      <table border="0" summary="Manufactured viewport for HTML image"
             cellspacing="0" cellpadding="0">
        <xsl:if test="$html.width != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="$html.width"/>
          </xsl:attribute>
        </xsl:if>
        <!-- align the table so that the viewport is aligned -->
<!-- or not
        <xsl:if test="@align">
          <xsl:attribute name="align">
            <xsl:value-of select="@align"/>
          </xsl:attribute>
        </xsl:if>
-->
        <tr>
          <xsl:if test="$html.depth != '' and $depth-units != '%'">
            <!-- don't do this for percentages because browsers get confused -->
            <xsl:attribute name="style">
              <xsl:text>height: </xsl:text>
              <xsl:value-of select="$html.depth"/>
              <xsl:text>px</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <td>
            <xsl:if test="$bgcolor != ''">
              <xsl:attribute name="style">
                <xsl:text>background-color: </xsl:text>
                <xsl:value-of select="$bgcolor"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="@align">
              <xsl:attribute name="align">
                <xsl:value-of select="@align"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="@valign">
              <xsl:attribute name="valign">
                <xsl:value-of select="@valign"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$img"/>
          </td>
        </tr>
      </table>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$img"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="$tag = 'img'
                and ancestor::db:imageobjectco
                and not($scaled)
                and exists($imageproperties)">
    <map name="{f:imagemap-name(ancestor::db:imageobjectco)}">
      <xsl:for-each select="ancestor::db:imageobjectco/db:areaspec//db:area">
        <xsl:variable name="units" as="xs:string"
                      select="if (@units) then @units
                              else if (../@units) then ../@units
                                   else 'calspair'"/>

        <xsl:choose>
          <xsl:when test="$units = 'calspair'">
            <xsl:variable name="coords"
                          select="tokenize(normalize-space(@coords),
                                           '[\s,]+')"/>

            <xsl:variable name="x1p" select="xs:decimal($coords[1]) div 100.0"/>
            <xsl:variable name="y1p" select="xs:decimal($coords[2]) div 100.0"/>
            <xsl:variable name="x2p" select="xs:decimal($coords[3]) div 100.0"/>
            <xsl:variable name="y2p" select="xs:decimal($coords[4]) div 100.0"/>

            <area shape="rect">
              <xsl:choose>
                <xsl:when test="@linkends
                                or (parent::db:areaset and ../@linkends)">
                  <xsl:variable name="idrefs"
                                select="if (@linkends)
                                        then normalize-space(@linkends)
                                        else normalize-space(../@linkends)"/>

                  <xsl:variable name="target"
                                select="key('id', tokenize($idrefs, '[\s]'))
                                  [1]"/>

                  <xsl:if test="$target">
                    <xsl:attribute name="href"
                                   select="f:href(/,$target)"/>
                  </xsl:if>
                </xsl:when>
                <xsl:when test="@xlink:href">
                  <xsl:attribute name="href" select="@xlink:href"/>
                </xsl:when>
              </xsl:choose>

              <xsl:attribute name="coords">
                <xsl:value-of select="round($x1p * $intrinsicwidth div 100.0)"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="round($intrinsicdepth
                                        - ($y1p * $intrinsicdepth div 100.0))"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="round($x2p * $intrinsicwidth div 100.0)"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="round($intrinsicdepth
                                        - ($y2p * $intrinsicdepth div 100.0))"/>
              </xsl:attribute>
            </area>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>
              <xsl:text>Warning: only calspair supported </xsl:text>
              <xsl:text>in imageobjectco</xsl:text>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </map>
  </xsl:if>
</xsl:template>

<xsl:function name="f:imagemap-name" as="xs:string">
  <xsl:param name="ioco" as="element(db:imageobjectco)"/>

  <!-- this whole test for mapid exists almost exclusively to make the xspec tests
       pass. It's probably overkill, but it might come in useful I suppose -->
  <xsl:choose>
    <xsl:when test="exists(f:pi($ioco/processing-instruction('dbhtml'), 'mapid'))">
      <xsl:value-of
          select="f:pi($ioco/processing-instruction('dbhtml'), 'mapid')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($ioco)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:template name="t:process-image-attributes">
  <xsl:param name="alt"/>
  <xsl:param name="html.width"/>
  <xsl:param name="html.depth"/>
  <xsl:param name="longdesc"/>
  <xsl:param name="scale"/>
  <xsl:param name="scalefit"/>
  <xsl:param name="scaled.contentdepth"/>
  <xsl:param name="scaled.contentwidth"/>
  <xsl:param name="viewport"/>

  <xsl:choose>
    <xsl:when test="@contentwidth or @contentdepth">
      <!-- ignore @width/@depth, @scale, and @scalefit if specified -->
      <xsl:if test="@contentwidth">
        <xsl:attribute name="width">
          <xsl:value-of select="$scaled.contentwidth"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@contentdepth">
        <xsl:attribute name="height">
          <xsl:value-of select="$scaled.contentdepth"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:when>

    <xsl:when test="number($scale) != 1.0">
      <!-- scaling is always uniform, we only have to specify one dimension -->
      <!-- ignore @scalefit if specified -->
      <xsl:attribute name="width">
        <xsl:value-of select="$scaled.contentwidth"/>
      </xsl:attribute>
    </xsl:when>

    <xsl:when test="$scalefit != 0">
      <xsl:choose>
        <xsl:when test="contains($html.width, '%')">
          <xsl:choose>
            <xsl:when test="$viewport != 0">
              <!-- The *viewport* will be scaled, so use 100% here! -->
              <xsl:attribute name="width">
                <xsl:value-of select="'100%'"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="width">
                <xsl:value-of select="$html.width"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="contains($html.depth, '%')">
          <!-- HTML doesn't deal with this case very well...do nothing -->
        </xsl:when>

        <xsl:when test="$scaled.contentwidth != '' and $html.width != ''
                        and $scaled.contentdepth != '' and $html.depth != ''">
          <!-- scalefit should not be anamorphic; figure out which direction -->
          <!-- has the limiting scale factor and scale in that direction -->
          <xsl:choose>
            <xsl:when test="$html.width div $scaled.contentwidth &gt;
                            $html.depth div $scaled.contentdepth">
              <xsl:attribute name="height">
                <xsl:value-of select="$html.depth"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="width">
                <xsl:value-of select="$html.width"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$scaled.contentwidth != '' and $html.width != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="$html.width"/>
          </xsl:attribute>
        </xsl:when>

        <xsl:when test="$scaled.contentdepth != '' and $html.depth != ''">
          <xsl:attribute name="height">
            <xsl:value-of select="$html.depth"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>

  <xsl:if test="$alt != ''">
    <xsl:attribute name="alt">
      <xsl:value-of select="$alt"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:if test="$longdesc != ''">
    <xsl:attribute name="longdesc">
      <xsl:value-of select="$longdesc"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:if test="@align and $viewport = 0">
    <xsl:attribute name="align">
      <xsl:choose>
        <xsl:when test="@align = 'center'">middle</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@align"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:mediaobject">
  <xsl:variable name="olist" select="*[not(self::db:info) and not(self::db:alt)]"/>

  <xsl:variable name="object.index"
                select="f:select-mediaobject-index($olist)"/>

  <xsl:variable name="object" select="$olist[position() = $object.index]"/>

  <xsl:variable name="center"
                select="if ($object/*/@align = 'center') then 'centerimg' else ()"/>

  <!-- hack -->
  <xsl:choose>
    <xsl:when test="$object/self::db:audioobject
                    and $object/db:audiodata/@condition='hidden'">
      <!-- don't output a div wrapper -->
      <xsl:apply-templates select="$object"/>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:sequence select="f:html-attributes(., f:node-id(.), local-name(.), (@role,$center), @h:*)"/>
        <xsl:if test="$html.longdesc != 0 and $html.longdesc.link != 0">
          <xsl:call-template name="t:longdesc-link">
            <xsl:with-param name="textobject"
                            select="db:textobject[not(db:phrase)][1]"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates select="$object"/>
        <xsl:apply-templates select="db:caption"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:inlinemediaobject">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:call-template name="t:select-mediaobject"/>
  </span>
</xsl:template>

<xsl:template match="db:programlisting/db:inlinemediaobject
                     |db:screen/db:inlinemediaobject" priority="2">
  <!-- the additional span causes problems in some cases -->
  <xsl:call-template name="t:select-mediaobject"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:imageobjectco">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates select="db:imageobject"/>
    <xsl:apply-templates select="db:calloutlist"/>
  </div>
</xsl:template>

<xsl:template match="db:imageobject">
  <xsl:choose>
    <xsl:when xmlns:svg="http://www.w3.org/2000/svg"
              test="svg:*">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="db:imagedata"/>
    </xsl:otherwise>
  </xsl:choose>
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

    <xsl:otherwise>
      <xsl:variable name="longdesc.uri"
                    select="f:longdesc-uri(ancestor::db:imageobject/parent::*)"/>

      <xsl:variable name="phrases"
                    select="../../db:textobject[db:phrase]"/>

      <xsl:variable name="normalphrases"
                    select="$phrases[not(@role) or @role != 'tex']"/>

      <xsl:call-template name="t:process-image">
        <xsl:with-param name="alt">
          <xsl:choose>
            <xsl:when test="../../db:alt">
              <xsl:value-of select="../../db:alt"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$normalphrases[1]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="longdesc" select="$longdesc.uri"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:videoobject">
  <xsl:apply-templates select="db:videodata"/>
</xsl:template>

<xsl:template match="db:videodata">
  <xsl:call-template name="t:process-image">
    <xsl:with-param name="tag" select="'embed'"/>
    <xsl:with-param name="alt">
      <xsl:apply-templates select="(../../db:textobject/db:phrase)[1]"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:audioobject">
  <xsl:apply-templates select="db:audiodata"/>
</xsl:template>

<xsl:template match="db:audiodata">
  <xsl:call-template name="t:process-image">
    <xsl:with-param name="alt">
      <xsl:apply-templates select="(../../db:textobject/db:phrase)[1]"/>
    </xsl:with-param>
  </xsl:call-template>
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
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- ==================================================================== -->
<!-- "Support" for SVG -->

<xsl:template match="svg:*" xmlns:svg="http://www.w3.org/2000/svg">
  <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/2000/svg">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- Resolve xml:base attributes -->
<xsl:template match="@fileref">
  <xsl:choose>
    <xsl:when test="starts-with(., '/')">
      <!-- special case: if it's absolute w/o a scheme, leave it alone -->
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="f:resolve-path(.,base-uri(.))"/>
<!--
      <xsl:variable name="absuri" select="f:resolve-path(.,base-uri(.))"/>
      <xsl:choose>
        <xsl:when test="starts-with($absuri, 'file://')">
          <xsl:value-of select="substring-after($absuri, 'file:/')"/>
        </xsl:when>
        <xsl:when test="starts-with($absuri, 'file:/')">
          <xsl:value-of select="substring-after($absuri, 'file:')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$absuri"/>
        </xsl:otherwise>
      </xsl:choose>
-->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:function name="f:longdesc-uri" as="xs:string?">
  <xsl:param name="node" as="element()?"/>

  <xsl:if test="exists($node) and $html.longdesc != 0
                and $node/db:textobject[not(db:phrase)]">
    <xsl:variable name="image-id" select="f:node-id($node)"/>
    <xsl:variable name="dbhtml.dir" select="f:dbhtml-dir($node)"/>
    <xsl:value-of>
      <xsl:choose>
        <xsl:when test="$dbhtml.dir != ''">
          <xsl:value-of select="$dbhtml.dir"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$base.dir"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat('ld-',$image-id,$html.ext)"/>
    </xsl:value-of>
  </xsl:if>
</xsl:function>

<xsl:template name="t:longdesc-link">
  <xsl:param name="textobject" as="element()?"/>

  <xsl:if test="exists($textobject) and $html.longdesc != 0">
    <xsl:variable name="this.uri"
                  select="concat($base.dir, f:href-target-uri($textobject))"/>

    <xsl:variable name="href.to"
                  select="f:trim-common-uri-paths(f:longdesc-uri($textobject),
                                                  $this.uri)"/>

    <div class="longdesc-link">
      <xsl:text>[</xsl:text>
      <a href="{$href.to}" target="longdesc"
         title="Link to long description">D</a>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="t:write-longdesc">
  <xsl:param name="mediaobject" select="."/>
  <xsl:variable name="firsttext"
                select="$mediaobject/db:textobject[not(db:phrase)][1]"/>

  <xsl:variable name="filename" select="f:longdesc-uri($firsttext)"/>

  <xsl:if test="$html.longdesc != 0
                and $mediaobject/db:textobject[not(db:phrase)]
                and $filename != ''">

    <xsl:result-document href="{$filename}" method="xhtml">
      <xsl:call-template name="t:user-preroot"/>
      <html>
        <xsl:call-template name="t:head">
          <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        <body>
          <xsl:for-each select="$mediaobject/db:textobject[not(db:phrase)]">
            <xsl:apply-templates select="*"/>
          </xsl:for-each>
        </body>
      </html>
    </xsl:result-document>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
