#' Make network object
#'
#' This uses the network package to coerce the adjacency matrix into a
#' network object. It also adds the fold change, label,
#' and relative ontology level parameters to each node in the network.
#'
#' It expects there to be a column of HPO IDs in the phenos dataframe called
#' HPO_Id.
#'
#' @param phenos dataframe of phenotypes and values/ parameters.
#' @param adjacency adjacency matrix (see \code{\?adjacency_matrix}) \<matrix\>
#' @param hpo The HPO ontology data object
#' @param colour_column The column from phenos that you wish
#' to map to node colour.
#' @param verbose Print messages.
#' @returns A ggnetwork graph/ network object of a subset of the RD EWCE results.
#'
#' @export
#' @import network
#' @importFrom data.table data.table
#' @examples
#' library(ontologyIndex)
#' data(hpo)
#' phenos = make_phenos_dataframe(hpo = hpo,
#'                                ancestor = "Neurodevelopmental delay",
#'                                add_description = FALSE)
#' phenos <- make_hoverboxes(phenos_dataframe = phenos)
#' adjacency <- adjacency_matrix(pheno_ids = unique(phenos$HPO_Id),
#'                               hpo = hpo)
#' phenoNet <- make_network_object(phenos = phenos,
#'                                 adjacency = adjacency,
#'                                 hpo = hpo,
#'                                 colour_column = "ontLvl_geneCount_ratio")
make_network_object <- function(phenos,
                                adjacency,
                                hpo,
                                colour_column = "fold_change",
                                verbose = TRUE) {

    phenos <- data.table::data.table(phenos)
    adjacency <- adjacency[phenos$HPO_Id, phenos$HPO_Id]
    hierarchy <- get_relative_ont_level_multiple(phenoAdj = adjacency,
                                                 hpo = hpo,
                                                 reverse = TRUE) + 1
    names(hierarchy) <- rownames(adjacency)
    phenos$hierarchy <- hierarchy[phenos$HPO_Id]
    phenoNet <- ggnetwork::ggnetwork(adjacency, arrow.gap = 0)
    #### Add meteadata to phenoNet ####
    phenoNet$hover <- create_node_data(phenoNet = phenoNet,
                                       phenos = phenos,
                                       phenos_column = "hover",
                                       verbose = verbose)
    phenoNet$hierarchy <- create_node_data(phenoNet = phenoNet,
                                           phenos = phenos,
                                           phenos_column = "hierarchy",
                                           verbose = verbose)
    phenoNet$label <- create_node_data(phenoNet = phenoNet,
                                       phenos = phenos,
                                       phenos_column = "Phenotype",
                                       verbose = verbose)
    phenoNet[,colour_column] <- create_node_data(phenoNet = phenoNet,
                                                  phenos = phenos,
                                                  phenos_column = colour_column)
    return(phenoNet)
}
