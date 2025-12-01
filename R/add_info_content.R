#' @describeIn add_ add_
#' Add information content
#'
#' Add a column containing the information content score  for each HPO ID.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @import simona
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_info_content(phenos = phenos)
add_info_content <- function(phenos,
                             hpo = get_hpo(),
                             force_new=FALSE){
  info_content <- hpo_id <- NULL;

  if(!"info_content" %in% names(phenos) | isTRUE(force_new)){
    messager("Adding information_content scores.")
    if(!"IC" %in% names(hpo@elementMetadata)){
      simona::mcols(hpo)$IC <- simona::term_IC(hpo)
    }
    ic_dict <- KGExplorer::get_ontology_dict(ont=hpo,
                                             to = "IC")
    phenos[,info_content:=ic_dict[hpo_id]]
  }
  return(phenos)
}
