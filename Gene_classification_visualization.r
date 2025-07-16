#! /usr/bin/env RScript

# Use one of the following files
# /gss1/home/hzhao/paul/rna_seq/pangenome/citrus_pangenome/gene_classification/distances_for_tree/genome_distance_distinct_genes.csv
# /gss1/home/hzhao/paul/rna_seq/pangenome/citrus_pangenome/gene_classification/distances_for_tree/genome_distance_inf_distinct_genes.csv
# /gss1/home/hzhao/paul/rna_seq/pangenome/citrus_pangenome/gene_classification/distances_for_tree/genome_distance_all_genes.csv


library(ape)

input1 <- read.csv("C:/Users/gomes/OneDrive/Documents/PhD/pangenome/gene_classification/All/distances_for_tree/genome_distance_distinct_genes.csv", sep=",", header = TRUE)
input2 <- read.csv("C:/Users/gomes/OneDrive/Documents/PhD/pangenome/gene_classification/All/distances_for_tree/genome_distance_inf_distinct_genes.csv", sep=",", header = TRUE)
input3 <- read.csv("C:/Users/gomes/OneDrive/Documents/PhD/pangenome/gene_classification/All/distances_for_tree/genome_distance_all_genes.csv", sep=",", header = TRUE)

input <- input2

dataframe = subset(input, select = -c(Genomes))
df.distance = as.matrix(dataframe, labels=TRUE)
colnames(df.distance) <- rownames(df.distance) <- input[['Genomes']]
NJ_tree <- nj(df.distance)
write.tree(NJ_tree, tree.names = TRUE, file="C:/Users/gomes/OneDrive/Documents/PhD/pangenome/gene_classification/genome_gene_distance.tree")
cat("\nGene distance tree written to: C:/Users/gomes/OneDrive/Documents/PhD/pangenome/gene_classification/genome_gene_distance.tree\n\n")


tree <- read.tree("C:/Users/gomes/OneDrive/Documents/PhD/pangenome/gene_classification/genome_gene_distance.tree")
plot(tree)