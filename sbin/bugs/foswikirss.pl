#!/usr/bin/perl
use strict;
use LWP::UserAgent;
use URI;
use Data::Dumper;
use File::Basename;
use XML::XPath;
use lib qw(/home/nmb/sbin/common);
require "encode.pl";

my $script_name = basename($0);

my $rss_url_base = 'http://mare.qbfreak.net/'; # If specifying a path beyond root, you MUST leave a trailing backslash
my $rss_url_login = 'bin/login';
my $rss_url_web = 'MAGA/Bugs'; # Web and Topic should NOT have leading or trailing backslash
my $rss_url_topic = 'WebRss';
my $rss_url_opts = '';
my $rss_username = 'NightMAREbot';
my $rss_password = 'sluggy';
my $rss_encode_output = 0;

# If we have any command line arguments, URL-encode the first as search=
#  and append to our RSS URL
if (scalar @ARGV) {
    foreach my $arg (@ARGV) {
        my $validParam = 0;
        if ($arg =~ m/^--url=([^"]*)$/) { $rss_url_base = $1; $validParam = 1; }
        if ($arg =~ m/^--web=([^"]*)$/) { $rss_url_web = $1; $validParam = 1; }
        if ($arg =~ m/^--topic=([^"]*)$/) { $rss_url_topic = $1; $validParam = 1; }
        if ($arg =~ m/^--options="?([^"]*)"?$/) { $rss_url_opts = $1; $validParam = 1; }
        if ($arg =~ m/^--login=([^"]*)$/) { $rss_url_login = $1; $validParam = 1; }
        if ($arg =~ m/^--user=([^"]*)$/) { $rss_username = $1; $validParam = 1; }
        if ($arg =~ m/^--passwd=([^"]*)$/) { $rss_password = $1; $validParam = 1; }
        if ($arg =~ m/^--encode$/) { $rss_encode_output = 1; $validParam = 1; }
        if ($arg =~ m/^--help$/) { doUsage(); $validParam = 1; }
        if ($validParam == 0) {
            print("Invalid parameter '$arg'\n");
            doUsage();
        }
    }
}

sub doUsage() {
    print("Usage: $script_name [--url=<base-url>] [--web=<web-name>] [--topic=<topic-name>]\n");
    print("                    [--options=<get-options>] [--login=<login-path>]\n");
    print("                    [--user=<username>] [--passwd=<password>] [--encode]\n");
    print("Usage: $script_name --help\n");
    exit 1;
    return;
}

# Clean up leading/trailing backslashes (as appropriate)
$rss_url_base =~ s/\/$//;
$rss_url_web =~ s/\./\//g;
$rss_url_web =~ s/^\/(.*)$/$1/;
$rss_url_web =~ s/^(.*)\/$/$1/;
$rss_url_topic =~ s/\./\//g;
$rss_url_topic =~ s/^\/(.*)$/$1/;
$rss_url_topic =~ s/^(.*)\/$/$1/;

my $uri = URI->new($rss_url_base);
my $uri_login = URI->new($rss_url_base);

# Check for validity
die "Error: You must specify a URL"
    unless $rss_url_base ne '';

die "Error: You must specify a Web"
    unless $rss_url_web ne '' or $rss_url_topic =~ m/\//;

die "Error: You must specify a topic"
    unless $rss_url_topic ne '';

die "Error: You must specify a login path"
    unless $rss_url_login ne '';

die "Error: You must specify a username"
    unless $rss_username ne '';

die "Error: You must specify a password"
    unless $rss_password ne '';

$uri_login->path($rss_url_login);

if($rss_url_web eq '') {
    $uri->path($uri->path . "/$rss_url_topic");
} else {
    $uri->path($uri->path . "/$rss_url_web/$rss_url_topic");
}

if($rss_url_opts ne '') {
    $uri->query($rss_url_opts);
}

my $rss_url = $uri->as_string;
my $login_url = $uri_login->as_string;

my $browser = LWP::UserAgent->new;
push @{ $browser->requests_redirectable }, 'POST'; # Enable redirects after POST
                                                   # See http://www.perlmonks.org/?node_id=147608#147785
$browser->cookie_jar( {} ); # Enable cookies

## Attempt to log in
my $response = $browser->post(
    $login_url,
    [
      'username'    => $rss_username,
      'password'    => $rss_password,
      'foswiki_origin'  =>  'GET,view,/'
    ],
);
die "Error: ", $response->status_line
  unless $response->is_success;

die("Error: Failed to log in.")
  if($response->content !~ m/Night MAR Ebot/);

## Attempt to retrieve the RSS
my $response = $browser->get($rss_url);
die "Error: ", $response->status_line
  unless $response->is_success;

die("Error: Invalid RSS response")
  if($response->content !~ m/<\?xml version="1\.0"/);

## Success! Parse it.
my $content = $response->content;
$content =~ s/&nbsp;/ /g;

my $xp = XML::XPath->new(xml => $content);
my @items;

my $count = 0;
for my $listitem ($xp->findnodes('/rdf:RDF/channel/items/rdf:Seq/rdf:li')) {
    for my $attr ($listitem->getAttributes('rdf:resource')) {
        #print($attr->getData, "\n");
        $count++;
        $items[$count] = {};
        $items[$count]->{'URL'} = $attr->getData;
        for my $item ($xp->findnodes('/rdf:RDF/item')) {
            for my $item_attr ($item->getAttributes('rdf:about')) {
                if ($item_attr->getData eq $attr->getData) {
                    # We finally found the right <item>
                    $items[$count]->{'title'} = $item->find('title');
                    $items[$count]->{'description'} = $item->find('description');
                    $items[$count]->{'date'} = $item->find('dc:date');
                }
            }
        }
    }
}

for (my $i = 1; $i < $count; $i++) {
    if ($rss_encode_output == 1) {
        print("URL " . &textencode($items[$i]->{'URL'}), "\n");
        print("TITLE " . &textencode($items[$i]->{'title'}), "\n");
        print("DESC " . &textencode($items[$i]->{'description'}), "\n");
        print("DATE " . &textencode($items[$i]->{'date'}), "\n");
    } else {
        print("URL " . $items[$i]->{'URL'}, "\n");
        print("TITLE " . $items[$i]->{'title'}, "\n");
        print("DESC " . $items[$i]->{'description'}, "\n");
        print("DATE " . $items[$i]->{'date'}, "\n");
    }
}

print("DONE\n");

exit;
