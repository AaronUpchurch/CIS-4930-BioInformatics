#=================================================
#  CIS 4930 Assignment 2
#  By: Aaron Upchurch, Justin Lapidus
#=================================================

#=====================================================
#                    Section 1
#=====================================================

library("DESeq2") # libraries
library(tibble)
library(ggplot2)

if (!dir.exists("data")) { # Sets up folders
  dir.create("data")
}
plots_dir <- "plots"
if (!dir.exists(plots_dir)) {
  dir.create(plots_dir)
}
results_dir <- "results"
if (!dir.exists(results_dir)) {
  dir.create(results_dir)
}

mat = as.matrix(read.table("C:/Users/aaron/OneDrive/Desktop/Sophmore Fall/Bioinformatics/Project/Data/Samples/Matrix/Series_Matrix_Just_Data.txt", header = TRUE, row.names=1, sep="\t")) # expression data
sampleDataMatrix = t(as.matrix(read.table("C:/Users/aaron/OneDrive/Desktop/Sophmore Fall/Bioinformatics/Project/Data/Samples/Matrix/SampleInformation.txt", header = TRUE, row.names=1,sep="\t"))) # stores matrix of information on each sample

print(paste("Dimensions of expression matrix")) # prints size of expression matrix
print(paste("Number of rows: ", dim(mat)[1]))
print(paste("Number of columns: ", dim(mat)[2]))
print(paste("Number of genes: ", dim(mat)[1]))

minValue = min(mat,na.rm = TRUE) # minimum value in expression matrix
maxValue = max(mat,na.rm = TRUE) # maximum value in expression matrix

mat = (mat - minValue)    # adds abs(minValue) to all indexes in matrix, therefore no more negative values


geneRangeMatrix = matrix(list(), nrow=41000, ncol=2) # gets range for all genes
for(i in 1:41000){
  geneRangeMatrix[i,1] <- (min(mat[i,1:44],na.rm = TRUE))
  geneRangeMatrix[i,2] <- (max(mat[i,1:44],na.rm = TRUE))
}

geneTotalRangeMatrix <- matrix(list(), nrow=41000, ncol=1) # gets max - min value for all genes
geneTotalRangeMatrix = (as.numeric(geneRangeMatrix[,2]) - as.numeric(geneRangeMatrix[,1]))

densityPlot <- plot(density(na.omit(as.vector(geneTotalRangeMatrix)))) # plots density curve of max-min, with NA values removed



#================================================================================#
#                        Section 2
#================================================================================#

mat[is.na(mat)] <- 0 # inserts 0 into missing data

mat <- round(mat) # rounds values for dds 

dds <- DESeqDataSetFromMatrix(countData = na.omit(mat),
                              colData = (sampleDataMatrix), 
                              design= ~1)

vsd <- vst(dds, blind=FALSE)

PCAPlot <- (plotPCA(vsd, intgroup = c("Sample_intervention_status")))  #keep me
print(PCAPlot)

ggsave(
  plot = PCAPlot,
  file.path(plots_dir, "PCA_Plot.png")
) # Replace with a plot name relevant to your data


#=====================================================
#                    Section 3
#=====================================================

if (!("DESeq2" %in% installed.packages())) {   # Installs libraries if not installed
  BiocManager::install("DESeq2", update = FALSE)
}
if (!("EnhancedVolcano" %in% installed.packages())) {
  BiocManager::install("EnhancedVolcano", update = FALSE)
}
if (!("apeglm" %in% installed.packages())) {
  BiocManager::install("apeglm", update = FALSE)
}

library(DESeq2)
library(magrittr)

set.seed(12345) # sets seed for randomness

metadata <- readr::read_tsv("C:/Users/aaron/OneDrive/Desktop/Sophmore Fall/Bioinformatics/Project/Data/Samples/Matrix/SampleInformation.txt", col_names = TRUE) # Read in metadata TSV file

metadata <- as_tibble(t(metadata), rownames = "Sample_geo_accession",) # has to be transposed to be like example, # remake it into a list
names(metadata) = c("Sample_geo_accession", "Sample_status", "Sample_submission_date", "Sample_last_update_date", "Sample_type", "Sample_channel_count", "Sample_source_name_ch1", "Sample_organism_ch1", "Sample_characteristics_ch1", "Sample_disease_status", "Sample_gender", "Sample_age", "Sample_intervention_status" )
metadata <- metadata[-1,] # remove first row because it containted column headers

expression_df <- readr::read_tsv("C:/Users/aaron/OneDrive/Desktop/Sophmore Fall/Bioinformatics/Project/Data/Samples/Matrix/Series_Matrix_Just_Data.txt") %>%
  tibble::column_to_rownames("ID_REF")


metadata <- metadata %>%  # sets up intervetion status variable
  dplyr::mutate(mutation_status = dplyr::case_when(
    stringr::str_detect(Sample_intervention_status, "intervention status: before") ~ "before",
    stringr::str_detect(Sample_intervention_status, "intervention status: after") ~ "after"
  ))

# Make mutation_status a factor and set the levels appropriately [changes intervention from strings to factors]
metadata <- metadata %>%
  dplyr::mutate(
    # Here we define the values our factor variable can have and their order.
    mutation_status = factor(mutation_status, levels = c("before", "after"))
  )


minValue = min(expression_df,na.rm = TRUE) # minimum value in expression matrix
expression_df = (expression_df - minValue) 
expression_df[is.na(expression_df)] <- 0
expression_df = 2^expression_df


filtered_expression_df <- expression_df %>%
  dplyr::filter(rowSums(.) >= 10)



gene_matrix <- round(filtered_expression_df)


ddset <- DESeqDataSetFromMatrix(
  # Here we supply non-normalized count data
  countData = gene_matrix,
  # Supply the `colData` with our metadata data frame
  colData = metadata,
  # Supply our experimental variable to `design`
  design = ~mutation_status
)



deseq_object <- DESeq(ddset)

deseq_results <- results(deseq_object)

deseq_results <- lfcShrink(
  deseq_object, # The original DESeq2 object after running DESeq()
  coef = 2, # The log fold change coefficient used in DESeq(); the default is 2.
  res = deseq_results # The original DESeq2 results table
)

# this is of class DESeqResults -- we want a data frame
deseq_df <- deseq_results %>%
  # make into data.frame
  as.data.frame() %>%
  # the gene names are row names -- let's make them a column for easy display
  tibble::rownames_to_column("ID_REF") %>%
  # add a column for significance threshold results
  dplyr::mutate(threshold = padj < 0.05) %>%
  # sort by statistic -- the highest values will be genes with
  # higher expression in RPL10 mutated samples
  dplyr::arrange(dplyr::desc(log2FoldChange))



#plotCounts(ddset, gene = "A_24_P68088", intgroup = "mutation_status")


volcano_plot <- EnhancedVolcano::EnhancedVolcano(
  deseq_df,
  lab = deseq_df$ID_REF,
  x = "log2FoldChange",
  y = "padj",
  pCutoff = 0.01 # Loosen the cutoff since we supplied corrected p-values
)

print(volcano_plot)

ggsave(
  plot = volcano_plot,
  file.path(plots_dir, "Data_volcano_plot.png")
) # Replace with a plot name relevant to your data

diff_expressed_genes <- subset(deseq_df, threshold == "TRUE") #Only gets stat significant genes
diff_expressed_genes <- as.data.frame(diff_expressed_genes)

readr::write_tsv(
  diff_expressed_genes,
  file.path(
    results_dir,
    "table_diff_expressed_genes.tsv" # Replace with a relevant output file name
  )
)

#=====================================================
#                    Section 4
#=====================================================


library(ComplexHeatmap)
library(circlize)

mat = as.matrix(read.table("C:/Users/aaron/OneDrive/Desktop/Sophmore Fall/Bioinformatics/Project/Data/Samples/Matrix/Series_Matrix_Just_Data.txt", header = TRUE, row.names=1, sep="\t"))




diff_expressed_genes <- diff_expressed_genes$ID_REF  # list of genes that are differentially expressed


minValue = min(mat,na.rm = TRUE) # minimum value in expression matrix

#print("min value is")
#print(minValue)

mat = (mat - minValue) 
mat[is.na(mat)] <- 0
mat = 2^mat


diff_expressed_mat <- mat[c(diff_expressed_genes),] # matrix of just diff expressed genes

diff_gene_map <- (heatmap((diff_expressed_mat)))


#=====================================================
#                    Section 5
#=====================================================

# gProfiler2
#g:GOSt


library(gprofiler2)


gostres <- gost(query = c(diff_expressed_genes))

data2 <- as.data.frame(gostres["result"])

readr::write_tsv(
  data2,
  file.path(
    results_dir,
    "Gostres_Data.tsv" # Replace with a relevant output file name
  )
)

print(publish_gosttable(gostres, highlight_terms = gostres$result[c(1:2,10,120),],
                  use_colors = TRUE, 
                  show_columns = c("source", "term_name", "term_size", "intersection_size"),
                  filename = NULL))


print("Program Finished")