#' Harmonise phenotypes
#'
#' Harmonise a mixed vector of phenotype names (e.g. "Focal motor seizure")
#' and HPO IDs (e.g. c("HP:0000002","HP:0000003")).
#' @inheritParams map_
#' @inheritParams KGExplorer::map_ontology_terms
#' @returns Character vector
#'
#' @export
#' @import KGExplorer
#' @examples
#' terms <- c("Focal motor seizure",
#'             "Focal MotoR SEIzure",
#'             "HP:0000002","HP:0000003")
#' #### As phenotype names ####
#' term_names <- map_phenotypes(terms=terms)
#' #### As HPO IDs ####
#' term_ids <- map_phenotypes(terms=terms, to="id")
map_phenotypes <- function(terms,
                           hpo = get_hpo(),
                           to=c("name","id"),
                           keep_order = TRUE,
                           ignore_case = TRUE,
                           ignore_char = eval(formals(
                               KGExplorer::map_ontology_terms
                               )$ignore_char),
                           invert = FALSE){
  to <- match.arg(to)
  KGExplorer::map_ontology_terms(terms = terms,
                                 ont = hpo,
                                 to = to,
                                 keep_order = keep_order,
                                 ignore_case = ignore_case,
                                 ignore_char = ignore_char,
                                 invert = invert)
}
