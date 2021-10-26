#' Adjacency matrix
#'
#' Create adjacency matrix of HPO child-parent relationships
#'
#' It may be possible to use a hash table for ggnetwork, which may be more
#' efficent than the matrix in a shiny app ?
#'
#' @param pheno_ids a character vector of HPO Ids
#' @param hpo ontology object (available in ontologyIndex package)
#' @param as_dataframe can return matrix or df <bool>
#' @examples
#' \dontrun{
#' pheno_ids <- c("HP:000001","HP:000002")
#' adjacency_matrix(pheno_ids,hpo,as_dataframe=FALSE)
#' }
#' @returns adjacency matrix
#' @export
adjacency_matrix <- function(pheno_ids,
                             hpo, as_dataframe = FALSE) {
  message("adjacency_matrix")
  HPO_id = unique(pheno_ids)
  size = length(HPO_id)
  adjacency = data.frame(matrix(nrow = size, ncol = size))
  rownames(adjacency) = HPO_id
  colnames(adjacency) = HPO_id
  adjacency[is.na(adjacency)] = 0
  for (id in HPO_id) {
    children = hpo$children[id][[1]]
    adjacency[id, children] = 1
  }
  if (as_dataframe) {
    return(adjacency[HPO_id,HPO_id])
  } else {
    return(as.matrix(adjacency[HPO_id,HPO_id]))
  }

}
