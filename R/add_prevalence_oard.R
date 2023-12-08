add_prevalence_oard <- function(ids){

  # ids <- unique(phenos$hpo_id)[1:100]
  res <- oard_query_api(ids=ids)
  res2 <- oard_query_api(ids=res$results$concept_id,
                         dataset_id=1,
                         endpoint="frequencies/singleConceptFreq",
                         concept_prefix="concept_id=")
  return(res2)
}
