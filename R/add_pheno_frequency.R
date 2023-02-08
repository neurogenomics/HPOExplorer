#' Add phenotype frequency
#'
#' Add phenotype-level frequency, i.e.
#' how often a phenotype occurs in a given disease.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table merge.data.table :=
#' @importFrom utils data
#' @importFrom stringr str_split
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_pheno_frequency(phenos = phenos)
add_pheno_frequency <- function(phenos,
                                all.x = TRUE,
                                verbose = TRUE){

  pheno_freq_min <- pheno_freq_max <- pheno_freq_mean <- NULL
  # annot <- HPOExplorer::load_phenotype_to_genes("phenotype.hpoa")
  new_cols <- c("pheno_freq_min","pheno_freq_max","pheno_freq_mean")
  if(!all(new_cols %in% names(phenos))){
    messager("Annotating phenotype frequencies.",v=verbose)
    #### Get precomputed phenotype-disease frequencies ####
    utils::data("hpo_frequency", package = "HPOExplorer")
    hpo_frequency <- get("hpo_frequency")
    freq_agg <- hpo_frequency[,list(
      pheno_freq_min=min(pheno_freq_min, na.rm = TRUE),
      pheno_freq_max=max(pheno_freq_max, na.rm = TRUE),
      pheno_freq_mean=mean(pheno_freq_mean, na.rm = TRUE)),
      by="HPO_ID"]
    #### Merge data ####
    phenos <- data.table::merge.data.table(
      x = phenos,
      y = freq_agg,
      all.x = all.x,
      by = "HPO_ID")
  }
  return(phenos)
}
