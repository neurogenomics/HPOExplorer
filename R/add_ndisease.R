#' Add N diseases
#'
#' Annotate each HPO term with the total number of disease
#' they are associated with.
#' @param pheno_ndiseases_threshold Filter phenotypes by the
#' maximum number of diseases they are associated with.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns
#'
#' @export
#' @importFrom data.table merge.data.table
#' @importFrom utils data
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_ndisease(phenos = phenos)
add_ndisease <- function(phenos,
                         pheno_ndiseases_threshold = NULL,
                         all.x = TRUE,
                         allow.cartesian = FALSE,
                         verbose = TRUE){
  n_diseases <- LinkID <- NULL;
  # devoptera::args2vars(add_ndisease)

  if(!"HPO_ID" %in% names(phenos)){
    stp <- paste("HPO_ID column must be present in phenos.")
    stop(stp)
  }
  if(!all(c("n_diseases") %in% names(phenos))){
    messager("Annotating phenos with n_diseases",v=verbose)
    d1 <- load_phenotype_to_genes(1)
    d2 <- load_phenotype_to_genes(2)
    d3 <- load_phenotype_to_genes(3)
    d <- rbind(d1[,c("HPO_ID","LinkID")],
               d2[,c("HPO_ID","LinkID")],
               data.table::setnames(d3[,c("HPO_ID","DatabaseID")],
                                    "DatabaseID","LinkID"))
    counts <- d[,list(n_diseases=length(unique(LinkID))), by="HPO_ID"]
    phenos <- data.table::merge.data.table(
      phenos,
      counts,
      by = "HPO_ID",
      all.x = all.x,
      allow.cartesian = allow.cartesian)
  }
  if(!is.null(pheno_ndiseases_threshold)){
    phenos <- phenos[n_diseases<=pheno_ndiseases_threshold]
  }
  return(phenos)
}
