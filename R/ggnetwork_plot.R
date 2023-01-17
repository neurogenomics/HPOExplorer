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
#' @param colour_label A label for the colour figure legend \<string\>.
#' @param interactive Make the plot interactive with \link[plotly]{ggplotly}.
#' @param verbose Print messages.
#' @inheritParams plotly::ggplotly
#' @inheritDotParams plotly::ggplotly
#' @returns A network plot (compatible with interactive plotly rendering).
#'
#' @export
#' @import ggplot2
#' @importFrom ggnetwork geom_edges
#' @importFrom plotly ggplotly layout
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenoNet <- make_network_object(phenos = phenos,
#'                                 colour_column = "ontLvl_geneCount_ratio")
#' plt <- ggnetwork_plot(phenoNet = phenoNet,
#'                       colour_column = "ontLvl_geneCount_ratio",
#'                       colour_label = "ontLvl_genes")
ggnetwork_plot <- function(phenoNet,
                           colour_column = "fold_change",
                           colour_label = gsub("_","",colour_column),
                           interactive = TRUE,
                           tooltip = "hover",
                           verbose = TRUE,
                           ...) {
  requireNamespace("ggplot2")
  x <- y <- xend <- yend <- hover <- label <- NULL;

  messager("Creating ggnetwork plot.",v=verbose)
  network_plot <- ggplot(phenoNet,
                         aes(x = x,
                             y = y,
                             xend = xend,
                             yend = yend,
                             text = hover)) +
      ggnetwork::geom_edges(color = "darkgray") +
      geom_point(aes_string(colour = colour_column,
                            size = "hierarchy")) + # , text= hover)) +
      geom_text(aes(label = label), color = "black") +
      scale_colour_gradient2(low = "white", mid = "yellow", high = "red") +
      scale_size(trans = "exp") +
      guides(size = "none") +
      labs(colour = colour_label) +
      theme_void() #  use tooltip = "hover" with ggplotly for hover box

  if(isTRUE(interactive)){
    return(plotly::ggplotly(p = network_plot,
                            tooltip = tooltip,
                            ...) |> plotly::layout(
                              hoverlabel = list(align = "left")))
  } else {
    return(network_plot)
  }
}
