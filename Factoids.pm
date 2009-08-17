#!/usr/bin/env perl
# Factoids Functions.
#

use warnings;
use strict;

package Factoids;
use DBI;
use Data::Dumper;

my $dbh = DBI->connect("dbi:SQLite:dbname=DATABASE.sqlite3","","",{AutoCommit => 0, PrintError => 1});

sub retrieve {
	my $id = shift;
	my $out = "";
	my $prep = $dbh->prepare("SELECT * FROM factoids WHERE title=?");
	$prep->execute($id);
	my $row = $prep->fetch;
	
	foreach my $r (@$row){
		$out .= $r."  ";
	}
	#print Dumper(@$row[1]);
	if($out ne ""){
		return $out;
	} else {
		#return "Factoid ".chr(2).$id.chr(2)." was not found.";
		return '';
	}
}

#print retrieve("exis3t");
1; # Make perl happy.
