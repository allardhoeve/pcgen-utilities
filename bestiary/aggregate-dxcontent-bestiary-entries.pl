#!/usr/bin/perl
use strict;
use warnings;
use URI::Escape qw/uri_escape/;
use Storable qw/store retrieve/;
use LWP::UserAgent;

our $DEBUG = 0;

my $ua = LWP::UserAgent->new();

if (not -d "cache") {
	die "No cache dir named './cache'!\n";
}

my $counter = 0;

open F, "preamble.html" or die "Could not open preamble.html: $!\n";
print <F>;
close F;

while (<>) {
	chomp;
	my ($url, $creature) = split /\t+/;
	my $escaped_url = uri_escape($url);
	my $response;
	my $cachefile = "cache/$escaped_url";

	if (-e $cachefile) {
		print "Getting $creature from cache\n" if $DEBUG;
		$response = retrieve($cachefile);
	} else {		
		print "Fetching $creature: " if $DEBUG;
		$response = $ua->get($url);
		print $response->code(), "\n" if $DEBUG;

		if ($response->code() != 200) {
			print "Error retrieving $creature: " . $response->code() . "\n" if $DEBUG;
			next;
		}

		store($response, $cachefile) or die "Could not store $creature to $cachefile: $!\n";
	}

	my $html = $response->content();

	$html =~ s!.*<div style="float:left; width:700px; margin-left:20px;">!<div style="display:block; width:800px; margin-left:20px; vertical-align:top;">!ms;
	$html =~ s!<div style="float:left; width:170px; margin-left:20px;" class="noPrint">.*!!ms;
	$html =~ s!<div style="float:right;" class="noPrint"><input type="button" value="print" onclick="window.print\(\)" /></div>!!ms;
	$html =~ s!<div class="Sec15CW_Head">.*?</div>!!gms;
	$html =~ s!<div class="Sec15CW_Body">.*?</div>!!gms;

	print $html;
}

open F, "postamble.html" or die "Could not open postamble.html: $!\n";
print <F>;
close F;
