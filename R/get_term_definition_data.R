get_term_definition_data <- function(term,
                                     line_length,
                                     hpo = get_hpo()){
  dict <- stats::setNames(hpo@elementMetadata$definition,
                          hpo@elementMetadata$id)
  definitions <- dict[term]
  if (line_length > 0) {
    definitions <- substr(x=definitions, start=0, stop=line_length)
  }
  return(definitions)
}
