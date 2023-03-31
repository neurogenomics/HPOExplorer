<img src='https://github.com/neurogenomics/HPOExplorer/raw/master/inst/hex/hex.png' title='Hex sticker for HPOExplorer' height='300'><br>
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
[![](https://img.shields.io/badge/devel%20version-0.99.7-black.svg)](https://github.com/neurogenomics/HPOExplorer)
[![](https://img.shields.io/github/languages/code-size/neurogenomics/HPOExplorer.svg)](https://github.com/neurogenomics/HPOExplorer)
[![](https://img.shields.io/github/last-commit/neurogenomics/HPOExplorer.svg)](https://github.com/neurogenomics/HPOExplorer/commits/master)
<br> [![R build
status](https://github.com/neurogenomics/HPOExplorer/workflows/rworkflows/badge.svg)](https://github.com/neurogenomics/HPOExplorer/actions)
[![](https://codecov.io/gh/neurogenomics/HPOExplorer/branch/master/graph/badge.svg)](https://codecov.io/gh/neurogenomics/HPOExplorer)
<br>
<a href='https://app.codecov.io/gh/neurogenomics/HPOExplorer/tree/master' target='_blank'><img src='https://codecov.io/gh/neurogenomics/HPOExplorer/branch/master/graphs/icicle.svg' title='Codecov icicle graph' width='200' height='50' style='vertical-align: top;'></a>  
<h4>  
Authors: <i>Brian Schilder, Robert Gordon-Smith, Nathan Skene</i>  
</h4>
<h4>  
Most recent update: <i>Mar-31-2023</i>  
</h4>

## Intro

`HPOExplorer` contains useful functions for working with the [Human
Phenotype Ontology (HPO)](https://hpo.jax.org/app/). It allows you to
create interactive phenotype network plots, as well as many other useful
functions.

## Installation

Within R:

``` r
if (!require("remotes")) install.packages("remotes")
if (!require("HPOExplorer")) remotes::install_github("neurogenomics/HPOExplorer")

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

    ## R version 4.2.1 (2022-06-23)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Big Sur ... 10.16
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] here_1.0.1          rprojroot_2.0.3     digest_0.6.31      
    ##  [4] utf8_1.2.3          BiocFileCache_2.6.1 R6_2.5.1           
    ##  [7] stats4_4.2.1        RSQLite_2.3.0       evaluate_0.20      
    ## [10] httr_1.4.5          ggplot2_3.4.1       pillar_1.9.0       
    ## [13] yulab.utils_0.0.6   rworkflows_0.99.8   biocViews_1.66.3   
    ## [16] rlang_1.1.0         curl_5.0.0          data.table_1.14.8  
    ## [19] rstudioapi_0.14     whisker_0.4.1       blob_1.2.4         
    ## [22] DT_0.27             RUnit_0.4.32        rmarkdown_2.20.1   
    ## [25] desc_1.4.2          readr_2.1.4         stringr_1.5.0      
    ## [28] htmlwidgets_1.6.2   dlstats_0.1.6       BiocPkgTools_1.16.1
    ## [31] igraph_1.4.1        RCurl_1.98-1.10     bit_4.0.5          
    ## [34] munsell_0.5.0       compiler_4.2.1      xfun_0.37          
    ## [37] pkgconfig_2.0.3     BiocGenerics_0.44.0 rorcid_0.7.0       
    ## [40] htmltools_0.5.4     tidyselect_1.2.0    tibble_3.2.1       
    ## [43] httpcode_0.3.0      XML_3.99-0.14       fansi_1.0.4        
    ## [46] dplyr_1.1.1         tzdb_0.3.0          dbplyr_2.3.2       
    ## [49] bitops_1.0-7        rappdirs_0.3.3      crul_1.3           
    ## [52] grid_4.2.1          RBGL_1.74.0         jsonlite_1.8.4     
    ## [55] gtable_0.3.3        lifecycle_1.0.3     DBI_1.1.3          
    ## [58] magrittr_2.0.3      scales_1.2.1        graph_1.76.0       
    ## [61] cli_3.6.0           stringi_1.7.12      cachem_1.0.7       
    ## [64] renv_0.17.2         fauxpas_0.5.0       xml2_1.3.3         
    ## [67] rvcheck_0.2.1       filelock_1.0.2      generics_0.1.3     
    ## [70] vctrs_0.6.1         gh_1.4.0            RColorBrewer_1.1-3 
    ## [73] tools_4.2.1         bit64_4.0.5         Biobase_2.58.0     
    ## [76] glue_1.6.2          hms_1.1.3           fastmap_1.1.1      
    ## [79] yaml_2.3.7          colorspace_2.1-0    BiocManager_1.30.20
    ## [82] rvest_1.0.3         memoise_2.0.1       badger_0.2.3       
    ## [85] knitr_1.42

</details>
<hr>
