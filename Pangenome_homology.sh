########## BUSCO protein
export PATH=/gss1/App_dir/jdk-15.0.1/bin:$PATH
source /gss1/env/busco.env

java -jar /gss1/home/hzhao/paul/rna_seq/tools/pantools-v4.2.2/pantools-4.3.2.jar busco_protein \
--odb10=eudicots_odb10 \
--longest-transcripts \
--threads 24 \
citrus_pangenome \
--out citrus_busco_results
