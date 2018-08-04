#!/usr/bin/perl
$TEMPFILE = ".bot.usage.temp";
$URLFILE = ".bot.usage.lasturl";
$WEBURL = "http://mare.qbfreak.net/bin/view/TinyMARE";
$TWIKISKIN = "rss";

if("$ARGV[0]" eq "") {
	print "Ack! Tell QB that the usage trigger is broken.\n";
	exit;
};

$TOPIC = $ARGV[0];
$CURURL = "$WEBURL/$TOPIC?skin=$TWIKISKIN";
$CACHED = 0;

if ( -e "$URLFILE" ) {
	$LASTURL = `cat $URLFILE`;
	chomp($LASTURL);
	if ("$LASTURL" eq "$CURURL") {
		$CACHED = 1;
	}
}

if( $CACHED == 0 ) {
	if( -e "$TEMPFILE") {
		unlink("$TEMPFILE");
	}
	$RES=`wget -A text -q -O $TEMPFILE $CURURL`;
	$RES=`echo $CURURL > $URLFILE`;
}

if( -s "$TEMPFILE") {
	$GRAB = 0;
	$CODE = "";
	$FOUND = 0;
	$TEMP = "";

	open (TOPICFILE,"$TEMPFILE") || exit;
	while($LINE = <TOPICFILE>) {
		chomp($LINE);
		$LINE =~ s/\s+/ /go;
		if($GRAB == 1) {
			$TEMP = $LINE;
			$TEMP =~ s/.*<code>.*<\/code>.*/FOUNDCODE/gi;
			if("$TEMP" eq "FOUNDCODE") {
				$CODE = $LINE;
				$CODE =~ s/.*<code>([^<]*)<\/code>.*/\1/gi;
				$CODE =~ s/&lt;/</gi;
				$CODE =~ s/&gt;/>/gi;
				print "$CODE\n";
			} else {
				$GRAB = 0;
				$FOUND = 1;
			}
		}
		$TEMP = $LINE;
		$TEMP =~ s/.*<h3>.*<\/h3>.*/FOUNDH3/gi;
		if("$TEMP" eq "FOUNDH3" && $FOUND == 0) {
			$GRAB = 1;
		}
	   }

   close (TOPICFILE);
} else {
	print "Sorry, that command isn't in the TWiki.\n";
}
