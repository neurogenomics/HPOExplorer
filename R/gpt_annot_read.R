gpt_annot_read <- function(path,
                           verbose=TRUE){
  pheno_count <- phenotype <- hpo_id <- NULL;

  d <- data.table::fread(path)
  #### Check phenotype names ####
  annot <- load_phenotype_to_genes(verbose = verbose)
  d <- merge(d,
             unique(annot[,c("hpo_id","hpo_name")]),
             by.x="phenotype",
             by.y="hpo_name")
  d <- data.frame(d)
  d[d==""] <- NA
  d <- data.table::data.table(d)
  d[,pheno_count:=table(d$phenotype)[phenotype]]

  #### Ensure no phenos are missing HPO IDs ####
  messager(length(unique(d[is.na(hpo_id)]$phenotype)),
           "phenotypes do not have matching HPO IDs.",v=verbose)
  # phenotype_miss_rate <-
  #   length(d$phenotype[!d$phenotype %in% annot$hpo_name]) /
  #   length(d$phenotype)
  return(d)
}
