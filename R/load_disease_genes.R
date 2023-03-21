#' Load disease genes
#'
#' Load gene lists associated with each disease phenotype from:
#' \itemize{
#' \item{DECIPHER}
#' \item{ORPHANET}
#' \item{OMIM}
#' }
#' @param verbose Print messages.
#' @returns data.table
#'
#' @export
#' @importFrom data.table := rbindlist
#' @examples
#' dat <- load_disease_genes()
load_disease_genes <- function(verbose=TRUE){
  # devoptera::args2vars(load_disease_genes)

  #### Import data ####
  decipher <- load_decipher_genes(verbose = verbose)
  orphanet <- load_orphanet_genes(verbose = verbose)
  omim <- load_omim_genes(verbose = verbose)
  #### Merge data ####
  nms <- c("DiseaseID","DiseaseName_og","Gene")
  dgenes <- list(
    DECIPHER=decipher[,c("ID","disease_name","gene_symbol")] |> `names<-`(nms),
    ORPHANET=orphanet[,c("Orphanet_ID","phenotype","gene")] |> `names<-`(nms),
    OMIMG=omim[,c("OMIMID","Disease","GeneSym")] |> `names<-`(nms)
  ) |> data.table::rbindlist(fill = TRUE,use.names = TRUE, idcol = "Database")
  return(dgenes)
}
