#!/usr/bin/perl
#echo $@ | aspell -a
$TEMPFILE = ".bot.spell.temp";
$SKIPLINES = 1;

if("$ARGV[0]" eq "") {
	exit;
}

$numArgs = $#ARGV + 1;

if( -s "$TEMPFILE") {
	$TEMP = "";
	$COUNTER = 0;

	open (SPELLFILE,"$TEMPFILE") || exit;
	while($LINE = <SPELLFILE>) {
		if ($COUNTER >= $SKIPLINES && $COUNTER <= $numArgs) {
			chomp($LINE);
			#print "$ARGV[$COUNTER - 1] $COUNTER: $LINE\n";
			if ($LINE eq "*") {
				print "$ARGV[$COUNTER - 1] ";
			} else {
				print "[$ARGV[$COUNTER - 1]] ";
			}
		}
		$COUNTER++;
	   }

   close (SPELLFILE);
}

print "\n";
