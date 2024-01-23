#' @describeIn make_ make_
#' Make an \link[igraph]{igraph} object
#'
#' This uses the network package to coerce the adjacency matrix into a
#' network object. It also adds the fold change, label,
#' and relative ontology level parameters to each node in the network.
#'
#' It expects there to be a column of HPO IDs in the phenos dataframe called
#' hpo_id.
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @returns A \link[igraph]{igraph} object.
#'
#' @export
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' g <- make_igraph_object(phenos = phenos)
make_igraph_object <- function(phenos,
                               hpo = get_hpo(),
                               colour_var = "fold_change",
                               cols = list_columns(
                                 extra_cols = c(
                                   colour_var,
                                   grep("_count$|_values$",
                                        names(phenos),
                                        value = TRUE)
                                 )
                               ),
                               ...
                               ){
  requireNamespace("tidygraph")
  g <- KGExplorer::ontology_to(ont = hpo,
                               terms = phenos$hpo_id,
                               to = "tbl_graph")
  g <- KGExplorer::filter_graph(g,
                                filters = list(name=phenos$hpo_id))
  pcols <- intersect(names(phenos), names(cols))
  gcols <- KGExplorer::get_graph_colnames(g)
  cols <- setdiff(pcols, gcols)
  if(length(cols)>0){
    phenos <- phenos[,cols,with=FALSE]
    g <- g |> tidygraph::activate("nodes") |>
      tidygraph::left_join(by=c("name" = "hpo_id"),
                           phenos)
  }
  return(g)
}
