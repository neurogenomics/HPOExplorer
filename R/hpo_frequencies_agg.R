hpo_frequencies_agg <- function(hpo_frequencies,
                                by=c("disease_id","hpo_id")){
  by <- by[1]
  pheno_freq_min <- pheno_freq_max <- pheno_freq_mean <- NULL
  annot_agg <- hpo_frequencies[,list(
    pheno_freq_min=min(pheno_freq_min, na.rm = TRUE),
    pheno_freq_max=max(pheno_freq_max, na.rm = TRUE),
    pheno_freq_mean=mean(pheno_freq_mean, na.rm = TRUE)),
    by=by]
  return(annot_agg)
}
