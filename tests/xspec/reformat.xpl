<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:exf="http://exproc.org/standard/functions"
                exclude-inline-prefixes="cx exf"
                name="main">
<p:input port="parameters" kind="parameter"/>
<!--
<p:output port="result"/>
<p:serialization port="result" indent="true"/>
-->

<p:declare-step type="cx:message">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:load name="stylesheet" href="../../xslt/base/html/docbook.xsl"/>
<p:sink/>

<p:directory-list path="src" include-filter="^.*\.xml$"/>

<!-- strip out the tests that require special parameters, see below -->
<p:xslt>
  <p:input port="stylesheet">
    <p:inline>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="xs"
                version="2.0">

<xsl:template match="element()">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="attribute()|text()|comment()|processing-instruction()">
  <xsl:copy/>
</xsl:template>

<xsl:template match="c:file[@name='meta.001.xml'
                     or @name='glossary.002.xml'
                     or @name='bibliography.003.xml'
                     or @name='calloutlist.001.xml'
                     or @name='calloutlist.002.xml'
                     or @name='calloutlist.003.xml'
                     or @name='screen.001.xml'
                     or @name='figure.001.xml'
                     or @name='figure.002.xml'
                     or @name='figure.003.xml'
                     or @name='figure.004.xml'
                     or @name='informalfigure.001.xml'
                     or @name='equation.001.xml'
                     or @name='equation.002.xml'
                     or @name='equation.003.xml'
                     or @name='mediaobject.001.xml'
                     or @name='mediaobject.002.xml'
                     or @name='svg.001.xml'
                     or @name='mediaobjectco.001.xml'
                     or @name='stamp.001.xml'
                     or @name='stamp.002.xml'
                     or @name='stamp.003.xml'
                     or @name='stamp.004.xml'
                     or @name='stamp.005.xml'
                     or @name='stamp.006.xml'
                     or @name='stamp.007.xml'
                     or @name='stamp.008.xml'
                     or @name='stamp.009.xml'
                     or @name='stamp.010.xml'
                     or @name='stamp.011.xml'
                     or @name='stamp.012.xml'
                     or @name='stamp.013.xml'
                     or @name='stamp.050.xml'
                     or @name='stamp.051.xml'
                     or @name='profiling.001.xml'
                     or @name='imageobjectco.001.xml']"
              xmlns:c="http://www.w3.org/ns/xproc-step">
  <!-- drop it on the floor -->
</xsl:template>

</xsl:stylesheet>
    </p:inline>
  </p:input>
</p:xslt>

<p:make-absolute-uris match="c:file/@name"/>

<p:for-each name="iter1">
  <p:iteration-source select="c:directory/c:file"/>

  <cx:message>
    <p:with-option name="message" select="concat('Formatting ', /c:file/@name)"/>
  </cx:message>

  <p:load name="document">
    <p:with-option name="href" select="/c:file/@name"/>
  </p:load>

  <p:xslt name="xslt">
    <p:input port="source">
      <p:pipe step="document" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe step="stylesheet" port="result"/>
    </p:input>
    <p:with-param name="resource.root" select="'http://localhost:8119/base/'"/>
  </p:xslt>

  <p:sink/>

  <p:string-replace match="/c:file/@name" replace="replace(., '/src/', '/x/')">
    <p:input port="source">
      <p:pipe step="iter1" port="current"/>
    </p:input>
  </p:string-replace>

  <p:string-replace match="/c:file/@name" replace="replace(., '.xml', '.html')"/>

  <p:store method="xhtml">
    <p:input port="source">
      <p:pipe step="xslt" port="result"/>
    </p:input>
    <p:with-option name="href" select="/c:file/@name"/>
  </p:store>
</p:for-each>

<!-- now the special ones -->
<p:identity>
  <p:input port="source">
    <p:inline>
<c:directory xmlns:c="http://www.w3.org/ns/xproc-step" name="src"
             xml:base="src/">
  <c:file name="glossary.002.xml"/>
  <c:file name="bibliography.003.xml"/>
  <c:file name="calloutlist.001.xml"/>
  <c:file name="calloutlist.002.xml"/>
  <c:file name="calloutlist.003.xml"/>
  <c:file name="screen.001.xml"/>
  <c:file name="figure.001.xml"/>
  <c:file name="figure.002.xml"/>
  <c:file name="figure.003.xml"/>
  <c:file name="figure.004.xml"/>
  <c:file name="informalfigure.001.xml"/>
  <c:file name="equation.001.xml"/>
  <c:file name="equation.002.xml"/>
  <c:file name="equation.003.xml"/>
  <c:file name="mediaobject.001.xml"/>
  <c:file name="mediaobject.002.xml"/>
  <c:file name="svg.001.xml"/>
  <c:file name="mediaobjectco.001.xml"/>
  <c:file name="stamp.001.xml"/>
  <c:file name="stamp.002.xml"/>
  <c:file name="stamp.003.xml"/>
  <c:file name="stamp.004.xml"/>
  <c:file name="stamp.005.xml"/>
  <c:file name="stamp.006.xml"/>
  <c:file name="stamp.007.xml"/>
  <c:file name="stamp.008.xml"/>
  <c:file name="stamp.009.xml"/>
  <c:file name="stamp.010.xml"/>
  <c:file name="stamp.011.xml"/>
  <c:file name="stamp.012.xml"/>
  <c:file name="stamp.013.xml"/>
  <c:file name="stamp.050.xml"/>
  <c:file name="stamp.051.xml"/>
  <c:file name="profiling.001.xml"/>
  <c:file name="imageobjectco.001.xml"/>
</c:directory>
    </p:inline>
  </p:input>
</p:identity>

<p:make-absolute-uris match="c:file/@name"/>

<p:for-each name="iter2">
  <p:iteration-source select="c:directory/c:file"/>

  <cx:message>
    <p:with-option name="message" select="concat('Formatting ', /c:file/@name)"/>
  </cx:message>

  <p:load name="document">
    <p:with-option name="href" select="/c:file/@name"/>
  </p:load>

  <p:xslt name="xslt">
    <p:input port="source">
      <p:pipe step="document" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe step="stylesheet" port="result"/>
    </p:input>
    <p:with-param name="preprocess" select="'profile'"/>
    <p:with-param name="profile.os" select="'win'"/>
    <p:with-param name="bibliography.collection" select="'../etc/bibliography.collection.xml'"/>
    <p:with-param name="glossary.collection" select="'../etc/glossary.collection.xml'"/>
    <p:with-param name="resource.root" select="'http://docbook.github.com/latest/'"/>
  </p:xslt>

  <p:sink/>

  <p:string-replace match="/c:file/@name" replace="replace(., '/src/', '/x/')">
    <p:input port="source">
      <p:pipe step="iter2" port="current"/>
    </p:input>
  </p:string-replace>

  <p:string-replace match="/c:file/@name" replace="replace(., '.xml', '.html')"/>

  <p:store method="xhtml">
    <p:input port="source">
      <p:pipe step="xslt" port="result"/>
    </p:input>
    <p:with-option name="href" select="/c:file/@name"/>
  </p:store>
</p:for-each>

<p:xslt>
  <p:input port="source">
    <p:document href="src/meta.001.xml"/>
  </p:input>
  <p:input port="stylesheet">
    <p:pipe step="stylesheet" port="result"/>
  </p:input>
  <p:with-param name="html.stylesheets" select="'a.css b.css c.css'"/>
  <p:with-param name="link.madeby.uri" select="'mailto:john.doe@example.com'"/>
  <p:with-param name="html.base" select="'http://www.example.com/'"/>
  <p:with-param name="generate.meta.abstract" select="1"/>
  <p:with-param name="inherit.keywords" select="1"/>
  <p:with-param name="resource.root" select="'http://docbook.github.com/latest/'"/>
</p:xslt>

<p:store method="xhtml" href="x/meta.001.html"/>

<p:xslt>
  <p:input port="source">
    <p:document href="src/profiling.001.xml"/>
  </p:input>
  <p:input port="stylesheet">
    <p:pipe step="stylesheet" port="result"/>
  </p:input>
</p:xslt>

<p:store method="xhtml" href="x/prof1/profiling.001.html"/>

<p:xslt>
  <p:input port="source">
    <p:document href="src/profiling.001.xml"/>
  </p:input>
  <p:input port="stylesheet">
    <p:pipe step="stylesheet" port="result"/>
  </p:input>
  <p:with-param name="preprocess" select="'profile'"/>
  <p:with-param name="profile.os" select="'win'"/>
</p:xslt>

<p:store method="xhtml" href="x/prof2/profiling.001.html"/>

<p:xslt>
  <p:input port="source">
    <p:document href="src/profiling.001.xml"/>
  </p:input>
  <p:input port="stylesheet">
    <p:pipe step="stylesheet" port="result"/>
  </p:input>
  <p:with-param name="preprocess" select="'profile'"/>
  <p:with-param name="profile.os" select="'linux'"/>
</p:xslt>

<p:store method="xhtml" href="x/prof3/profiling.001.html"/>

</p:declare-step>
