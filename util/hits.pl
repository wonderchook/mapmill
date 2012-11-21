#!/usr/bin/perl -n
BEGIN {$/ = ""}
my $ip = (m|((?:\d+\.){3}\d+)|gos)[0];
my $stamp = (m|at (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)|gos)[0];
my ($date, $time) = split " ", $stamp;
my ($image, $score) = (m|/vote/(\d+)/(\d+)|gos);
print join(",", $date, $time, $ip, $image, $score), "\n" if $ip and $image;
