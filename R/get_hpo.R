#' Get Human Phenotype Ontology (HPO)
#'
#' Import the HPO as an R object.
#' See \link[HPOExplorer]{hpo} for details.
#' @inheritParams utils::data
#' @returns Ontology
#' @export
#' @examples
#' hpo <- get_hpo()
get_hpo <- function(package=c("HPOExplorer",
                              "ontologyIndex")){
  utils::data("hpo",package = package[[1]])
  hpo <- get("hpo")
  return(hpo)
}
