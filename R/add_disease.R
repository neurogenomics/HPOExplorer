#' Add diseases
#'
#' Annotate each HPO term with diseases that they are associated with.
#' @param add_descriptions Add disease names and descriptions.
#' @inheritParams add_
#' @inheritParams map_disease
#'
#' @export
#' @importFrom data.table merge.data.table
#' @importFrom utils data
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_disease(phenos = phenos)
add_disease <- function(phenos,
                        phenotype_to_genes = load_phenotype_to_genes(),
                        hpo = get_hpo(),
                        add_descriptions=FALSE,
                        all.x = TRUE,
                        use_api=FALSE,
                        workers=NULL,
                        allow.cartesian = FALSE){
  if(!"hpo_id" %in% names(phenos)){
    stp <- paste("hpo_id column must be present in phenos.")
    stop(stp)
  }
  if(!"disease_id" %in% names(phenos)){
    phenos <- add_genes(phenos = phenos,
                        phenotype_to_genes = phenotype_to_genes,
                        hpo = hpo,
                        all.x = all.x,
                        allow.cartesian = allow.cartesian)
  }
  if(isTRUE(add_descriptions)){
    phenos <- map_disease(dat=phenos,
                          id_col="disease_id",
                          fields=c("disease"),
                          use_api=use_api,
                          return_dat=TRUE,
                          all.x = all.x,
                          allow.cartesian = allow.cartesian,
                          workers=workers)
  }

  return(phenos)
}
