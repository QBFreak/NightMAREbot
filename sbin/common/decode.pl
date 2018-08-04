#!/usr/bin/perl -w

#if (! -z "$ARGV[0]") {
#	print  &textdecode("$ARGV[0]") . "\n";
#}

sub textdecode {
	my ($text) = @_;
	my $count = 0;
	
	for ($count=32; $count<48; $count++) {
		$text = &decodechar($count, "$text");
	}
	for ($count=58; $count<65; $count++) {
		$text = &decodechar($count, "$text");
	}
	for ($count=91; $count<95; $count++) {
		$text = &decodechar($count, "$text");
	}
	$text = &decodechar(96, "$text");
	for ($count=123; $count<127; $count++) {
		$text = &decodechar($count, "$text");
	}
	$text = &decodechar(95, "$text");
	
	return $text;
}

sub decodechar {
	my ($num, $text) = @_;
	my $code = "_$num" . "_";
	my $char = chr($num);

	$text =~ s/$code/$char/g;

	return $text;
}

1;
