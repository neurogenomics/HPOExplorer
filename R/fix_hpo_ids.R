#' Fix missing HPO IDs
#'
#' Fix missing HPO IDs by inferring their identity from the \code{hpo_name}
#' column using several methods.
#' @param dt \link[data.table]{data.table}
#'  containing a column named "hpo_name".
#' @inheritParams make_phenos_dataframe
#' @returns data.table with the column "hpo_id"
#'
#' @keywords internal
#' @importFrom data.table setcolorder setkey
#' @importFrom stats setNames
fix_hpo_ids <- function(dt,
                        phenotype_to_genes = load_phenotype_to_genes()) {
  hpo_id <- NULL;

  dt$hpo_id <- harmonise_phenotypes(dt$hpo_name, as_hpo_ids = TRUE)
  dict <- stats::setNames(phenotype_to_genes$hpo_id,
                          phenotype_to_genes$hpo_name)
  dt[is.na(hpo_id)]$hpo_id <- dict[dt[is.na(hpo_id)]$hpo_name]
  #### Check if any IDs are still missing ####
  missing1 <- sum(is.na(dt$hpo_id))
  if(missing1>0){
    stp <- paste(missing1,"HPO IDs are still missing.")
    warning(stp)
  }
  missing2 <- sum(!grepl("HP",dt$hpo_id))
  if(missing2>0){
    stp <- paste(missing2,"HPO IDs are still missing.")
    warning(stp)
  }
  missing3 <- sum(is.na(dt$hpo_name))
  if(missing3>0){
    stp <- paste(missing3,"hpo_names are still missing.")
    warning(stp)
  }
  data.table::setcolorder(dt,"hpo_id")
  data.table::setkey(dt,"hpo_id")
  return(dt)
}
