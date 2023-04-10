#' Get Mondo Disease Ontology
#'
#' Import \href{https://mondo.monarchinitiative.org/}{Mondo} as an R object.
#' @source
#' \code{
#' save_path <- file.path(tempdir(),"mondo.rds")
#' URL <- paste0(
#' "https://data.bioontology.org/ontologies/MONDO/submissions/52/download",
#' "?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb"
#' )
#' tmp <- file.path(tempdir(),"mondo.obo")
#' utils::download.file(URL, tmp)
#' mondo <- ontologyIndex::get_OBO(file = tmp, extract_tags="everything")
#' saveRDS(mondo,save_path)
#' piggyback::pb_new_release(repo = "neurogenomics/HPOExplorer",
#'                           tag = "latest")
#' piggyback::pb_upload(file = save_path,
#'                      repo = "neurogenomics/HPOExplorer",
#'                      overwrite = TRUE,
#'                      tag = "latest")
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
  get_data(fname = "mondo.rds",
           tag = tag,
           overwrite = overwrite,
           save_dir = save_dir)
}
