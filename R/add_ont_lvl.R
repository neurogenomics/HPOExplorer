#' Add ontology level
#'
#' Add the relative ontology level for each HPO ID.
#' @param keep_ont_levels Only keep phenotypes at certain \emph{absolute}
#'  ontology levels to keep.
#' See \link[HPOExplorer]{add_ont_lvl} for details.
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
                        keep_ont_levels = NULL,
                        reverse = TRUE,
                        verbose = TRUE){

  ontLvl_geneCount_ratio <- geneCount <- hpo_id <- ontLvl <- tmp <- NULL;

  col <- if(isTRUE(absolute)) "ontLvl" else "ontLvl_relative"
  if(col %in% names(phenos)) return(phenos)
  if("hpo_id" %in% names(phenos)){
    lvls_dict <- get_ont_lvls(terms = unique(phenos$hpo_id),
                              hpo = hpo,
                              adjacency = adjacency,
                              absolute = absolute,
                              reverse = reverse,
                              exclude_top_lvl = exclude_top_lvl,
                              verbose = verbose)
    #### Add the new column ####
    phenos[,tmp:=lvls_dict[hpo_id]]
    data.table::setnames(phenos,old = "tmp", new = col)
    #### Compute gene ratio ####
    if(all(c("ontLvl","geneCount") %in% names(phenos))){
      messager("Computing ontology level / gene count ratio.",v=verbose)
      phenos[,ontLvl_geneCount_ratio:=(ontLvl/geneCount)]
    }
  } else {
    messager("hpo_id column not found. Cannot add ontology level.",v=verbose)
  }
  #### Filter ####
  if(!is.null(keep_ont_levels)){
    phenos <- phenos[ontLvl %in% keep_ont_levels,]
  }
  return(phenos)
}
