get_term_definition_data <- function(term,
                                     line_length,
                                     hpo = get_hpo()){
  definitions <- hpo$def[term]
  if (line_length > 0) {
    definitions <- substr(x=definitions, start=0, stop=line_length)
  }
  return(definitions)
}
