#' @describeIn filter_ filter_
#' Filter descendants
#'
#' Subset a \code{phenos} data.table to only
#' descendants of an ancestor HPO ID term.
#' @param ancestor Phenotype names (or HPO ID) of an ancestor in the
#'  \href{https://hpo.jax.org/}{Human Phenotype Ontology}.
#'  Only phenotypes that are descendants of this ancestor will be kept.
#'  Set to \code{NULL} (default) to skip this filtering step.
#' @returns data.table of phenotypes, with additional columns:
#' "ancestor", "ancestor_id"
#'
#' @export
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenos2 <- filter_descendants(phenos = phenos,
#'                               ancestor = "Motor delay")
filter_descendants <- function(phenos,
                               ancestor = NULL,
                               hpo = get_hpo()){

  hpo_id <- NULL;

  if(!is.null(ancestor)){
    messager("Subsetting phenotypes to only ancestors of:",
             paste(ancestor,collapse = ","))
    ancestor_id <- map_phenotypes(terms = ancestor,
                                  hpo = hpo,
                                  to="id")
    all_ids <- simona::dag_offspring(dag = hpo,
                                     term=ancestor_id,
                                     include_self = TRUE )
    phenos <- phenos[hpo_id %in% all_ids,
    ][,ancestor:=ancestor][,ancestor_id:=ancestor_id]
    messager(formatC(nrow(phenos),big.mark = ","),
             "associations remain after filtering.")
  }
  return(phenos)
}
