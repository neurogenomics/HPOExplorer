#' @describeIn make_ make_
#' Generate network plot
#'
#' This creates a network plot.
#' It makes it possible to hover box that includes your results related to
#' each phenotype and/or a description of the phenotypes.
#' @param method Method to construct plot with.
#' @inheritParams main
#' @inheritParams KGExplorer::plot_
#' @inheritParams KGExplorer::add_hoverboxes
#' @inheritDotParams make_network_object
#' @returns A named list containing the graph data and the plot.
#'
#' @export
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' plt <- make_network_plot(phenos = phenos)
make_network_plot <- function(phenos,
                              colour_var = "ontLvl",
                              size_var = colour_var,
                              label_var = "hpo_name",
                              interactive = TRUE,
                              show_plot = TRUE,
                              hoverbox_column = "hover",
                              preferred_palettes="brewer.reds",
                              method=c("ggnetwork","visnetwork"),
                              ...) {
  method <- match.arg(method)
  if(method=="ggnetwork"){
    g <- make_network_object(phenos = phenos,
                             colour_var = colour_var,
                             as = "ggnetwork",
                             ...)
    #### Create plot ####
    KGExplorer::plot_ggnetwork(g = g,
                               colour_var = colour_var,
                               size_var = size_var,
                               label_var=label_var,
                               hoverbox_column = hoverbox_column,
                               interactive=interactive,
                               show_plot=show_plot,
                               ...)
  } else {
    g <- make_network_object(phenos = phenos,
                             colour_var = colour_var,
                             as = "tbl_graph",
                             ...)
    KGExplorer::plot_graph_visnetwork(g,
                                      colour_var = colour_var,
                                      size_var = size_var,
                                      label_var = label_var,
                                      selectedBy = label_var,
                                      preferred_palettes=preferred_palettes,
                                      ...)
  }
}
