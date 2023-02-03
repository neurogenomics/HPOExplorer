#' Add ancestor
#'
#' Assign each HPO ID to the higher-order ancestral term that it is part of.
#' @param lvl How many levels deep into the ontology to get ancestors from.
#' For example:
#' \itemize{
#' \item{1:}{"All"}
#' \item{2:}{"Phenotypic abnormality"}
#' \item{3:}{"Abnormality of the nervous system"}
#' \item{4:}{"Abnormality of nervous system physiology"}
#' \item{5:}{"Neurodevelopmental abnormality" or "Behavioral abnormality"}
#' }
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenos2 <- add_ancestor(phenos = phenos, lvl=5)
add_ancestor <- function(phenos,
                         lvl = 3,
                         hpo = get_hpo(),
                         verbose=TRUE){

  if("HPO_ID" %in% names(phenos)){
    messager(paste0("Adding level-"),lvl," ancestor to each HPO ID.",v=verbose)
    phenos$ancestor <- unlist(lapply(hpo$ancestors[phenos$HPO_ID],
                                     function(x){x[lvl]}))
    phenos$ancestor_name <- hpo$name[phenos$ancestor]

  } else {
    messager("HPO_ID column not found. Cannot add ancestors.",v=verbose)
  }
  return(phenos)
}
