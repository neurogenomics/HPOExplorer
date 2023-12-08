#' Add diseases
#'
#' Annotate each HPO term with diseases that they are associated with.
#' @param extra_cols Extra metadata columns from the"phenotype.hpoa"
#' annotations file to include.
#' See
#' \href{https://hpo-annotation-qc.readthedocs.io/en/latest/annotationFormat.html}{
#' here for column descriptions}.
#' @param add_definitions Add disease definitions using
#' \link[HPOExplorer]{add_disease_definition}.
#' @inheritParams add_disease_definition
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
                        include_mondo = TRUE,
                        all.x = TRUE,
                        allow.cartesian = FALSE,
                        add_definitions = FALSE,
                        verbose = TRUE){

  # devoptera::args2vars(add_disease)

  if(!"hpo_id" %in% names(phenos)){
    stp <- paste("hpo_id column must be present in phenos.")
    stop(stp)
  }
  if(!all(c("disease_name","disease_id") %in% names(phenos))){
    messager("Annotating phenos with Disease",v=verbose)
    annot <- load_phenotype_to_genes(3)
    #### From disease_id ####
    data.table::setnames(phenos,"disease_id","disease_id", skip_absent = TRUE)
    if("disease_name" %in% names(phenos)){
      return(phenos)
    }
    #### From hpo_id alone ####
    by <- c("hpo_id","disease_id")
    by <- by[by %in% names(phenos)]
    #### Ensure there's only 1 row per Disease ####
    annot <- annot[,unique(c("hpo_id","disease_name","disease_id",
                             extra_cols)),
                   with=FALSE][,.SD[1], by=c("disease_id","hpo_id")]
    #### Merge ####
    phenos <- data.table::merge.data.table(
      phenos,
      annot,
      by = by,
      all.x = all.x,
      allow.cartesian = allow.cartesian)
  }
  #### Add Definitions column and fill out missing disease_name columns ####
  if(isTRUE(add_definitions)){
    phenos <- add_disease_definition(phenos = phenos,
                                     all.x = all.x,
                                     include_mondo = include_mondo,
                                     verbose = verbose)
  }
  return(phenos)
}
