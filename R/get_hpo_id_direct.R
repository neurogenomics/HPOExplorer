#' Get HPO term ID direct
#'
#' Directly retrieves it from the HPO
#' ontology object (found in the \pkg{ontologyIndex} package \code{data(hpo)}).
#' @param phenotype One or more phenotype names in to get HPO IDs for.
#' @inheritParams make_phenos_dataframe
#' @returns The HPO ID(s) of phenotype(s)
#'
#' @export
#' @examples
#' phenotype = "Phenotypic abnormality"
#' pheno_abnormality_id <- get_hpo_id_direct(phenotype = phenotype)
get_hpo_id_direct <- function(phenotype,
                              hpo = get_hpo()) {
    return(hpo$id[which(phenotype == hpo$name)])
}
