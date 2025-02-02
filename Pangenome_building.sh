#!/bin/bash

#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -n 24
#BSUB -R span[hosts=1]
#BSUB -J hzao index

# Build the graph-based pangneome
# Note : KMC must be in the $PATH for build_pangenome to work
export PATH=/gss1/home/hzhao/paul/rna_seq/tools/KMC/bin/:$PATH
export PATH=/gss1/App_dir/jdk-15.0.1/bin:$PATH

java -jar /gss1/home/hzhao/paul/rna_seq/tools/pantools-v4.2.2/pantools-4.3.2.jar build_pangenome \
--threads=24 \
citrus_pangenome \
genome_locations.txt


# Add annotations to the pangenome
# This will also generate a list of proteins based on gene and CDS coordinates
java -jar /gss1/home/hzhao/paul/rna_seq/tools/pantools-v4.2.2/pantools-4.3.2.jar add_annotations \
citrus_pangenome \
genome_annotations.txt


# Get metrics 
java -jar /gss1/home/hzhao/paul/rna_seq/tools/pantools-v4.2.2/pantools-4.3.2.jar metrics \
citrus_pangenome 


