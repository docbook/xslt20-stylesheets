<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fp="http://docbook.org/xslt/ns/extension/private"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:tp="http://docbook.org/xslt/ns/template/private"
                xmlns:tmpl="http://docbook.org/xslt/titlepage-templates"
		xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="db m t tp ghost xs f fp tmpl h">

  <xsl:template match="*"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)?">
    <xsl:sequence select="()"/>
  </xsl:template>

  <xsl:template match="db:set|db:part|db:reference|db:article|db:setindex"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:recto>
        <header tmpl:class="titlepage">
          <db:title/>
          <db:subtitle/>
          <db:corpauthor/>
          <db:authorgroup/>
          <db:author/>
          <db:editor/>
          <db:othercredit/>
          <db:releaseinfo/>
          <db:copyright/>
          <db:legalnotice/>
          <db:pubdate/>
          <db:revision/>
          <db:revhistory/>
          <db:abstract/>
        </header>
      </tmpl:recto>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:book"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:recto>
        <header tmpl:class="titlepage">
          <db:title/>
          <db:subtitle/>
          <db:corpauthor/>
          <db:authorgroup/>
          <db:author/>
          <db:editor/>
          <db:othercredit/>
          <db:releaseinfo/>
          <db:copyright/>
          <db:legalnotice/>
          <db:pubdate/>
          <db:revision/>
          <db:revhistory/>
          <db:abstract/>
        </header>
      </tmpl:recto>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:preface|db:chapter|db:appendix|db:partintro"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage>
        <header tmpl:class="titlepage">
          <db:title/>
          <db:subtitle/>
          <db:authorgroup/>
          <db:author/>
          <db:releaseinfo/>
          <db:abstract/>
          <db:revhistory/>
        </header>
      </tmpl:titlepage>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:dedication|db:colophon"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage>
        <header tmpl:class="titlepage">
          <db:title/>
          <db:subtitle/>
        </header>
      </tmpl:titlepage>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:sect1|db:sect2|db:sect3|db:sect4|db:sect5
                       |db:section|db:simplesect"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage>
        <div class="section-titlepage">
          <db:title/>
          <db:subtitle/>
        </div>
      </tmpl:titlepage>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:refsection|db:refsect1|db:refsect2|db:refsect3"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage>
        <div class="refsection-titlepage">
          <db:title/>
          <db:subtitle/>
        </div>
      </tmpl:titlepage>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:bibliography|db:bibliodiv
                       |db:glossary|db:glossdiv
                       |db:index|db:indexdiv"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage>
        <header tmpl:class="titlepage">
          <db:title/>
        </header>
      </tmpl:titlepage>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:abstract|db:sidebar|db:task"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage>
        <header tmpl:class="titlepage">
          <db:title/>
        </header>
      </tmpl:titlepage>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:formalgroup|db:figure|db:example|db:table|db:equation
                       |db:procedure|db:step
                       |db:bibliolist|db:glosslist
                       |db:qandaset|db:qandadiv
                       |db:itemizedlist|db:orderedlist|db:variablelist
                       |db:segmentedlist|db:calloutlist
                       |db:warning|db:caution|db:note|db:tip|db:danger
                       |db:important|db:blockquote
                       |db:annotation|db:revhistory|db:msgset"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage>
        <db:title/>
      </tmpl:titlepage>
    </tmpl:templates>
  </xsl:template>

  <xsl:template match="db:tasksummary|db:taskprerequisites|db:taskrelated"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage>
        <db:title/>
      </tmpl:titlepage>
    </tmpl:templates>
  </xsl:template>

    <!-- refentry elements are special, they don't really get a titlepage -->
  <xsl:template match="db:refentry"
                mode="m:get-titlepage-templates" as="element(tmpl:templates)">
    <tmpl:templates>
      <tmpl:titlepage/>
    </tmpl:templates>
  </xsl:template>

</xsl:stylesheet>
