#' Get HPO term ontology level
#'
#' In this function, ontology level refers to the number of generations of
#' sub-phenotypes a term has below it in the HPO DAG. For example, the root of
#' the HPO is term "HP:0000001", the longest path to a term with no child terms
#' is 14. In other words there are 14 generations of "is-a" relationships below
#' HP:0000001 and it is therefore at ontology level 14. A term with no
#' sub-phenotypes below it (a leaf node), is at ontology level 0.
#'
#' Typically this function should be used to get the level of a single term,
#' but you can supply a vector of multiple terms and it will return the level of
#' the highest level term in that vector.
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @inheritParams adjacency_matrix
#' @returns Ontology level of HPO ID.
#'
#' @keywords internal
#' @source
#' \code{
#' lvl <- get_ontvl(term = "HP:0000001")
#' }
get_ont_lvl <- function(term,
                        hpo = get_hpo(),
                        adjacency,
                        verbose = FALSE) {
  messager("Getting ontology level for:", paste(term,collapse = ", "),
           v=verbose)
  #### Children method ####
  # children <- unique(
  #   setdiff(unlist(hpo$children[term]),
  #           term)
  # )
  # if (length(children) == 0) {
  #   return(0)
  # } else {
  #   return(1 + get_ont_lvl(term = children,
  #                          hpo = hpo,
  #                          verbose = verbose)) #<- recursion..
  # }

  #### Parents method ####
  pos_parents <- hpo$parents[term]
  phenotypes <- rownames(adjacency)
  paths <- list()
  for (p in phenotypes) {
    if (adjacency[p, term] == 1) {
      if (p %in% pos_parents) {
        paths[p] <- 1 + get_ont_lvl(term = p,
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
