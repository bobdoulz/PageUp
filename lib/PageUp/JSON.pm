package PageUp::JSON;

use JSON;
use utf8;
use strict;
use warnings;
use File::Basename;
binmode STDOUT, ":utf8";

####################################################
#
# The 3 following subroutines should be the only 
# used subroutines in external programs
#
####################################################

# Either add of modify depending of the existance of a meta
sub addOrModifyMeta {
	my ($fileName, $metaName, $metaValue) = @_;
	if (! modifyMeta($fileName, $metaName, $metaValue)){
		addMeta($fileName, $metaName, $metaValue);
	}
}

# Create an empty JSON file
sub createMetaFile {
	my ($fileName) = @_;
	$fileName = correctFileName($fileName);
	#print "JSON.pm : file to create $fileName\n";
	open FILE, ">".$fileName or die $!;
	print FILE "{}";
	close FILE;
}

####################################################
#
# The following subroutines should not be used by 
# inexperienced programmers
#
####################################################

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

# Subroutine to open a JSON file, decode its content
# and return it
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

# Take some JSON content and encode it into a file
sub writeJSONToFile {
	# Write new JSON file
	my ($data, $fileName) = @_;
	$fileName = correctFileName($fileName);
	open my $fh, ">", $fileName;
	print $fh JSON::encode_json($data);
}

# Open a JSOn file and check if a meta is already in it
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

# Modify a meta value in a JSON file
sub modifyMeta {
	my ($fileName, $metaName, $metaValue) = @_;
	$fileName = correctFileName($fileName);

	my ($exists, $data) = 
	openFileDecodeJSONCheckMeta($fileName, $metaName, $metaValue);
 	if (!$exists){
 		#print "Meta not existing, cannot modify it, use add instead.\n";
 		return 0;
 	}
 	else {
 		# Modify meta value
 		$data->{"$metaName"} = $metaValue;
 		writeJSONToFile($data, $fileName);
 		return 1;
 	}

}

# Add a meta name and value in a JSON file
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
 		#print "Meta already existing, cannot add it, use modify to modify value.\n";
 		return 0;
 	}
}

1;

