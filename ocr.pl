#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use PageUp::JSON;
use File::Basename;

my $fileName = $ARGV[0];
print "File to OCR: $fileName\n";
my ($file,$dir,$ext) = fileparse($fileName, qr/\.[^.]*/);

my $datebefore = `date`;
my $result = `/usr/local/bin/tesseract $fileName $file`;
my $dateafter = `date`;

PageUp::JSON::createMetaFile($file);

PageUp::JSON::addMeta($file, "ocr-date-before", $datebefore);
PageUp::JSON::addMeta($file, "ocr-date-after", $dateafter);
my $text = `cat $file.txt`;
PageUp::JSON::addMeta($file, "ocr-text", $text);

