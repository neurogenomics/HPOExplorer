#' Example phenotypes dataframe
#'
#' Create a minimal example of a phenos dataframe.
#' @param i Indices of HPO IDs to use.
#' @returns phenotype data.table
#'
#' @export
#' @importFrom data.table data.table
#' @examples
#' phenos <- example_phenos()
example_phenos <- function(i=seq(10)){
  data.table::data.table(hpo_id=grep("^HP:",get_hpo()$id, value = TRUE)[i])
}
