#!/usr/bin/perl
use strict;
use Text::Aspell;
use Getopt::Long;
use YAML 'LoadFile';
use Cwd 'realpath';
use File::Basename;

#TODO: Remove debug
use Data::Dumper;

# Set up Aspell
my $speller = Text::Aspell->new;
die unless $speller;

# Default settings
my $sc_prefix = '[';
my $sc_suffix = ']';
my $sc_marker = '';

# Load settings from file
my $config_file = dirname(realpath($0)) . '/checkspell.yaml';
my $config;
if ( -e $config_file ) { $config = LoadFile($config_file); }

if ($config) {
    if ($config->{prefix}) { $sc_prefix = $config->{prefix}; }
    if ($config->{suffix}) { $sc_suffix = $config->{suffix}; }
    if ($config->{marker}) { $sc_marker = $config->{marker}; }
}

# Process command line options
GetOptions( "prefix:s"  =>  \&optHandler,
            "suffix:s"  =>  \&optHandler,
            "marker:s"  =>  \&optHandler)
or die ("Error in command line arguments\n");

# If marker was specified, override prefix and suffix
if ($sc_marker ne '') {
    $sc_prefix = $sc_marker;
    $sc_suffix = $sc_marker;
}

# Set some options
$speller->set_option('lang','en_US');
$speller->set_option('sug-mode','fast');

foreach my $arg (@ARGV) {
    my @words = split / /, $arg;
    foreach my $word (@words) {
        print $speller->check( $word )
              ? "$word "
              : "$sc_prefix$word$sc_suffix ";
    }
}
print("\n");

exit;

sub optHandler {
    my ($opt_name, $opt_value) = @_;
    if ($opt_name eq 'prefix') {
        $sc_prefix = substr($opt_value, 0, 1);
    }
    if ($opt_name eq 'suffix') {
        $sc_suffix = substr($opt_value, 0, 1);
    }
    if ($opt_name eq 'marker') {
        $sc_marker = substr($opt_value, 0, 1);
    }
}
