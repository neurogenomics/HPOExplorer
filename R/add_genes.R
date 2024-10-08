#' @describeIn add_ add_
#' Add genes
#'
#' Add genes associated with each phenotype
#' (in the context of a particular disease).
#' @param gene_col Name of the gene column.
#' @inheritParams make_network_object
#' @inheritParams make_phenos_dataframe
#' @inheritParams data.table::merge.data.table
#'
#' @export
#' @import data.table
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_genes(phenos = phenos)
add_genes <- function(phenos = NULL,
                      phenotype_to_genes =
                        load_phenotype_to_genes(),
                      hpo = get_hpo(),
                      by = c("hpo_id","hpo_name",
                             "disease_id","disease_name","disease_description"),
                      gene_col = "gene_symbol",
                      all.x = FALSE,
                      allow.cartesian = FALSE){
  #### Prepare gene data ####
  phenotype_to_genes <- data.table::copy(phenotype_to_genes)
  data.table::setnames(phenotype_to_genes,"disease_id","disease_id",
                       skip_absent = TRUE)
  #### Prepare phenotypes data ####
  if(is.character(phenos)){
    phenos <- data.table::data.table(hpo_id=names(phenos),
                                     hpo_name=unname(phenos))
  } else if(is.null(phenos)){
    phenos <- unique(phenotype_to_genes[,c("hpo_id","hpo_name")])
  }
  #### Unlist intersection column ####
  ## Genes driving celltype-symptom enrichment.
  if(!is.null(gene_col) &&
     gene_col %in% names(phenos)){
    phenos <- unlist_col(dat=phenos,
                         col=gene_col)
    data.table::setnames(phenos,gene_col,"gene_symbol")
    by <- unique(c(by,"gene_symbol"))
  }
  #### Ensure necessary columns are in phenos ####
  phenos <- add_hpo_id(phenos = phenos,
                       hpo = hpo)
  #### Add Gene col to data ####
  if(!"gene_symbol" %in% names(phenos)){
    messager("Adding genes and disease IDs.")
    by <- by[by %in% names(phenos)]
    # ## Merge with input data
    phenos <- data.table::merge.data.table(phenos,
                                           phenotype_to_genes,
                                           by = by,
                                           all.x = all.x,
                                           allow.cartesian = allow.cartesian)
  }
  return(phenos)
}
