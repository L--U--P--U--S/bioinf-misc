#!/usr/bin/perl

######################
# FASta SUBstitution #
######################

# Copyright 2017 Thomas Wolf, Hans-Knoell-Institute

# DNA only!
# change comments near end to remove * from PROTEINS

use strict;
use warnings;
use File::Basename;
use Getopt::Std;
use Bio::SeqIO;

my %options;
getopts( 'a:', \%options );
my $allowed_letters = "acgtn";    # default
$allowed_letters = $options{'a'} if defined $options{'a'};

die "usage: " . fileparse($0) . " [ -a <allowed letters> ] files\n" unless (@ARGV);

while ( my $file = shift(@ARGV) )
{
	# read from specified file(s)
	my $seq_in = Bio::SeqIO->new( -file => "<$file" );

	# write to STDOUT
	# may be redirected (">") to file
	# nicely FASTA formatted, due to BioPerl usage
	my $seq_out = Bio::SeqIO->new( -fh => \*STDOUT, -format => "fasta" );

	while ( my $seq_obj = $seq_in->next_seq )
	{
		my $seq = $seq_obj->seq();            # get sequence
		$seq =~ s/[^$allowed_letters]/n/g;    # substitute not allowed letters with 'n'
		# $seq =~ s/\*$//;    # remove * at very end of sequence

		# if(index($seq, "*") == -1) # if no * inside sequence
		# {
			$seq_obj->seq($seq);                  # set sequence
			$seq_out->write_seq($seq_obj);        # write sequence
		# }
	}
}
