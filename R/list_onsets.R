#' List age of onset HPO terms
#'
#' List age of onset phenotypes in the HPO.
#' @param exclude HPO phenotype names to exclude.
#' @param as_hpo_ids Return as a character vector vector HPO IDs only.
#' @param include_na Include NA values for onset.
#' @inheritParams make_phenos_dataframe
#' @returns Named list of HPO IDs.
#'
#' @export
#' @examples
#' onsets <- list_onsets()
list_onsets <- function(hpo = get_hpo(),
                        exclude = FALSE, #c("Antenatal","Fetal","Congenital")
                        as_hpo_ids = FALSE,
                        include_na = TRUE,
                        verbose = TRUE){
  # devoptera::args2vars(list_onsets)

  opts <- harmonise_phenotypes(phenotypes = names(hpo_dict(type = "onset")),
                               hpo = hpo,
                               as_hpo_ids = TRUE,
                               keep_order = FALSE,
                               invert = TRUE,
                               verbose = verbose)
  if(!is.null(exclude)){
    opts <- opts[!grepl(paste(exclude,collapse = "|"),opts,
                            ignore.case = TRUE)]
  }
  if(isTRUE(as_hpo_ids)){
    ids <- names(opts)
    if(isTRUE(include_na)){
      ids <- c(ids,NA)
    }
    return(ids)
  } else {
    if(isTRUE(include_na)){
      opts <- c(opts,"NA"=NA)
    }
    return(opts)
  }
}
