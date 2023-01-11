#' Get gene list
#'
#' This function returns a vector of genes associated with a
#'  particular phenotype.
#' It uses the \code{phenotype_to_genes.txt} file from the HPO.
#'
#' @param phenotype A phenotype (name) from the HPO
#' (e.g. "Phenotypic abnormality") \<string\>.
#' @param phenotype_to_genes The phenotype_to_genes.txt file from HPO that
#' contains gene annotations for HPO phenotypes.
#' @returns a character vector of genes associated with the selected phenotype.
#'
#' @export
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()
#' # Creating a list of gene lists indexed by phenotype name
#' GeneLists <- list()
#' Phenotypes <- unique(phenotype_to_genes$Phenotype[1:5])
#' for (p in Phenotypes) {
#'     GeneLists[[p]] <- get_gene_list(p, phenotype_to_genes)
#' }
get_gene_list <- function(phenotype,
                          phenotype_to_genes) {
    return(phenotype_to_genes$Gene[phenotype_to_genes$Phenotype == phenotype])
}
