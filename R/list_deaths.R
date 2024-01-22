#' @describeIn map_ map_
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
                        to = c("name","id"),
                        include_na = TRUE){
  to <- match.arg(to)
  opts <- map_phenotypes(terms = names(hpo_dict(type = "AgeOfDeath")),
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
