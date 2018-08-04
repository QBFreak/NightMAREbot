#!/usr/bin/perl
use strict;
use LWP::UserAgent;
use HTML::TokeParser;
use HTML::TableExtract;
use Data::Dumper;

my $login_url = 'http://mare.qbfreak.net/bin/login/MAGA/Bugs';
my $rss_url = 'http://mare.qbfreak.net/bin/view/MAGA/Bugs/Tabulator?status=new&skin=rss';

my $browser = LWP::UserAgent->new;
push @{ $browser->requests_redirectable }, 'POST'; # Enable redirects after POST
                                                   # See http://www.perlmonks.org/?node_id=147608#147785
$browser->cookie_jar( {} ); # Enable cookies

## Attempt to log in
my $response = $browser->post(
    $login_url,
    [
      'username'    => 'NightMAREbot',
      'password'    => 'sluggy',
      'foswiki_origin'  =>  'GET,view,/'
    ],
);
die "BUGS Error: ", $response->status_line
  unless $response->is_success;

die("BUGS Error: Failed to log in.")
  if($response->content !~ m/Night MAR Ebot/);

## Attempt to retrieve the RSS
my $response = $browser->get($rss_url);
die "BUGS Error: ", $response->status_line
  unless $response->is_success;

die("BUGS Error: Invalid RSS response")
  if($response->content !~ m/<\?xml version="1\.0"/);

## Success! Parse it.
my $content = $response->content;
$content =~ s/&nbsp;/ /g;

my $te = HTML::TableExtract->new();
$te->parse($content);

my $row_text = "";
foreach my $row ($te->rows) {
    $row_text = join('|', @$row);
    $row_text =~ s/\n/,/g;
    print("BUGS $row_text\n");
}

print("BUGS done.\n");

exit;
