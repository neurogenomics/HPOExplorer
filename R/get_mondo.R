#' Get Mondo Disease Ontology
#'
#' Import \href{https://mondo.monarchinitiative.org/}{Mondo} as an R object.
#' @source
#' \code{
#' mondo <- HPOExplorer:::make_ontology(file="mondo-base.obo",
#'                        repo="monarch-initiative/mondo",
#'                        upload_tag="latest")
#' }
#' @inheritParams get_data
#' @inheritParams piggyback::pb_download
#' @importFrom tools R_user_dir
#' @returns \link[ontologyIndex]{ontology_index}
#'
#' @export
#' @examples
#' mondo <- get_mondo()
get_mondo <- function(save_dir=tools::R_user_dir("HPOExplorer",
                                                 which="cache"),
                      tag = "latest",
                      overwrite = TRUE){
  #### ontoProc data outdated, from 2021 Don't use. ####
  # mondo <- ontoProc::getMondoOnto()
  get_data(file = "mondo-base.rds",
           tag = tag,
           overwrite = overwrite,
           save_dir = save_dir)
}
