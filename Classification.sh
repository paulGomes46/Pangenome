#!/bin/bash

#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -n 24
#BSUB -R span[hosts=1]
#BSUB -J hzao index


# Load pantools environment
source ~/anaconda3/etc/profile.d/conda.sh
conda activate /gss1/home/hzhao/anaconda3/envs/py3/envs/pantools

# Determine if pangenome is open or close
pantools pangenome_structure citrus_pangenome



pantools gene_classification citrus_pangenome
