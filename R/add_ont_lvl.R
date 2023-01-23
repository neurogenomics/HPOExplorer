#' Add ontology level
#'
#' Add the relative ontology level for each HPO ID.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table merge.data.table .EACHI
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenos2 <- add_ont_lvl(phenos = phenos)
add_ont_lvl <- function(phenos,
                        hpo = get_hpo(),
                        adjacency =
                          adjacency_matrix(terms = phenos$HPO_ID,
                                           hpo = hpo),
                         verbose=TRUE){

  ontLvl_geneCount_ratio <- geneCount <- HPO_ID <- ontLvl <- NULL;

  lvls_dict <- get_ont_lvls(terms = unique(phenos$HPO_ID),
                            hpo = hpo,
                            adjacency = adjacency,
                            verbose = TRUE)
  phenos[,ontLvl:=lvls_dict[HPO_ID]]
  messager("Computing ontology level / gene count ratio",v=verbose)
  if("geneCount" %in% names(phenos)){
    phenos[,ontLvl_geneCount_ratio:=(ontLvl/geneCount)]
  }
  return(phenos)
}
