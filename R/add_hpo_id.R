#' @describeIn add_ add_
#' Add HPO ID column to dataframe
#'
#' Adds the HPO term ID column "hpo_id".
#' @export
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()
#' phenos <- unique(phenotype_to_genes[,c("hpo_id","hpo_name")])
#' phenos2 <- add_hpo_id(phenos=phenos)
add_hpo_id <- function(phenos,
                       hpo = get_hpo(),
                       phenotype_to_genes = NULL) {
  HPO_term_valid <- hpo_id <- NULL;

  if(!"hpo_id" %in% names(phenos)){
    messager("Adding HPO IDs.")
    alt_names <- grep("hpo_id","^id$",names(phenos),
                      value=TRUE, ignore.case = TRUE)
    if(length(alt_names)>0){
      data.table::setnames(phenos,alt_names[[1]],"hpo_id")
      return(phenos)
    } else {
      if(is.null(phenotype_to_genes)) {
        phenotype_to_genes <- load_phenotype_to_genes()
      }
      phenos <- fix_hpo_ids(dat=phenos,
                            phenotype_to_genes=phenotype_to_genes)
    }
    phenos[,HPO_term_valid:=(hpo_id %in% hpo@terms)]
  }
  return(phenos)
}

