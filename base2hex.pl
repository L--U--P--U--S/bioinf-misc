#!/usr/bin/perl

#############################################
# Hexadecimal compression for DNA sequences #
#############################################

# Copyright 2017 Thomas Wolf, Hans-Knoell-Institute

# script found at http://www.biostars.org/p/8722
# posted by user "Benm"
# modified by Thomas Wolf

# compression with 7z is way slower, but also way smaller!

use strict;
use warnings;
use Bio::SeqIO;

my $input_file_name = $ARGV[0];
my $output_file_name = $input_file_name . ".hexc";

# not really hex
# would be without N|n
my %base_hex=(
"AA"=>0,
"AC"=>1,
"AG"=>2,
"AT"=>3,
"CA"=>4,
"CC"=>5,
"CG"=>6,
"CT"=>7,
"GA"=>8,
"GC"=>9,
"GG"=>'a',
"GT"=>'b',
"TA"=>'c',
"TC"=>'d',
"TG"=>'e',
"TT"=>'f',
"NN"=>'g',
"NA"=>'h',
"NC"=>'i',
"NG"=>'j',
"NT"=>'k',
"AN"=>'l',
"CN"=>'m',
"GN"=>'n',
"TN"=>'o'
);

my $sequence_io = Bio::SeqIO->new( -file => $input_file_name )->next_seq();
my $sequence = uc($sequence_io->seq());
my $header = $sequence_io->display_id();

$sequence =~ s/(\w{2})/$base_hex{$1}/eg;
$sequence =~ s/(.{60})/$1\n/g;

open (my $output, ">", $output_file_name) or die $!;
print $output ">$header\n";
print $output $sequence;
close $output;

# decode
#
# my @hex_base=sort(keys %base_hex);
# my $seq=$hex;
# $seq=~s/([^ACGT])/$hex_base[oct("0x".$1)]/eg;
# print "decode: $seq\n";
