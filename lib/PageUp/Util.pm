package PageUp::Util;

use strict;
use warnings;

# subroutine to remove spaces at beginning and end of string
# also remove newlines
sub cleanString {
	my ($string) = @_;
	$string =~ s/\n\s*/ /g;
	$string =~ s/^\s*//g;
	$string =~ s/\s*$//g;
	return $string;
}

sub getCurrentTime {
	return cleanString(`date`);
}

1;