#' Get Human Phenotype Ontology (HPO)
#'
#' Import the HPO as an R object.
#' @returns Ontology
#' @export
#' @examples
#' hpo <- get_hpo()
get_hpo <- function(){
  utils::data("hpo",package = "ontologyIndex")
  return(get("hpo"))
}
