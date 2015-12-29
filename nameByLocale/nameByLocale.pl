#! /usr/bin/perl
#
# Transform repeater location to call data fields, optionally sorts by
# location and/or applies offset to numeric location.  Data format
# read is specific to the CHIRP format of the online RepeaterBook
# (http://www.repeaterbook.com) as specified below.  Disclaimer: I
# have no affiliation with the RepeaterBook website.
#
# Usage: nameByLocale.pl [-s] [-o memory_offset] -f filename.csv
#
#     where:
#		-f <filename> specifies the input filename (required)
#		-s specifies output sort by locale (optional)
#		-o <offset> specifies starting location offset (optional)
#       -h this help
#
# Input data format: 
#
# Location,Name,Frequency,Duplex,Offset,Tone,rToneFreq,cToneFreq,DtcsCode,DtcsPolarity,Mode,TStep,Comment
# 1,,144.50000,split,147.50000,Tone,107.2,88.5,023,NN,FM,5,"Butte", 
#
# Copyright 2014 Brian Koontz <kz5q@qsl.net>.
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# 
#
#####################################################################
use Getopt::Std;

getopts('so:f:');

if(!defined($opt_f) || defined($opt_h))
{
print <<EOF;
	Usage: nameByLocale.pl [-s] [-o memory_offset] -f filename.csv

	where:
		-f <filename> specifies the input filename (required)
		-s specifies output sort by locale (optional)
		-o <offset> specifies starting location offset (optional)
		-h this help
EOF
	exit(0);
}



$offset = 0;
if(defined($opt_o))
{
	$offset = $opt_o;
}
$filename = $opt_f;
open(IN, "<$filename") or die "Can't open $filename for reading!";
$firstLineRead = 0;
%dupes = {};
@output = ();
while(<IN>)
{
	chomp;
	if(!$firstLineRead) {
		push(@output, $_);
		$firstLineRead = 1;
		next;
	}
	@fields = split(/,/, $_);
	@location = split(//, $fields[12]);
	@location = map { uc($_) } @location;
	@modified_location = ();
	$firstChar = 1;
	foreach $char (@location)
	{
		if($char eq "\"") { 
			next;
		}
		if($firstChar) {
			push(@modified_location, $char);
			$firstChar = 0;
			next;
		}
		if($char =~ /\s|\W/ || $char =~ /[AEIOU]/) {
			next;
		}
		push(@modified_location, $char);
		if(scalar(@modified_location) == 6) {
			last;
		}
	}

	# Pad out location field with spaces to 6
	if(scalar(@modified_location) < 6)
	{
		do {
			push(@modified_location, " ");
		} while(scalar(@modified_location) < 6);
	}

	$newLoc = join('', @modified_location);

	# Check for dupes
	if(!exists $dupes{$newLoc}) {
		$dupes{$newLoc} = 1;
	}
	else {
		$dupes{$newLoc}++;
		@digits = split(//, $dupes{$newLoc});
		$i = 5;
		while(@digits) {
			$modified_location[$i--] = pop @digits;
		}
		$newLoc = join('', @modified_location);
	}

	$fields[1] = $newLoc;
	$fields[0] += $offset;
	push(@output, join(',', @fields));
}

# Sort if asked
if($opt_s) {
	# Save original memory start location
	$start = (split(/,/, $output[1]))[0];
	print shift(@output)."\n";
	@sorted_output = map {
		$_->[0]
	} sort {
		$a->[1] cmp $b->[1]
	}
	  map {
		[ $_, (split /,/, $_)[1] ]
	} @output;
	while($_ = shift(@sorted_output)) {	
		@fields = split(/,/, $_);
		$fields[0] = $start;
		$start++;
		print join(",", @fields)."\n";
	}
}
else {
	print join("\n", @output);
}

close IN;
