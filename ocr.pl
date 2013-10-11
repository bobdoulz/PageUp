#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use PageUp::JSON;
use File::Basename;

# Get the file to OCR and get his name, extension and path
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

# OCR the shit out of the file
my $datebefore = `date`;
my $result = `/usr/local/bin/tesseract $fileName $file > /dev/null 2>&1`;
my $dateafter = `date`;

# Add info in the JSON file
my $text = `cat $file.txt`;
PageUp::JSON::addOrModifyMeta($file, "ocr-date-before", $datebefore);
PageUp::JSON::addOrModifyMeta($file, "ocr-date-after", $dateafter);
PageUp::JSON::addOrModifyMeta($file, "ocr-text", $text);

# Clean our temp shit
$result = `rm -f ${file}.txt`;