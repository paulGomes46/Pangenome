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

# STEP 2: Add transcript paths from GFF
echo "📚 Adding transcript paths..."
vg rna \
  -g /gss1/home/hzhao/paul/rna_seq/genome/pangenome/SWO.vg.gz \
  -x /gss1/home/hzhao/paul/rna_seq/genome/pangenome/SWO.xg.gz \
  -a /gss1/home/hzhao/paul/rna_seq/genome/hzao3.gff3 \
  -t 8 \
  > SWO_rna.vg

# STEP 3: Index the graph
echo "🧩 Indexing the graph..."
vg index -x "${BASENAME}.xg" "${BASENAME}_txp.vg"
vg index -g "${BASENAME}.gcsa" -k 16 "${BASENAME}_txp.vg"

# STEP 4: Map RNA-seq reads using mpmap
echo "🎯 Mapping reads with vg mpmap..."
vg mpmap \
  -x "${BASENAME}.xg" \
  -g "${BASENAME}.gcsa" \
  -f "$READ1" \
  -f "$READ2" \
  -t $THREADS \
  > "${BASENAME}.gamp"

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
