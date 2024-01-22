make_node_data <- function(phenoNet,
                           phenos,
                           phenos_column,
                           new_column=phenos_column) {

  if(!phenos_column %in% names(phenos)){
    messager(paste0("phenos_column=",shQuote(phenos_column)),
             "not found in phenos.")
    return(phenoNet)
  }
  messager("Adding",paste0("new_column=",shQuote(new_column)))
  # data.table::setkeyv(phenos,"hpo_id")
  # phenoNet[[new_column]] <- phenos[phenoNet$vertex.names, ][[phenos_column]]
  dat <- unique(phenos[,c("hpo_id",phenos_column), with=FALSE])
  data_dict <- stats::setNames(dat[[phenos_column]], dat$hpo_id)
  phenoNet[[new_column]] <- data_dict[phenoNet$name]
  return(phenoNet)
}
