#!/usr/bin/python
# -*- coding: utf-8 -*-

# https://genohub.com/next-generation-sequencing-guide/
# https://genohub.com/recommended-sequencing-coverage-by-application/

# "normal" transcriptomic DEG analysis: ~ 10-fold exome coverage

import sys
if sys.version_info[0] < 3:
    raise Exception("Must be using Python 3")

print("\n".join([
    "",
    "Equation: [coverage] = [number of reads] * [read length] / [genome size]",
    "Example: [30-fold] = [9,000,000] * [100 base pairs] / [30,000,000 base pairs]",
    "",
    "Skip question (hit Enter) if not known. This value will be calculated for you. Only [coverage] and [number of reads] are supported at the moment.",
    ""
]))

coverage = input("Average mapping coverage per base in x-fold? ")
number_of_reads = input("Number of total reads per sample? ")
read_length = input("Sequencing read length in base pairs? ")
genome_size = input("Size of target genome in base pairs? ")

try:
    if coverage == "":
        number_of_reads = int(number_of_reads)
        read_length = int(read_length)
        genome_size = int(genome_size)
        print("")
        print("coverage = {:,d} reads * {:,d} base pairs / {:,d} base pairs".format(number_of_reads, read_length, genome_size))
        print("coverage ~ {:,.0f}-fold".format(number_of_reads * read_length / genome_size))
    elif number_of_reads == "":
        coverage = int(coverage)
        read_length = int(read_length)
        genome_size = int(genome_size)
        print("")
        print("number of reads = {:,d}-fold * {:,d} base pairs / {:,d} base pairs".format(coverage, genome_size, read_length))
        print("number of reads ~ {:,.0f}".format(coverage * genome_size / read_length))
except Exception as e:
    print("\n".join([
        "",
        str(e),
        "Please enter valid numbers for at least three of the four values. Only [coverage] or [number of reads] can be skipped as input and calculated."
    ]))
