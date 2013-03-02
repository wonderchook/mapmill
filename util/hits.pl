#!/usr/bin/perl -n
BEGIN {
    $/ = "";
    $filter = shift @ARGV;
    print "date,time,site,email,ip,image,score\n";
}
next if $filter and not m|$filter/vote|os;
my $ip = (m|((?:\d+\.){3}\d+)|gos)[0];
my $stamp = (m|at (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)|gos)[0];
my ($date, $time) = split " ", $stamp;
my ($site) = (m|/review/(\w+)/vote|gos);
my ($image, $score) = (m|/vote/(\d+)/(\d+)|gos);
my ($email) = m|Email: (\S+)|gos;
print join(",", $date, $time, $site, $email, $ip, $image, $score), "\n" if $ip and $image;
