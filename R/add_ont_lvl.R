#' Add ontology level
#'
#' Add the relative ontology level for each HPO ID.
#' @inheritParams get_ont_lvls
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
                        adjacency = NULL,
                        absolute = TRUE,
                        exclude_top_lvl = TRUE,
                        reverse = TRUE,
                        verbose = TRUE){

  ontLvl_geneCount_ratio <- geneCount <- HPO_ID <- ontLvl <- tmp <- NULL;

  col <- if(isTRUE(absolute)) "ontLvl" else "ontLvl_relative"
  if(col %in% names(phenos)) return(phenos)
  if("HPO_ID" %in% names(phenos)){
    lvls_dict <- get_ont_lvls(terms = unique(phenos$HPO_ID),
                              hpo = hpo,
                              adjacency = adjacency,
                              absolute = absolute,
                              reverse = reverse,
                              exclude_top_lvl = exclude_top_lvl,
                              verbose = verbose)
    #### Add the new column ####
    phenos[,tmp:=lvls_dict[HPO_ID]]

    data.table::setnames(phenos,old = "tmp", new = col)
    #### Compute gene ratio ####
    if(all(c("ontLvl","geneCount") %in% names(phenos))){
      messager("Computing ontology level / gene count ratio.",v=verbose)
      phenos[,ontLvl_geneCount_ratio:=(ontLvl/geneCount)]
    }
  } else {
    messager("HPO_ID column not found. Cannot add ontology level.",v=verbose)
  }
  return(phenos)
}
