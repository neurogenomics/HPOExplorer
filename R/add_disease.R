#' Add diseases
#'
#' Annotate each HPO term with diseases that they are associated with.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns
#'
#' @export
#' @importFrom data.table merge.data.table
#' @importFrom utils data
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_disease(phenos = phenos)
add_disease <- function(phenos,
                        all.x = TRUE,
                        allow.cartesian = FALSE,
                        verbose = TRUE){

  # devoptera::args2vars(add_disease)

  if(!all(c("DiseaseName","DatabaseID") %in% names(phenos))){
    messager("Annotating phenos with Disease",v=verbose)
    annot <- load_phenotype_to_genes(3)
    phenos <- data.table::merge.data.table(
      phenos,
      annot[,c("HPO_ID","DiseaseName","DatabaseID",
               "Evidence","Reference","Biocuration")],
      by = "HPO_ID",
      all.x = all.x,
      allow.cartesian = allow.cartesian)
  }
  return(phenos)
}
