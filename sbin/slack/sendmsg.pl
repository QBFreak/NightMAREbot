#!/usr/bin/perl
use strict;
use LWP::UserAgent;
use URI::Encode;
use lib qw(/home/nmb/sbin/common);
require "decode.pl";

## Check for missing parameters
if("$ARGV[0]" eq "") {
        exit;
} elsif("$ARGV[1]" eq "") {
    exit;
} elsif("$ARGV[2]" eq "") {
    exit;
};

## Get parameters
my $room = $ARGV[0];
my $chan = $ARGV[1];
my $user = $ARGV[2];
my $mesg = $ARGV[3];

if("$mesg" eq "") {
    $mesg = $user;
    $user = "";
}

## Decode any encoded parameters
$room = &textdecode($room);
$chan = &textdecode($chan);
$user = &textdecode($user);
$mesg = &textdecode($mesg);

## Set up our objects
my $browser = LWP::UserAgent->new;
my $uri = URI::Encode->new({ encode_reserved => 1 });

## Encode the data
my $url = "http://127.0.0.1:8081/hubot/lazyhorses/$room";
my $json = '{"channel":"' . $chan . '","user":"' . $user . '","message":"' . $mesg . '"}';
my $encoded = $uri->encode($json);
my $data = "payload=$encoded";
my $response = $browser->post( $url, Content => $data);

print($response->content . "\n");
