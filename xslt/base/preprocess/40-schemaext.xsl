<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db f mp xs"
                version="2.0">

<xsl:param name="schemaext.schema" select="''"/>

<xsl:param name="schema"
	   select="if ($schemaext.schema = '')
		   then ()
		   else document($schemaext.schema)"/>

<xsl:param name="schema-extensions" as="element()*" select="()"/>

<xsl:template match="/" as="document-node()">
  <xsl:variable name="content" as="document-node()">
    <xsl:copy>
      <xsl:apply-templates mode="m:schemaextensions"/>
    </xsl:copy>
  </xsl:variable>
  <xsl:sequence select="$content"/>
</xsl:template>

<xsl:template match="*" mode="m:schemaextensions"
	      xmlns:r="http://nwalsh.com/xmlns/schema-remap/"
	      xmlns:rng="http://relaxng.org/ns/structure/1.0">

  <xsl:variable name="element-name" select="node-name(.)"/>
  <xsl:variable name="known" select="for $n in $schema-extensions
				     return
				        if (node-name($n) = $element-name)
					then $n
					else ()"/>


  <!-- There are some limitations here with multiple patterns that define
       the same element, with namespaced elements, and with multiple remaps.
       We can come back to them if they ever matter. -->
  <xsl:variable name="remap"
		select="$schema
			//rng:element[resolve-QName(@name,.)=$element-name
                                      and r:remap]/r:remap[1]"/>

  <!--
  <xsl:message>
    <xsl:text>normalize </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="name($remap/*[1])"/>
    <xsl:text>)</xsl:text>
  </xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="$known">
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="m:schemaextensions"/>
      </xsl:copy>
    </xsl:when>
    <xsl:when test="$remap">
      <xsl:variable name="mapped" as="element()">
	<xsl:choose>
	  <xsl:when test="$remap//r:content">
	    <xsl:apply-templates select="$remap/*" mode="m:remap">
	      <xsl:with-param name="attrs" select="@*"/>
	      <xsl:with-param name="content" select="node()"/>
	    </xsl:apply-templates>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:element name="{local-name($remap/*[1])}"
			 namespace="{namespace-uri($remap/*[1])}">
	      <xsl:copy-of select="$remap/*[1]/@*"/>
	      <xsl:copy-of select="@*"/>
	      <xsl:copy-of select="node()"/>
	    </xsl:element>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="$mapped" mode="m:schemaextensions"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="m:schemaextensions"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:schemaextensions">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="r:content" mode="m:remap"
	      xmlns:r="http://nwalsh.com/xmlns/schema-remap/">
  <xsl:param name="attrs" select="()"/>
  <xsl:param name="content" select="()"/>
  <xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template match="*" mode="m:remap">
  <xsl:param name="attrs" select="()"/>
  <xsl:param name="content" select="()"/>

  <xsl:element name="{local-name(.)}"
	       namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:if test="$attrs">
      <xsl:copy-of select="$attrs"/>
    </xsl:if>
    <xsl:apply-templates mode="m:remap">
      <xsl:with-param name="content" select="$content"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="text()|processing-instruction()|comment()" mode="m:remap">
  <xsl:param name="attrs" select="()"/>
  <xsl:param name="content" select="()"/>
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
