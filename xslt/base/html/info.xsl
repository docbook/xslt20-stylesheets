<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f fn h m t xs"
                version="2.0">

<!-- many info elements are handled by ../common/inlines.xsl -->

<xsl:template match="db:orgname|db:orgdiv|db:shortaffil|db:artpagenums
                     |db:confdates|db:conftitle|db:confnum
                     |db:confsponsor|db:contractnum|db:contractsponsor
                     |db:volumenum|db:issuenum|db:seriesvolnums">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:call-template name="t:xlink"/>
  </span>
</xsl:template>

<xsl:template match="db:copyright">
  <xsl:param name="wrapper" select="'span'"/>

  <xsl:element name="{$wrapper}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:sequence select="f:html-attributes(.)"/>

    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>

    <xsl:text>&#160;©&#160;</xsl:text>

    <span class="years">
      <xsl:call-template name="t:copyright-years">
	<xsl:with-param name="years" select="db:year"/>
	<xsl:with-param name="print.ranges" select="$make.year.ranges"/>
	<xsl:with-param name="single.year.ranges"
			select="$make.single.year.ranges"/>
      </xsl:call-template>
    </span>

    <xsl:text>&#160;</xsl:text>

    <span class="holders">
      <xsl:apply-templates select="db:holder"/>
    </span>
  </xsl:element>
</xsl:template>

<xsl:template match="db:holder">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:holder">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:year">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:year">, </xsl:if>
</xsl:template>

<xsl:template match="db:revhistory">
  <xsl:variable name="has-revnumber" select="db:revision/db:revnumber"/>
  <xsl:variable name="has-date" select="db:revision/db:date"/>
  <xsl:variable name="has-author" select="db:revision/db:author
					  |db:revision/db:authorinitials"/>
  <xsl:variable name="has-desc" select="db:revision/db:revdescription"/>
  <xsl:variable name="has-remark" select="db:revision/db:revremark"/>

  <xsl:variable name="colspec" as="xs:integer*">
    <xsl:sequence select="if ($has-revnumber) then 1 else 0"/>
    <xsl:sequence select="if ($has-date) then 1 else 0"/>
    <xsl:sequence select="if ($has-author) then 1 else 0"/>
    <xsl:sequence select="if ($has-remark) then 1 else 0"/>
  </xsl:variable>

  <xsl:variable name="cols" select="sum($colspec)"/>

  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <table border="0" summary="Revision History">
      <tr>
        <td colspan="{$cols}">
          <span class="title">
            <xsl:value-of select="f:gentext(.)"/>
          </span>
        </td>
      </tr>
      <xsl:for-each select="db:revision">
        <tr>
          <xsl:sequence select="f:html-attributes(.)"/>
          <xsl:if test="$has-revnumber">
            <td class="revnumber">
              <xsl:apply-templates select="db:revnumber"/>
              <xsl:if test="not(db:revnumber)">&#160;</xsl:if>
            </td>
          </xsl:if>
          <xsl:if test="$has-date">
            <td class="date">
              <xsl:apply-templates select="db:date"/>
              <xsl:if test="not(db:date)">&#160;</xsl:if>
            </td>
          </xsl:if>
          <xsl:if test="$has-author">
            <td class="author">
              <xsl:apply-templates select="db:author|db:authorinitials"/>
              <xsl:if test="not(db:author|db:authorinitials)">&#160;</xsl:if>
            </td>
          </xsl:if>
          <xsl:if test="$has-remark">
            <td class="remark">
              <xsl:apply-templates select="db:revremark"/>
              <xsl:if test="not(db:revremark)">&#160;</xsl:if>
            </td>
          </xsl:if>
        </tr>
        <xsl:if test="$has-desc and db:revdescription">
          <tr class="revdescription">
            <xsl:if test="$cols &gt; 1">
              <td>&#160;</td>
            </xsl:if>
            <td class="revdescription">
              <xsl:if test="$cols &gt; 1">
                <xsl:attribute name="colspan" select="$cols - 1"/>
              </xsl:if>
              <xsl:apply-templates select="db:revdescription"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:for-each>
    </table>
  </div>
</xsl:template>

<xsl:template match="db:revdescription">
  <span>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

</xsl:stylesheet>
