#' Get HPO ID from phenotype name
#'
#' I have done this more efficiently elsewhere using the HPO data object.
#' May be worth replacing, or just add the HPO Id to all data points
#' in the results permanently.
#' @param phenotype Phenotype name from the HPO \<string\>
#' @inheritParams make_phenos_dataframe
#' @returns The HPO Id \<string\>
#'
#' @export
#' @examples
#' genedata <- load_phenotype_to_genes()
#' phenotype <- "Phenotypic abnormality"
#' pheno_abnorm_id <- get_hpo_id(phenotype, genedata)
get_hpo_id <- function(phenotype,
                       phenotype_to_genes = load_phenotype_to_genes()) {
    return(phenotype_to_genes$ID[phenotype_to_genes$Phenotype == phenotype][1])
}
