if (!require("BiocManager")) install.packages("BiocManager"); library(BiocManager)
if (!require("DESeq2")) BiocManager::install("DESeq2"); library(DESeq2)
if (!require("edgeR")) BiocManager::install("edgeR"); library(edgeR)
if (!require("genefilter")) BiocManager::install("genefilter"); library(genefilter)

# PC Users only, install Rtools https://cran.r-project.org/bin/windows/Rtools/

if (!require("devtools")) install.packages("devtools"); library(devtools)
if (!require("SARTools")) install_github("KField-Bucknell/SARTools", build_vignettes=TRUE, force=TRUE); library(SARTools)

################################################################################
### R script to compare several conditions with the SARTools and edgeR packages
### Hugo Varet
### November 28th, 2019
### designed to be executed with SARTools 1.7.2
################################################################################

################################################################################
###                parameters: to be modified by the user                    ###
################################################################################
rm(list=ls())                                        # remove all the objects from the R session

workDir <- "/Users/rileymcdonnell/Desktop/Biology 364/rrm020/HW 7/SARTools/SARTools.edgeR.transcripts"
projectName <- "SARTools.edgeR.transcripts"                         # name of the project
author <- "Riley McDonnell"                                # author of the statistical analysis/report

targetFile <- "../transcripts.target.txt"                           # path to the design/target file
rawDir <- "../"                                      # path to the directory containing raw counts files
featuresToRemove <- NULL

varInt <- "Treatment"                                    # factor of interest
condRef <- "Untreated"                                      # reference biological condition
batch <- NULL                                        # blocking factor: NULL (default) or "batch" for example

idColumn = 1                                         # column with feature Ids (usually 1)
countColumn = 5                                      # column with counts  (2 for htseq-count, 7 for featurecounts, 5 for RSEM/Salmon, 4 for kallisto)
rowSkip = 0                                          # rows to skip (not including header) 

alpha <- 0.05                                        # threshold of statistical significance
pAdjustMethod <- "BH"                                # p-value adjustment method: "BH" (default) or "BY"

cpmCutoff <- 1                                       # counts-per-million cut-off to filter low counts
gene.selection <- "pairwise"                         # selection of the features in MDSPlot
normalizationMethod <- "TMM"                         # normalization method: "TMM" (default), "RLE" (DESeq) or "upperquartile"

colors <- c("#f3c300", "#875692", "#f38400",         # vector of colors of each biological condition on the plots
            "#a1caf1", "#be0032", "#c2b280",
            "#848482", "#008856", "#e68fac",
            "#0067a5", "#f99379", "#604e97")

forceCairoGraph <- FALSE

################################################################################
###                             running script                               ###
################################################################################
setwd(workDir)
library(SARTools)
if (forceCairoGraph) options(bitmapType="cairo")

# checking parameters
checkParameters.edgeR(projectName=projectName,author=author,targetFile=targetFile,
                      rawDir=rawDir,featuresToRemove=featuresToRemove,varInt=varInt,
                      condRef=condRef,batch=batch,alpha=alpha,pAdjustMethod=pAdjustMethod,
                      cpmCutoff=cpmCutoff,gene.selection=gene.selection,
                      normalizationMethod=normalizationMethod,colors=colors)

# loading target file
target <- loadTargetFile(targetFile=targetFile, varInt=varInt, condRef=condRef, batch=batch)

# loading counts
# loading counts
counts <- loadCountData(target=target, rawDir=rawDir, featuresToRemove=featuresToRemove, 
                        skip=rowSkip, idColumn=idColumn, countColumn=countColumn)

# description plots
majSequences <- descriptionPlots(counts=counts, group=target[,varInt], col=colors)

# edgeR analysis
out.edgeR <- run.edgeR(counts=counts, target=target, varInt=varInt, condRef=condRef,
                       batch=batch, cpmCutoff=cpmCutoff, normalizationMethod=normalizationMethod,
                       pAdjustMethod=pAdjustMethod)

# MDS + clustering
exploreCounts(object=out.edgeR$dge, group=target[,varInt], gene.selection=gene.selection, col=colors)

# summary of the analysis (boxplots, dispersions, export table, nDiffTotal, histograms, MA plot)
summaryResults <- summarizeResults.edgeR(out.edgeR, group=target[,varInt], counts=counts, alpha=alpha, col=colors)

# save image of the R session
#save.image(file=paste0(projectName, ".RData"))

# generating HTML report
writeReport.edgeR(target=target, counts=counts, out.edgeR=out.edgeR, summaryResults=summaryResults,
                  majSequences=majSequences, workDir=workDir, projectName=projectName, author=author,
                  targetFile=targetFile, rawDir=rawDir, featuresToRemove=featuresToRemove, varInt=varInt,
                  condRef=condRef, batch=batch, alpha=alpha, pAdjustMethod=pAdjustMethod, cpmCutoff=cpmCutoff,
                  colors=colors, gene.selection=gene.selection, normalizationMethod=normalizationMethod)

