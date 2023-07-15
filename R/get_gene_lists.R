#' Get gene list
#'
#' This function returns a vector of genes associated with a
#'  particular phenotype.
#' It uses the \code{phenotype_to_genes.txt} file from the HPO.
#'
#' @param phenotypes One or more phenotype name from the HPO
#' (e.g. "Phenotypic abnormality") \<string\>.
#' @param hpo_id_labels Label the gene lists with HPO IDs
#' (instead of phenotype names).
#' @param as_list Return as a named list instead of a data.table.
#' @inheritParams make_phenos_dataframe
#' @returns a character vector of genes associated with the selected phenotype.
#'
#' @export
#' @importFrom stats setNames
#' @examples
#' phenotypes <- c("Focal motor seizure","HP:0000002","HP:0000003")
#' gene_lists <- get_gene_lists(phenotypes = phenotypes)
get_gene_lists <- function(phenotypes,
                           phenotype_to_genes = load_phenotype_to_genes(),
                           hpo = get_hpo(),
                           as_list = FALSE,
                           hpo_id_labels = TRUE) {
  # devoptera::args2vars(get_gene_lists)
  hpo_id <- NULL;

  hpo_ids <- harmonise_phenotypes(phenotypes = phenotypes,
                                  hpo = hpo,
                                  as_hpo_ids = TRUE,
                                  verbose = TRUE)
  p2g <- phenotype_to_genes[hpo_id %in% hpo_ids]
  #### Return at data.table #####
  if(isFALSE(as_list)) return(p2g)
  #### Return as list ####
  nms <- if(isTRUE(hpo_id_labels)) unique(p2g$hpo_id) else unique(p2g$hpo_name)
  gene_lists <- lapply(stats::setNames(unique(p2g$hpo_id),
                                       nms),
                       function(pheno_i){
    unique(phenotype_to_genes[hpo_id == pheno_i]$gene_symbol)
  })
  return(gene_lists)
}
