include ../../../buildtools/Makefile.incl

param.xsl: param.xml ../common/mkparam.xsl
	../../../buildtools/saxon $^ $@

clean:
	$(RM) param.xsl
