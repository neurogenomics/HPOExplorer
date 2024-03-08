<img src='https://github.com/neurogenomics/HPOExplorer/raw/master/inst/hex/hex.png' title='Hex sticker for HPOExplorer' height='300'><br>
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
[![](https://img.shields.io/badge/devel%20version-1.0.0-black.svg)](https://github.com/neurogenomics/HPOExplorer)
[![](https://img.shields.io/github/languages/code-size/neurogenomics/HPOExplorer.svg)](https://github.com/neurogenomics/HPOExplorer)
[![](https://img.shields.io/github/last-commit/neurogenomics/HPOExplorer.svg)](https://github.com/neurogenomics/HPOExplorer/commits/master)
<br> [![R build
status](https://github.com/neurogenomics/HPOExplorer/workflows/rworkflows/badge.svg)](https://github.com/neurogenomics/HPOExplorer/actions)
[![](https://codecov.io/gh/neurogenomics/HPOExplorer/branch/master/graph/badge.svg)](https://app.codecov.io/gh/neurogenomics/HPOExplorer)
<br>
<a href='https://app.codecov.io/gh/neurogenomics/HPOExplorer/tree/master' target='_blank'><img src='https://codecov.io/gh/neurogenomics/HPOExplorer/branch/master/graphs/icicle.svg' title='Codecov icicle graph' width='200' height='50' style='vertical-align: top;'></a>  
<h4>  
Authors: <i>Brian Schilder, Robert Gordon-Smith, Nathan Skene</i>  
</h4>
<h4>  
Most recent update: <i>Mar-08-2024</i>  
</h4>

## Intro

### About HPO

The [Human Phenotype Ontology (HPO)](https://hpo.jax.org/app/) is a
controlled vocabulary of phenotypic abnormalities encountered in human
disease. It currently contains over 18,000 hierarchically organised
terms. Each term in the HPO describes a phenotypic abnormality, ranging
from very broad phenotypes (e.g. “Abnormality of the nervous system”)
down to extremely specific phenotypes (e.g. “Decreased CSF
5-hydroxyindolacetic acid concentration”).

The HPO is currently being used in thousands of exome and genome
sequencing projects around the world to aid in the interpretation of
human variation, in clinical practice to support differential diagnosis
and to annotate patient information, and in research to understand the
role of rare variants in human health and disease. The HPO was developed
by the [Monarch Initiative](https://monarchinitiative.org/) in
collaboration with [The Jackson Laboratory](https://www.jax.org/).

### About `HPOExplorer`

`HPOExplorer` is an R package with extensive functions for easily
importing, annotating, filtering, and visualising the [Human Phenotype
Ontology (HPO)](https://hpo.jax.org/app/) at the disease, phenotype, and
gene levels. By pulling fresh data directly from official resources like
[HPO](https://hpo.jax.org/app/),
[Monarch](https://monarchinitiative.org/) and
[GenCC](https://thegencc.org/), it ensures tightly controlled version
coordination with the most up-to-date data available at any given time
(with the option to use caching to boost speed). Furthermore, it can
efficiently reorganise gene annotations into sparse matrices for usage
within downstream statistical and machine learning analysis.

`HPOExplorer` was developed by the [Neurogenomics
Lab](https://www.neurogenomics.co.uk/) at Imperial College London, along
with valuable feedback provided by the HPO team. This package is still
actively evolving and growing. Community engagement is welcome and any
suggestions can be submitted as an
[Issue](https://github.com/neurogenomics/HPOExplorer/issues) or [Pull
Request](https://github.com/neurogenomics/HPOExplorer/pulls).

## Installation

Within R:

``` r
if(!require("BiocManager")) install.packages("BiocManager")

BiocManager::install("neurogenomics/HPOExplorer")
library(HPOExplorer)
```

## [Documentation website](https://neurogenomics.github.io/HPOExplorer/)

### [Getting started](https://neurogenomics.github.io/HPOExplorer/articles/HPOExplorer.html)

A quick tutorial on how to get started with `HPOExplorer`.

### [Docker](https://neurogenomics.github.io/HPOExplorer/articles/docker.html)

`HPOExplorer` is also available via
[DockerHub](https://hub.docker.com/repository/docker/neurogenomicslab/hpoexplorer).
Click
[here](https://neurogenomics.github.io/HPOExplorer/articles/docker.html)
for instructions on how to create a Docker or Singularity container with
`HPOExplorer` and Rstudio pre-installed.

# Citation

If you use `HPOExplorer`, please cite:

<!-- Modify this by editing the file: inst/CITATION  -->

> Kitty B. Murphy, Robert Gordon-Smith, Jai Chapman, Momoko Otani, Brian
> M. Schilder, Nathan G. Skene (2023) Identification of cell
> type-specific gene targets underlying thousands of rare diseases and
> subtraits. medRxiv, <https://doi.org/10.1101/2023.02.13.23285820>

# Session Info

<details>

``` r
utils::sessionInfo()
```

    ## R version 4.3.1 (2023-06-16)
    ## Platform: aarch64-apple-darwin20 (64-bit)
    ## Running under: macOS Sonoma 14.3.1
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRblas.0.dylib 
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.11.0
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## time zone: Europe/London
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] gtable_0.3.4        jsonlite_1.8.8      renv_1.0.3         
    ##  [4] dplyr_1.1.4         compiler_4.3.1      BiocManager_1.30.22
    ##  [7] tidyselect_1.2.0    rvcheck_0.2.1       scales_1.3.0       
    ## [10] yaml_2.3.8          fastmap_1.1.1       here_1.0.1         
    ## [13] ggplot2_3.4.4       R6_2.5.1            generics_0.1.3     
    ## [16] knitr_1.45          yulab.utils_0.1.4   tibble_3.2.1       
    ## [19] desc_1.4.3          dlstats_0.1.7       rprojroot_2.0.4    
    ## [22] munsell_0.5.0       pillar_1.9.0        RColorBrewer_1.1-3 
    ## [25] rlang_1.1.3         utf8_1.2.4          cachem_1.0.8       
    ## [28] badger_0.2.3        xfun_0.42           fs_1.6.3           
    ## [31] memoise_2.0.1.9000  cli_3.6.2           magrittr_2.0.3     
    ## [34] rworkflows_1.0.1    digest_0.6.34       grid_4.3.1         
    ## [37] rstudioapi_0.15.0   lifecycle_1.0.4     vctrs_0.6.5        
    ## [40] data.table_1.15.0   evaluate_0.23       glue_1.7.0         
    ## [43] fansi_1.0.6         colorspace_2.1-0    rmarkdown_2.25     
    ## [46] tools_4.3.1         pkgconfig_2.0.3     htmltools_0.5.7

</details>
<hr>
