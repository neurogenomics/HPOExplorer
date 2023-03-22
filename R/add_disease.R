#' Add diseases
#'
#' Annotate each HPO term with diseases that they are associated with.
#' @param extra_cols Extra metadata columns from the"phenotype.hpoa"
#' annotations file to include.
#' See
#' \href{https://hpo-annotation-qc.readthedocs.io/en/latest/annotationFormat.html}{
#' here for column descriptions}.
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
                        # extra_cols = c("Evidence","Reference","Biocuration"),
                        extra_cols = NULL,
                        all.x = TRUE,
                        allow.cartesian = FALSE,
                        verbose = TRUE){

  # devoptera::args2vars(add_disease)

  if(!"HPO_ID" %in% names(phenos)){
    stp <- paste("HPO_ID column must be present in phenos.")
    stop(stp)
  }
  if(!all(c("DiseaseName","DatabaseID") %in% names(phenos))){
    messager("Annotating phenos with Disease",v=verbose)
    annot <- load_phenotype_to_genes(3)
    #### From LinkID ####
    if("LinkID" %in% names(phenos) &&
       !"DatabaseID" %in% names(phenos)){
      data.table::setnames(phenos,"LinkID","DatabaseID")
      if("DiseaseName" %in% names(phenos)){
        return(phenos)
      }
      by <- c("HPO_ID","DatabaseID")
    #### From HPO_ID alone ####
    }  else {
      by <- "HPO_ID"
    }
    phenos <- data.table::merge.data.table(
      phenos,
      annot[,unique(c("HPO_ID","DiseaseName","DatabaseID",
                      extra_cols)), with=FALSE],
      by = by,
      all.x = all.x,
      allow.cartesian = allow.cartesian)
  }
  return(phenos)
}
