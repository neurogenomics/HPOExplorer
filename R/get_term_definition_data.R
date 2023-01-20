get_term_definition_data <- function(term,
                                     line_length){

  hpo_id <- NULL;

  #### Import data ####
  utils::data(hpo_meta, package = "HPOExplorer")
  hpo_meta <- get("hpo_meta")
  term <- gsub(":","_",term)
  hpo_meta_sub <- hpo_meta[hpo_id %in% term]
  definitions <- stats::setNames(hpo_meta_sub$definition,
                                 gsub("_",":",hpo_meta_sub$hpo_id))
  if (line_length > 0) {
    definitions <- substr(definitions,0,line_length)
  }
  return(definitions)
}
