#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use PageUp::JSON qw(modifyMeta addMeta createMetaFile);
use File::Type;
use Image::Info qw(image_info dim);
use Switch;

my $ft = File::Type->new();

# read in data from file to $data, then
#my $type_from_data = $ft->checktype_contents($data);

# alternatively, check file from disk
my $file = "1017_001.tiff";
my ($file,$dir,$ext) = fileparse($fileName, qr/\.[^.]*/);


my $type_from_file = $ft->checktype_filename($file);

# convenient method for checking either a file or data
my $type_1 = $ft->mime_type($file);
#my $type_2 = $ft->mime_type($data);

switch ($type_1) {
	case "image/tiff" {processingTIFF()}
	else {print "Type unknown"}
}

sub processingTIFF {
	print "This is a TIFF image\n";
	my $info = Image::Info->image_info("ay5XvzY_460s.jpg");
	if (my $error = $info->{error}) {
		die "Can't parse image info: $error\n";
	}

	my $color = $info->{color_type};
 	my $type = Image::Info->image_type("ay5XvzY_460s.jpg");
 	if (my $error = $type->{error}) {
 		die "Can't determine file type: $error\n";
 	}
 	die "No gif files allowed!" if $type->{file_type} eq 'GIF';
 	my($w, $h) = dim($info);

 	print "color = ".$color."\n";
 	print "type = ".$type."\n";
 	print "w = ".$w." h = ".$h."\n";
}