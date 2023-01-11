#' Get HPO term definition
#'
#' This gets the disease description from a data frame of disease descriptions.
#' The rows names of the data frame are the HPO ID and the description column is
#' called "description". It also adds new lines to the description so that the
#' hover box in the web app does not get too wide. This is done by calling the
#' \code{newlines_to_definition} function.
#'
#' It uses the disease description dataframe rather than accessing the HPO API
#' because its more efficient for use in web apps etc.
#'
#' @param ontologyId The HPO Id of the term (string)
#' @param disease_descriptions A data frame of disease descriptions corresponding to each HPO Id
#' @return The disease description with new lines added.
#'
#' @export
#' @examples
#' genedata <- load_phenotype_to_genes()
#' ontologyId <- unique(genedata$ID)[seq_len(10)]
#' disease_descriptions <- get_disease_description_dataframe(
#'   HPO_ids = ontologyId)
#' defs <- hpo_get_term_definition(ontologyId = ontologyId,
#'                                 disease_descriptions = disease_descriptions)
hpo_get_term_definition <- function(ontologyId,
                                    disease_descriptions) {

  HPO_id <- NULL;
  definition <- disease_descriptions[HPO_id %in% ontologyId,]$description
  definition <- newlines_to_definition(definition = definition)
  return(definition)
}
