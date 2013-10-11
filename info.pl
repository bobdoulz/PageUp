#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use PageUp::JSON qw(modifyMeta addMeta createMetaFile);
use File::Basename;

# subroutine to remove spaces at beginning and end of string
# also remove newlines
sub cleanString{
	my ($string) = @_;
	$string =~ s/\n\s*/ /g;
	$string =~ s/^\s*//g;
	$string =~ s/\s*$//g;
	return $string;
}

# alternatively, check file from disk
my $fileName = $ARGV[0];
my ($file,$dir,$ext) = fileparse($fileName, qr/\.[^.]*/);

# Create JSON file if not existing (should not happen at this stage though)
my $existingJSON = 0;
if (! -e "${file}.json"){
	PageUp::JSON::createMetaFile("${file}.json");
}
else {
	$existingJSON = 1;
}

# Identify everything. Yes. Everything.
my $datebefore = `date`;
my $retVal = `/usr/local/bin/identify -verbose $fileName > ${file}.id`;

# This can be tuned to get more / less info 
my @consideredTags = qw (Resolution Geometry Colorspace Depth);
# For each info, we grep the info, split and clean then store
foreach (@consideredTags){
	my $tag = $_;
	my $currentInfo = `grep $tag ${file}.id`;
	my @splitNameValue = split(/:/, $currentInfo);
	my $name = $splitNameValue[0];
	my $value = $splitNameValue[1];
	$name = cleanString($name);
	$name = lc($name);
	$value = cleanString($value);
	PageUp::JSON::addOrModifyMeta($file, "info-$name", $value);

}

# Cleaning our temp shit
$retVal = `rm -f ${file}.id`;

# Add time tracking info
my $dateafter = `date`;
PageUp::JSON::addOrModifyMeta($file, "info-date-before", $datebefore);
PageUp::JSON::addOrModifyMeta($file, "info-date-after", $dateafter);

