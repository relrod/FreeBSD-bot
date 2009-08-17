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
	my $action;
	my $locked;
	my $notitle;
	my $prep = $dbh->prepare("SELECT * FROM factoids WHERE title=?");
	$prep->execute($id);
	my $row = $prep->fetch;
	
	my @flags = split(/ /, @$row[3]);
	foreach my $flag (@flags){
		if($flag == "ACTION"){
			$action = 1;
		}
		if($flag == "LOCKED"){
			$locked = 1;
		}
		if($flag == "NOTITLE"){
			$notitle = 1;
		}
	}


	
	print Dumper(@$row);
	if($out ne ""){
		return $out;
	} else {
		#return "Factoid ".chr(2).$id.chr(2)." was not found.";
		return '';
	}
}

#print retrieve("exis3t");
1; # Make perl happy.
