# Some results have to be constructed with specific parameters.
# This shell script simplifies that process :-)

saxon src/meta.001.xml ../../xslt/base/html/docbook.xsl result/meta.001.html html.stylesheets="a.css b.css c.css" link.madeby.uri="mailto:john.doe@example.com" html.base="http://www.example.com/" generate.meta.abstract=1 inherit.keywords=1 resource.root="http://docbook.github.com/latest/"

for f in \
glossary.002 \
bibliography.003 \
calloutlist.001 \
calloutlist.002 \
calloutlist.003 \
screen.001 \
figure.001 \
figure.002 \
figure.003 \
figure.004 \
informalfigure.001 \
equation.001 \
equation.002 \
equation.003 \
mediaobject.001 \
mediaobject.002 \
svg.001 \
mediaobjectco.001 \
stamp.001 \
stamp.002 \
stamp.003 \
stamp.004 \
stamp.005 \
stamp.006 \
stamp.007 \
stamp.008 \
stamp.009 \
stamp.010 \
stamp.011 \
stamp.012 \
stamp.013 \
stamp.050 \
stamp.051 \
profiling.001 \
imageobjectco.001;
do
    echo $f
    saxon src/$f.xml ../../xslt/base/html/docbook.xsl result/$f.html preprocess=profile profile.os=win bibliography.collection="../etc/bibliography.collection.xml" glossary.collection="../etc/glossary.collection.xml" resource.root="http://docbook.github.com/latest/"
done

saxon src/profiling.001.xml ../../xslt/base/html/docbook.xsl result/prof1/profiling.001.html
saxon src/profiling.001.xml ../../xslt/base/html/docbook.xsl result/prof2/profiling.001.html preprocess=profile profile.os=win
saxon src/profiling.001.xml ../../xslt/base/html/docbook.xsl result/prof3/profiling.001.html preprocess=profile profile.os=linux
