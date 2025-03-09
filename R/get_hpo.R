#' @describeIn get_ get_
#' Get Human Phenotype Ontology (HPO)
#'
#' Downloads and imports the "v2024-02-08" release of the
#'  Human Phenotype Ontology (HPO) for the purposes of version control and
#'  consistency of results. To get the latest version of the HPO,
#'  use \code{get_hpo(tag="release", force_new=T)}
#' The HPO objects are created from the OBO files distributed via
#' the official
#' \href{https://github.com/obophenotype/human-phenotype-ontology}{
#' HPO GitHub repository}.
#'
#' By comparison, the \code{hpo} data from \pkg{ontologyIndex} is from 2016.
#' Note that the maximum ontology level depth in the 2016 version was 14,
#' whereas in the 2023 version the maximum ontology level depth is 16
#'  (due to an expansion of the HPO).
#' @inheritParams KGExplorer::get_ontology
#' @inheritDotParams KGExplorer::get_ontology
#' @returns \link[simona]{ontology_DAG} object.
#'
#' @export
#' @import KGExplorer
#' @examples
#' hpo <- get_hpo()
get_hpo <- function(lvl = 2,
                    force_new = FALSE,
                    terms=NULL,
                    tag = "v2024-02-08",
                    method="github",
                    save_dir=KGExplorer::cache_dir(),
                    ...){

  file <- file.path(save_dir,"hp.rds")
  if(!file.exists(file) || isTRUE(force_new)){
    ont <- KGExplorer::get_ontology(name = "hp",
                                    lvl = lvl,
                                    force_new = force_new,
                                    terms = terms,
                                    method = method,
                                    save_dir = save_dir,
                                    tag = tag,
                                    ...)
    saveRDS(ont,file)
  } else {
    ont <- readRDS(file)
  }
  ont <- KGExplorer::filter_ontology(ont = ont,
                                     terms = terms)
  return(ont)
}
