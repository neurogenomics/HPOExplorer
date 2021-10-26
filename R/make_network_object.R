#' Make network object
#'
#' This uses the network package to coerce the adjacency matrix into a
#' network object. It also adds the fold change, label, and relative ontology level
#' parameters to each node in the network.
#'
#' It expects there to be a column of HPO IDs in the phenos dataframe called
#' HPO_Id.
#'
#' @param phenos dataframe of phenotypes and values/ parameters.
#' @param adjacency adjacency matrix (see ?adjacency_matrix) <matrix>
#' @param hpo The HPO ontology data object
#' @param colour_column The column from phenos that you wish to map to node colour
#' @import network
#' @examples
#' \dontrun{make_network_object(phenos,adjacency,hpo, colour_column = "fold_change")}
#' @returns A ggnetowrk graph/ network object of a subset of the RD EWCE results.
#' @export
make_network_object = function (phenos, adjacency, hpo, colour_column = "fold_change") {
  create_node_data <- function(phenoNet, phenos, phenos_column) {
    nodeData <- c()
    for (p in phenoNet$vertex.names) {
      nodeData <- append(nodeData, phenos[,phenos_column][phenos$HPO_Id == p][1])
    }
    return (nodeData)
  }

  adjacency <- adjacency[phenos$HPO_Id,phenos$HPO_Id]

  hierarchy <- get_relative_ont_level_multiple(adjacency,hpo,reverse=TRUE) + 1
  names(hierarchy) <- rownames(adjacency)
  phenos$hierarchy <- hierarchy[phenos$HPO_Id]

  phenoNet <- ggnetwork::ggnetwork(adjacency, arrow.gap=0)
  phenoNet$hover <- create_node_data(phenoNet, phenos, "hover")
  phenoNet$hierarchy <- create_node_data(phenoNet, phenos, "hierarchy")
  phenoNet$label <- create_node_data(phenoNet, phenos, "Phenotype")
  phenoNet[,colour_column] <- create_node_data(phenoNet, phenos, colour_column)

  return(phenoNet)
}
