#' Get term definition
#'
#' This function accesses the HPO API to get a description/ definition of an
#' HPO term. If a \code{line_length} \> 0 is passed to the function, it will add
#' newlines every nth word. This can be useful when displaying the description
#' in plots with limited space.
#' @param ontologyId A HPO term Id (e.g. "HP:0000002") \<string\>
#' @param line_length The number of desired words per line \<int\>
#' @returns A disease definition \<string\>
#' @examples
#' \dontrun{
#' ontologyId <- "HP:0000002"
#' get_term_definition(ontologyId)
#' }
#' @export
get_term_definition <- function(ontologyId,
                                line_length = FALSE) {
    hpo_termdetails <- tryCatch(expr = {
        httr::GET(paste0("hpo.jax.org/api/hpo/term/",
                         ontologyId))

    },
    error = function(e){
        httr::set_config(httr::config(ssl_verifypeer = FALSE))
        httr::GET(paste0("hpo.jax.org/api/hpo/term/",
                         ontologyId))
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
}
