include ../../../tools/Makefile.incl

all: i18ndata.xsl

i18ndata.xsl: ../../../gentext/i18n.xml ../../../tools/i18nxsl.xsl
	$(XSLT) $< ../../../tools/i18nxsl.xsl $@

clean:
	rm -f i18ndata.xsl
