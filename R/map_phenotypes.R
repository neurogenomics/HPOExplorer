#' @describeIn map_ map_
#' Harmonise phenotypes
#'
#' Harmonise a mixed vector of phenotype names (e.g. "Focal motor seizure")
#' and HPO IDs (e.g. c("HP:0000002","HP:0000003")).
#' @returns Character vector
#'
#' @export
#' @import KGExplorer
#' @examples
#' terms <- c("Focal motor seizure","HP:0000002","HP:0000003")
#' #### As phenotype names ####
#' term_names <- map_phenotypes(terms=terms)
#' #### As HPO IDs ####
#' term_ids <- map_phenotypes(terms=terms, to="id")
map_phenotypes <- function(terms,
                           hpo = get_hpo(),
                           to=c("name","id"),
                           keep_order = TRUE,
                           invert = FALSE){
  KGExplorer::map_ontology_terms(terms = terms,
                                 ont = hpo,
                                 to = to,
                                 keep_order = keep_order,
                                 invert = invert)
}
