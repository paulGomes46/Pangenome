#!/bin/bash

#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -n 24
#BSUB -R span[hosts=1]
#BSUB -J hzao index



# Annotate with interproscan
for seq in /gss1/home/hzhao/paul/rna_seq/proteome/*
do
	interproscan.sh -i $seq \
	--applications Pfam,TIGRFAM \
	-goterms \
	-f gff3 \
	-cpu 24
done