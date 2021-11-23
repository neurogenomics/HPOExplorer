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
#' to map to node colour
#' @import network
#' @examples
#' \dontrun{
#' make_network_object(phenos, adjacency, hpo, colour_column = "fold_change")
#' }
#' @returns A ggnetowrk graph/ network object of a subset of the RD EWCE results.
#'
#' @examples
#' library(ontologyIndex)
#' data(hpo)
#' phenotype_to_genes <- load_phenotype_to_genes()
#' Neuro_delay_ID <- get_hpo_termID_direct(hpo = hpo,
#'                                         phenotype = "Neurodevelopmental delay")
#' Neuro_delay_descendants <- phenotype_to_genes[
#'     phenotype_to_genes$ID %in% get_descendants(hpo,Neuro_delay_ID),]
#'
#' phenos = data.frame()
#' for (p in unique(Neuro_delay_descendants$Phenotype)) {
#'     id <- get_hpo_termID(phenotype = p,
#'                          phenotype_to_genes = phenotype_to_genes)
#'     ontLvl_geneCount_ratio <- (get_ont_level(hpo = hpo,
#'                                              term_ids = p) + 1)/length(get_gene_list(p,phenotype_to_genes))
#'     description <- get_term_definition(ontologyId = id,
#'                                        line_length = 10)
#'     phenos <- rbind(phenos,
#'                     data.frame("Phenotype"=p,
#'                                "HPO_Id"=id,
#'                                "ontLvl_geneCount_ratio"=ontLvl_geneCount_ratio,
#'                                "description"=description))
#' }
#'
#' phenoAdj <- adjacency_matrix(unique(phenos$HPO_Id), hpo)
#' phenoNet <- make_network_object(phenos,phenoAdj, hpo, colour_column = "ontLvl_geneCount_ratio")
#'
#' @export
make_network_object <- function(phenos,
                                adjacency,
                                hpo,
                                colour_column = "fold_change") {
    create_node_data <- function(phenoNet, phenos, phenos_column) {
        nodeData <- c()
        for (p in phenoNet$vertex.names) {
            nodeData <- append(nodeData,
                               phenos[, phenos_column][phenos$HPO_Id == p][1])
        }
        return(nodeData)
    }

    adjacency <- adjacency[phenos$HPO_Id, phenos$HPO_Id]

    hierarchy <- get_relative_ont_level_multiple(phenoAdj = adjacency,
                                                 hpo = hpo,
                                                 reverse = TRUE) + 1
    names(hierarchy) <- rownames(adjacency)
    phenos$hierarchy <- hierarchy[phenos$HPO_Id]

    phenoNet <- ggnetwork::ggnetwork(adjacency, arrow.gap = 0)
    phenoNet$hover <- create_node_data(phenoNet, phenos, "hover")
    phenoNet$hierarchy <- create_node_data(phenoNet, phenos, "hierarchy")
    phenoNet$label <- create_node_data(phenoNet, phenos, "Phenotype")
    phenoNet[, colour_column] <- create_node_data(phenoNet, phenos, colour_column)

    return(phenoNet)
}
