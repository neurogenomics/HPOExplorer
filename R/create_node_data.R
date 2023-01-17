create_node_data <- function(phenoNet,
                             phenos,
                             phenos_column,
                             new_column=phenos_column,
                             verbose=TRUE) {

  if(!phenos_column %in% names(phenos)){
    messager(paste0("phenos_column=",shQuote(phenos_column)),
             "not found in phenos.",v=verbose)
    return(phenoNet)
  }
  data.table::setkeyv(phenos,"HPO_ID")
  phenoNet[[new_column]] <- phenos[phenoNet$vertex.names, ][[phenos_column]]
  return(phenoNet)
}
