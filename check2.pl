#!/usr/bin/perl -w

use strict;
use warnings;

use Getopt::Std;
use File::Monitor;

my %opts;
getopt('dcs', \%opts);
die "correct usage: ./check.pl -d dir -c command [-s sleep]" unless $opts{d} and $opts{c};
# defaults to 5 sec:
$opts{s} = 5 unless $opts{s};

my $monitor = File::Monitor->new();

sub create {
	opendir(my $dh, $opts{d}) || die "can't opendir $opts{d}: $!";
	my @nodots = grep { !/^\./ && -f "$opts{d}/$_" } readdir($dh);
	closedir $dh;
	my $isopen;
	foreach my $f (@nodots) {
		$isopen = qx(lsof | grep $f | wc -l);
		while ($isopen != 0) {
			sleep(1);
			$isopen = qx(lsof | grep $f | wc -l);
		} 
		print "calling $opts{c} $opts{d}/$f!\n";
	}
}

$monitor->watch( {
	name => $opts{d},
	recurse => 0,
	files => 1,
	callback => {
		files_created => \&create,
		}
	}
);

while (1) {
	sleep $opts{s};
	$monitor->scan;
}

