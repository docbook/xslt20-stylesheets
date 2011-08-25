#!/usr/bin/perl -- # -*- Perl -*-

my $usage = "$0 paramname\n";
my $pname = shift || die $usage;

die "$0: $pname already exists!\n"
    if -f "/sourceforge/docbook/xsl2/params/$pname.xml";

open (TEMP, "/sourceforge/docbook/xsl2/params/template.xml")
    || die "$0: cannot find template\n";

open (F, ">/sourceforge/docbook/xsl2/params/$pname.xml");

while (<TEMP>) {
    s/\[\[TEMPLATE\]\]/$pname/sg;
    print F $_;
}
close (TEMP);

if (open (G, "/sourceforge/docbook/xsl/params/$pname.xml")) {
    print F "\n\n";
    while (<G>) {
	print F $_;
    }
    close (G);
}

close (F);


