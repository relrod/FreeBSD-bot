#!/usr/local/env perl
use warnings;
use strict;
use PortLookup;
use ProblemReport;
use Factoids;

package FreeBSD;
use base qw( Bot::BasicBot );

my $version = "1.1";

sub said{
	my $self	= shift;
	my $info	= shift;
	my $text	= $info->{body};
	my $nick	= $info->{who};
	my $mask	= $info->{raw_nick};
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

	elsif($text =~ /^!(.*)/i) { # Factoid-time!
		$self->reply($info,Factoids::retrieve($1));
	}

}

FreeBSD->new(
	server		=> "cesium.eighthbit.net",
	port		=> 6667,
	channels	=> ["#offtopic"],
	nick		=> "FreeBSD",
	alt_nicks	=> ["BSDbot","BSD"],
	username	=> "FreeBSD",
	name		=> "FreeBSD Information Bot.",
	charset		=> "utf-8"
)->run();
