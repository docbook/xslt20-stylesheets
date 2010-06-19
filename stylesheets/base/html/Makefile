include ../../../tools/Makefile.incl

all: titlepages.xsl

titlepages.xsl: titlepages.xml ../../../tools/titlepages.xsl
	$(XSLT) $< ../../../tools/titlepages.xsl $@

clean:
	$(RM) titlepages.xsl

