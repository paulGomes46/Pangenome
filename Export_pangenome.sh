#!/bin/bash

#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -n 24
#BSUB -R span[hosts=1]
#BSUB -J hzao index

# Load pantools environment
source ~/anaconda3/etc/profile.d/conda.sh
conda activate /gss1/home/hzhao/anaconda3/envs/py3/envs/pantools


pantools export_pangenome \
  --node-properties-file=pangenome_nodes.tsv \
  --relationship-properties-file=pangenome_edges.tsv \
  --sequence-node-anchors-file=pangenome_anchors.tsv \
  ~/my_pangenome_project
