#' Adjacency matrix
#'
#' Create adjacency matrix of HPO child-parent relationships.
#' @param terms Character vector of HPO IDs.
#' @inheritParams make_phenos_dataframe
#' @inheritParams ontologyIndex::get_term_descendancy_matrix
#' @returns adjacency matrix
#'
#' @export
#' @importFrom ontologyIndex get_term_descendancy_matrix
#' @examples
#' adjacency <- adjacency_matrix(terms = c("HP:0000001", "HP:0000002"))
adjacency_matrix <- function(hpo = get_hpo(),
                             terms = unique(hpo$id),
                             verbose = TRUE) {

   messager("Creating adjacency matrix for",
            formatC(length(terms),big.mark = ","),"terms.",
            v=verbose)
  #### Custom script #####
  terms <- unique(terms)
  terms <- terms[terms %in% hpo$id]
  if(length(terms)==0) stop("0 valid HPO IDs (terms) provided.")
  size <- length(terms)
  adjacency <- matrix(nrow = size,
                      ncol = size,
                      dimnames = list(terms, terms))
  adjacency[is.na(adjacency)] <- 0
  for (id in terms) {
    children <- hpo$children[[id]]
    children <- children[children %in% terms]
    if(length(children)>0){
      adjacency[id, children] <- 1
    }
  }
  #### ontologyIndex method ####
  ## Returns same object but not sure if it's the same in all conditions
  # adjacency <- ontologyIndex::get_term_descendancy_matrix(ontology = hpo,
  #                                                         terms = terms) *1
  return(adjacency)
}
