# $Id: Makefile 7706 2008-02-23 20:23:14Z mzjn $

include ../buildtools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=xsl2

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS = base install.sh

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES = \./NOTES extensions/build/

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES =

# to make sure that executable bit is retained after packaging,
# you need to explicitly list any executable files here
DISTRIB_EXECUTABLES = install.sh

# list of pathname+URIs to test for catalog support
URILIST = \
./\ http://docbook.sourceforge.net/release/xsl2/current/

DEBUG=
PDFVIEWER=evince

DIRS=base extensions schemas

.PHONY: distrib clean $(NEWSFILE)

# Some of this is for easy testing during XSLT2 development
SRCDIR=../docbook/relaxng/docbook/tests/passed
ABSSRCDIR=/sourceforge/docbook/docbook/relaxng/docbook/tests/passed
VPATH=$(SRCDIR):output/passed:output
RAW=$(wildcard ../docbook/relaxng/docbook/tests/passed/*.xml)
XML=$(subst ../docbook/relaxng/docbook/tests/passed/,,$(RAW))
HTML=$(patsubst %.xml,%.html,$(XML))

.PHONY: tests base

STYLE=$(wildcard common/*.xsl) $(wildcard base/html/*.xsl)
FOSTYLE=$(wildcard common/*.xsl) $(wildcard base/fo/*.xsl)

all:
	@echo Run 'make base' or 'make tests' or 'make xxx.html'

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) clean -C $$i"; $(MAKE) clean -C $$i; \
		fi \
	done

tests: $(HTML)

%.html : %.xml $(STYLE)
	saxon $(DEBUG) $< base/html/docbook.xsl output/$@

%.fo: %.xml $(FOSTYLE)
	saxon $(DEBUG) $< base/fo/docbook.xsl $@
	saxon $@ tools/prettyprint.xsl $@.xml

%.pdf: %.fo
	xep -q $<
	$(PDFVIEWER) $@

glossary.002.html: glossary.002.xml glossary.002.data.xml $(STYLE)
	saxon -8b $(DEBUG) $< base/html/docbook.xsl output/$@ glossary.collection=glossary.002.data.xml

part.001.html: part.001.xml glossary.002.data.xml $(STYLE)
	saxon -8b $(DEBUG) $< base/html/docbook.xsl output/$@ glossary.collection=glossary.002.data.xml

include ../releasetools/Targets.mk
