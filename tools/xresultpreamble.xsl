<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                exclude-result-prefixes="c h"
                version="2.0">

<xsl:template match="c:param-set">
  <x:preamble>
    <xsl:choose>
      <xsl:when test="c:param">
        <div>
          <p>These tests were run with the following parameters:</p>
          <dl>
            <xsl:for-each select="c:param">
              <dt><xsl:value-of select="@name"/></dt>
              <dd><xsl:value-of select="@value"/></dd>
            </xsl:for-each>
          </dl>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div>
          <p>These tests were run with no explicit parameters.</p>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </x:preamble>
</xsl:template>

</xsl:stylesheet>
