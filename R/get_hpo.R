#' Get Human Phenotype Ontology (HPO)
#'
#' Updated version of Human Phenotype Ontology (HPO) from 2023-06-17.
#' Created from the OBO files distributed by
#' \href{https://bioportal.bioontology.org/ontologies/HP}{BioPortal}.
#' By comparison, the \code{hpo} data from \pkg{ontologyIndex} is from 2016.
#' Note that the maximum ontology level depth in the 2016 version was 14,
#' whereas in the 2023 version the maximum ontology level depth is 16
#'  (due to an expansion of the HPO).
#' @source \href{https://bioportal.bioontology.org/ontologies/HP}{BioPortal}
#' \code{
#' save_path <- file.path(tempdir(),"hpo.rds")
#' URL <- paste0(
#'   "https://data.bioontology.org/ontologies/HP/submissions/602/",
#'   "download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb"
#' )
#' tmp <- tempfile(fileext = "hpo.obo")
#' utils::download.file(URL, tmp)
#' hpo <- ontologyIndex::get_OBO(tmp, extract_tags = "everything")
#' saveRDS(hpo,save_path)
#' ### Fix non-ASCII characters in metadata ####
#' func <- function(v){
#'   Encoding(v) <- "latin1"
#'   iconv(v, "latin1", "UTF-8")
#' }
#' attributes(hpo)$version <- func(attributes(hpo)$version)
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
#' hpo <- get_hpo()
get_hpo <- function(save_dir=tools::R_user_dir("HPOExplorer",
                                               which="cache"),
                    tag = "latest",
                    overwrite = TRUE){
  #### ontologyIndex data outdated, from 2016. Don't use. ####
  # utils::data("hpo",package = "ontologyIndex")
  get_data(file = "hpo.rds",
           tag = tag,
           overwrite = overwrite,
           save_dir = save_dir)
}
