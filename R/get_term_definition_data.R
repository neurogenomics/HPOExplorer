get_term_definition_data <- function(ontologyId,
                                     line_length){

  utils::data(hpo_meta, package = "HPOExplorer")
  hpo_id <- NULL;

  ontologyId <- gsub(":","_",ontologyId)
  hpo_meta_sub <- hpo_meta[hpo_id %in% ontologyId]
  definitions <- stats::setNames(hpo_meta_sub$definition,
                                 gsub("_",":",hpo_meta_sub$hpo_id))
  if (line_length > 0) {
    definitions <- substr(definitions,0,line_length)
  }
  return(definitions)
}
