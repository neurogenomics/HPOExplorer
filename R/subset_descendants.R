#' Subset descendants
#'
#' Subset a \code{phenos} datatable to only
#' descendants of an ancestor HPO ID term.
#' @param ancestor Phenotype names (or HPO ID) of an ancestor in the
#'  \href{https://hpo.jax.org/}{Human Phenotype Ontology}.
#'  Only phenotypes that are descendants of this ancestor will be kept.
#'  Set to \code{NULL} (default) to skip this filtering step.
#' @inheritParams make_phenos_dataframe
#' @inheritParams harmonise_phenotypes
#' @returns data.table of phenotypes, with additional columns:
#' "ancestor", "ancestor_id"
#'
#' @export
#' @importFrom ontologyIndex get_descendants
#' @importFrom data.table :=
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenos2 <- subset_descendants(phenos = phenos,
#'                               ancestor = "Motor delay")
subset_descendants <- function(phenos,
                               ancestor = NULL,
                               hpo = get_hpo(),
                               ignore_case = TRUE,
                               verbose = TRUE){

  if(!is.null(ancestor)){
    messager("Subsetting phenotypes to only ancestors of:",
             paste(ancestor,collapse = ","),v=verbose)
    ancestor_id <- harmonise_phenotypes(phenotypes = ancestor,
                                        hpo = hpo,
                                        as_hpo_ids = TRUE,
                                        ignore_case = ignore_case)
    all_ids <- ontologyIndex::get_descendants(ontology = hpo,
                                              roots = ancestor_id,
                                              exclude_roots = FALSE)
    phenos <- phenos[HPO_ID %in% all_ids,
    ][,ancestor:=ancestor][,ancestor_id:=ancestor_id]
    messager(formatC(nrow(phenos),big.mark = ","),
             "associations remain after filtering.",v=verbose)
  }
  return(phenos)
}
