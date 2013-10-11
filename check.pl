#!/usr/bin/perl
use strict;
use warnings;
use Archive::Tar;
use File::Basename;

my ($folderIn, $folderOut, $extension, $toExec) = @ARGV;

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
			# Moving file(s?) into $folderOut
			my $retVal = `mv $folderIn/$file $folderOut`;
			# Execute whatever 
			$retVal = `perl $toExec $folderOut/$file`;
			# Create a tar archive with all the files
			my $tar = Archive::Tar->new;
			$tar->add_files("./$folderOut/$file");
			my ($name,$rep,$ext) = fileparse("$folderOut/$file", qr/\.[^.]*/);
			$tar->add_files("./$folderOut/${name}.json");
			$tar->rename("$folderOut/${name}.json", "${name}.json");
			$tar->rename("$folderOut/${name}.tiff", "${name}.tiff");
			$tar->write("$folderOut/${name}.tar");
			# Remove the other files
			$retVal = `rm -f $folderOut/$file $folderOut/${name}.json`;
		}
		else {
			print "The file $file is currently open, waiting ...\n";
		}		
    }
	closedir(DIR);
	sleep 1;
} while (1);
