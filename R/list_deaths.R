#' List age of death HPO terms
#'
#' List age of death phenotypes in the HPO.
#' @inheritParams list_onsets
#' @inheritParams make_phenos_dataframe
#' @returns Named list of HPO IDs.
#'
#' @export
#' @examples
#' deaths <- list_deaths()
list_deaths <- function(hpo = get_hpo(),
                        exclude = FALSE,# c("Miscarriage","Stillbirth","Prenatal death" )
                        as_hpo_ids = FALSE,
                        include_na = TRUE,
                        verbose = TRUE){
  # devoptera::args2vars(list_opts)

  opts <- harmonise_phenotypes(phenotypes = names(hpo_dict(type = "AgeOfDeath")),
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
