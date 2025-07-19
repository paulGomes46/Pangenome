#!/bin/bash

# INPUT FILES
/gss1/home/hzhao/paul/rna_seq/genome/pangenome
SWO.gcsa.gz  SWO.gcsa.lcp.gz  SWO.gfa.gz  SWO.vg.gz  SWO.xg.gz
REF="ref.fa"
VCF="variants.vcf.gz"
GFF="annotation.gff"
READ1="reads_1.fq.gz"
READ2="reads_2.fq.gz"
THREADS=8
BASENAME="graph_rna"

# STEP 1: Build the graph with variation
echo "Building variation graph..."
vg construct -r "$REF" -v "$VCF" -a -t $THREADS > "${BASENAME}.vg"


# STEP 2: Add transcript paths from GFF   ----------- OK --------------
# Note : the pangenome cannot be zipped
vg rna \
-p \
--threads 8 \
--transcripts /gss1/home/hzhao/paul/rna_seq/genome/hzao3.gff3 \
/gss1/home/hzhao/paul/rna_seq/genome/pangenome/SWO.vg \
> SWO_spliced.pg


# STEP 3: Index the graph     -------------- OK  ----------
vg index -x SWO_spliced.xg -g SWO_spliced.gcsa -k 16 SWO_spliced.vg


# STEP 4: Map RNA-seq reads using mpmap     ------------ In validation ------------
echo "🎯 Mapping reads with vg mpmap..."
vg mpmap \
-x SWO_spliced.xg \
-g SWO_spliced.gcsa \
-f "$READ1" \
-f "$READ2" \
-t 8 \
> SWO_spliced.gamp

#in a Loop

#Récuper la liste de tous les reads

for file in /gss1/home/hzhao/paul/rna_seq/data/my_dataset/*trimmed*
do
        sample_name=$(basename  "$file" | cut -c1-6)
        if [[ ! ${read_prefix[@]} =~ $sample_name ]]
        then
                read_prefix+=($sample_name)
                echo $sample_name
        fi
done

echo $read_prefix

for element in ${read_prefix[@]}
do
        vg mpmap \
        -x SWO_spliced.xg \
        -g SWO_spliced.gcsa \
        -f /gss1/home/hzhao/paul/rna_seq/data/my_dataset/${element}_1_trimmed_PE.fastq.gz \
        -f /gss1/home/hzhao/paul/rna_seq/data/my_dataset/${element}_2_trimmed_PE.fastq.gz \
        -t 8 \
        > ${element}.gamp
done


#Align with Hisat2
for element in ${read_prefix[@]}
do
        # be sure the name of the index is correct. I usually use genome_index_ + name of the genome
        echo "alignment : $element"
        hisat2 --dta -x $index \
        -1 /gss1/home/hzhao/paul/rna_seq/data/my_dataset/${element}_1_trimmed_PE.fastq.gz \
        -2 /gss1/home/hzhao/paul/rna_seq/data/my_dataset/${element}_2_trimmed_PE.fastq.gz \
        --fr \
        -S $alignment/${element}.sam \
        --summary-file $alignment/log/${element}_alignment_summary.txt
        samtools sort \
        -o $alignment/${element}.bam \
        $alignment/${element}.sam
        #remove the .bam files to save space
        rm $alignment/${element}.sam
done






# STEP 5: Convert GAMP to GAM (optional but needed for pack)
echo "🔁 Converting .gamp to .gam..."
vg view -a "${BASENAME}.gamp" > "${BASENAME}.gam"

# STEP 6: Pack read alignments
echo "📦 Packing reads..."
vg pack \
  -x "${BASENAME}.xg" \
  -g "${BASENAME}.gam" \
  -o "${BASENAME}.pack" \
  -t $THREADS

# STEP 7: (Optional) Surject to reference coordinates
echo "📤 Surjecting to linear reference..."
vg surject \
  -x "${BASENAME}.xg" \
  -b \
  "${BASENAME}.gam" \
  -t $THREADS \
  > "${BASENAME}.bam"

# STEP 8: (Optional) Transcript expression quantification
echo "📊 Extracting transcript expression (if transcript paths are available)..."
vg rna \
  -x "${BASENAME}.xg" \
  -d "${BASENAME}.pack" \
  -o "${BASENAME}_expression.tsv"

echo "✅ Pipeline complete!"
