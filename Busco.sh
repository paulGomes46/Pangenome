#!/bin/bash

#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -n 24
#BSUB -R span[hosts=1]
#BSUB -J hzao index


# Load pantools environment
source ~/anaconda3/etc/profile.d/conda.sh
conda activate /gss1/home/hzhao/anaconda3/envs/py3/envs/pantools

# Perform busco_protein
pantools busco_protein \
--odb10=eudicots_odb10 \
--longest-transcripts \
citrus_pangenome