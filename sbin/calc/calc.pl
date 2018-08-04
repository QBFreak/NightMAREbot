#!/usr/bin/perl
$TEMPFILE = ".bot.math.temp";
use lib qw(/home/nmb/sbin/common);
require "decode.pl";

if("$ARGV[0]" eq "") {
	exit;
};

$EQU = $ARGV[0];
$EQU = &textdecode("$EQU");

if( -e "$TEMPFILE") {
	unlink("$TEMPFILE");
}

open(TEMPFILE, ">$TEMPFILE");
print TEMPFILE "$EQU\n";
close(TEMPFILE);

print `cat $TEMPFILE | bc -q`;
