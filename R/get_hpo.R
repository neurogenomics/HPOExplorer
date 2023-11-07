#' Get Human Phenotype Ontology (HPO)
#'
#' Updated version of Human Phenotype Ontology (HPO) from 2023-10-09.
#' Created from the OBO files distributed by the HPO project's
#' \href{https://github.com/obophenotype/human-phenotype-ontology}{GitHub}.
#'
#' By comparison, the \code{hpo} data from \pkg{ontologyIndex} is from 2016.
#' Note that the maximum ontology level depth in the 2016 version was 14,
#' whereas in the 2023 version the maximum ontology level depth is 16
#'  (due to an expansion of the HPO).
#' @source \href{https://bioportal.bioontology.org/ontologies/HP}{BioPortal}
#' \code{
#' hpo <- HPOExplorer:::make_hpo(upload_tag="latest")
#' }
#' @inheritParams get_data
#' @inheritParams piggyback::pb_download
#' @importFrom tools R_user_dir
#' @returns \link[ontologyIndex]{ontology_index} object.
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
