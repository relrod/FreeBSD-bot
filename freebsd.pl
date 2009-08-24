#!/usr/local/env perl
use warnings;
use strict;
use PortLookup;
use ProblemReport;
use Factoids;
use Levels;

package FreeBSD;
use base qw( Bot::BasicBot );
use Data::Dumper

my $version = "1.1";

sub said{
	my $self	= shift;
	my $info	= shift;
	my $text	= $info->{body};
	my $nick	= $info->{who};
	my $rawnick	= $info->{raw_nick};
	my @rlmask	= split(/\@/,$rawnick);
	my $mask 	= $rlmask[1];
	my $channel	= $info->{channel};
	
	if($text =~ /^!version$/i){
		$self->reply($info,"FreeBSD-Bot Version 1.0 by CodeBlock  |  http://github.com/CodeBlock/FreeBSD-bot/");
	}

	elsif($text =~ /^!commands$/i){
		$self->reply($info,"<category/portname>: fetch info. about a port; [category/id]: fetch info. about a Problem Report.");
	}
	
	elsif($text =~ /<([\w]+)\/([\w\-]+)>/i){
		$self->reply($info,PortLookup::port($1,$2));
	}

	elsif($text =~ /\[([\w]+)\/([\d]+)\]/i){
		$self->reply($info,ProblemReport::pr($1,$2));
	}
	
	# <admin>
		# <levels>
	elsif(($text =~ /^!levels? (?:group|status|current|get) ([\w\-\`\[\]\\\:\.\/]+)/i) and (Levels::group($mask) eq "ADMIN")){
		#my $response = Levels::group($1);
		$self->reply($info,Levels::group($1));
	}

	elsif(($text =~ /^!levels? (edit|update|add) ([\w\-\`\\\[\]\_\.\:\/]+) ([\w]+)/i) and (Levels::group($mask) eq "ADMIN")){
		$self->reply($info,Levels::pluslevel($1,$2, $3));
	}
	
		# </levels>
	# </admin>

	elsif(($text =~ /^!(?:facts|fact|factoid|factoids) (?:edit|change|modify|update) (.*) = (.*)/i) and (Levels::canEditFact($mask))){
		$self->reply($info,"Hi, You're able to edit facts, but this feature has not been implemented yet.");
	}
	

	elsif(($text =~ /^!(?:facts|fact|factoid|factoids) (?:add|register|commit|new|create) (.*) ?= ?(<nopre>|<noprefix>|<notitle>|<act>|<action>)? ?(.*)/i) and (Levels::canEditFact($mask))){
		my $commit = Factoids::commit($1,$3,$2,$nick,$mask);
		if($commit){
			$self->reply($info,"Commited '$1' => $3");
		} else {
			$self->reply($info,"Uh Oh - Kersplam! I was unable to add the factoid to the database.");
		}
	}

	elsif($text =~ /^!check$/i){
		if(Levels::canEditFact($mask)){
			$self->reply($info,"you can edit facts");
		} else {
			$self->reply($info,"nice try");
		}
	}

	elsif($text =~ /^!(?:fi|factinfo|fact info|info) (.*)/i){
		$self->reply($info,Factoids::factinfo($1));
	}

	elsif($text =~ /^!(.*)/i) { # Factoid-time!
		$self->reply($info,Factoids::retrieve($1));
	}

}

#FreeBSD->new(
#	server		=> "10.10.10.165",
#	port		=> 6667,
#	channels	=> ["#offtopic"],
#	nick		=> "FreeBSD",
#	alt_nicks	=> ["BSDbot","BSD"],
#	username	=> "FreeBSD",
#	name		=> "FreeBSD Information Bot.",
#	charset		=> "utf-8"
#)->run();

FreeBSD->new(
	server		=> "cesium.eighthbit.net",
	port		=> 6667,
	channels	=> ["#offtopic","#freebsd"],
	nick		=> "FreeBSD",
	alt_nicks	=> ["BSDbot","BSD"],
	username	=> "FreeBSD",
	name		=> "FreeBSD Information Bot.",
	charset		=> "utf-8"
)->run();
