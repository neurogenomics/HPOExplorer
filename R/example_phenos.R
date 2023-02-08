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
example_phenos <- function(i=seq_len(10)){
  data.table::data.table(HPO_ID=get_hpo()$id[i])
}
