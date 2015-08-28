<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:dbp="http://docbook.github.com/ns/pipeline"
                xmlns:exf="http://exproc.org/standard/functions"
                exclude-inline-prefixes="cx exf"
                name="main">
<p:input port="parameters" kind="parameter"/>

<p:option name="srcdir" select="'../src/'"/>
<p:option name="builddir" select="'../build/'"/>
<p:option name="pluginsdir" select="'../build/plugins/'"/>

<p:declare-step type="cx:message" xmlns:cx="http://xmlcalabash.com/ns/extensions">
  <p:input port="source" sequence="true"/>
  <p:output port="result" sequence="true"/>
  <p:option name="message" required="true"/>
</p:declare-step>

<p:directory-list include-filter="..*\.xml$">
  <p:with-option name="path" select="resolve-uri($srcdir)"/>
</p:directory-list>

<p:for-each name="loop">
  <p:iteration-source select="/c:directory/c:file"/>

  <cx:message>
    <p:with-option name="message" select="concat('Processing ', /*/@name)"/>
  </cx:message>

  <p:load>
    <p:with-option name="href" select="resolve-uri(/*/@name, base-uri(/*))"/>
  </p:load>

  <p:validate-with-relax-ng name="valid">
    <p:input port="schema">
      <p:document href="../../schemas/locale.rng"/>
    </p:input>
  </p:validate-with-relax-ng>

  <p:xslt name="add-missing">
    <p:input port="stylesheet">
      <p:document href="../../tools/build-l10n.xsl"/>
    </p:input>
    <p:with-param name="en.locale.file" select="'en.xml'"/>
  </p:xslt>

  <p:store method="xml" indent="false">
    <p:input port="source">
      <p:pipe step="add-missing" port="result"/>
    </p:input>
    <p:with-option name="href" select="concat(resolve-uri($builddir),/*/@name)">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:store>

  <p:xslt name="make-plugins">
    <p:input port="source">
      <p:pipe step="valid" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../../tools/build-plugins.xsl"/>
    </p:input>
  </p:xslt>

  <p:store method="text" indent="false" cx:decode="true">
    <p:input port="source">
      <p:pipe step="make-plugins" port="result"/>
    </p:input>
    <p:with-option name="href"
                   select="replace(
                              concat(resolve-uri($pluginsdir),/*/@name),
                              '.xml', '.xqy')">
      <p:pipe step="loop" port="current"/>
    </p:with-option>
  </p:store>
</p:for-each>

</p:declare-step>



<!--
<project name="DocBook XSLT 2.0 stylesheets - Gentext &amp; Localization" default="all">

  <property name="dbroot.dir" value="${ant.file}/../.."/>
  <import file="../tools/build-shared.xml"/>

  <fileset id="l10n-files" dir="src">
    <include name="*.xml"/>
  </fileset>

  <target name="all" depends="l10n,plugins"/>

  <target name="l10n">
    <echo>Validating l10n files...</echo>
    <jing rngfile="../schemas/locale.rnc" compactsyntax="true" checkid="false">
      <fileset refid="l10n-files"/>
    </jing>

    <echo>Adding missing translations from English master localization...</echo>
    <xslt style="../tools/build-l10n.xsl"
          destdir="build" basedir="src" includes="*.xml">
      <factory name="net.sf.saxon.TransformerFactoryImpl"/>
      <classpath refid="saxon.classpath"/>
      <param name="en.locale.file" expression="en.xml"/>
      <mapper type="identity"/>
    </xslt>
  </target>

  <target name="plugins" depends="l10n">
    <xslt style="../tools/build-plugins.xsl"
          destdir="build/plugins" basedir="build" includes="*.xml">
      <factory name="net.sf.saxon.TransformerFactoryImpl"/>
      <classpath refid="saxon.classpath"/>
      <mapper type="glob" from="*.xml" to="*.xqy"/>
    </xslt>
  </target>

  <target name="clean">
    <delete>
      <fileset dir=".">
        <include name="build/*.xml"/>
      </fileset>
    </delete>
  </target>

</project>
-->
