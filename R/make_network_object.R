#' Make network object
#'
#' This uses the network package to coerce the adjacency matrix into a
#' network object. It also adds the fold change, label,
#' and relative ontology level parameters to each node in the network.
#'
#' It expects there to be a column of HPO IDs in the phenos dataframe called
#' HPO_ID.
#' @param phenos dataframe of phenotypes and values / parameters.
#' @param adjacency AN adjacency matrix generated
#' by \link[HPOExplorer]{adjacency_matrix}.
#' @param colour_var The column from phenos that you wish
#' to map to node colour.
#' @param add_ontLvl Add the "ontLvl" (ontology level)
#' column if not already present.
#' @inheritParams make_phenos_dataframe
#' @returns A ggnetwork graph/ network object of a subset of the RD EWCE results.
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
                                adjacency =
                                  adjacency_matrix(
                                    terms = phenos$HPO_ID,
                                    hpo = hpo),
                                colour_var = "fold_change",
                                add_ontLvl = FALSE,
                                verbose = TRUE) {

    messager("Making phenotype network object.",v=verbose)
    adjacency <- adjacency[phenos$HPO_ID, phenos$HPO_ID]
    if(!"ontLvl" %in% names(phenos) &&
       isTRUE(add_ontLvl)){
      phenos <- add_ont_lvl(phenos = phenos,
                            hpo = hpo,
                            adjacency = adjacency,
                            verbose = verbose)
    }
    #### Create phenoNet obj ####
    messager("Creating ggnetwork object.",v=verbose)
    phenoNet <- ggnetwork::ggnetwork(x = adjacency,
                                     arrow.gap = 0)
    #### Add metadata to phenoNet ####
    phenoNet <- create_node_data(phenoNet = phenoNet,
                                 phenos = phenos,
                                 phenos_column = "hover",
                                 verbose = verbose)
    phenoNet <- create_node_data(phenoNet = phenoNet,
                                 phenos = phenos,
                                 phenos_column = "ontLvl",
                                 verbose = verbose)
    phenoNet <- create_node_data(phenoNet = phenoNet,
                                 phenos = phenos,
                                 phenos_column = "Phenotype",
                                 new_column = "label",
                                 verbose = verbose)
    phenoNet <- create_node_data(phenoNet = phenoNet,
                                 phenos = phenos,
                                 phenos_column = colour_var,
                                 verbose = verbose)
    #### Add number of total edges for each node ####
    phenoNet$n_edges <- rowSums(adjacency)[phenoNet$vertex.names]
    phenoNet <- unique(phenoNet)
    return(phenoNet)
}
