#' Add phenotype frequency
#'
#' Add phenotype-level frequency, i.e.
#' how often a phenotype occurs in a given disease.
#' @param pheno_frequency_threshold Only keep phenotypes with frequency
#'  above the set threshold. Frequency ranges from 0-100 where 100 is
#'  a phenotype that occurs 100% of the time in all associated diseases.
#'  Include \code{NA} if you wish to retain phenotypes that
#'  do not have any frequency data.
#'  See \link[HPOExplorer]{add_pheno_frequency} for details.
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
                                pheno_frequency_threshold = NULL,
                                all.x = TRUE,
                                allow.cartesian = FALSE,
                                verbose = TRUE){
  # devoptera::args2vars(add_pheno_frequency)
  pheno_freq_mean <- NULL;

  new_cols <- c("pheno_freq_min","pheno_freq_max","pheno_freq_mean")
  if(!all(new_cols %in% names(phenos))){
    messager("Annotating phenotype frequencies.",v=verbose)
    phenos <- add_disease(phenos = phenos,
                          all.x = all.x,
                          allow.cartesian = allow.cartesian,
                          verbose = verbose)
    #### Get precomputed phenotype-disease frequencies ####
    utils::data("hpo_frequencies", package = "HPOExplorer")
    hpo_frequencies <- get("hpo_frequencies")
    # hpo_frequencies <- hpo_frequencies_agg(hpo_frequencies)
    #### Merge data ####
    phenos <- data.table::merge.data.table(
      x = phenos,
      y = hpo_frequencies,
      all.x = all.x,
      by = c("disease_id","hpo_id"))
  }
  #### Filter ####
  if(!is.null(pheno_frequency_threshold)){
    if(any(is.na(pheno_frequency_threshold))){
      phenos <- phenos[
        pheno_freq_mean>=min(pheno_frequency_threshold,na.rm = TRUE) |
          is.na(pheno_freq_mean),]
    } else{
      phenos <- phenos[pheno_freq_mean>=
                           min(pheno_frequency_threshold,na.rm = TRUE),]
    }
  }
  return(phenos)
}
