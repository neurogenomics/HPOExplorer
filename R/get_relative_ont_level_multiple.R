#' Get relative ontology level for multiple HPO terms
#'
#' This calls the \code{get_relative_ont_level} function on all phenotypes in a
#' subset of the HPO. The subest chosen when creating the adjacency from the main
#' adjacency matrix of all phenotypes. So, the phenotypes can be found in the
#' row and column names of adjacency.
#'
#' @param adjacency A adjacency matrix of phenotypes where 1 represents
#' i is parent of j
#' and 0 represents that i is not a parent of j. It is a subset of
#' the main phenotype adjacency matrix
#' @param reverse A boolean, if TRUE it will reverse the ontology
#' level numbers so that
#' the parent terms are larger than the child terms.
#' @inheritParams make_phenos_dataframe
#' @returns A named vector of relative ontology level,
#' where names are HPO Ids and
#' value is relative ontology level.
#'
#' @export
#' @examples
#' pheno_ids <- c("HP:000001", "HP:000002")
#' adjacency <- adjacency_matrix(pheno_ids)
#' rel_ont_lvls <- get_relative_ont_level_multiple(adjacency)
get_relative_ont_level_multiple <- function(adjacency,
                                            hpo = get_hpo(),
                                            reverse = TRUE) {
    hierarchy <- c()
    for (p in rownames(adjacency)) {
        hierarchy[p] <- get_relative_ont_level(phenotype = p,
                                               adjacency = adjacency,
                                               hpo = hpo)
    }
    if (isTRUE(reverse)) {
        hierarchy <- max(hierarchy) - hierarchy
    }
    names(hierarchy) <- rownames(adjacency)
    return(hierarchy)
}
