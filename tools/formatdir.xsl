<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                exclude-result-prefixes="c"
                version="2.0">

<xsl:template match="/c:directory" priority="10">
  <dl class="dirlist">
    <xsl:apply-templates select="c:directory[@name='release']"/>
    <xsl:apply-templates select="c:directory[@name!='release']"/>
    <xsl:apply-templates select="c:file"/>
  </dl>
</xsl:template>

<xsl:template match="c:directory">
  <xsl:variable name="class"
                select="if (count(ancestor::c:directory) &gt; 0)
                        then 'toggleClosed' else 'toggleOpen'"/>
  <dt class="dir {$class}" id="{generate-id(.)}">
    <xsl:value-of select="@name"/>
    <xsl:text>/</xsl:text>
  </dt>
  <dd class="dir {$class}" id="dd-{generate-id(.)}">
    <dl>
      <xsl:choose>
        <xsl:when test="@name = 'release'">
          <xsl:for-each select="c:directory">
            <xsl:sort select="@name" order="descending"/>
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="c:directory">
            <xsl:sort select="@name"/>
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:variable name="sorted">
        <xsl:for-each select="c:file[matches(@name, '^[0-9]+\..*$')]">
          <xsl:sort select="substring-before(@name, '.')" data-type="number"/>
          <c:file>
            <xsl:attribute name="xml:base" select="base-uri(.)"/>
            <xsl:copy-of select="@*"/>
          </c:file>
        </xsl:for-each>

        <xsl:for-each select="c:file[not(matches(@name, '^[0-9]+\..*$'))]">
          <xsl:sort select="@name"/>
          <c:file>
            <xsl:attribute name="xml:base" select="base-uri(.)"/>
            <xsl:copy-of select="@*"/>
          </c:file>
        </xsl:for-each>
      </xsl:variable>

      <xsl:for-each-group select="$sorted/c:file" group-by="replace(@name,'^(.*)\.[^\.]+$','$1')">
        <dt>
          <xsl:choose>
            <xsl:when test="count(current-group()) = 1">
              <xsl:variable name="file" select="current-group()"/>
              <a href="{substring-after(base-uri($file), 'distributions/')}{$file/@name}">
                <xsl:value-of select="@name"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="current-grouping-key()"/>
              <xsl:for-each select="current-group()">
                <xsl:sort select="@name"/>
                <xsl:if test="position()&gt;1">, </xsl:if>
                <xsl:text>.</xsl:text>
                <a href="{substring-after(base-uri(.), 'distributions/')}{@name}">
                  <xsl:value-of select="replace(@name,'^.*\.([^\.]+)$','$1')"/>
                </a>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </dt>
      </xsl:for-each-group>
    </dl>
  </dd>
</xsl:template>

<xsl:template match="c:file">
  <dt>
    <a href="{substring-after(base-uri(.), 'distributions/')}{@name}">
      <xsl:value-of select="@name"/>
    </a>
  </dt>
</xsl:template>

</xsl:stylesheet>
