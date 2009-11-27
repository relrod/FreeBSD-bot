#!/usr/bin/env perl
# Get information about a port from freshports.

use warnings;
use strict;
use Switch;

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

sub shortenurl {
   my $long_url = shift;
   my $short_url;
   $short_url = get("http://is.gd/api.php?longurl=$long_url");
   if($short_url =~ /The URL you entered is on our blacklist /){
      return $long_url;
   }
   return $short_url;
}

sub portsearch {
   my $search_by = shift;
   my $keywords = shift;
   my $s_cat;
   switch($search_by) {
      case "maintainer" { $s_cat = 'maintainer'; }
      case "keyword" { $s_cat = 'all'; }
      case "name" { $s_cat = 'name'; }
      case "desc" { $s_cat = 'text'; }
      case "description" { $s_cat = 'text'; }
   }

   my $results = get("http://www.freebsd.org/cgi/ports.cgi?query=$keywords&stype=$s_cat&sektion=all");
   return "I exist and you poked me with k:$keywords, s:$search_by, scat:$s_cat";
}

1; # Make perl happy.
