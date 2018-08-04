#!/usr/bin/perl
$TEMPFILE = ".bot.html.temp";

if("$ARGV[0]" eq "") {
	exit;
};

$PAGE = $ARGV[0];

if( -e "$TEMPFILE") {
	unlink("$TEMPFILE");
}

$RES=`wget -A text -q -O $TEMPFILE $PAGE`;

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
