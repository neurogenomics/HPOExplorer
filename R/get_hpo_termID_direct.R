#' Get HPO term ID direct
#'
#' This is similar to the \code{get_hpo_germID} function except it does not take
#' the ID from the phenotype_to_genes dataframe.
#' It directly retrieves it from the HPO
#' ontology object (found in the ontologyIndex package \code{data(hpo)}). This
#' allows you to get the ID of terms that do not have gene annotations.
#'
#' Why not always use this? I have found that occasionally it doesn't work.
#'  Also, it requires you to load the full HPO object to get an ID,
#'  which is wasteful if you are only using the gene annotations.
#'
#' @param phenotype The phenotype of interest \<string\>
#' @param hpo The HPO object from ontologyIndex package \<list\>
#' @returns The HPO ID of phenotype \<string\>
#' @export
get_hpo_termID_direct <- function(hpo,
                                  phenotype = "Phenotypic abnormality") {
    return(hpo$id[which(phenotype == hpo$name)])
}
