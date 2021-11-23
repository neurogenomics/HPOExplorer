#' Generate network plot
#'
#' This creates a network plot which is compatible with plotly
#'  to make interactive plots.
#' It makes it possible to hover box that includes your results related to
#' each phenotype and/or a description of the phenotypes.
#'
#' @param phenoNet The network object created using create_network_object
#' @param colour_column column name of the variable to be mapped
#'  to colour \<string\>
#' @param colour_label A label for the colour figure legend \<string\>
#'
#' @examples
#' library(ontologyIndex)
#' data(hpo)
#' phenotype_to_genes <- load_phenotype_to_genes()
#' Neuro_delay_ID <- get_hpo_termID_direct(hpo = hpo,
#'                                         phenotype = "Neurodevelopmental delay")
#' Neuro_delay_descendants <- phenotype_to_genes[
#'     phenotype_to_genes$ID %in% get_descendants(hpo,Neuro_delay_ID),]
#' phenoAdj <- adjacency_matrix(unique(phenos$HPO_Id), hpo)
#' phenoNet <- make_network_object(phenos,phenoAdj, hpo, colour_column = "ontLvl_geneCount_ratio")
#' plt <- ggnetwork_plot(phenoNet = phenoNet,
#'                       colour_column = "ontLvl_geneCount_ratio",
#'                       colour_label = "OntLvl/nGenes")
#'
#' @returns A network plot (compatible with interactive plotly rendering).
#' @import ggplot2
#' @export
ggnetwork_plot <- function(phenoNet,
                           colour_column = "fold_change",
                           colour_label = "Fold change") {
    message("ggnetwork_plot")
    network_plot <- ggplot(phenoNet, aes(x = x, y = y, xend = xend, yend = yend, text = hover)) +
        ggnetwork::geom_edges(color = "darkgray") +
        geom_point(aes_string(colour = colour_column, size = "hierarchy")) + # , text= hover)) +
        geom_text(aes(label = label), color = "black") +
        scale_colour_gradient2(low = "white", mid = "yellow", high = "red") +
        scale_size(trans = "exp") +
        guides(size = "none") +
        labs(colour = colour_label) +
        theme_void() #  use tooltip = "hover" with ggplotly for hover box
    return(network_plot)
}
