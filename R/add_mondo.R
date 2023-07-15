#' Add age of death
#'
#' Add metadata from MONDO, including:
#' \itemize{
#' \item{MONDO_ID: }{MONDO term ID.}
#' \item{MONDO_name: }{MONDO term name.}
#' \item{MONDO_definition: }{MONDO term definition.}
#' }
#' @inheritParams add_disease
#' @inheritParams data.table::merge.data.table
#' @export
#' @importFrom data.table :=
#' @examples
#' phenos <- load_phenotype_to_genes("phenotype.hpoa")
#' phenos2 <- add_mondo(phenos = phenos)
add_mondo <- function(phenos,
                      add_definitions = TRUE,
                      all.x = TRUE,
                      allow.cartesian = FALSE,
                      verbose = TRUE){

  # devoptera::args2vars(add_mondo)
  disease_id <- MONDO_definition <- MONDO_name <- MONDO_ID <- NULL;

  if(!all(c("MONDO_ID","MONDO_name","MONDO_definition") %in% names(phenos))){
    phenos <- add_disease(phenos = phenos,
                          all.x = all.x,
                          allow.cartesian = allow.cartesian,
                          add_definitions = add_definitions,
                          verbose = verbose)
    messager("Annotating phenos with MONDO metadata.",v=verbose)
    mondo <- get_mondo()
    dict <-  unlist(mondo$xref) |> invert_dict()
    names(dict) <- gsub("^Orphanet","ORPHA",names(dict))
    ### Add new columns ####
    phenos[,MONDO_ID:=dict[disease_id]]
    phenos[,MONDO_name:=mondo$name[MONDO_ID]]
    phenos[,MONDO_definition:=mondo$def[MONDO_ID]]
    report_missing(phenos = phenos,
                   col = "MONDO_ID",
                   verbose = verbose)
    report_missing(phenos = phenos,
                   col = "MONDO_name",
                   verbose = verbose)
    report_missing(phenos = phenos,
                   col = "MONDO_definition",
                   verbose = verbose)
  }
  return(phenos)
}
