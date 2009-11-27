#!/usr/local/env perl
use warnings;
use strict;
use PortLookup;
use ProblemReport;
use Factoids;
use Levels;

package FreeBSD;
use base qw( Bot::BasicBot );
use Data::Dumper;

my $version = "1.1";

my @eatresponses = (
	'sends Beastie after $nick',
	'brutally murders $nick from the inside out.',
	'cries at being eaten and executes a script to get out.',
	'blinks a few times and punches random $nick-guts',
	'laughs at how you think you\'re all leet... Don\'t look behind you.. bwhahaha XD',
	'tells you not to go there.',
	'says something to the effect of, "Hey now, what was that for!?"',
	'snickers some comment about Linux',
	'mumbles something about Windows...',
	'glares at $nick and laughs hysterically for no reason.',
	'watches $nick be all "lol im s0 1337"',
	'feels eaten.',
	'eats $nick in return',
	'cries.',
);

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
	
	elsif(my @portqueries = $text =~ /<([\w]+\/[\w\-\d]+)>/ig){
		my $result;
		my $donenumber = 0;
		foreach my $port (@portqueries){
			if($donenumber == 3){
				$result .= "Maximum limit of three port queries per message reached.";
				last;
			}
			my @portsplit = split(/\//,$port);
         if($portsplit[0] !~ /(?:base|community|extra|aur)/i){
   			$result .= PortLookup::port($portsplit[0],$portsplit[1])."\n";
         }
			$donenumber++;
		}
      if($result){
   		$self->reply($info,$result);
      }
	}

   elsif($text =~ /<(keyword|maintainer|desc|description):([\w\d\.\-\_\@\ ]+)>/i){
      my $search_by = lc($1);
      my $keywords = $2;

      # And throw it to portsearch().
      return PortLookup::portsearch($search_by, $keywords);
   }

	elsif($text =~ /\[([a-z]+)\/([\d]+)\]/i){
		$self->reply($info,ProblemReport::pr($1,$2));
	}
	
	elsif($text =~ /^eats FreeBSD/i){
		my $random = $eatresponses[int rand(@eatresponses)];
		$random =~ s/\$nick/$nick/g;
		$self->emote(who=>$nick,channel=>$channel,body=>$random);
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

	elsif(($text =~ /^!(?:facts|fact|factoid|factoids) (?:edit|change|modify|update) (.*) ?= ?(<nopre>|<noprefix>|<notitle>|<act>|<action>)? ?(.*)/i) and (Levels::canEditFact($mask))){
		my $edit = Factoids::edit($1,$3,$2,$nick,$mask);
		if($edit){
			$self->reply($info,"EditCommit '$1' => $3");
		} else {
			$self->reply($info,"EditCommit Failed.");
		}
		#$self->reply($info,"Hi, You're able to edit facts, but this feature has not been implemented yet.");
	}

	elsif(($text =~ /^!(?:facts|fact|factoid|factoids) (?:add|register|commit|new|create) (.*) ?= ?(<nopre>|<noprefix>|<notitle>|<act>|<action>)? ?(?:'|")?(.*)(?:'|")?/i) and (Levels::canEditFact($mask))){
      my $input = $1;
      my $flags = $2;
      my $response = $3;
      $response =~ s/(?:'|")$//;
      $input  =~ s/ +$//;
		my $commit = Factoids::commit($input,$response,$flags,$nick,$mask);
		if($commit){
			$self->reply($info,"Commited '$input' => $response");
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
	
	return;
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

my $eighthbit = FreeBSD->new(
	server		=> "irc.eighthbit.net",
	port		=> 6667,
	channels	=> ["#bots"],#,"#offtopic","#freebsd","#codeblock","#baddog"],
	nick		=> "FreeBSD",
	alt_nicks	=> ["BSDbot","BSD"],
	username	=> "FreeBSD",
	name		=> "FreeBSD Information Bot.",
	no_run		=> 1,
	charset		=> "utf-8"
);

my $freenode = FreeBSD->new(
	server		=> "irc.freenode.net",
	port		=> 6667,
	channels	=> ["#botters"],
	nick		=> "FreeBSD-bot",
	alt_nicks	=> ["BSDbot","BSD"],
	username	=> "FreeBSD",
	name		=> "FreeBSD Information Bot.",
	no_run		=> 1,
	charset		=> "utf-8"
);


#my $vega = FreeBSD->new(
#	server		=> "vega.eighthbit.net",
#	port		=> 6667,
#	channels	=> ["#raw"],
#	nick		=> "FreeBSD",
#	alt_nicks	=> ["BSDbot","BSD"],
#	username	=> "FreeBSD",
#	name		=> "FreeBSD Information Bot.",
#	no_run		=> 1,
#	charset		=> "utf-8"
#);

$eighthbit->run();
#$freenode->run();
#$vega->run();

use POE;
$poe_kernel->run();
