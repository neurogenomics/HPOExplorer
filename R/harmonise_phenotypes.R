#' Harmonise phenotypes
#'
#' Harmonise a mixed vector of phenotype names (e.g. "Focal motor seizures")
#' and HPO IDs (e.g. c("HP:0000002","HP:0000003")).
#' @param phenotypes A character vector of phenotype names and/or HPO IDs.
#' @param as_hpo_ids Return all \code{phenotypes} as HPO IDs (\code{TRUE}),
#' or phenotype names (\code{FALSE}).
#' @param ignore_case Ignore casing when searching for matches.
#' @inheritParams make_phenos_dataframe
#' @returns Character vector
#'
#' @export
#' @importFrom stats setNames
#' @examples
#' phenotypes <- c("Focal motor seizures","HP:0000002","HP:0000003")
#' #### As phenotype names ####
#' pheno_names <- harmonise_phenotypes(phenotypes=phenotypes)
#' #### As HPO IDs ####
#' pheno_ids <- harmonise_phenotypes(phenotypes=phenotypes, as_hpo_ids=TRUE)
harmonise_phenotypes <- function(phenotypes,
                                 hpo = get_hpo(),
                                 as_hpo_ids = FALSE,
                                 ignore_case = TRUE){

  hpo_ids <- grep("^HP:|^HP_",phenotypes,
                  value = TRUE, ignore.case = ignore_case)
  #### Validate phenotypes ####
  if(isTRUE(as_hpo_ids)){
    ptypes <- phenotypes[!phenotypes %in% hpo_ids]
    if(length(ptypes)>0) {
      id_dict <- stats::setNames(names(hpo$name),
                                 unname(hpo$name))
      input_ids <- phenotypes[!phenotypes %in% ptypes]
      hpo_ids <- c(stats::setNames(input_ids,input_ids),
                   id_dict[ptypes])
    }
    hpo_ids <- hpo_ids[hpo_ids %in% unname(hpo$id)]
    return(hpo_ids)
  } else {
    if(length(hpo_ids)>0) {
      phenotypes <- c(phenotypes[!phenotypes %in% hpo_ids],
                      unname(hpo$name[hpo_ids]))
    }
    phenotypes <- phenotypes[phenotypes %in% unname(hpo$name)]
    return(phenotypes)
  }
}
