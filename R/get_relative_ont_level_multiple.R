#' Get relative ontology level for multiple HPO terms
#'
#' This calls the \code{get_relative_ont_level} function on all phenotypes in a
#' subset of the HPO. The subest chosen when creating the phenoAdj from the main
#' adjacency matrix of all phenotypes. So, the phenotypes can be found in the
#' row and column names of phenoAdj.
#'
#' @param phenoAdj A adjacency matrix of phenotypes where 1 represents i is parent of j
#' and 0 represents that i is not a parent of j. It is a subset of the main phenotype adjacency matrix
#' @param hpo The HPO ontology data object
#' @param reverse A boolean, if TRUE it will reverse the ontology level numbers so that
#' the parent terms are larger than the child terms.
#' @returns A named vector of relative ontology level, where names are HPO Ids and
#' value is relative ontology level.
#' @export
get_relative_ont_level_multiple <- function (phenoAdj,hpo,reverse=TRUE) {
  heirarchy = c()
  for (p in rownames(phenoAdj)) {
    heirarchy[p] = get_relative_ont_level(p,phenoAdj,hpo)
  }
  if (reverse) {
    heirarchy = max(heirarchy) - heirarchy
  }
  return (heirarchy)
}
