#' @describeIn get_ get_
#' Get Human Phenotype Ontology (HPO)
#'
#' Updated version of Human Phenotype Ontology (HPO).
#' Created from the OBO files distributed by the HPO project's
#' \href{https://github.com/obophenotype/human-phenotype-ontology}{GitHub}.
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
                    ## rols imports the international version for some reason
                    method="github",
                    save_dir=KGExplorer::cache_dir(package = "HPOExplorer"),
                    ...){

  file <- file.path(save_dir,"hp.rds")
  if(!file.exists(file) || isTRUE(force_new)){
    ont <- KGExplorer::get_ontology(name = "hp",
                                    lvl = lvl,
                                    force_new = force_new,
                                    terms = terms,
                                    method = method,
                                    save_dir = save_dir,
                                    ...)
    saveRDS(ont,file)
  } else {
    ont <- readRDS(file)
  }
  ont <- KGExplorer::filter_ontology(ont = ont,
                                     terms = terms)
  return(ont)
}
