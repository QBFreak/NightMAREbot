#!/usr/bin/perl -w

#if (! -z "$ARGV[0]") {
#	print  &textencode("$ARGV[0]") . "\n";
#}

sub textencode {
	my ($text) = @_;
	my $count = 0;
	
	$text = &encodechar(95, "$text");
	for ($count=32; $count<48; $count++) {
		$text = &encodechar($count, "$text");
	}
	for ($count=58; $count<65; $count++) {
		$text = &encodechar($count, "$text");
	}
	for ($count=91; $count<95; $count++) {
		$text = &encodechar($count, "$text");
	}
	$text = &encodechar(96, "$text");
	for ($count=123; $count<127; $count++) {
		$text = &encodechar($count, "$text");
	}
	
	return $text;
}

sub encodechar {
	my ($num, $text) = @_;
	my $code = "_$num" . "_";
	my $char = "\\" . chr($num);

    $text =~ s/$char/$code/g;

	return $text;
}

1;
