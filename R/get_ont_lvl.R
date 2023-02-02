#' Get HPO term level
#'
#' In this function, ontology level refers to the number of generations of
#' sub-phenotypes a term has below it in the HPO DAG. For example, the root of
#' the HPO is term "HP:0000001", the longest path to a term with no child terms
#' is 14. In other words there are 14 generations of "is-a" relationships below
#' HP:0000001 and it is therefore at ontology level 14. A term with no
#' sub-phenotypes below it (a leaf node), is at ontology level 0.
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @inheritParams adjacency_matrix
#' @returns Ontology level of HPO ID.
#'
#' @keywords internal
#' @source
#' \code{
#' lvl_absolute <- get_ont_lvl(term = "HP:0000001", absolute=TRUE)
#' lvl_relative <- get_ont_lvl(term = "HP:0000001", absolute=FALSE)
#' }
get_ont_lvl <- function(term,
                        hpo = get_hpo(),
                        adjacency = NULL,
                        absolute = TRUE,
                        verbose = FALSE) {

  messager("Getting ontology level for:", paste(term,collapse = ", "),
           v=verbose)
  #### Children method ####
  if(isTRUE(absolute)){
    children <- unique(
      setdiff(unlist(hpo$children[term]),
              term)
    )
    if (length(children) == 0) {
      return(0)
    } else {
      return(1 + get_ont_lvl(term = children,
                             hpo = hpo,
                             absolute = absolute,
                             verbose = verbose)) #<- recursion..
    }
  } else {
    #### Parents method ####
    if(is.null(adjacency)){
      stp <- "Must supply adjacency when absolute=FALSE."
      stop(stp)
    }
    phenotypes <- rownames(adjacency)
    pos_parents <- hpo$parents[term]
    paths <- lapply(phenotypes, function(p){
      if (adjacency[p, term] == 1) {
        if (p %in% pos_parents) {
          1 + get_ont_lvl(term = p,
                          adjacency =  adjacency,
                          absolute = absolute,
                          hpo = hpo) # <- recursion
        }
      }
    }) |> unlist()
    #### Check count ####
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
}
