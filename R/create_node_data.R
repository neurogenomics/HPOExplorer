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
  messager("Adding",paste0("new_column=",shQuote(new_column)),v=verbose)
  # data.table::setkeyv(phenos,"HPO_ID")
  # phenoNet[[new_column]] <- phenos[phenoNet$vertex.names, ][[phenos_column]]
  dat <- unique(phenos[,c("HPO_ID",phenos_column), with=FALSE])
  data_dict <- stats::setNames(dat[[phenos_column]], dat$HPO_ID)
  phenoNet[[new_column]] <- data_dict[phenoNet$vertex.names]
  return(phenoNet)
}
