#!/usr/bin/perl
$TEMPFILE = ".bot.html.temp";
$RECENTFILE = "recentlinks.txt";
use lib qw(/home/nmb/sbin/common);
require "decode.pl";

if("$ARGV[0]" eq "") {
	exit;
};

$PAGE = $ARGV[0];
$PAGE = &textdecode("$PAGE");

if( -e "$TEMPFILE") {
	unlink("$TEMPFILE");
}

#open(LINKS, "$RECENTFILE");
#my @links = <LINKS>;
#close(LINKS);
#push @links, "$PAGE\n";
#while (scalar(@links) > 10) { shift @link; }
#open(LINKS, ">$RECENTFILE");
#print LINKS @links;
#close(LINKS);

$RES=`wget --user-agent="Mozilla/5.0 [en] (compatible; NightMAREbot mare.qbfreak.net/Main/SluggyNightMAREbot)" -A text -q -O $TEMPFILE "$PAGE"`;

if( -s "$TEMPFILE") {
	$GRAB=0;
	$TITLE="";
	$TEMP="";
	$FOUND=0;
	open (PAGEFILE,"$TEMPFILE") || exit;
	while($LINE = <PAGEFILE>) {
		chomp($LINE);
		$LINE =~ s/\s+/ /go;
		$TEMP = $LINE;
		$TEMP =~ s/.*<title>.*/TITLE/gi;
		if("$TEMP" eq "TITLE" && $FOUND == 0) {
			$GRAB = 1;
		}
		if($GRAB == 1) {
			$TITLE = $TITLE . " " . $LINE;
		}
		$TEMP = $LINE;
		$TEMP =~ s/.*<\/title>.*/TITLE/gi;
		if("$TEMP" eq "TITLE" && $GRAB == 1) {
			$GRAB = 0;
			$FOUND = 1;
		}
	   }

   close (PAGEFILE);
}

$TITLE =~ s/.*<title>([^<]*)<\/title>.*/\1/gi;
print "$TITLE\n";
