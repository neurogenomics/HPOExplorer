#' @describeIn map_ map_
#' List age of onset HPO terms
#'
#' List age of onset phenotypes in the HPO.
#' @param exclude HPO phenotype names to exclude.
#' @param include_na Include NA values for onset.
#' @inheritParams make_phenos_dataframe
#' @returns Named list of HPO IDs.
#'
#' @export
#' @examples
#' onsets <- list_onsets()
list_onsets <- function(hpo = get_hpo(),
                        exclude = FALSE, #c("Antenatal","Fetal","Congenital")
                        to = c("name","id"),
                        include_na = TRUE,
                        verbose = TRUE){
  to <- match.arg(to)
  opts <- map_phenotypes(terms = names(hpo_dict(type = "onset")),
                         hpo = hpo,
                         to="id",
                         keep_order = FALSE,
                         invert = TRUE)
  if(!is.null(exclude)){
    opts <- opts[!grepl(paste(exclude,collapse = "|"),opts,
                            ignore.case = TRUE)]
  }
  if(to=="id"){
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
