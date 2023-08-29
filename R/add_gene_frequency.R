#' Add gene frequency
#'
#' Add gene-level frequency, i.e. how often mutations in a given gene
#' are associated with a given phenotype.
#' Numeric frequency columns are on a 0-100% scale.
#' @param gene_frequency_threshold Only keep genes with frequency
#'  above the set threshold. Frequency ranges from 0-100 where 100 is
#'  a gene that occurs 100% of the time in a given phenotype.
#'  Include \code{NA} if you wish to retain genes that
#'  do not have any frequency data.
#'  See \link[HPOExplorer]{add_gene_frequency} for details.
#' @inheritParams make_phenos_dataframe
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table setnames merge.data.table :=
#' @importFrom utils data
#' @importFrom stringr str_split
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()[seq(1000),]
#' phenos2 <- add_gene_frequency(phenotype_to_genes = phenotype_to_genes)
add_gene_frequency <- function(phenotype_to_genes = load_phenotype_to_genes(),
                               gene_frequency_threshold = NULL,
                               all.x = TRUE,
                               verbose = TRUE){

  # devoptera::args2vars(add_gene_frequency)
  # annot <- HPOExplorer::load_phenotype_to_genes("phenotype.hpoa")
  frequency <- gene_freq_name <- gene_freq_mean <-
    gene_freq_min <- gene_freq_max <- . <- NULL;

  phenotype_to_genes <- add_hpo_id(phenos = phenotype_to_genes,
                                   phenotype_to_genes= phenotype_to_genes,
                                   verbose = verbose)
  new_cols <- c("gene_freq_name","gene_freq_min",
                "gene_freq_max","gene_freq_mean")
  if(!all(new_cols %in% names(phenotype_to_genes))){
    messager("Annotating gene frequencies.",v=verbose)
    g2p <- load_phenotype_to_genes("genes_to_phenotype.txt")
    g2p <- g2p[!frequency %in% c("","-"),]
    #### Merge data ####
    phenotype_to_genes <- data.table::merge.data.table(
      x = phenotype_to_genes,
      y = g2p[,c("hpo_id","gene_symbol","frequency"),with=FALSE],
      by = c("hpo_id","gene_symbol"),
      all.x = all.x)
    #### Parse freq data ####
    phenotype_to_genes[,gene_freq_name:=mapply(frequency,FUN=function(f){
      if(grepl("HP:",f)) get_freq_dict()[f] else f })]
    phenotype_to_genes[,gene_freq_min:=mapply(frequency,FUN=parse_frequency,
                                              type="min")]
    phenotype_to_genes[,gene_freq_max:=mapply(frequency,FUN=parse_frequency,
                                              type="max")]
    phenotype_to_genes$gene_freq_mean <- rowMeans(
      phenotype_to_genes[,c("gene_freq_min","gene_freq_max")], na.rm = TRUE
    )
    data.table::setnames(phenotype_to_genes,"frequency","gene_freq")
    #### Aggregate gene frequencies to phenotype-level ####
    # g2p_agg <- g2p[,.(gene_freq_name=paste(unique(gene_freq_name),
    #                                            collapse = "; "),
    #                   gene_freq_min=mean(gene_freq_min),
    #                   gene_freq_max=mean(gene_freq_max),
    #                   gene_freq_mean=mean(gene_freq_mean)
    #        ),
    #     by="hpo_name"]
  }
  #### Filter ####
  if(!is.null(gene_frequency_threshold)){
    if(any(is.na(gene_frequency_threshold))){
      phenotype_to_genes <- phenotype_to_genes[
        gene_freq_mean>=min(gene_frequency_threshold,na.rm = TRUE) |
          is.na(gene_freq_mean),]
    } else{
      phenotype_to_genes <- phenotype_to_genes[gene_freq_mean>=
                               min(gene_frequency_threshold,na.rm = TRUE),]
    }
  }
  return(phenotype_to_genes)
}
