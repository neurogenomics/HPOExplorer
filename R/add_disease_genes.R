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

  if(!"Gene" %in% names(phenos)){
    stp <-"'Gene' column must be present in phenos."
    stop(stp)
  }

  if(!all(c("Modifier","Modifier_name") %in% names(phenos))){
    messager("Annotating phenos with disease genes.",v=verbose)
    annot <- load_phenotype_to_genes(filename = "genes_to_phenotype.txt")
    dannot <- load_phenotype_to_genes(filename = "phenotype.hpoa")
    # annot <- annot[HPO_ID %in% unique(phenos$HPO_ID),]
    # #### Add HPO_ID associations ####
    # dgenes <- load_disease_genes()
    # dgenes <- data.table::merge.data.table(
    #   dgenes,
    #   annot[,c("DatabaseID","DiseaseName","HPO_ID")],
    #   by.x = "DiseaseID",
    #   by.y = "DatabaseID",
    #   all = FALSE,
    #   allow.cartesian = TRUE)
    # dgenes[,DiseaseName_og:=NULL]
    #### Add DiseaseName ####
    if(!"DiseaseName" %in% names(phenos)){
      phenos <- data.table::merge.data.table(
        phenos,
        dannot[,c("DatabaseID","DiseaseName","HPO_ID")],
        by = "HPO_ID",
        allow.cartesian = TRUE,
        all.x = all.x)
    }
  }
  return(phenos)
}
