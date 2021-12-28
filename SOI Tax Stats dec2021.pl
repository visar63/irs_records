#!/usr/bin/perl

use strict;
use HTTP::Request::Common qw(GET POST);
use LWP::UserAgent;
use DBI;
use LWP::Protocol::https;
use IO::Socket::SSL;
#use File::Slurp;
use LWP::Simple;

my $ua = new LWP::UserAgent;
my $source = "https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf";
my $ua = LWP::UserAgent->new(keep_alive  =>  1000, timeout  =>  1800, agent  =>  "Chrome");
$ua->ssl_opts( verify_hostname => 0 );
push @{$ua->requests_redirectable}, 'POST';
$ua->cookie_jar({});

my $req = HTTP::Request->new(GET  =>  "$source");
my $res = $ua->request($req);
my $con = $res->decoded_content();
# open (Savefile, '>>record.html');
				# print Savefile "$con";
				# close (Savefile);
while($con=~m#href="(/pub/irs-soi/[^"]+)"#igs){
	my $snip = $1;
	if($snip=~m#/pub/irs-soi/eo_(.*?).csv#igs){
		my $state=$1;
		my $source2 = "https://www.irs.gov".$snip;
		#my $source2 = "https://www.irs.gov/pub/irs-soi/eo_wy.csv";
		my $filename = "$state.csv";
		my $rc = getstore($source2, $filename);
			print $snip."\n";
	}
}		


# This part is added on Dec2021
# It includes downloading 2 separate files (International records, Purto Rico records)
my $xx = "https://www.irs.gov/pub/irs-soi/eo_xx.csv";
my $pr = "https://www.irs.gov/pub/irs-soi/eo_pr.csv";

my @external_states = ($xx, $pr);
foreach(@external_states){
	print("$_","\n");
	my $filename = substr($_, -9);
	my $rc = getstore($_, $filename);
	print $filename."\n";
}