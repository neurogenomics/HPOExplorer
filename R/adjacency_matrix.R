#' Adjacency matrix
#'
#' Create adjacency matrix of HPO child-parent relationships.
#' @param terms Character vector of HPO IDs.
#' @param method Method to use to create the adjacency matrix.
#' @inheritParams make_phenos_dataframe
#' @inheritParams ontologyIndex::get_term_descendancy_matrix
#' @returns adjacency matrix
#'
#' @export
#' @importFrom ontologyIndex get_term_descendancy_matrix
#' @examples
#' terms <- get_hpo()$id[seq_len(1000)]
#' adjacency <- adjacency_matrix(terms = terms)
adjacency_matrix <- function(hpo = get_hpo(),
                             terms = unique(hpo$id),
                             method = "HPOExplorer",
                             verbose = TRUE) {

  if(is.null(terms)){
    terms <- hpo$id
  }
   messager("Creating adjacency matrix for",
            formatC(length(terms),big.mark = ","),"term(s).",
            v=verbose)
  if(tolower(method)=="ontologyindex"){
    #### ontologyIndex method ####
    ## Returns same object but not sure if it's the same in all conditions
    adjacency <- ontologyIndex::get_term_descendancy_matrix(ontology = hpo,
                                                            terms = terms) *1
  } else {
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
  }
  return(adjacency)
}
