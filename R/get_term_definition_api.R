#' Get term definition: API
#'
#' This function accesses the HPO API to get a description/definition of an
#' HPO term. If a \code{line_length} \> 0 is passed to the function, it will add
#' newlines every nth word. This can be useful when displaying the description
#' in plots with limited space.
#' @returns Character vector of definitions.
#' @keywords internal
get_term_definition_api <- function(term,
                                    line_length = FALSE){
  requireNamespace("httr")
  requireNamespace("jsonlite")
  lapply(stats::setNames(term,term), function(hpo_id){
    hpo_termdetails_data <- hpo_api(hpo_id = hpo_id)
    if (line_length > 0) {
      definition <- newlines_to_definition(
        hpo_termdetails_data$details$definition,
        line_length
      )
    } else {
      definition <- hpo_termdetails_data$details$definition
    }
    return(definition)
  }) |> unlist()
}
