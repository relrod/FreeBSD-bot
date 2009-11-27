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
	my ($desc,$categories,$pkgname,$maintainer);
	my $content = get("http://portsmon.freebsd.org/portoverview.py?category=$category&portname=$name");
	if($content !~ /No port was found matching category/){
		my $te = HTML::TableExtract->new(attribs=>{ cellpadding=>2, cellspacing=>1, border=>1 }, count=>1);
		$te->parse($content);
		foreach my $ts ($te->tables){
			foreach my $row ($ts->rows){
				$desc = scalar(@$row[1]) if(scalar(@$row[0] eq "description"));
				$categories = scalar(@$row[1]) if(scalar(@$row[0] eq "categories"));
				$pkgname = scalar(@$row[1]) if(scalar(@$row[0] eq "package name"));
				$maintainer = scalar(@$row[1]) if(scalar(@$row[0] eq "maintainer"));
			}
		}
		my $pkgversion = (split(/-/,$pkgname))[1];
		return "$category/$name ($pkgversion): ($categories)... \"$desc\" >>  Maintained By: $maintainer.";
	} else {
		return "The port you've tried to look up ($category/$name), was not found.";
	}
}

sub searchports {
   my $keywords = shift;
}

1; # Make perl happy.
