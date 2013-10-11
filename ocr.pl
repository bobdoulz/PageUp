#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use PageUp::JSON;
use File::Basename;

# Get the file to OCR and get his name, extension and path
my $fileName = $ARGV[0];
print "File to OCR: $fileName\n";
my ($file,$dir,$ext) = fileparse($fileName, qr/\.[^.]*/);

# Create JSON file if not existing (should not happen at this stage though)
if (! -e $fileName){
	PageUp::createMetaFile("${file}.json");
}

# OCR the shit out of the file
my $datebefore = `date`;
my $result = `/usr/local/bin/tesseract $fileName $file`;
my $dateafter = `date`;

# Add info in the JSON file
PageUp::JSON::addMeta($file, "ocr-date-before", $datebefore);
PageUp::JSON::addMeta($file, "ocr-date-after", $dateafter);
my $text = `cat $file.txt`;
PageUp::JSON::addMeta($file, "ocr-text", $text);

# Clean our temp shit
$result = `rm -f ${file}.txt`;