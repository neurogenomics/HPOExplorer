#' @describeIn get_ get_
#' Get HPO term ID direct
#'
#' Directly retrieves it from the HPO
#' ontology object.
#' @returns The HPO ID(s) of phenotype(s)
#'
#' @export
#' @examples
#' term = "Phenotypic abnormality"
#' pheno_abnormality_id <- get_hpo_id_direct(term = term)
get_hpo_id_direct <- function(term,
                              hpo = get_hpo()) {
    return(hpo@terms[which(term == hpo@elementMetadata$name)])
}
