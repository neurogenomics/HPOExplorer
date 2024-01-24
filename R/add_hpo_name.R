#' @describeIn add_ add_
#' Add HPO name column to dataframe
#'
#' Adds the HPO term name column "hpo_name".
#' @export
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_hpo_name(phenos=phenos)
add_hpo_name <- function(phenos,
                         hpo = get_hpo()) {
  if(!"hpo_name" %in% names(phenos)){
    messager("Adding HPO names.")
    phenos <- add_hpo_id(phenos)
    phenos$hpo_name <- map_phenotypes(hpo = hpo,
                                      terms = phenos$hpo_id,
                                      to = "name")
  }
  return(phenos)
}

