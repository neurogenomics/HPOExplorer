#' Add prevalence
#'
#' Add a column containing the prevalence score for each disease ("disease_id")
#'  or phenotype ("hpo_id").
#' @param method One of "orphanet" or "oard".
#' @param id_col Name of the column containing the disease or phenotype IDs.
#' @param drop_na Whether to drop rows with missing prevalence data.
#' @inheritParams make_network_object
#' @returns phenos data.table with extra column
#'
#' @export
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_prevalence(phenos = phenos)
add_prevalence <- function(phenos,
                           id_col="disease_id",
                           drop_na=TRUE,
                           verbose=TRUE,
                           method="orphanet"){

  #### From OARD ####
  # res <- add_prevalence_oard(phenos$hpo_id[1:100])
  #### From ORPHANET ####
  if(method=="orphanet"){
    phenos2 <- add_prevalence_orphanet(phenos=phenos,
                                       id_col=id_col,
                                       drop_na=drop_na,
                                       verbose=verbose)
  }
  return(phenos2)
}
