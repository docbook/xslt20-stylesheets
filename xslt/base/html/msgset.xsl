<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:db="http://docbook.org/ns/docbook"
		exclude-result-prefixes="h f m fn db t"
                version="2.0">

<!-- ============================================================ -->

<xsl:template match="db:msgset">
  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:msgset]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-class(., local-name(.), @role)"/>
        <xsl:apply-templates/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:msgset/db:info/db:title"
	      mode="m:titlepage-mode"
              priority="100">
  <div class="title">
    <xsl:next-match/>
  </div>
</xsl:template>

<xsl:template match="db:msgentry">
  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:msgentry]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-class(., local-name(.), @role)"/>
        <xsl:apply-templates/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:msgentry/db:info/db:title"
	      mode="m:titlepage-mode"
              priority="100">
  <div class="title">
    <xsl:next-match/>
  </div>
</xsl:template>

<xsl:template match="db:simplemsgentry">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:msg">
  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:msg]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-class(., local-name(.), @role)"/>
        <xsl:apply-templates/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:msg/db:info/db:title"
	      mode="m:titlepage-mode"
              priority="100">
  <div class="title">
    <xsl:next-match/>
  </div>
</xsl:template>

<xsl:template match="db:msgmain">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:msgmain/db:info/db:title">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="db:msgsub">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:msgsub/db:info/db:title">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="db:msgrel">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:msgrel/db:info/db:title">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="db:msgtext">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:msginfo">
  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:msglevel">
  <p>
    <b>
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'msgset'"/>
        <xsl:with-param name="name" select="'MsgLevel'"/>
      </xsl:call-template>
    </b>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="db:msgorig">
  <p>
    <b>
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'msgset'"/>
        <xsl:with-param name="name" select="'MsgOrig'"/>
      </xsl:call-template>
    </b>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="db:msgaud">
  <p>
    <b>
      <xsl:call-template name="gentext-template">
        <xsl:with-param name="context" select="'msgset'"/>
        <xsl:with-param name="name" select="'MsgAud'"/>
      </xsl:call-template>
    </b>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="db:msgexplan">
  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:msgexplan]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-class(., local-name(.), @role)"/>
        <xsl:apply-templates/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:msgexplan/db:info/db:title"
	      mode="m:titlepage-mode"
              priority="100">
  <div class="title">
    <xsl:next-match/>
  </div>
</xsl:template>

</xsl:stylesheet>
