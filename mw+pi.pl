#!/usr/bin/perl

# Copyright 2017 Thomas Wolf, Hans-Knoell-Institute

use 5.14.2;

use strict;
use warnings;

use Text::CSV;                   # output
use Bio::SeqIO;                  # input
use Bio::Tools::SeqStats;        # properties
use Bio::Tools::pICalculator;    # properties

my @MWs_and_pIs;                 # collect results
my $pi_calc = Bio::Tools::pICalculator->new(
	-places => 2,                # places after comma --> precision
	-pKset  => 'EMBOSS'          # included set of pK values from EMBOSS --> self-defined set is also possible
);

my $protein_file = shift;                                      # first command-line argument
my $sequence_io = Bio::SeqIO->new( -file => $protein_file );
while ( my $sequence = $sequence_io->next_seq() )
{
	$pi_calc->seq($sequence);                                  # calculate isoelectric point
	my $seq_stats = Bio::Tools::SeqStats->new( -seq => $sequence );
	my $mw = $seq_stats->get_mol_wt();    # calculate molecular weight
	print "different min/max molecular weight for: " . $sequence->display_id() . "\n" if ( $$mw[0] != $$mw[1] ); # not necessary, only additional info
	push( @MWs_and_pIs, { id => $sequence->display_id(), pi => $pi_calc->iep, mw_min => $$mw[0], mw_max => $$mw[1] } );
}

my $csv = Text::CSV->new( { sep_char => "\t" } );                                                                # tab is column separator
$csv->eol("\n");

open( my $out, ">", "$protein_file.mw+pi.csv" ) or die $!;
print $out join( "\t", "Protein ID", "Isoelectric point", "Molecular weight (min) in Da(?)", "Molecular weight (max) in Da(?)" ) . "\n";  # table head

for (@MWs_and_pIs)
{
	$csv->print( $out, [ $_->{id}, $_->{pi}, $_->{mw_min}, $_->{mw_max} ] ) or die $csv->error_diag();    # write to file line by line
}

close $out;
