

use JSON;
binmode STDOUT, ":utf8";
use utf8;
use Data::Dumper;

package PageUp::JSON;
use strict;
#use base 'Exporter';
#our @EXPORT_OK = ('addMeta', 'modifyMeta');

#modifyMeta("fakeData.json", "boss/Name", "Paquita");
#addMeta("fakeData.json", "boss/Banane", "Jean");

sub openAndDecode {
	my $fileName = $_[0];
	print "Opening file ".$fileName."\n";
	# Read the file
	my $json;
	local $/;
	# Check if file exists
	if (-e $fileName){
		print "File does exist\n";
		open my $fh, "<", $fileName;
		$json = <$fh>;
 		close $fh;
 	}

 	# Decode JSON
 	my $data = JSON::decode_json($json);
 	return $data;
}

sub writeJSONToFile {
	# Write new JSON file
	my $data = $_[0];
	my $fileName = $_[1];
	open my $fh, ">", $fileName;
	print $fh JSON::encode_json($data);
}

sub openFileDecodeJSONCheckMeta {
	my $fileName = $_[0];
	my $metaName = $_[1];
	my $metaValue = $_[2]; 

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
	my $fileName = $_[0];
	my $metaName = $_[1];
	my $metaValue = $_[2]; # If multiple values, should be adapted

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
	my $fileName = $_[0];
	my $metaName = $_[1];
	my $metaValue = $_[2];

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
	my $fileName = $_[0];
	open FILE, ">".$fileName.".json" or die $!;
	print FILE "{}";
	close FILE;
}

sub deleteMeta {
	my $fileName = $_[0];
	my $metaName = $_[1];
	my $metaValue = $_[2]; # If multiple values, should be adapted

	my ($exists, $jsonHierarchy, $data) = 
	openFileDecodeJSONCheckMeta($fileName, $metaName, $metaValue);

	if (!$exists){
 		#print "The JSON meta does not exist, nothing to delete";
 	}
 	else {
 		
  	}
 	return 1;
}


