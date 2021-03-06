# Installation instructions:
# 1. Install DEBrowser and its dependencies by running the lines below
# in R or RStudio.

if (!requireNamespace("BiocManager", quietly=TRUE))
  install.packages("BiocManager")
BiocManager::install("debrowser")

# 2. Load the library

library(debrowser)

# 3. Prepare data for DEBrowser

if (!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)

### Now repeat all of that for the transcript files
getwd()
transcriptfilelist <- list.files(pattern="*abundance.tsv", full.names=T, recursive= TRUE)
transcriptfiles <- lapply(transcriptfilelist, read_tsv)
transcriptfilenames <- list.files(pattern="*abundance.tsv", full.names=F, recursive=TRUE)

samplenames <- gsub("SRP100701/kallisto/", "", transcriptfilenames)
samplenames <- gsub("SRP100701/kallisto/","", samplenames)
samplenames <- gsub(".abundance.tsv", "", samplenames)
samplenames <- gsub("-","_", samplenames) # DEBrowser doesn't like -
samplenames <- trimws(samplenames)
samplenames

transcriptfiles %>%
  bind_cols() %>%
  dplyr::select(target_id, starts_with("est_counts")) -> transcripttable
colnames(transcripttable)[2:13] <- as.list(samplenames)

head(transcripttable)
str(transcripttable)
write_tsv(transcripttable, path="transcripttable.tsv")
transcripttable

transcripts_target <- read_delim("hypothalamus_only.tsv", 
                                 "\t", escape_double = FALSE, trim_ws = TRUE)
transcripts_target
colnames(transcripttable) <- gsub("-","_", colnames(transcripttable))
colnames(transcripttable)
transcripts_target$Sample_Name_s[1:12] <- colnames(transcripttable)[2:13]
metadata <- dplyr::select(transcripts_target, c(Sample_Name_s, treatment_s, gender_s))
colnames(metadata) <- c("sample","treatment","gender")
write_tsv(metadata, path="Finalmetadata.tsv")

# 4. Start DEBrowser

# To use the annotations for drosophila
if (!require("org.Dm.eg.db")) BiocManager::install("org.Dm.eg.db"); library(org.Dm.eg.db)

startDEBrowser()

# 5. Data Exploration with DE Browser

#1 Load the Count Data File and the Metadata File
#2 Filter the data using CPM, CPM<1, in at least 3 samples (half of the samples)
#3 Batch correct the data using TMM normalization, Combat correction method, condition as Treatment, batch as Batch
#4 Visualize the PCA plot by changing Color field to "condition", and Shape field to "batch"
#5 Go to DE Analysis and Add New Comparison
#   Leave the Condition 1 samples as the RNAi group and the Condition 2 samples the Untreated group
#   Chose the appropriate DE Method, and leave the parameters on the default settings
#   Go to Main Plots and explore the MA and Volcano plots

# 6. Confirm that RNAi experiment worked 

# 6a. If you have gene results:
#1 Load in the gene results and metadata
#2 Filter and batch correct as above
#3 Run the appropriate DE Analysis 
#4 Go to the Tables and sort by log10padjust search for FBgn0261552 - this is the *pasilla* gene

# 6b. If you have transcript results:
#1 Load in the gene results and metadata
#2 Filter and batch correct as above
#3 Run the appropriate DE Analysis 
#4 Go to the Tables and sort by log10padjust search for FBtr0073426 - this is one of the *Ant2* transcripts that shows differential expression
