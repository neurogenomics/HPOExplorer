HPOExplorer
================
[![](https://img.shields.io/badge/devel%20version-0.99.2-black.svg)](https://github.com/neurogenomics/HPOExplorer)
[![R build
status](https://github.com/neurogenomics/HPOExplorer/workflows/rworkflows/badge.svg)](https://github.com/neurogenomics/HPOExplorer/actions)
[![](https://img.shields.io/github/last-commit/neurogenomics/HPOExplorer.svg)](https://github.com/neurogenomics/HPOExplorer/commits/master)
[![](https://img.shields.io/github/languages/code-size/neurogenomics/HPOExplorer.svg)](https://github.com/neurogenomics/HPOExplorer)
[![](https://codecov.io/gh/neurogenomics/HPOExplorer/branch/master/graph/badge.svg)](https://codecov.io/gh/neurogenomics/HPOExplorer)
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
¶ <h4> ¶ Authors: <i>Robert Gordon-Smith, Brian Schilder, Nathan
Skene</i> ¶ </h4>
<h4> ¶ Most recent update: <i>Jan-17-2023</i> ¶ </h4>

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
    ##  [1] BiocManager_1.30.19 compiler_4.2.1      pillar_1.8.1       
    ##  [4] RColorBrewer_1.1-3  yulab.utils_0.0.6   tools_4.2.1        
    ##  [7] digest_0.6.31       jsonlite_1.8.4      evaluate_0.19      
    ## [10] lifecycle_1.0.3     tibble_3.1.8        gtable_0.3.1       
    ## [13] pkgconfig_2.0.3     rlang_1.0.6         cli_3.6.0          
    ## [16] DBI_1.1.3           rstudioapi_0.14     rvcheck_0.2.1      
    ## [19] yaml_2.3.6          xfun_0.36           fastmap_1.1.0      
    ## [22] stringr_1.5.0       dplyr_1.0.10        knitr_1.41         
    ## [25] desc_1.4.2          generics_0.1.3      vctrs_0.5.1        
    ## [28] dlstats_0.1.6       rprojroot_2.0.3     grid_4.2.1         
    ## [31] tidyselect_1.2.0    here_1.0.1          glue_1.6.2         
    ## [34] R6_2.5.1            fansi_1.0.3         rmarkdown_2.19     
    ## [37] ggplot2_3.4.0       badger_0.2.2        magrittr_2.0.3     
    ## [40] scales_1.2.1        htmltools_0.5.4     rworkflows_0.99.5  
    ## [43] assertthat_0.2.1    colorspace_2.0-3    utf8_1.2.2         
    ## [46] stringi_1.7.12      munsell_0.5.0

</details>
<hr>
