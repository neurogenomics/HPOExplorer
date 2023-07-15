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
                      by = c("hpo_id","disease_id"),
                      gene_col = "gene_symbol",
                      all.x = FALSE,
                      allow.cartesian = FALSE,
                      verbose = TRUE){
  # devoptera::args2vars(add_genes, reassign = TRUE)

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
    phenos <- unlist_col(dt=phenos,
                         col=gene_col)
    data.table::setnames(phenos,gene_col,"gene_symbol")
    by <- unique(c(by,"gene_symbol"))
  }
  #### Ensure necessary columns are in phenos ####
  phenos <- add_hpo_id(phenos = phenos,
                       phenotype_to_genes = phenotype_to_genes,
                       hpo = hpo,
                       verbose = verbose)
  phenos <- add_disease(phenos = phenos,
                        allow.cartesian = allow.cartesian,
                        verbose = verbose)
  #### Add Gene col to data ####
  if(!"gene_symbol" %in% names(phenos)){
    by <- by[by %in% names(phenos)]
    ## Get gene annotations
    annot <- unique(
      phenotype_to_genes[,unique(c(by,"gene_symbol","ncbi_gene_id")),
                         with=FALSE]
    )
    ## Merge with input data
    phenos <- data.table::merge.data.table(phenos,
                                           annot,
                                           by = by,
                                           all.x = all.x,
                                           allow.cartesian = allow.cartesian)
  }
  return(phenos)
}
