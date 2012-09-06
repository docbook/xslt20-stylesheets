<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:ext="http://docbook.org/extensions/xslt20"
                xmlns:xdmp="http://marklogic.com/xdmp"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:mp="http://docbook.org/xslt/ns/mode/private"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:tp="http://docbook.org/xslt/ns/template/private"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="doc h f m mp fn db t ext xdmp xs tp"
                version="2.0">

<xsl:include href="verbatim-patch.xsl"/>

<xsl:param name="pygments-default" select="0"/>
<xsl:param name="pygmenter-uri" select="''"/>

<xsl:template match="db:programlistingco|db:screenco">
  <xsl:variable name="areas-unsorted" as="element()*">
    <xsl:apply-templates select="db:areaspec"/>
  </xsl:variable>

  <xsl:variable name="areas" as="element()*"
                xmlns:ghost="http://docbook.org/ns/docbook/ephemeral">
    <xsl:for-each select="$areas-unsorted">
      <xsl:sort data-type="number" select="@ghost:line"/>
      <xsl:sort data-type="number" select="@ghost:col"/>
      <xsl:sort data-type="number" select="@ghost:number"/>
      <xsl:if test="@ghost:line">
	<xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:apply-templates select="db:programlisting|db:screen" mode="m:verbatim">
    <xsl:with-param name="areas" select="$areas"/>
  </xsl:apply-templates>

  <xsl:apply-templates select="db:calloutlist"/>
</xsl:template>

<xsl:template match="db:programlisting|db:address|db:screen|db:synopsis|db:literallayout">
  <xsl:apply-templates select="." mode="m:verbatim"/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:verbatim" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing normalized verbatim elements</refpurpose>

<refdescription>
<para>This mode is used to format normalized verbatim elements.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:programlisting|db:screen|db:synopsis
		     |db:literallayout[@class='monospaced']"
	      mode="m:verbatim">
  <xsl:call-template name="tp:format-as-verbatim"/>
</xsl:template>

<xsl:template match="db:literallayout|db:address"
	      mode="m:verbatim">
  <xsl:variable name="asTable" select="f:lineNumbering(.,'asTable')" as="xs:boolean"/>
  <xsl:choose>
    <xsl:when test="$asTable">
      <xsl:call-template name="tp:format-as-verbatim"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="verbatim" as="node()*">
        <xsl:apply-templates/>
      </xsl:variable>
      <xsl:variable name="formatted" as="node()*">
        <xsl:call-template name="t:verbatim-patch-html">
          <xsl:with-param name="content" select="$verbatim"/>
        </xsl:call-template>
      </xsl:variable>
      <div>
        <xsl:sequence select="f:html-attributes(.)"/>
        <xsl:apply-templates select="$formatted" mode="mp:literallayout"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tp:format-as-verbatim">
  <xsl:param name="areas" select="()"/>

  <xsl:variable name="pygments-pi" as="xs:string?"
                select="f:pi(/processing-instruction('dbhtml'), 'pygments')"/>

  <xsl:variable name="use-pygments" as="xs:boolean"
                select="$pygments-pi = 'true' or $pygments-pi = 'yes' or $pygments-pi = '1'
                        or (contains(@role,'pygments') and not(contains(@role,'nopygments')))"/>

  <xsl:variable name="verbatim" as="node()*">
    <!-- n.b. look below where the class attribute is computed -->
    <xsl:choose>
      <xsl:when test="contains(@role,'nopygments') or string-length(.) &gt; 9000
                      or self::db:literallayout or exists(*)">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$pygments-default = 0 and not($use-pygments)">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when use-when="function-available('xdmp:http-post')"
                test="$pygmenter-uri != ''">
        <xsl:sequence select="ext:highlight(string(.), string(@language))"/>
      </xsl:when>
      <xsl:when use-when="function-available('ext:highlight')"
                test="true()">
        <xsl:sequence select="ext:highlight(string(.), string(@language))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="formatted" as="node()*">
    <xsl:call-template name="t:verbatim-patch-html">
      <xsl:with-param name="content" select="$verbatim"/>
      <xsl:with-param name="areas" select="$areas"/>
    </xsl:call-template>
  </xsl:variable>

  <div>
    <xsl:sequence select="f:html-attributes(.)"/>
    <xsl:attribute name="class">
      <xsl:value-of select="string-join((local-name(.), @role), ' ')"/>
      <!-- n.b. look above where $verbatim is computed -->
      <xsl:choose>
        <xsl:when test="contains(@role,'nopygments') or string-length(.) &gt; 9000
                        or self::db:literallayout or exists(*)"/>
        <xsl:when test="$pygments-default = 0 and not($use-pygments)"/>
        <xsl:when use-when="function-available('xdmp:http-post')"
                  test="$pygmenter-uri != ''">
          <xsl:value-of select="' highlight'"/>
        </xsl:when>
        <xsl:when use-when="function-available('ext:highlight')"
                  test="true()">
          <xsl:value-of select="' highlight'"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:attribute>

    <xsl:variable name="asTable" select="f:lineNumbering(.,'asTable')" as="xs:boolean"/>

    <xsl:choose>
      <xsl:when test="$asTable">
        <xsl:variable name="startnum" as="xs:decimal">
          <xsl:choose>
            <xsl:when test="not(@continuation) or @continuation != 'continues'">
              <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="prev"
                            select="preceding::*[node-name(.)=node-name(.)][1]"/>
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

        <xsl:variable name="everyNth" select="f:lineNumbering(.,'everyNth')" as="xs:integer"/>
        <xsl:variable name="minlines" select="f:lineNumbering(.,'minlines')" as="xs:integer"/>

        <xsl:variable name="lines" select="tokenize(string-join($formatted, ' '), '&#10;')"/>

        <xsl:variable name="wrapper"
                      select="if ((self::db:literallayout and not(@class='monospaced'))
                                   or self::db:address)
                              then 'div'
                              else 'pre'"/>

        <table class="verbatimlined" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top" align="right" class="verbatimlinenumbers">
              <xsl:element name="{$wrapper}">
                <xsl:for-each select="$lines">
                  <xsl:variable name="linenumber" select="position() + $startnum"/>
                  <div class="verbatimline verbatimlinenumber {
                              if (position() mod 2 = 0) then 'verbatimeven' else 'verbatimodd'
                              }">
                    <div class="vlcontent">
                      <xsl:if test="position() = 1 or ($everyNth = 0) or ($linenumber mod $everyNth = 0)">
                        <xsl:value-of select="$linenumber"/>
                      </xsl:if>
                      <xsl:text>&#10;</xsl:text>
                    </div>
                  </div>
                </xsl:for-each>
              </xsl:element>
            </td>
            <td valign="top" align="left" class="verbatimlines">
              <xsl:element name="{$wrapper}">
                <xsl:if test="@language">
                  <xsl:attribute name="class" select="@language"/>
                </xsl:if>
                <xsl:sequence select="$formatted"/>
              </xsl:element>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <!-- Removed spaces before xsl:attribute so that if <pre> is schema validated
             and magically grows an xml:space="preserve" attribute, the processor
             doesn't fall over because we've added an attribute after a text node.
             Maybe this only happens in MarkLogic. Maybe it's a bug. For now: whatever. -->
        <pre><xsl:if test="@language"><xsl:attribute name="class" select="@language"/></xsl:if><xsl:sequence select="$formatted"/></pre>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template match="*" mode="mp:literallayout">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="mp:literallayout"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()"
	      mode="mp:literallayout">
  <xsl:copy/>
</xsl:template>

<xsl:template match="text()" mode="mp:literallayout">
  <xsl:choose>
    <xsl:when test="system-property('xsl:vendor') = 'MarkLogic Corporation'">
      <xsl:variable name="parts" as="item()*">
        <xsl:analyze-string select="." regex="&#10;">
          <xsl:matching-substring>
            <wrap><br/><xsl:text>&#10;</xsl:text></wrap>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:analyze-string select="." regex="[\s]">
              <xsl:matching-substring>
                <wrap><xsl:text>&#160;</xsl:text></wrap>
              </xsl:matching-substring>
              <xsl:non-matching-substring>
                <wrap><xsl:copy/></wrap>
              </xsl:non-matching-substring>
            </xsl:analyze-string>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:variable>
      <xsl:for-each select="$parts/node()">
        <xsl:sequence select="./node()"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:analyze-string select="." regex="&#10;">
        <xsl:matching-substring>
          <br/><xsl:text>&#10;</xsl:text>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:analyze-string select="." regex="[\s]">
            <xsl:matching-substring>
              <xsl:text>&#160;</xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
              <xsl:copy/>
            </xsl:non-matching-substring>
          </xsl:analyze-string>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- This is a highlight implementation that works on MarkLogic server.
     It relies on a web service to perform the actual highlighting. -->
<xsl:function use-when="function-available('xdmp:http-post')"
              name="ext:highlight" as="node()*">
  <xsl:param name="code"/>
  <xsl:param name="language"/>

  <xsl:variable name="code-node" as="text()">
    <xsl:value-of select="$code"/>
  </xsl:variable>

  <xsl:variable name="highlighted"
                select="xdmp:http-post(concat($pygmenter-uri,'?language=',$language),(),$code-node)"/>

  <xsl:sequence select="$highlighted[2]//h:pre/node()"/>
</xsl:function>

</xsl:stylesheet>
