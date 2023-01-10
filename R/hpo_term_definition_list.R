#' Get HPO term description for a list of terms
#'
#' Need to redo this without a for loop (use \code{lapply} or something).
#' This just applies the \link[HPOExplorer]{hpo_get_term_definition} function
#' to a character vector of terms.
#'
#' @param ontologyId_list A character vector of HPO Ids.
#' @param disease_descriptions A data frame of disease descriptions
#'  for all HPO Id.
#' @returns A named vector of disease descriptions,
#' with HPO Id as names and descriptions as values.
#' @examples
#' genedata <- load_phenotype_to_genes()
#' HPO_ids <- unique(genedata$ID[1:10])
#'
#' disease_descriptions <- get_disease_description_dataframe(HPO_ids)
#' hpo_term_definition_list(HPO_ids[1:3], disease_descriptions)
#' @export
hpo_term_definition_list <- function(ontologyId_list,
                                     disease_descriptions) {
    term_details <- c()
    for (term in ontologyId_list) {
        term_details[term] <- hpo_get_term_definition(term,
                                                      disease_descriptions)
    }
    return(term_details)
}
