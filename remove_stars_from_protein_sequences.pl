#!/usr/bin/perl

# Copyright 2017 Thomas Wolf, Hans-Knoell-Institute

use strict;
use warnings;
use File::Basename;
use Bio::SeqIO;

while(my $file = shift)
{
	my ($filename, $dir, $suffix) = fileparse($file, "\.[^.]*");
	my $in = Bio::SeqIO->new(-file => "<$file");
	my $out = Bio::SeqIO->new(-file => ">$dir$filename" . "_no_star" . $suffix);

	while(my $seq_obj = $in->next_seq())
	{
		my $seq = $seq_obj->seq();
		my $desc = $seq_obj->desc();

		if($seq =~ m/\*$/) # remove trailing *
		{
			$seq =~ s/\*$//;
		}

		if(index($seq, "*") != -1)  # remove * inside sequence
		{
			$seq =~ s/\*//g;
			$desc .= " | removed asterisk(s) inside sequence!"; # add reminder to description
		}

		$seq_obj->seq($seq);
		$seq_obj->desc($desc);
		$out->write_seq($seq_obj);
	}
}
