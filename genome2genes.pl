#!/usr/bin/perl


# Create multi FASTA file with gene sequences, using:
# - genome sequence FASTA file, e.g. with scaffold/contig sequences
# - corresponding GTF/GFF annotation file


# BASH:
#
# 1) create multi FASTA file, but with "useless" headers
# bedtools getfasta -fi Aspergillus_fumigatusa1163.CADRE.dna.nonchromosomal.fa -bed Aspergillus_fumigatusa1163.CADRE.38.genes.gtf -fo genes.fasta -name
#
# 2) create GTF annotation file with "gene" features only
# grep -P "\tgene\t" Aspergillus_fumigatusa1163.CADRE.38.gtf > Aspergillus_fumigatusa1163.CADRE.38.genes.gtf


# Perl:
#
# 3) modify/extend FASTA headers

use strict;
use warnings;

# collect info from GTF columns
open(my $gtf, "<", "Aspergillus_fumigatusa1163.CADRE.38.genes.gtf") or die $!;
my (@seq, @start, @stop, @gene_id, @gene_name);
while(<$gtf>){
    $_=~/^(\w+)/; push(@seq, $1);
    $_=~/\t(\d+)\t(\d+)\t/; push(@start, $1); push(@stop, $2);
    $_=~/gene_id "([\w-]+)"; gene_name "([\w-]+)"/; push(@gene_id, $1); push(@gene_name, $2);
}
close $gtf;

# add previously collected info to header
open(my $fasta_in, "<", "genes.fasta") or die $!;
open(my $fasta_out, ">", "gene_sequences.fasta") or die $!;
my $i=0;
while(<$fasta_in>){
    if(index($_, ">") == 0){
        # extend header
        $_=~s/>gene/>$gene_name[$i] $gene_id[$i] $seq[$i]:$start[$i]-$stop[$i++]/;
    } else {
        # line wrap
        $_=~s/(.{60})/$1\n/g;
    }
    print $fasta_out $_; # write line to new file
}
close $fasta_in;
close $fasta_out;
