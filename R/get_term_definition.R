#' Get term definition
#'
#' This function accesses the HPO API to get a description/definition of an
#' HPO term. If a \code{line_length} \> 0 is passed to the function, it will add
#' newlines every nth word. This can be useful when displaying the description
#' in plots with limited space.
#' @param ontologyId A HPO term Id (e.g. "HP:0000002") \<string\>
#' @param line_length The number of desired words per line \<int\>
#' @param use_api Get definitions from the HPO API,
#' as opposed to a static local dataset.
#' @returns A named vector of HPO term descriptions.
#'
#' @export
#' @importFrom stats setNames
#' @examples
#' definitions <- get_term_definition(ontologyId=c("HP:0000002","HP:0000003"))
get_term_definition <- function(ontologyId,
                                line_length = FALSE,
                                use_api = FALSE) {
  if(isTRUE(use_api)){
    definitions <- get_term_definition_api(ontologyId = ontologyId,
                                           line_length = line_length)
  } else {
    definitions <- get_term_definition_data(ontologyId = ontologyId,
                                            line_length = line_length)
  }
  return(definitions)
}
