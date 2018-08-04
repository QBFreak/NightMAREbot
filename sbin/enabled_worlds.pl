#!/usr/bin/perl -w
my $worlddir = "worlds/enabled";

if ( ! -d "$worlddir" )
   { exit; }

my $nl = 1;
my $type = "[^\"]+";

foreach $argnum (0 .. $#ARGV) {
   if ( "$ARGV[$argnum]" eq "-n")
      { $nl = 0; }
   elsif ( "$ARGV[$argnum]" ne "")
      { $type = $ARGV[$argnum]; }
}

opendir(DIR, "$worlddir");
@files = grep(/\.world$/,readdir(DIR));
closedir(DIR);

my $line;

foreach $file (@files) {
   if ( -s "$worlddir/$file" ) {
      open (WORLDFILE, "$worlddir/$file") || next;
      while($line = <WORLDFILE>) {
         chomp($line);
         if ($line =~ /^\/test addworld\("([^"]+)", "($type)", (.*)\)$/) {
	    print "$1";
	    if ($nl)
	       { print "\n"; }
	    else
	       { print " ";  }
	 }
      }
      close (WORLDFILE);
   }
}
if ( ! $nl ) { print "\n"; }
