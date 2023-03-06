get_term_definition_data <- function(term,
                                     line_length){

  HPO_ID <- NULL;

  #### Import data ####
  utils::data("hpo_meta", package = "HPOExplorer")
  hpo_meta <- get("hpo_meta")
  hpo_meta_sub <- hpo_meta[HPO_ID %in% term]
  definitions <- stats::setNames(hpo_meta_sub$definition,
                                 hpo_meta_sub$HPO_ID)
  if (line_length > 0) {
    definitions <- substr(x=definitions, start=0, stop=line_length)
  }
  return(definitions)
}
