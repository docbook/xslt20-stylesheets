<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db doc t xs"
                version="2.0">

<xsl:template match="db:task|db:tasksummary|db:taskprerequisites|db:taskrelated">
  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="object" as="element()">
      <div>
        <xsl:sequence select="f:html-attributes(.)"/>
	<xsl:apply-templates/>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
