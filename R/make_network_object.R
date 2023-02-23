#' Make a \link[ggnetwork]{ggnetwork} object
#'
#' This uses the network package to coerce the adjacency matrix into a
#' network object. It also adds the fold change, label,
#' and relative ontology level parameters to each node in the network.
#'
#' It expects there to be a column of HPO IDs in the phenos dataframe called
#' HPO_ID.
#' @param phenos dataframe of phenotypes and values / parameters.
#' @param adjacency An adjacency matrix generated
#' by \link[HPOExplorer]{adjacency_matrix}.
#' @param colour_var The column from phenos that you wish
#' to map to node colour.
#' @param cols Columns to add to metadata of \link[ggnetwork]{ggnetwork} object.
#' @inheritParams make_phenos_dataframe
#' @inheritParams ggnetwork::fortify.network
#' @inheritDotParams ggnetwork::ggnetwork
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
                                adjacency =
                                  adjacency_matrix(
                                    terms = phenos$HPO_ID,
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
                                ...) {

    messager("Making phenotype network object.",v=verbose)
    if("HPO_ID" %in% names(phenos)){
      adjacency <- adjacency[unique(phenos$HPO_ID),
                             unique(phenos$HPO_ID)]
    }
    if(!"ontLvl" %in% names(phenos) &&
       isTRUE(add_ont_lvl_absolute)){
      phenos <- add_ont_lvl(phenos = phenos,
                            hpo = hpo,
                            absolute = TRUE,
                            verbose = verbose)
    }
    #### Create phenoNet obj ####
    messager("Creating ggnetwork object.",v=verbose)
    phenoNet <- ggnetwork::ggnetwork(x = adjacency,
                                     arrow.gap = 0,
                                     layout = layout,
                                     ...)
    cols <- cols[cols %in% names(phenos)]
    for(col in cols){
      #### Add metadata to phenoNet ####
      phenoNet <- create_node_data(phenoNet = phenoNet,
                                   phenos = phenos,
                                   phenos_column = col,
                                   verbose = verbose)
    }
    #### Add number of total edges for each node ####
    if("HPO_ID" %in% names(phenos)){
      messager("Adding n_edges per node.",v=verbose)
      phenoNet$n_edges <- rowSums(adjacency)[phenoNet$vertex.names]
    }
    phenoNet <- unique(phenoNet)
    return(phenoNet)
}
