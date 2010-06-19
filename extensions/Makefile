# $Id: Makefile 5342 2005-10-25 09:11:18Z xmldoc $

ANT = ant
ANT_OPTS =

all: jars

jars: docbook-xsl2-saxon.jar

docbook-xsl2-saxon.jar: build/lib/docbook-xsl2-saxon.jar
	cp build/lib/docbook-xsl2-saxon.jar docbook-xsl2-saxon.jar

build/lib/docbook-xsl2-saxon.jar:
	$(ANT) $(ANT_OPTS)

clean:
	$(ANT) $(ANT_OPTS) clean
	$(RM) docbook-xsl2-saxon.jar
