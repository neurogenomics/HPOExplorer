create_node_data <- function(phenoNet,
                             phenos,
                             phenos_column,
                             verbose=TRUE) {
  if(!phenos_column %in% names(phenos)){
    messager(paste0("phenos_column=",shQuote(phenos_column)),
             "not found in phenos.",v=verbose)
    return(NULL)
  }
  nodeData <- lapply(phenoNet$vertex.names, function(p){
    phenos[, phenos_column, with=FALSE][phenos$HPO_Id == p][1]
  }) |> unlist()
  return(nodeData)
}
