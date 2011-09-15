<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
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
                exclude-result-prefixes="db m t tp ghost xs f fp tmpl">

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
  <templates-list xmlns="http://docbook.org/xslt/titlepage-templates">

    <templates name="part">
      <recto>
        <fo:block>
          <fo:block font-size="{f:hsize(5)}pt"
                    space-before="{f:hsize(5)*0.75}pt"
                    text-align="center"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:title/>
          </fo:block>
          <fo:block font-size="{f:hsize(4)}pt"
                    space-before="{f:hsize(4)*0.75}pt"
                    text-align="center"
                    text-style="italic"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:subtitle/>
          </fo:block>
        </fo:block>
      </recto>
    </templates>

    <templates name="book">
      <recto>
        <fo:block text-align="center"
                  font-family="{$title.fontset}"
                  font-weight="bold">
          <fo:block font-size="{f:hsize(5)}pt"
                    space-before="{f:hsize(5)*0.75}pt">
            <db:title/>
          </fo:block>
          <fo:block font-size="{f:hsize(4)}pt"
                    space-before="{f:hsize(4)*0.75}pt">
            <db:subtitle/>
          </fo:block>
          <fo:block font-size="{f:hsize(1)}pt"
                    keep-with-next.within-column="always"
                    space-before="2in">
            <fo:block>
              <db:author/>
            </fo:block>
            <fo:block>
              <db:authorgroup/>
            </fo:block>
          </fo:block>
        </fo:block>
      </recto>

      <verso>
        <fo:block font-family="{$body.fontset}">
          <fo:block font-size="{f:hsize(2)}pt"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:title/>
          </fo:block>
          <fo:block>
            <db:author/>
          </fo:block>
          <fo:block>
            <db:authorgroup/>
          </fo:block>
          <fo:block>
            <db:othercredit/>
          </fo:block>
          <fo:block space-before="0.5em">
            <db:releaseinfo/>
          </fo:block>
          <fo:block space-before="1em">
            <db:pubdate/>
          </fo:block>
          <fo:block>
            <db:copyright/>
          </fo:block>
          <fo:block>
            <db:abstract/>
          </fo:block>
          <fo:block font-size="8pt">
            <db:legalnotice/>
          </fo:block>
        </fo:block>
      </verso>

      <before-recto/>
      <before-verso/>
      <separator>
        <fo:block break-after="page"/>
      </separator>
    </templates>

    <templates name="dedication preface chapter appendix colophon">
      <titlepage>
        <fo:block>
          <fo:block font-size="{f:hsize(5)}pt"
                    margin-left="{$title.margin.left}"
                    font-family="{$title.fontset}"
                    font-weight="bold">
            <db:title/>
          </fo:block>
          <fo:block font-family="{$title.fontset}">
            <db:subtitle/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="article">
      <titlepage>
        <fo:block font-family="{$title.fontset}" text-align="center">
          <fo:block font-size="{f:hsize(5)}pt">
            <db:title/>
          </fo:block>
          <fo:block>
            <db:authorgroup/>
          </fo:block>
          <fo:block>
            <db:author/>
          </fo:block>
          <fo:block>
            <db:abstract/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="article/appendix">
      <titlepage>
        <fo:block space-before="1.5em">
          <fo:block font-size="{f:hsize(4)}pt"
                    margin-left="{$title.margin.left}"
                    font-family="{$title.fontset}">
            <db:title/>
          </fo:block>
          <fo:block font-family="{$title.fontset}">
            <db:subtitle/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="section sect1 sect2 sect3 sect4 sect5
                     refsection refsect1 refsect2 refsect3">
      <titlepage>
        <fo:block space-before="1.5em">
          <fo:block font-family="{$title.fontset}"
                    margin-left="{$title.margin.left}">
            <db:title/>
          </fo:block>
          <fo:block font-family="{$title.fontset}">
            <db:subtitle/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="itemizedlist orderedlist variablelist">
      <titlepage>
        <fo:block>
          <fo:block xsl:use-attribute-sets="list.title.properties">
            <db:title/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>

    <templates name="abstract">
      <titlepage>
        <fo:block>
          <fo:block xsl:use-attribute-sets="list.title.properties">
            <db:title/>
          </fo:block>
        </fo:block>
      </titlepage>
    </templates>
  </templates-list>
</xsl:template>

</xsl:stylesheet>
