#!/usr/bin/env perl
# FreeBSD Bot PR Module.
#

use warnings;
use strict;
use HTML::TableExtract;
use LWP::Simple;

sub getPR{
	my $pr = shift;
	my $sitecontents = get("http://www.freebsd.org/cgi/query-pr.cgi?pr=$pr");
	my $te = HTML::TableExtract->new( attribs => { class => "headtable" });
	$te->parse($sitecontents);
	foreach my $ts ($te->tables){
		foreach my $row ($ts->rows){
				print "   ", @$row,"\n";
		}
	}
}

getPR("ports/137599");
