#' Add information content
#'
#' Add a column containing the information content score  for each HPO ID.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table :=
#' @importFrom ontologyIndex get_term_info_content
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_info_content(phenos = phenos)
add_info_content <- function(phenos,
                             hpo = get_hpo(),
                             verbose = TRUE){
  info_content <- HPO_ID <- NULL;

  if(!"info_content" %in% names(phenos)){
    messager("Adding information_content scores.",v=verbose)
    ic_dict <- ontologyIndex::get_term_info_content(
      ontology = hpo,
      term_sets = phenos$HPO_ID,
      patch_missing = FALSE)
    phenos[,info_content:=ic_dict[HPO_ID]]
  }
  return(phenos)
}
