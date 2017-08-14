#!/usr/bin/perl

#########################################################
# Print given subset of sequences of a given FASTA file #
#########################################################

# Copyright 2017 Thomas Wolf, Hans-Knoell-Institute

use strict;
use warnings;
use Getopt::Std;
use Bio::SeqIO;
use List::AllUtils qw(any);

die "subset of sequences to print? fasta file to read from?\n" unless (@ARGV == 2);

my @subset = split(",", $ARGV[0]);
my $file = $ARGV[1];

# read from specified file
my $seq_in = Bio::SeqIO->new( -file => "<$file" );

# write to STDOUT
# may be redirected (">") to file
# nicely FASTA formatted, due to BioPerl usage
my $seq_out = Bio::SeqIO->new( -fh => \*STDOUT, -format => "fasta" );

while ( my $seq_obj = $seq_in->next_seq )
{
	# write sequence if its ID is part of the given subset
	$seq_out->write_seq($seq_obj) if(any { index($seq_obj->desc(), $_) != -1 } @subset);
}
