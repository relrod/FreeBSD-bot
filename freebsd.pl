#!/usr/local/env perl
use warnings;
use strict;
use PortLookup;
use ProblemReport;

package FreeBSD;
use base qw( Bot::BasicBot );

sub said{
	my $self	= shift;
	my $info	= shift;
	my $text	= $info->{body};
	my $nick	= $info->{who};
	my $mask	= $info->{raw_nick};
	my $channel	= $info->{channel};
	
	if($text =~ /^!test$/i){
		$self->reply($info,"Y HALO THAR, $nick! LAWL.");
	}

	if($text =~ /<([\w]+)\/([\w\-]+)>/i){
		$self->reply($info,PortLookup::port($1,$2));
	}

	if($text =~ /\[([\w]+)\/([\d]+)\]/i){
		$self->reply($info,ProblemReport::pr($1,$2));
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
