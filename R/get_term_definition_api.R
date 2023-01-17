#' Get term definition: API
#'
#' This function accesses the HPO API to get a description/definition of an
#' HPO term. If a \code{line_length} \> 0 is passed to the function, it will add
#' newlines every nth word. This can be useful when displaying the description
#' in plots with limited space.
#' @inheritParams get_term_definition
#' @returns Character vector of definitions.
#' @keywords internal
get_term_definition_api <- function(ontologyId,
                                    line_length = FALSE){
  requireNamespace("httr")
  requireNamespace("jsonlite")
 lapply(stats::setNames(ontologyId,ontologyId), function(oid){
   hpo_termdetails <- tryCatch(expr = {
     httr::GET(paste0("hpo.jax.org/api/hpo/term/",
                      oid))

   },
   error = function(e){
     httr::set_config(httr::config(ssl_verifypeer = FALSE))
     httr::GET(paste0("hpo.jax.org/api/hpo/term/",
                      oid))
   })
   hpo_termdetails_char <- rawToChar(hpo_termdetails$content)
   hpo_termdetails_data <- jsonlite::fromJSON(hpo_termdetails_char)
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
