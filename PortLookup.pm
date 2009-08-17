#!/usr/bin/env perl
# Get information about a port from freshports.

use warnings;
use strict;

package PortLookup;
use LWP::Simple;
use HTML::TableExtract;

sub port {
	my $category = shift;
	my $name     = shift;
	my $return = "$category/$name ";
	my $content = get("http://portsmon.freebsd.org/portoverview.py?category=$category&portname=$name");
	my $te = HTML::TableExtract->new(attribs=>{ cellpadding=>2, cellspacing=>1, border=>1 }, count=>1);
	$te->parse($content);
	foreach my $ts ($te->tables){
		foreach my $row ($ts->rows){
			#print "   ".join(",", @$row),"\n" if(scalar(@$row[0]) =~ /description/i);
			$return .= scalar(@$row[1]) if(scalar(@$row[0] eq "description"));
			$return .= "(".scalar(@$row[1]).") -> " if(scalar(@$row[0] eq "categories"));
			$return .= " : Maintainer: ".scalar(@$row[1])." " if(scalar(@$row[0] eq "maintainer"));
			#print scalar(@$row[1])."\n";
		}
	}
	if($return != "$category/$name "){
		return $return;
	} else {
		return "The port $category/$name was not found.";
	}

}
