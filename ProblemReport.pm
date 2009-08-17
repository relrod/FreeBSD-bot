#!/usr/bin/env perl
# FreeBSD Bot PR Module.
#

use warnings;
use strict;

package ProblemReport;
use HTML::TableExtract;
use LWP::Simple;
use Data::Dumper;

sub pr{
	my $category = shift;
	my $id = shift;
	my $return = "$category/$id - ";
	my $sitecontents = get("http://www.freebsd.org/cgi/query-pr.cgi?pr=$category/$id");
	my $te = HTML::TableExtract->new( attribs => { class => "headtable" });
	$te->parse($sitecontents);
	foreach my $ts ($te->tables){
		foreach my $row ($ts->rows){
			$return .= " - By: ".scalar(@$row[1]) if(scalar(@$row[0] eq "Originator:"));
			$return .= " - Submitted: ".scalar(@$row[1]) if(scalar(@$row[0] eq "Date:"));
			$return .= " - Summary: ".scalar(@$row[1]) if(scalar(@$row[0] eq "Synopsis:"));
			$return .= " - State: ".scalar(@$row[1]) if(scalar(@$row[0] eq "State:"));
			$return .= " - Responsible: ".scalar(@$row[1]) if(scalar(@$row[0] eq "Responsible:"));
			$return .= " - Modified: ".scalar(@$row[1]) if(scalar(@$row[0] eq "Last-Modified:"));
		
		}
	}
return $return;
}
