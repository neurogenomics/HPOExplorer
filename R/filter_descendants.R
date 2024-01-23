#' @describeIn filter_ filter_
#' Filter descendants
#'
#' Subset a \code{phenos} data.table to only
#' descendants of an ancestor HPO ID term.
#' @returns data.table of phenotypes, with additional columns:
#' "ancestor", "ancestor_id"
#'
#' @export
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenos2 <- filter_descendants(phenos = phenos,
#'                               keep_descendants = "Motor delay")
filter_descendants <- function(phenos,
                               keep_descendants = NULL,
                               remove_descendants = NULL,
                               hpo = get_hpo()){
  hpo_id <- NULL;
  hpo2 <- KGExplorer::filter_ontology(
    ont = hpo,
    keep_descendants = keep_descendants,
    remove_descendants = remove_descendants)
  phenos <- phenos[hpo_id %in% hpo2@terms,]
  messager(formatC(nrow(phenos),big.mark = ","),
           "associations remain after filtering.")
  return(phenos)
}
