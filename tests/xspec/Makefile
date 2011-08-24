COVERAGE=

.PHONY: htmlbase htmlalt

all: htmlbase htmlalt

htmlbase: htmlbase.xml
	xspec $< $(COVERAGE)

htmlalt: htmlalt.xml
	xspec $< $(COVERAGE)
