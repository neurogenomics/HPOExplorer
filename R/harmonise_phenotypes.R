#' Harmonise phenotypes
#'
#' Harmonise a mixed vector of phenotype names (e.g. "Focal motor seizure")
#' and HPO IDs (e.g. c("HP:0000002","HP:0000003")).
#' @param phenotypes A character vector of phenotype names and/or HPO IDs.
#' @param as_hpo_ids Return all \code{phenotypes} as HPO IDs (\code{TRUE}),
#' or phenotype names (\code{FALSE}).
#' @param ignore_case Ignore casing when searching for matches.
#' @param keep_order Return a named list of the same length and order
#' as \code{phenotypes}.
#' If \code{FALSE}, return a named list of only the unique \code{phenotypes},
#' sometimes in a different order.
#' @param validate Remove any phenotype names or IDs that cannot be found in the
#' \code{hpo}.
#' @param invert Invert the keys/values of the dictionary,
#' such that the key becomes the values (and vice versa).
#' @param verbose Print messages.
#' @inheritParams make_phenos_dataframe
#' @returns Character vector
#'
#' @export
#' @importFrom stats setNames
#' @examples
#' phenotypes <- c("Focal motor seizure","HP:0000002","HP:0000003")
#' #### As phenotype names ####
#' pheno_names <- harmonise_phenotypes(phenotypes=phenotypes)
#' #### As HPO IDs ####
#' pheno_ids <- harmonise_phenotypes(phenotypes=phenotypes, as_hpo_ids=TRUE)
harmonise_phenotypes <- function(phenotypes,
                                 hpo = get_hpo(),
                                 as_hpo_ids = FALSE,
                                 validate = TRUE,
                                 ignore_case = TRUE,
                                 keep_order = TRUE,
                                 invert = FALSE,
                                 verbose = TRUE){

  # templateR:::args2vars(harmonise_phenotypes)
  phenotypes_og <- phenotypes
  phenotypes <- unique(phenotypes)
  hpo_ids <- grep("^HP:|^HP_",phenotypes,
                  value = TRUE,
                  ignore.case = ignore_case)
  ptypes <- phenotypes[!phenotypes %in% hpo_ids]
  #### Validate phenotypes ####
  if(isTRUE(as_hpo_ids)){
    messager("Translating all phenotypes to HPO IDs.",v=verbose)
    out <- stats::setNames(hpo_ids,hpo_ids)
    if(length(ptypes)>0) {
      id_dict <- stats::setNames(names(hpo$name),
                                 unname(hpo$name))
      out <- c(out,id_dict[ptypes])
    }
    if(isTRUE(validate)){
      out <- out[out %in% unname(hpo$id)]
    }
  } else {
    messager("Translating all phenotypes to names.",v=verbose)
    out <- stats::setNames(ptypes,ptypes)
    if(length(hpo_ids)>0){
      out <- c(out, hpo$name[hpo_ids])
    }
    if(isTRUE(validate)){
      out <- out[out %in% unname(hpo$name)]
    }
  }
  #### Return ####
  if(isFALSE(keep_order)){
    messager("+ Returning a dictionary of phenotypes",
             "(different order as input).",
             v=verbose)
  } else {
    messager("+ Returning a vector of phenotypes",
             "(same order as input).",
             v=verbose)
    out <- out[phenotypes_og]
  }
  #### Invert ####
  if(isTRUE(invert)){
    out <- stats::setNames(names(out), unname(out))
  }
  return(out)
}
