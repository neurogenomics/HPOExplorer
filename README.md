HPOExplorer
================
<h4>
Authors: <i>Bobby Gordon-Smith, Brian M. Schilder, Nathan G .Skene</i>
</h4>
<h4>
Most recent update: <i>Nov-10-2021</i>
</h4>

[![](https://img.shields.io/badge/devel%20version-0.99.0-black.svg)](https://github.com/neurogenomics/HPOExplorer)
[![R build
status](https://github.com/neurogenomics/HPOExplorer/workflows/R-CMD-check/badge.svg)](https://github.com/neurogenomics/HPOExplorer/actions)
[![](https://codecov.io/gh/neurogenomics/HPOExplorer/branch/master/graph/badge.svg)](https://codecov.io/gh/neurogenomics/HPOExplorer)
[![](https://img.shields.io/github/last-commit/neurogenomics/HPOExplorer.svg)](https://github.com/neurogenomics/HPOExplorer/commits/master)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://cran.r-project.org/web/licenses/MIT)

## Intro

This package contains useful functions for working with the [Human
Phenotype Ontology (HPO)](https://hpo.jax.org/app/). It allows you to
create interactive phenotype network plots, as well as many other useful
functions.

## Documentation

Visit the package site for a tutorial and docs for functions.  
[`HPOExplorer` site](https://neurogenomics.github.io/HPOExplorer/)

## Installation

``` r
if(!"remotes" %in% rownames(install.packages())){install.packages("remotes")}

remotes::install_github("neurogenomics/HPOExplorer")
```

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
    ##  [1] BiocManager_1.30.16 pillar_1.6.2        compiler_4.1.0     
    ##  [4] RColorBrewer_1.1-2  sys_3.4             tools_4.1.0        
    ##  [7] digest_0.6.27       jsonlite_1.7.2      evaluate_0.14      
    ## [10] lifecycle_1.0.0     tibble_3.1.6        gtable_0.3.0       
    ## [13] pkgconfig_2.0.3     rlang_0.4.11        rstudioapi_0.13    
    ## [16] cli_3.0.1           DBI_1.1.1           rvcheck_0.1.8      
    ## [19] yaml_2.2.1          xfun_0.25           stringr_1.4.0      
    ## [22] dplyr_1.0.7         knitr_1.33          askpass_1.1        
    ## [25] fs_1.5.0            desc_1.3.0          generics_0.1.0     
    ## [28] vctrs_0.3.8         dlstats_0.1.4       gert_1.3.2         
    ## [31] rprojroot_2.0.2     grid_4.1.0          tidyselect_1.1.1   
    ## [34] glue_1.4.2          R6_2.5.1            fansi_0.5.0        
    ## [37] rmarkdown_2.10      ggplot2_3.3.5       purrr_0.3.4        
    ## [40] badger_0.1.0        magrittr_2.0.1      credentials_1.3.1  
    ## [43] usethis_2.0.1       scales_1.1.1        ellipsis_0.3.2     
    ## [46] htmltools_0.5.1.1   assertthat_0.2.1    colorspace_2.0-2   
    ## [49] utf8_1.2.2          stringi_1.7.5       openssl_1.4.4      
    ## [52] munsell_0.5.0       crayon_1.4.1

</details>
<hr>
