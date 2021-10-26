#' Generate HPO disease desription dataframe
#'
#' This function will interact with the HPO API to create a dataframe that
#' contains a column of HPO IDs and a column of short descriptions describing
#' the phenotype.
#'
#' This can take a while to run on a large number of IDs so it is reccomended
#' that you do it once and save the dataframe.
#'
#' @param HPO_ids A character vector of HPO Ids
#' @returns A dataframe of HPO phenotype descriptions
#' @export
get_disease_description_dataframe <- function(HPO_ids) {
  descriptions = c()
  for (id in HPO_ids) {
    descriptions = append(descriptions, get_term_definition(id))
  }
  return(data.frame("HPO_Id"=HPO_ids, "description" = descriptions))
}
