#' Add gene frequency
#'
#' Add gene-level frequency, i.e. how often mutations in a given gene
#' are associated with a given phenotype.
#' Numeric frequency columns are on a 0-100% scale.
#' @inheritParams make_phenos_dataframe
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table setnames merge.data.table :=
#' @importFrom utils data
#' @importFrom stringr str_split
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()[seq_len(1000),]
#' phenos2 <- add_gene_frequency(phenotype_to_genes = phenotype_to_genes)
add_gene_frequency <- function(phenotype_to_genes = load_phenotype_to_genes(),
                               all.x = TRUE,
                               verbose = TRUE){

  FrequencyHPO <- gene_freq_name <- gene_freq_min <- gene_freq_max <- . <-
    NULL;
  phenotype_to_genes <- add_hpo_id(phenos = phenotype_to_genes,
                                   phenotype_to_genes= phenotype_to_genes,
                                   verbose = verbose)
  # annot <- HPOExplorer::load_phenotype_to_genes("phenotype.hpoa")
  new_cols <- c("gene_freq_name","gene_freq_min",
                "gene_freq_max","gene_freq_mean")
  if(!all(new_cols %in% names(phenotype_to_genes))){
    messager("Annotating gene frequencies.",v=verbose)
    g2p <- load_phenotype_to_genes("genes_to_phenotype.txt")
    data.table::setnames(g2p,"ID","HPO_ID")
    g2p <- g2p[FrequencyHPO!="",]
    #### Parse freq data ####
    g2p[,gene_freq_name:=get_freq_dict()[g2p$FrequencyHPO]]
    g2p[,gene_freq_min:=get_freq_dict(type="min")[g2p$FrequencyHPO]]
    g2p[,gene_freq_max:=get_freq_dict(type="max")[g2p$FrequencyHPO]]
    g2p$gene_freq_mean <- rowMeans(
      g2p[,c("gene_freq_min","gene_freq_max")], na.rm = TRUE
    )
    #### Merge data ####
    phenotype_to_genes <- data.table::merge.data.table(
      x = phenotype_to_genes,
      y = g2p[,c("HPO_ID","Gene",new_cols), with=FALSE],
      by = c("HPO_ID","Gene"),
      all.x = all.x)
    #### Aggregate gene frequencies to phenotype-level ####
    # g2p_agg <- g2p[,.(gene_freq_name=paste(unique(gene_freq_name),
    #                                            collapse = "; "),
    #                   gene_freq_min=mean(gene_freq_min),
    #                   gene_freq_max=mean(gene_freq_max),
    #                   gene_freq_mean=mean(gene_freq_mean)
    #        ),
    #     by="Phenotype"]
  }
  return(phenotype_to_genes)
}
