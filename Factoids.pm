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
	my $out = '';
	my $action;
	my $locked;
	my $notitle;
	my $prep = $dbh->prepare("SELECT * FROM factoids WHERE title=?");
	$prep->execute($id);
	my $row = $prep->fetch;
	
	my @flags = split(/ /, @$row[3]);
	foreach my $flag (@flags){
		if($flag eq "ACTION"){
			$action = 1;
			$notitle = 1;
		}
		if($flag eq "NOTITLE"){
			$notitle = 1;
		}
	}

	$out = @$row[2];

	if($action){
		return chr(1)."ACTION $out".chr(1);
	}

	elsif($notitle){
		return $out;
	}

	else{
		if($out ne ""){
			return "$id is $out";
		} else {
			return '';
		}
	}
	
}

sub factinfo {
	my $id = shift;
	my $out;
	my @factinfo;
	my $prep = $dbh->prepare("SELECT * FROM factoids WHERE title=?");
	$prep->execute($id);
	my $row = $prep->fetch;
	return "Information about ".chr(2).$id.chr(2).": [".@$row[3]."] :: Added by ".@$row[4]." using mask ".@$row[5]." @ ".@$row[6];
}



1; # Make perl happy.
