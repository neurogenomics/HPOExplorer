#' Fix missing HPO IDs
#'
#' Fix missing HPO IDs by inferring their identity from the \code{Phenotype}
#' column using several methods.
#' @param dt \link[data.table]{data.table}
#'  containing a column named "Phenotype".
#' @inheritParams make_phenos_dataframe
#' @returns data.table with the column "HPO_ID"
#'
#' @keywords internal
#' @importFrom data.table setcolorder setkey
#' @importFrom stats setNames
fix_hpo_ids <- function(dt,
                        phenotype_to_genes = load_phenotype_to_genes()) {
  HPO_ID <- NULL;

  dt$HPO_ID <- harmonise_phenotypes(dt$Phenotype, as_hpo_ids = TRUE)
  dict <- stats::setNames(phenotype_to_genes$HPO_ID,
                          phenotype_to_genes$Phenotype)
  dt[is.na(HPO_ID)]$HPO_ID <- dict[dt[is.na(HPO_ID)]$Phenotype]
  #### Check if any IDs are still missing ####
  missing1 <- sum(is.na(dt$HPO_ID))
  if(missing1>0){
    stp <- paste(missing1,"HPO IDs are still missing")
    stop(stp)
  }
  missing2 <- sum(!grepl("HP",dt$HPO_ID))
  if(missing2>0){
    stp <- paste(missing2,"HPO IDs are still missing")
    stop(stp)
  }
  missing3 <- sum(is.na(dt$Phenotype))
  if(missing3>0){
    stp <- paste(missing3,"Phenotypes are still missing")
    stop(stp)
  }
  data.table::setcolorder(dt,"HPO_ID")
  data.table::setkey(dt,"HPO_ID")
  return(dt)
}
