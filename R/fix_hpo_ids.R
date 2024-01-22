#' Fix missing HPO IDs
#'
#' Fix missing HPO IDs by inferring their identity from the \code{hpo_name}
#' column using several methods.
#' @param dat \link[data.table]{data.table}
#'  containing a column named "hpo_name".
#' @returns data.table with the column "hpo_id"
#'
#' @keywords internal
fix_hpo_ids <- function(dat,
                        phenotype_to_genes = load_phenotype_to_genes()) {
  hpo_id <- NULL;

  dat$hpo_id <- map_phenotypes(dat$hpo_name, to = "id")
  dict <- stats::setNames(phenotype_to_genes$hpo_id,
                          phenotype_to_genes$hpo_name)
  dat[is.na(hpo_id)]$hpo_id <- dict[dat[is.na(hpo_id)]$hpo_name]
  #### Check if any IDs are still missing ####
  missing1 <- sum(is.na(dat$hpo_id))
  if(missing1>0){
    stp <- paste(missing1,"HPO IDs are still missing.")
    warning(stp)
  }
  missing2 <- sum(!grepl("HP",dat$hpo_id))
  if(missing2>0){
    stp <- paste(missing2,"HPO IDs are still missing.")
    warning(stp)
  }
  missing3 <- sum(is.na(dat$hpo_name))
  if(missing3>0){
    stp <- paste(missing3,"hpo_names are still missing.")
    warning(stp)
  }
  data.table::setcolorder(dat,"hpo_id")
  data.table::setkey(dat,"hpo_id")
  return(dat)
}
