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
#' @inheritParams make_phenos_dataframe
#' @returns The HPO ID of phenotype \<string\>
#'
#' @export
#' @examples
#' pheno_abnormality_id <- get_hpo_id_direct("Phenotypic abnormality")
get_hpo_id_direct <- function(phenotype,
                              hpo = get_hpo()) {
    return(hpo$id[which(phenotype == hpo$name)])
}
