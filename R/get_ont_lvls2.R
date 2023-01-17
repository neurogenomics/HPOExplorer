#' Get relative ontology level for multiple HPO terms
#'
#' This calls the \code{get_ont_lvl} function on all phenotypes in a
#' subset of the HPO. The subset chosen when creating the adjacency from the main
#' adjacency matrix of all phenotypes. So, the phenotypes can be found in the
#' row and column names of adjacency.
#' @param reverse A boolean, if TRUE it will reverse the ontology
#' level numbers so that
#' the parent terms are larger than the child terms.
#' @param absolute Make the levels absolute in the sense that they consider
#'  the entire HPO ontology (\code{TRUE}).
#'  Otherwise, levels will be relative to only the subset \code{terms} provided
#'   (\code{FALSE}).
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @inheritParams adjacency_matrix
#' @returns A named vector of relative ontology level,
#' where names are HPO Ids and
#' value is relative ontology level.
#'
#' @export
#' @importFrom stats setNames
#' @examples
#' terms <- ontologyIndex::get_descendants(ontology = get_hpo(),
#'                                         roots = "HP:0000002")
#' lvls <- get_ont_lvls2(terms = terms)
get_ont_lvls2 <- function(terms,
                          hpo = get_hpo(),
                          adjacency =
                            adjacency_matrix(terms = terms,
                                             hpo = hpo),
                          absolute = FALSE,
                          reverse = TRUE,
                          verbose = TRUE) {

  messager("Getting ontology level for",
           formatC(length(terms),big.mark = ","),"HPO IDs.", v=verbose)
  # if(isTRUE(absolute)){
  #   adjacency <- adjacency_matrix(hpo = hpo,
  #                                 verbose = verbose)
  # }



  # if (isTRUE(reverse)) {
  #   hierarchy <- max(hierarchy) - hierarchy
  # }
  # return(hierarchy)
}
