include ../../tools/Makefile.incl

VPATH=..

SOURCES=$(notdir $(wildcard ../src/*.xml))

../i18n.xml: $(SOURCES)
	$(XSLT) -it:join en.xml ../../tools/build-l10n.xsl $@ locales="$^"
	$(JING) -c -i ../../schemas/i18n.rnc $@

%.xml: src/%.xml
	$(JING) -c -i ../../schemas/locale.rnc $<
	$(XSLT) $< ../../tools/build-l10n.xsl $@ locale.file=$@ en.locale.file=en.xml

clean:
	rm -f *.xml
