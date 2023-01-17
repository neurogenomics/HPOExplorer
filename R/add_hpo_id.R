#' Add HPO term ID column to dataframe
#'
#' This adds the HPO term id column to the subest of ewce results data
#' to be plotted
#' in the cell select app. It also checks if it is a valid HPO term id to
#' prevent error and adds
#' a boolean column where TRUE if term is valid. If the HPO Id is not correct,
#' it caused an error in the ontologyPlot package.
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @returns The subset of EWCE results dataframe with a HPO Id column added.
#'
#' @export
#' @importFrom data.table := setkeyv
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()
#' phenos <- unique(phenotype_to_genes[,c("ID","Phenotype")])
#' phenos2 <- add_hpo_id(phenos=phenos)
add_hpo_id <- function(phenos,
                       phenotype_to_genes =
                           HPOExplorer::load_phenotype_to_genes(),
                       hpo = HPOExplorer::get_hpo()) {
  HPO_term_valid <- HPO_ID <- NULL;

  if(!all(c("HPO_ID","HPO_term_valid") %in% names(phenos))){
    pheno_dict <- unique(phenotype_to_genes[,c("ID","Phenotype")])
    data.table::setkeyv(pheno_dict,"Phenotype")
    phenos$HPO_ID <- pheno_dict[phenos$Phenotype,]$ID
    phenos[,HPO_term_valid:=(HPO_ID %in% hpo$id)]
  }
  return(phenos)
}

