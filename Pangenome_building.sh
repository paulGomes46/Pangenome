#!/bin/bash

#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -n 24
#BSUB -R span[hosts=1]
#BSUB -J hzao index

# Load pantools environment
source ~/anaconda3/etc/profile.d/conda.sh
conda activate /gss1/home/hzhao/anaconda3/envs/py3/envs/pantools

# Build the graph-based pangneome
pantools build_pangenome \
--threads=24 \
citrus_pangenome \
genome_locations.txt


# Add annotations to the pangenome
# This will also generate a list of proteins based on gene and CDS coordinates
pantools add_annotations \
citrus_pangenome \
genome_annotations.txt


# Get metrics 
pantools metrics \
citrus_pangenome 


