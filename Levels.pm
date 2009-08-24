#!/usr/bin/env perl
# Levels Module
#

use warnings;
use strict;

package Levels;
use DBI;
use Data::Dumper;

my $dbh = DBI->connect("dbi:SQLite:dbname=DATABASE.sqlite3","","",{AutoCommit => 1, PrintError => 1});

sub group {
	my $hostmask = shift;
	my $prep = $dbh->prepare("SELECT * FROM levels WHERE hostmask=?");
	$prep->execute($hostmask);
	my $row = $prep->fetch;
	if(@$row[1]){
		return @$row[1];
	} else {
		return "No level has been found for $hostmask.";
	}
}

sub canEditFact {
	my $hostmask = shift;
	my $group = group($hostmask);
	if(($group eq "ADMIN") or ($group eq "FACTEDITOR")){
		return 1;
	} else {
		return 0;
	}
}

sub pluslevel {
	my $action = shift;
	$action = uc($action);
	my $hostmask = shift;
	my $group = shift; # Current Options: FACTEDITOR, ADMIN
	if($group =~ /^(?:admin|facteditor)$/i) {
		$group = uc($group);
		if($action eq "ADD") {
			my $prep = $dbh->prepare("INSERT INTO levels(hostmask,access) VALUES(?,?)");
			if($prep->execute($hostmask,$group)) {
				return "Added ".chr(2).$hostmask.chr(2)." to group ".uc($group).".";
			} else {
				return "A database error has occured.";
			}
		} elsif(($action eq "UPDATE") or ($action eq "EDIT")) {
			my $prep = $dbh->prepare("UPDATE levels SET access=? WHERE hostmask=?");
			if($prep->execute($group,$hostmask)) {
				return "Updated level for ".chr(2).$hostmask.chr(2).". Set group to $group.";
			} else {
				return "A database error has occured.";
			}
		}
	} else {
		return "Valid Groups: ADMIN FACTEDITOR";
	}
}

1; # Make perl happy
