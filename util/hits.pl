#!/usr/bin/perl -n
BEGIN {$/ = ""}
my $ip = (m|((?:\d+\.){3}\d+)|gos)[0];
my ($image, $score) = (m|/vote/(\d+)/(\d+)|gos);
print join(",", $ip, $image, $score), "\n" if $ip and $image;
