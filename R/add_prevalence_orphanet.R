add_prevalence_orphanet <- function(phenos=NULL,
                                    id_col="disease_id",
                                    drop_na=TRUE,
                                    verbose=TRUE){
  # devoptera::args2vars(add_prevalence_orphanet)

  mean_prevalence <- NULL;
  #### Example phenos data
  if(is.null(phenos)){
     phenos <- make_phenos_dataframe(add_disease_data = TRUE,
                                     include_mondo = FALSE,
                                     verbose = verbose)
  } else {
    phenos <- data.table::copy(phenos)
  }
  #### Add MONDO IDs ####
  phenos <- add_mondo(phenos = phenos,
                      id_col = id_col,
                      verbose = verbose)
  #### Get Orphanet data ####
  dprev <- get_orphanet_epidemiology(agg_by=c("MONDO_ID","id","Name"))
  phenos2 <- data.table::merge.data.table(
    phenos,
    dprev,
    by="MONDO_ID",
    all.x=TRUE
  )[order(-mean_prevalence)]
  #### Drop NAs ####
  if(isTRUE(drop_na)) phenos2[!is.na(mean_prevalence),]
  #### Report missing ####
  add_prevalence_report(phenos = phenos,
                        phenos2 = phenos2,
                        id_col = sort(
                          unique(c(id_col,
                                   "hpo_id",
                                   "disease_id",
                                   "MONDO_ID")
                          )
                        ),
                        verbose = verbose)
  return(phenos2)
}
