#' Get relative ont level (for terms in a connected component of HPO subset)
#'
#' When plotting subsets of the HPO data as a
#'  network plot, there is often more than
#' one connected component to be plotted
#'  (i.e. sections of the graph are not connected
#' by any edges). To map the ontology level to the size of nodes
#'  (such that high up terms
#' are bigger than low level terms). This was made to find the relative ontology
#' level with respect to other terms in its connected component so that
#' each connected section
#' of the plot would have the same size for its root node.
#' It would also be possible to just use absolute ontology level,
#' so that "Phenotypic abnormality" would always be the largest datapoint etc.
#'
#' @param phenotype HPO term Id \<string\>
#' @param adjacency A adjacency matrix (produced by the adjacency_matrix function)
#' @param hpo The HPO ontology data object
#' @returns A integer representing the relative ontology level of a term within
#' a connected component of a subset of the HPO.
#'
#' @export
#' @examples
#' pheno_ids <- c("HP:000001", "HP:000002")
#' adjacency <- adjacency_matrix(pheno_ids)
#' rel_ont_lvls <- get_relative_ont_level(phenotype="HP:000002",
#'                                        adjacency = adjacency)
get_relative_ont_level <- function(phenotype,
                                   adjacency,
                                   hpo = get_hpo()) {

    pos_parents <- hpo$parents[phenotype]
    phenotypes <- rownames(adjacency)
    paths <- list()
    for (p in phenotypes) {
        if (adjacency[p, phenotype] == 1) {
            if (p %in% pos_parents) {
                paths[p] <- 1 + get_relative_ont_level(phenotype = p,
                                                       adjacency =  adjacency,
                                                       hpo = hpo) # <- recursion
            }
        }
    }
    if (length(paths) == 0) {
        return(0)
    } else {
        parents <- 0
        for (i in seq(length(paths))) {
            if (paths[[i]] > parents) {
                parents <- paths[[i]]
            }
        }
    }
    return(parents)
}
