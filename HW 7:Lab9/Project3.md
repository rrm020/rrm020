Project 3
================
Transcriptomics Noob
6 Apr 2020

## Project 3

### Objectives:

1.  Perform a differential expression analysis pipeline for RNASeq
2.  Understand the differences between read mapping and pseudoalignment
3.  Compare different analysis options for measuring differential
    expression
4.  Use an R vignette to closely examine an RNASeq analysis pipeline
5.  Collaborate as a large group to compare 12 different analysis
    pipelines

### Tasks:

  - [ ] Complete the [Galaxy Tutorial](1-Galaxy.md) using Salmon
    pseudoalignment
  - [ ] Complete the [SARTools Tutorial](2-SARTools.md) using DESeq2
    differential expression analysis
  - [ ] Repeat the SARTools analysis incorporating batch correction
  - [ ] Compare the results of the SARTools analysis at the gene and
    transcript level
  - [ ] Complete a different analysis pipeline and compare the results
    using [DE Browser](DEBrowser/DEBrowser.R)
  - [ ] Collaborate to complete a report comparing the results from all
    analysis pipelines

### Pipelines:

kallisto-\>DESeq2 kallisto-\>edgeR kallisto-\>limma Sailfish-\>DESeq2 1
1 1 1 Sailfish-\>edgeR Sailfish-\>limma Salmon-\>DESeq2 Salmon-\>edgeR 1
1 1 1 Salmon-\>limma STAR-\>DESeq2 STAR-\>edgeR STAR-\>limma 1 1 1 1

| Name             | Github.Username  | Email.Address          | Pipeline          |
| :--------------- | :--------------- | :--------------------- | :---------------- |
| Riley McDonnell  | rrm020           | <rrm020@bucknell.edu>  | kallisto-\>DESeq2 |
| Nellie Heitzman  | Nellie001        | <nskh001@bucknell.edu> | Salmon-\>limma    |
| Owen LaFramboise | olaframboise     | <oll001@bucknell.edu>  | kallisto-\>edgeR  |
| Rob Han          | roberthjhan      | <rhh026@bucknell.edu>  | Sailfish-\>DESeq2 |
| Go Ogata         | go001            | <go001@bucknell.edu>   | STAR-\>limma      |
| Will Snyder      | wsnyder4         | <wes021@bucknell.edu>  | STAR-\>edgeR      |
| Leila Hashemi    | ly94-bot         | <lh046@bucknell.edu>   | Sailfish-\>limma  |
| Alyssa Peeples   | apeeples13       | <amp030@bucknell.edu>  | Salmon-\>DESeq2   |
| Fallon Goldberg  | fallongoldberg   | <feg003@bucknell.edu>  | kallisto-\>limma  |
| Brenna Prevelige | brp006           | <brp006@bucknell.edu>  | Sailfish-\>edgeR  |
| Savannah Weaver  | science-with-sav | <sjw018@bucknell.edu>  | STAR-\>DESeq2     |
| Alicia Kim       | ak039            | <ak039@bucknell.edu>   | Salmon-\>edgeR    |

### Notes on mapping pipelines

#### RNA STAR

Input: Drosophila\_melanogaster.BDGP6.dna.toplevel.fa.gz and
Drosophila\_melanogaster.BDGP6.95.chr.gtf.gz Setting: `Count number of
reads per gene` to “Yes” Output: “reads per gene” (BAM file can be
deleted) FBgn tsv

#### Kallisto

Run Kallisto quant

Input: Drosophila\_melanogaster.BDGP6.cdna.all.fa.gz Output: FBtr tsv

#### Salmon

Input: Drosophila\_melanogaster.BDGP6.cdna.all.fa.gz and
Drosophila\_melanogaster.BDGP6.95.chr.gtf.gz Output: FBtr tsv and FBgn
tsv

#### Sailfish

Input: Drosophila\_melanogaster.BDGP6.cdna.all.fa.gz and
Drosophila\_melanogaster.BDGP6.95.chr.gtf.gz Output: FBtr tsv and FBgn
tsv

### Preparing results for DEBrowser

After you download the tsv file(s) from Galaxy, you will need to
reformat it so that it matches what is expected by DEBrowser and
metadata.tsv Do not use Excel or a text editor to alter the file - use
dplyr\!

Load in your tsv file(s) and use `dplyr::select()` and/or `rename()` to
make sure that you have the correct data. Then save the data using
`write_tsv()`

``` r
metadata <- read_tsv("DEBrowser/metadata.tsv", trim_ws = TRUE)
```

    ## Parsed with column specification:
    ## cols(
    ##   sample = col_character(),
    ##   batch = col_character(),
    ##   condition = col_character()
    ## )

``` r
print(metadata)
```

    ## # A tibble: 6 x 3
    ##   sample      batch  condition
    ##   <chr>       <chr>  <chr>    
    ## 1 Untreated_1 Single Untreated
    ## 2 Untreated_3 Paired Untreated
    ## 3 Untreated_4 Paired Untreated
    ## 4 RNAi_1      Single RNAi     
    ## 5 RNAi_3      Paired RNAi     
    ## 6 RNAi_4      Paired RNAi

### Running DEBrowser

<https://debrowser.readthedocs.io/en/master/index.html>

Use the [DEBrowser.R](DEBRowser/DEBrowser.R) script to load the
DEBrowser library and launch the Shiny app. You should probably click
the Open in Browser button so that you can run DEBrowser in a web
browser.

1.  Load in your results and the metadata file.

If you have trouble loading in your results, double-check that every
column in your tsv is an exact match for the samples listed in the
metadata.tsv file: Name RNAi\_1 RNAi\_3 RNAi\_4 Untreated\_1
Untreated\_3 Untreated\_4

2.  Filter the counts.

Select “CPM”, “\<1”, and “3” to filter out any transcripts/genes with
fewer than 1 CPM in at least 3 samples.

3.  Batch Effect Correction

Select “TMM” for normalization, “Combat” for Correction Method,
“condition” for Treatment, and “batch” for Batch.

Check the PCA plots to verify that the batch correction was successful.

4.  DE Analysis

Select New Comparison and verify that the three RNAi samples are
“Condition 1” and the untreated samples are “Condition 2”.

For DE Method choose DESeq2, EdgeR, or Limma, depending on your assigned
pipeline. (Note that DEBrowser makes it easy to run all three, if you
want.) Leave the settings for the DE Method as the default and make note
of them for the future.

Read about the DE Analysis results from DEBrowser:
<https://debrowser.readthedocs.io/en/master/deseq/deseq.html>

*Change the “padj value cut off” to 0.05 and leave “foldChange” set to
2.*

Click “Download” to save a csv file of the differentially expressed
genes/transcripts. This file will be used to complete the Group Project.
It should be named using the following convention:

Mapper.DEmethod.Features.csv

Mapper should equal kallisto, Salmon, Sailfish, or STAR. DEmethod should
equal DESeq2, edgeR, or limma. Features should equal genes or
transcripts.

5.  Explore the results

Use DEBrowser to look at the MA and Volcano plots of your results.
Explore the expression of the following genes/transcripts:

Pasilla

sesB/Ant2

bmm

dre4

Are the results that you see consistent with those reported in Figure 3
of the paper?
<https://genome.cshlp.org/content/21/2/193/F3.expansion.html>

## Acknowledgements

<https://cgatoxford.wordpress.com/2016/08/17/why-you-should-stop-using-featurecounts-htseq-or-cufflinks2-and-start-using-kallisto-salmon-or-sailfish/>

<https://f1000research.com/articles/4-1521/v2>
