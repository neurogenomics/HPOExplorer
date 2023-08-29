#' Add disease genes
#'
#' Add genes that overlap between an HPO ID and an associated phenotype.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns
#'
#' @export
#' @importFrom data.table merge.data.table
#' @importFrom utils data
#' @examples
#' \dontrun{
#' phenos <- load_phenotype_to_genes()
#' phenos2 <- add_severity(phenos = phenos)
#' }
add_disease_genes <- function(phenos,
                              all.x = TRUE,
                              verbose = TRUE){

  # devoptera::args2vars(add_disease_genes)

  if(!"gene_symbol" %in% names(phenos)){
    stp <-"'gene_symbol' column must be present in phenos."
    stop(stp)
  }

  if(!all(c("modifier","modifier_name") %in% names(phenos))){
    messager("Annotating phenos with disease genes.",v=verbose)
    annot <- load_phenotype_to_genes(file = "genes_to_phenotype.txt")
    dannot <- load_phenotype_to_genes(file = "phenotype.hpoa")
    # annot <- annot[hpo_id %in% unique(phenos$hpo_id),]
    # #### Add hpo_id associations ####
    # dgenes <- load_disease_genes()
    # dgenes <- data.table::merge.data.table(
    #   dgenes,
    #   annot[,c("disease_id","disease_name","hpo_id")],
    #   by.x = "disease_id",
    #   by.y = "disease_id",
    #   all = FALSE,
    #   allow.cartesian = TRUE)
    # dgenes[,disease_name_og:=NULL]
    #### Add disease_name ####
    if(!"disease_name" %in% names(phenos)){
      phenos <- data.table::merge.data.table(
        phenos,
        dannot[,c("disease_id","disease_name","hpo_id")],
        by = "hpo_id",
        allow.cartesian = TRUE,
        all.x = all.x)
    }
  }
  return(phenos)
}
