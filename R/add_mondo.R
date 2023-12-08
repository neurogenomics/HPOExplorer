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
#' @inheritParams add_disease
#' @inheritParams data.table::merge.data.table
#' @export
#' @importFrom data.table :=
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_mondo(phenos = phenos)
add_mondo <- function(phenos,
                      id_col = "disease_id",
                      add_definitions = TRUE,
                      all.x = TRUE,
                      allow.cartesian = FALSE,
                      verbose = TRUE){

  # devoptera::args2vars(add_mondo)
  MONDO_definition <- MONDO_name <- MONDO_ID <- NULL;

  if(!all(c("MONDO_ID","MONDO_name","MONDO_definition") %in% names(phenos))){
    phenos <- add_disease(phenos = phenos,
                          all.x = all.x,
                          allow.cartesian = allow.cartesian,
                          add_definitions = add_definitions,
                          include_mondo = FALSE,
                          verbose = verbose)
    messager("Annotating phenos with MONDO metadata.",v=verbose)
    mondo <- get_mondo()
    dict <- mondo_dict(mondo = mondo)

    #### Assess missing values ####
    # sum(is.na(mondo$name))
    # sum(is.na(mondo$def))
    # xref_ids <- unique(names(unlist(mondo$xref)))
    # sum(!xref_ids %in% names(mondo$id))
    # sum(!xref_ids %in% names(mondo$name))
    # sum(!xref_ids %in% names(mondo$def))
    # names(mondo$name)[is.na(unname(mondo$name))]
    # sum(is.na(unname(mondo$name)))
    # names(unlist(mondo$xref))

    ### Add new columns ####
    phenos[,MONDO_ID:=dict[get(id_col)]]
    phenos[,MONDO_name:=mondo$name[MONDO_ID]]
    phenos[,MONDO_definition:=mondo$def[MONDO_ID]]
    report_missing(phenos = phenos,
                   id_col = id_col,
                   report_col = c("MONDO_ID","MONDO_name","MONDO_definition"),
                   verbose = verbose)
  }
  return(phenos)
}
