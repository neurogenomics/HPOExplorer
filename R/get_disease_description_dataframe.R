#' Generate HPO disease description dataframe
#'
#' This function will interact with the HPO API to create a dataframe that
#' contains a column of HPO IDs and a column of short descriptions describing
#' the phenotype.
#'
#' This can take a while to run on a large number of IDs so it is recommended
#' that you do it once and save the dataframe.
#' @param HPO_ids A character vector of HPO Ids
#' @param verbose Print messages.
#' @returns A dataframe of HPO phenotype descriptions
#'
#' @export
#' @importFrom stats setNames
#' @importFrom data.table as.data.table
#' @examples
#' genedata <- load_phenotype_to_genes()
#' HPO_ids <- unique(genedata$ID)[seq_len(5)]
#' description_df <- get_disease_description_dataframe(HPO_ids)
get_disease_description_dataframe <- function(HPO_ids,
                                              verbose=TRUE) {

  messager("Gathering descriptions for",
           formatC(length(HPO_ids),
                   big.mark = ","),"HPO_ids.",v=verbose)
  definitions <- get_term_definition(ontologyId = HPO_ids)
  description_df <- data.table::as.data.table(
    list(description=unname(definitions),
         HPO_id=names(definitions))
  )
  return(description_df)
}
