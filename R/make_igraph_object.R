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
#' @inheritParams ggnetwork::fortify.network
#' @inheritDotParams ggnetwork::ggnetwork
#' @returns A \link[igraph]{igraph} object.
#'
#' @export
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' g <- make_igraph_object(phenos = phenos)
make_igraph_object <- function(phenos,
                               hpo = get_hpo(),
                               adjacency = adjacency_matrix(
                                 terms = phenos$hpo_id,
                                 hpo = hpo),
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
                               layout = "fruchtermanreingold",
                               verbose = TRUE,
                               ...
                               ){
  requireNamespace("igraph")
  phenoNet <- make_network_object(phenos = phenos,
                                  hpo = hpo,
                                  adjacency = adjacency,
                                  colour_var = colour_var,
                                  add_ont_lvl_absolute = add_ont_lvl_absolute,
                                  cols = cols,
                                  verbose = verbose,
                                  ...)
  messager("Creating igraph object.",v=verbose)
  vertices <- unique(
    phenoNet[,!names(phenoNet) %in% c("x","y","vertex.names","xend","yend")]
  )
  rownames(vertices) <- vertices$hpo_id
  g <- igraph::graph_from_adjacency_matrix(adjacency)
  for(n in names(vertices)){
    igraph::vertex_attr(g,name = n) <- vertices[names(igraph::V(g)),n]
  }
  return(g)
}
