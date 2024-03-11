#' @describeIn add_ add_
#' Add HPO ID column to dataframe
#'
#' Adds the HPO term ID column "hpo_id".
#' @inheritParams KGExplorer::map_ontology_terms
#' @export
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()
#' phenos <- unique(phenotype_to_genes[,c("hpo_id","hpo_name")])
#' phenos2 <- add_hpo_id(phenos=phenos)
add_hpo_id <- function(phenos,
                       hpo = get_hpo(),
                       ignore_case = TRUE) {
  if(!"hpo_id" %in% names(phenos)){
    phenos$hpo_id <- map_phenotypes(hpo = hpo,
                                    ignore_case = ignore_case,
                                    terms = phenos$hpo_name,
                                    to = "id")
  }
  return(phenos)
}

