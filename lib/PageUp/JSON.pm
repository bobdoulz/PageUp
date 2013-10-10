package PageUp::JSON;

use JSON;
use utf8;
use strict;
use File::Basename;
use base 'Exporter';
our @EXPORT_OK = qw(addMeta modifyMeta createMetaFile);
binmode STDOUT, ":utf8";

sub openAndDecode {
	# Read the file
	my ($fileName) = @_;
	$fileName = correctFileName($fileName);
	my $json;
	local $/;
	# Check if file exists
	if (-e $fileName){
		open my $fh, "<", $fileName;
		$json = <$fh>;
 		close $fh;
 	}
 	else {
 		print $fileName . " does not exist\n";
 	}

 	# Decode JSON
 	my $data = JSON::decode_json($json);
 	return $data;
}

sub writeJSONToFile {
	# Write new JSON file
	my ($data, $fileName) = @_;
	$fileName = correctFileName($fileName);
	open my $fh, ">", $fileName;
	print $fh JSON::encode_json($data);
}

# This subroutine checks if the fileName has the .json extension
# and adds it if not
sub correctFileName {
	my ($fileName) = @_;
	my ($file,$dir,$ext) = fileparse($fileName, qr/\.[^.]*/);
	if ($ext ne ".json"){
		$fileName = "${fileName}.json";
	}
	return $fileName;
}

sub openFileDecodeJSONCheckMeta {
	my ($fileName, $metaName, $metaValue) = @_;
	$fileName = correctFileName($fileName);
 	# Decode JSON
 	my $data = openAndDecode($fileName);
 	# Check if the meta already exists 
 	if (!$data->{"$metaName"}){
 		return 0, $data;
 	}
 	else {
 		return 1, $data;
 	}
}

sub modifyMeta {
	my ($fileName, $metaName, $metaValue) = @_;
	$fileName = correctFileName($fileName);

	my ($exists, $data) = 
	openFileDecodeJSONCheckMeta($fileName, $metaName, $metaValue);
 	if (!$exists){
 		 print "Meta not existing, cannot modify it, use add instead.\n";
 		return 0;
 	}
 	else {
 		# Modify meta value
 		$data->{"$metaName"} = $metaValue;
 		writeJSONToFile($data, $fileName);
 		return 1;
 	}

}

sub addMeta {
	my ($fileName, $metaName, $metaValue) = @_;
	$fileName = correctFileName($fileName);

	my ($exists, $data) = 
	openFileDecodeJSONCheckMeta($fileName, $metaName, $metaValue);
 	if (!$exists){
 		# Add meta value
 		$data->{"$metaName"} = $metaValue;
 		writeJSONToFile($data, $fileName);
 		return 1;
 	}
 	else {
 		print "Meta already existing, cannot add it, use modify to modify value.\n";
 		return 0;
 	}
}

sub createMetaFile {
	my ($fileName) = @_;
	$fileName = correctFileName($fileName);
	#print "JSON.pm : file to create $fileName\n";
	open FILE, ">".$fileName or die $!;
	print FILE "{}";
	close FILE;
}

1;

