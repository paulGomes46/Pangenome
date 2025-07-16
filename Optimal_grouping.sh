#!/bin/bash

#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -n 24
#BSUB -R span[hosts=1]
#BSUB -J hzao index

# Load pantools environment
source ~/anaconda3/etc/profile.d/conda.sh
conda activate /gss1/home/hzhao/anaconda3/envs/py3/envs/pantools


# Find the best parameters (relaxation) for grouping 
export _JAVA_OPTIONS="-Xms16g -Xmx32g"

pantools optimal_grouping \
--longest \
citrus_pangenome \
citrus_pangenome/busco/eudicots_odb10


# Perform grouping with the chosen relaxation level
export _JAVA_OPTIONS="-Xms16g -Xmx32g"

pantools group \
-r=3 \
citrus_pangenome