map_upheno_rainplot <- function(plot_dat){

  requireNamespace("ggplot2")
  requireNamespace("ggdist")
  requireNamespace("tidyquant")


  ### Plot proportion of intersecting orthologs per ontology ####
  ggplot(plot_dat,
         aes(x=paste0(subject_taxon_label2,
                      "\n(n = ",n_phenotypes," phenotypes)"),
             y=(n_genes_intersect/n_genes_db1),
             fill=factor(db2))) +
    facet_grid(db1~.,
               scales = "free_y",
               space = "free_y") +
    # add half-violin from {ggdist} package
    ggdist::stat_halfeye(
      # adjust bandwidth
      adjust = 0.5,
      # move to the right
      justification = -0.1,
      # remove the slub interval
      .width = 0,
      point_colour = NA
    ) +
    geom_boxplot(
      show.legend = FALSE,
      width = 0.12,
      # removing outliers
      outlier.color = NA,
      alpha = 0.5
    ) +
    # ggdist::stat_dots(
    #   aes(color=factor(db2)),
    #   show.legend = FALSE,
    #   # ploting on left side
    #   side = "left",
    #   # adjusting position
    #   justification = 1.1,
    #   # adjust grouping (binning) of observations
    #   # binwidth = 0.25
    # ) +
    # Themes and Labels
    tidyquant::scale_fill_tq() +
    tidyquant::scale_color_tq() +
    tidyquant::theme_tq() +
    coord_flip() +
    labs(x="Species",
         fill="Ontology")
}
