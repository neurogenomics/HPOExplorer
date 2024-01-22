#' @describeIn make_ make_
#' Make a \link[ggnetwork]{ggnetwork} object
#'
#' This uses the network package to coerce the adjacency matrix into a
#' network object. It also adds the fold change, label,
#' and relative ontology level parameters to each node in the network.
#'
#' It expects there to be a column of HPO IDs in the phenos dataframe called
#' hpo_id.
#' @param colour_var The column from phenos that you wish
#' to map to node colour.
#' @param cols Columns to add to metadata of \link[ggnetwork]{ggnetwork} object.
#' @inheritParams ggnetwork::fortify
#' @inheritDotParams ggnetwork::fortify
#' @returns A \link[ggnetwork]{ggnetwork} object.
#'
#' @export
#' @import network
#' @importFrom ggnetwork ggnetwork
#' @importFrom data.table as.data.table
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenoNet <- make_network_object(phenos = phenos,
#'                                 colour_var = "ontLvl_geneCount_ratio")
make_network_object <- function(phenos,
                                hpo = get_hpo(),
                                colour_var = "fold_change",
                                add_ont_lvl_absolute = FALSE,
                                cols = list_columns(
                                  extra_cols = c(
                                    colour_var,
                                    grep("_count$|_values$",
                                         names(phenos),
                                         value = TRUE)
                                    )
                                  ),
                                as=c("ggnetwork","tbl_graph"),
                                ...) {
  as <- match.arg(as)
  messager("Making phenotype network object.")
  if(!"ontLvl" %in% names(phenos) &&
     isTRUE(add_ont_lvl_absolute)){
    phenos <- add_ont_lvl(phenos = phenos,
                          hpo = hpo,
                          absolute = TRUE)
  }
  #### Create phenoNet obj ####
  g <- make_igraph_object(phenos,
                          hpo = hpo,
                          colour_var = colour_var,
                          cols = cols)
  #### Return tbl_graph object if requested ####
  if(as == "tbl_graph")  return(g)
  #### Proceed to convert to ggnetwork object ####
  messager("Creating ggnetwork object.")
  phenoNet <- ggnetwork::fortify(g,
                                 ...)
  cols <- cols[cols %in% names(phenos)]
  #### No longer needed as make_igraph_object() adds these columns ####
  # for(col in cols){
  #   #### Add metadata to phenoNet ####
  #   phenoNet <- make_node_data(phenoNet = phenoNet,
  #                              phenos = phenos,
  #                              phenos_column = col)
  # }
  phenoNet <- unique(phenoNet)
  return(phenoNet)
}
