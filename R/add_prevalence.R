#' @describeIn add_ add_
#' Add prevalence
#'
#' Add a column containing the prevalence score for each disease ("disease_id")
#'  or phenotype ("hpo_id").
#' @param method One of "orphanet" or "oard".
#' @param input_col Name of the column containing the disease or phenotype IDs.
#' @param drop_na Whether to drop rows with missing prevalence data.
#'
#' @export
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_prevalence(phenos = phenos)
add_prevalence <- function(phenos,
                           input_col="disease_id",
                           drop_na=TRUE,
                           method="orphanet"){
  method <- match.arg(method)
  #### Example phenos data
  if(is.null(phenos)){
    phenos <- make_phenos_dataframe(add_disease_data = TRUE,
                                    include_mondo = FALSE)
  } else {
    phenos <- data.table::copy(phenos)
  }
  phenos <- add_disease(phenos)
  #### From OARD ####
  # res <- add_prevalence_oard(phenos$hpo_id[1:100])
  #### From ORPHANET ####
  if(method=="orphanet"){
    mean_prevalence <- NULL;
    #### Add MONDO IDs ####
    phenos <- add_mondo(phenos = phenos,
                        input_col = input_col)
    #### Get Orphanet data ####
    dprev <- KGExplorer:::get_prevalence_orphanet(agg_by=c("mondo_id",
                                                           "id","Name"))
    phenos2 <- data.table::merge.data.table(
      phenos,
      dprev,
      by="mondo_id",
      all.x=TRUE
    )[order(-mean_prevalence)]
    #### Drop NAs ####
    if(isTRUE(drop_na)) phenos2 <- phenos2[!is.na(mean_prevalence),]
    #### Report missing ####
    add_prevalence_report(phenos = phenos,
                          phenos2 = phenos2,
                          input_col = sort(
                            unique(c(input_col,
                                     "hpo_id",
                                     "disease_id",
                                     "mondo_id")
                            )
                          ))
    return(phenos2)
  }
}
