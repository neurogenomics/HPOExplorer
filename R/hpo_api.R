#' HPO API
#'
#' Extract data from the Human Phenotype Ontology (HPO) using the
#' Application Programming Interface (API).
#' @param hpo_id HPO ID for a given term.
#' @param url API entry point.
#' See \href{https://hpo.jax.org/api/hpo/docs}{HPO API documentation}
#'  for details.
#' @param type Type of data to extract. Set \code{NULL} to return all data.
#' @returns A named list or data.frame of metadata for a given HPO ID.
#'
#' @export
#' @examples
#' dat <- hpo_api(hpo_id="HP:0011420", type="diseases")
hpo_api <- function(hpo_id,
                    type = list(NULL,"genes","diseases")[[1]],
                    url = paste("hpo.jax.org/api/hpo/term",hpo_id,type,sep="/")
                    ){

  hpo_termdetails <- tryCatch(expr = {
    httr::GET(url = url)
  },
  error = function(e){
    httr::set_config(httr::config(ssl_verifypeer = FALSE))
    httr::GET(url = url)
  })
  hpo_termdetails_char <- rawToChar(hpo_termdetails$content)
  hpo_termdetails_data <- jsonlite::fromJSON(hpo_termdetails_char)
  return(hpo_termdetails_data)
}
