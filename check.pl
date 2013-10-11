#!/usr/bin/perl
use strict;
use warnings;

my ($folderIn, $folderOut, $extension, $toExec) = @ARGV;
print "Program will check folder $folderIn\n";

do {
	opendir(DIR, $folderIn) or die $!;
	while (my $file = readdir(DIR)) {
		# We only want files
    	next unless (-f "$folderIn/$file");
		# Use a regular expression to find files ending in .txt
		next unless ($file =~ m/\.$extension$/);
		# Verify is the file is not currently using
		my $res = `lsof | grep $file | wc -l`;
		if ($res == 0){
			my $retVal = `mv $folderIn/$file $folderOut`;
			$retVal = `perl $toExec $folderOut/$file`;
		}
		else {
			print "The file $file is currently open, waiting ...\n";
		}
		# Execution of the script
		#my $retVal = `perl $toExec $file`;
    }
	closedir(DIR);
	sleep 1;
} while (1);
