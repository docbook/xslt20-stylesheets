<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:p="http://pygments.org/"
                version="2.0"
                exclude-result-prefixes="h m">

<xsl:template match="h:span[@class='hll']" mode="m:verbatim">
  <fo:inline background-color="#ffffcc" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='c']" mode="m:verbatim">
  <!-- Comment -->
  <fo:inline color="#408080" font-style="italic" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='err']" mode="m:verbatim">
  <!-- Error -->
  <fo:inline border="1px solid #FF0000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='k']" mode="m:verbatim">
  <!-- Keyword -->
  <fo:inline color="#008000" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='o']" mode="m:verbatim">
  <!-- Operator -->
  <fo:inline color="#666666" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='cm']" mode="m:verbatim">
  <!-- Comment.Multiline -->
  <fo:inline color="#408080" font-style="italic" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='cp']" mode="m:verbatim">
  <!-- Comment.Preproc -->
  <fo:inline color="#BC7A00" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='c1']" mode="m:verbatim">
  <!-- Comment.Single -->
  <fo:inline color="#408080" font-style="italic" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='cs']" mode="m:verbatim">
  <!-- Comment.Special -->
  <fo:inline color="#408080" font-style="italic" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='gd']" mode="m:verbatim">
  <!-- Generic.Deleted -->
  <fo:inline color="#A00000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='ge']" mode="m:verbatim">
  <!-- Generic.Emph -->
  <fo:inline font-style="italic" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='gr']" mode="m:verbatim">
  <!-- Generic.Error -->
  <fo:inline color="#FF0000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='gh']" mode="m:verbatim">
  <!-- Generic.Heading -->
  <fo:inline color="#000080" font-weight="bold" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='gi']" mode="m:verbatim">
  <!-- Generic.Inserted -->
  <fo:inline color="#00A000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='go']" mode="m:verbatim">
  <!-- Generic.Output -->
  <fo:inline color="#808080" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='gp']" mode="m:verbatim">
  <!-- Generic.Prompt -->
  <fo:inline color="#000080" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='gs']" mode="m:verbatim">
  <!-- Generic.Strong -->
  <fo:inline font-weight="bold" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='gu']" mode="m:verbatim">
  <!-- Generic.Subheading -->
  <fo:inline color="#800080" font-weight="bold" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='gt']" mode="m:verbatim">
  <!-- Generic.Traceback -->
  <fo:inline color="#0040D0" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='kc']" mode="m:verbatim">
  <!-- Keyword.Constant -->
  <fo:inline color="#008000" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='kd']" mode="m:verbatim">
  <!-- Keyword.Declaration -->
  <fo:inline color="#008000" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='kn']" mode="m:verbatim">
  <!-- Keyword.Namespace -->
  <fo:inline color="#008000" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='kp']" mode="m:verbatim">
  <!-- Keyword.Pseudo -->
  <fo:inline color="#008000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='kr']" mode="m:verbatim">
  <!-- Keyword.Reserved -->
  <fo:inline color="#008000" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='kt']" mode="m:verbatim">
  <!-- Keyword.Type -->
  <fo:inline color="#B00040" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='m']" mode="m:verbatim">
  <!-- Literal.Number -->
  <fo:inline color="#666666" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='s']" mode="m:verbatim">
  <!-- Literal.String -->
  <fo:inline color="#BA2121" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='na']" mode="m:verbatim">
  <!-- Name.Attribute -->
  <fo:inline color="#7D9029" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='nb']" mode="m:verbatim">
  <!-- Name.Builtin -->
  <fo:inline color="#008000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='nc']" mode="m:verbatim">
  <!-- Name.Class -->
  <fo:inline color="#0000FF" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='no']" mode="m:verbatim">
  <!-- Name.Constant -->
  <fo:inline color="#880000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='nd']" mode="m:verbatim">
  <!-- Name.Decorator -->
  <fo:inline color="#AA22FF" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='ni']" mode="m:verbatim">
  <!-- Name.Entity -->
  <fo:inline color="#999999" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='ne']" mode="m:verbatim">
  <!-- Name.Exception -->
  <fo:inline color="#D2413A" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='nf']" mode="m:verbatim">
  <!-- Name.Function -->
  <fo:inline color="#0000FF" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='nl']" mode="m:verbatim">
  <!-- Name.Label -->
  <fo:inline color="#A0A000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='nn']" mode="m:verbatim">
  <!-- Name.Namespace -->
  <fo:inline color="#0000FF" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='nt']" mode="m:verbatim">
  <!-- Name.Tag -->
  <fo:inline color="#008000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='nv']" mode="m:verbatim">
  <!-- Name.Variable -->
  <fo:inline color="#19177C" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='ow']" mode="m:verbatim">
  <!-- Operator.Word -->
  <fo:inline color="#AA22FF" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='w']" mode="m:verbatim">
  <!-- Text.Whitespace -->
  <fo:inline color="#bbbbbb" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='mf']" mode="m:verbatim">
  <!-- Literal.Number.Float -->
  <fo:inline color="#666666" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='mh']" mode="m:verbatim">
  <!-- Literal.Number.Hex -->
  <fo:inline color="#666666" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='mi']" mode="m:verbatim">
  <!-- Literal.Number.Integer -->
  <fo:inline color="#666666" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='mo']" mode="m:verbatim">
  <!-- Literal.Number.Oct -->
  <fo:inline color="#666666" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='sb']" mode="m:verbatim">
  <!-- Literal.String.Backtick -->
  <fo:inline color="#BA2121" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='sc']" mode="m:verbatim">
  <!-- Literal.String.Char -->
  <fo:inline color="#BA2121" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='sd']" mode="m:verbatim">
  <!-- Literal.String.Doc -->
  <fo:inline color="#BA2121" font-style="italic" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='s2']" mode="m:verbatim">
  <!-- Literal.String.Double -->
  <fo:inline color="#BA2121" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='se']" mode="m:verbatim">
  <!-- Literal.String.Escape -->
  <fo:inline color="#BB6622" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='sh']" mode="m:verbatim">
  <!-- Literal.String.Heredoc -->
  <fo:inline color="#BA2121" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='si']" mode="m:verbatim">
  <!-- Literal.String.Interpol -->
  <fo:inline color="#BB6688" font-weight="inherit" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='sx']" mode="m:verbatim">
  <!-- Literal.String.Other -->
  <fo:inline color="#008000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='sr']" mode="m:verbatim">
  <!-- Literal.String.Regex -->
  <fo:inline color="#BB6688" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='s1']" mode="m:verbatim">
  <!-- Literal.String.Single -->
  <fo:inline color="#BA2121" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='ss']" mode="m:verbatim">
  <!-- Literal.String.Symbol -->
  <fo:inline color="#19177C" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='bp']" mode="m:verbatim">
  <!-- Name.Builtin.Pseudo -->
  <fo:inline color="#008000" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='vc']" mode="m:verbatim">
  <!-- Name.Variable.Class -->
  <fo:inline color="#19177C" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='vg']" mode="m:verbatim">
  <!-- Name.Variable.Global -->
  <fo:inline color="#19177C" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='vi']" mode="m:verbatim">
  <!-- Name.Variable.Instance -->
  <fo:inline color="#19177C" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="h:span[@class='il']" mode="m:verbatim">
  <!-- Literal.Number.Integer.Long -->
  <fo:inline color="#666666" p:class="{@class}">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

</xsl:stylesheet>
