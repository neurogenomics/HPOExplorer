HPOExplorer
================
<h4>
Authors: <i>Robert Gordon-Smith, Brian M. Schilder, Nathan G .Skene</i>
</h4>
<h4>
Most recent update: <i>Nov-10-2021</i>
</h4>

[![](https://img.shields.io/badge/devel%20version-0.99.1-black.svg)](https://github.com/neurogenomics/HPOExplorer)
[![R build
status](https://github.com/neurogenomics/HPOExplorer/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/neurogenomics/HPOExplorer/actions)
[![R build
status](https://github.com/neurogenomics/HPOExplorer/workflows/DockerHub/badge.svg)](https://github.com/neurogenomics/HPOExplorer/actions)
[![](https://codecov.io/gh/neurogenomics/HPOExplorer/branch/master/graph/badge.svg)](https://codecov.io/gh/neurogenomics/HPOExplorer)
[![](https://img.shields.io/github/last-commit/neurogenomics/HPOExplorer.svg)](https://github.com/neurogenomics/HPOExplorer/commits/master)
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)

## Intro

`HPOExplorer` contains useful functions for working with the [Human
Phenotype Ontology (HPO)](https://hpo.jax.org/app/). It allows you to
create interactive phenotype network plots, as well as many other useful
functions.

## Installation

Within R:

``` r
if(!"remotes" %in% rownames(install.packages())){install.packages("remotes")}

remotes::install_github("neurogenomics/HPOExplorer")
```

## [Documentation website](https://neurogenomics.github.io/HPOExplorer/)

### [Getting started](https://neurogenomics.github.io/HPOExplorer/articles/HPOExplorer.html)

A quick tutorial on how to get started with `HPOExplorer`.

### [Docker](https://neurogenomics.github.io/HPOExplorer/articles/HPOExplorer.html)

`HPOExplorer` is also available via
[DockerHub](https://hub.docker.com/repository/docker/neurogenomicslab/hpoexplorer).
Click
[here](https://neurogenomics.github.io/HPOExplorer/articles/HPOExplorer.html)
for instructions on how to create a Docker or Singularity container with
`HPOExplorer` and Rstudio pre-installed.

# Session Info

<details>

``` r
utils::sessionInfo()
```

    ## R version 4.1.0 (2021-05-18)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 20.04.2 LTS
    ## 
    ## Matrix products: default
    ## BLAS/LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.8.so
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=C             
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.1    xfun_0.28           purrr_0.3.4        
    ##  [4] colorspace_2.0-2    vctrs_0.3.8         generics_0.1.1     
    ##  [7] htmltools_0.5.2     usethis_2.1.3       yaml_2.2.1         
    ## [10] utf8_1.2.2          rlang_0.4.12        gert_1.4.2         
    ## [13] pillar_1.6.4        glue_1.5.0          DBI_1.1.1          
    ## [16] RColorBrewer_1.1-2  rvcheck_0.2.1       lifecycle_1.0.1    
    ## [19] stringr_1.4.0       dlstats_0.1.4       munsell_0.5.0      
    ## [22] gtable_0.3.0        evaluate_0.14       knitr_1.36         
    ## [25] fastmap_1.1.0       curl_4.3.2          sys_3.4            
    ## [28] fansi_0.5.0         openssl_1.4.5       scales_1.1.1       
    ## [31] BiocManager_1.30.16 desc_1.4.0          jsonlite_1.7.2     
    ## [34] fs_1.5.0            credentials_1.3.1   ggplot2_3.3.5      
    ## [37] askpass_1.1         digest_0.6.28       stringi_1.7.5      
    ## [40] gh_1.3.0            dplyr_1.0.7         grid_4.1.0         
    ## [43] rprojroot_2.0.2     cli_3.1.0           tools_4.1.0        
    ## [46] yulab.utils_0.0.4   magrittr_2.0.1      tibble_3.1.6       
    ## [49] crayon_1.4.2        pkgconfig_2.0.3     ellipsis_0.3.2     
    ## [52] assertthat_0.2.1    rmarkdown_2.11      httr_1.4.2         
    ## [55] rstudioapi_0.13     gitcreds_0.1.1      badger_0.1.0       
    ## [58] R6_2.5.1            compiler_4.1.0

</details>
<hr>
