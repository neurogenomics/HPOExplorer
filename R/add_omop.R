#' @describeIn add_ add_
#' Add OMOP
#'
#' Add metadata from \href{https://mondo.monarchinitiative.org/}{MONDO},
#' including:
#' \itemize{
#' \item{mondo_id: }{MONDO term ID.}
#' \item{mondo_name: }{MONDO term name.}
#' \item{mondo_def: }{MONDO term definition.}
#' }
#' @param input_col ID column to map to MONDO IDs.
#' @param force_new Force a new query to the OARD API instead of
#' using pre-downloaded data.
#'
#' @export
#' @import data.table
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_omop(phenos = phenos)
add_omop <- function(phenos,
                     input_col = "hpo_id",
                     all.x = TRUE,
                     allow.cartesian = FALSE,
                     force_new = FALSE,
                     verbose = TRUE){
  if(!input_col %in% names(phenos)){
    stop("input_col not found in phenos.")
  }
  if(!all(c("OMOP_ID","OMOP_NAME") %in% names(phenos))){
    messager("Annotating phenos with OMOP metadata.",v=verbose)
    #### Select the correct map ####
    if(input_col=="hpo_id" || isTRUE(force_new)){
      omop <- pkg_data("hpo_id_to_omop")
    } else if(input_col=="disease_id"){
      omop <- pkg_data("disease_id_to_omop")
    } else {
      omop <- KGExplorer::query_oard(ids = phenos[[input_col]])
    }
    phenos2 <- data.table::merge.data.table(
      phenos,
      omop,
      by=input_col,
      all.x = all.x,
      allow.cartesian = allow.cartesian,
    )
    report_missing(phenos2,
                   input_col = input_col,
                   report_col = c("OMOP_ID","OMOP_NAME"),
                   verbose = verbose)
    return(phenos2)
  }
  return(phenos)
}
