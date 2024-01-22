#' @describeIn main main
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
example_phenos <- function(i=seq(10),
                           hpo=get_hpo()){
  data.table::data.table(hpo_id=grep("^HP:",hpo@terms, value = TRUE)[i])
}
