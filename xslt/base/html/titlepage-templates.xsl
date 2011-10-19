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

<!-- ============================================================ -->
<!-- User templates -->

<xsl:template name="t:user-titlepage-templates" as="element(tmpl:templates-list)?">
  <!-- Empty by default, override for custom templates -->
</xsl:template>

<!-- ============================================================ -->
<!-- System templates -->

<xsl:template name="t:titlepage-templates" as="element(tmpl:templates-list)">
  <!-- These are explicitly inline so that we can use XSLT during their construction -->
  <!-- Don't change these, define your own in t:user-titlepage-templates -->
  <tmpl:templates-list>

    <tmpl:templates name="set part reference article setindex">
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

    <tmpl:templates name="book">
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
        <hr tmpl:keep="true"/>
      </tmpl:recto>
    </tmpl:templates>

    <tmpl:templates name="preface chapter appendix partintro">
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

    <tmpl:templates name="dedication colophon">
      <tmpl:titlepage>
        <header tmpl:class="titlepage">
          <db:title/>
          <db:subtitle/>
        </header>
      </tmpl:titlepage>
    </tmpl:templates>

    <tmpl:templates name="section sect1 sect2 sect3 sect4 sect5
                          simplesect">
      <tmpl:titlepage>
        <div class="section-titlepage">
          <db:title/>
          <db:subtitle/>
        </div>
      </tmpl:titlepage>
    </tmpl:templates>

    <tmpl:templates name="refsection refsect1 refsect2 refsect3">
      <tmpl:titlepage>
        <div class="refsection-titlepage">
          <db:title/>
          <db:subtitle/>
        </div>
      </tmpl:titlepage>
    </tmpl:templates>

    <tmpl:templates name="bibliography bibliodiv glossary glossdiv index indexdiv">
      <tmpl:titlepage>
        <header tmpl:class="titlepage">
          <db:title/>
        </header>
      </tmpl:titlepage>
    </tmpl:templates>

    <tmpl:templates name="abstract sidebar task">
      <tmpl:titlepage>
        <header tmpl:class="titlepage">
          <db:title/>
        </header>
      </tmpl:titlepage>
    </tmpl:templates>

    <tmpl:templates name="figure example table equation procedure step
                          bibliolist glosslist qandaset qandadiv
                          itemizedlist orderedlist variablelist segmentedlist calloutlist
                          warning caution note tip important blockquote
                          annotation revhistory msgset">
      <tmpl:titlepage>
        <db:title/>
      </tmpl:titlepage>
    </tmpl:templates>

    <tmpl:templates name="tasksummary taskprerequisites taskrelated">
      <tmpl:titlepage>
        <db:title/>
      </tmpl:titlepage>
    </tmpl:templates>

    <!-- refentry elements are special, they don't really get a titlepage -->
    <tmpl:templates name="refentry">
      <tmpl:titlepage/>
    </tmpl:templates>
  </tmpl:templates-list>
</xsl:template>

</xsl:stylesheet>
