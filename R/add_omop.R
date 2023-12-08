#' Add MONDO
#'
#' Add metadata from \href{https://mondo.monarchinitiative.org/}{MONDO},
#' including:
#' \itemize{
#' \item{MONDO_ID: }{MONDO term ID.}
#' \item{MONDO_name: }{MONDO term name.}
#' \item{MONDO_definition: }{MONDO term definition.}
#' }
#' @param id_col ID column to map to MONDO IDs.
#' @param force_new Force a new query to the OARD API instead of
#' using pre-downloaded data.
#' @inheritParams add_disease
#' @inheritParams data.table::merge.data.table
#' @export
#' @importFrom data.table :=
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_omop(phenos = phenos)
add_omop <- function(phenos,
                     id_col = "hpo_id",
                     all.x = TRUE,
                     allow.cartesian = FALSE,
                     force_new = FALSE,
                     verbose = TRUE){

  # devoptera::args2vars(add_omop)
  if(!id_col %in% names(phenos)){
    stop("id_col not found in phenos.")
  }
  if(!all(c("OMOP_ID","OMOP_NAME") %in% names(phenos))){
    messager("Annotating phenos with OMOP metadata.",v=verbose)
    #### Select the correct map ####
    if(id_col=="hpo_id" || isTRUE(force_new)){
      omop <- pkg_data("hpo_id_to_omop")
    } else if(id_col=="disease_id"){
      omop <- pkg_data("disease_id_to_omop")
    } else {
      omop <- oard_query_api(ids = phenos[[id_col]])
    }
    phenos2 <- data.table::merge.data.table(
      phenos,
      omop,
      by=id_col,
      all.x = all.x,
      allow.cartesian = allow.cartesian,
    )
    report_missing(phenos = phenos2,
                   id_col = id_col,
                   report_col = c("OMOP_ID","OMOP_NAME"),
                   verbose = verbose)
    return(phenos2)
  }
  return(phenos)
}
