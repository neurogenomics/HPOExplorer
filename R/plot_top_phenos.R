#' Plot top phenotypes
#'
#' Plot the most severe phenotypes per severity class:
#'  Profound, Severe, Moderate, Mild.
#' The exception to this is the "Mild" class, where the \emph{least}
#'  severe phenotypes will be taken instead of the most severe phenotypes.
#' @param res_class Output of the \link{gpt_annot_class} function.
#' @param n_per_class Number of phenotypes per severity class to include.
#' @param annotation_order The order of the annotations to include.
#' @param split_by_congenital Split the phenotypes by congenital onset
#' (congenital = always/often, noncongenital = never/rarely).
#' @inheritParams add_ont_lvl
#' @inheritParams add_ancestor
#' @export
#' @examples
#' res_class <- gpt_annot_class()
#' out <- plot_top_phenos(res_class = res_class)
plot_top_phenos <- function(res_class = gpt_annot_class(),
                            keep_ont_levels = seq(3,17),
                            keep_descendants = "Phenotypic abnormality",
                            n_per_class = 10,
                            annotation_order=NULL,
                            split_by_congenital=TRUE){
  requireNamespace("ggplot2")
  requireNamespace("colorspace")

  get_top_phenos_out <- get_top_phenos(
    res_class = res_class,
    keep_ont_levels = keep_ont_levels,
    keep_descendants = keep_descendants,
    n_per_class = n_per_class,
    annotation_order = annotation_order,
    split_by_congenital = split_by_congenital)
  plot_top_phenos_i <- function(dt,
                                title=NULL,
                                show.legend=TRUE,
                                xlab="Clinical characteristic",
                                ylab="HPO phenotype",
                                direction = 1,
                                limits=NULL){
    # devoptera::args2vars(plot_top_phenos_i, run_source_all = FALSE)
    variable <- hpo_name <- value <- NULL;

    p1 <- ggplot2::ggplot(data = dt,
                          ggplot2::aes(x=variable, y=hpo_name,
                                       fill=factor(value))) +
      ggplot2::geom_tile(colour = "white", lwd = 0.5, linetype =1,
                         show.legend=show.legend) +
      ggplot2::scale_y_discrete(limits=rev) +
      ggplot2::scale_fill_brewer(palette = "GnBu",
                                 labels=c("0"="never","1"="rarely",
                                          "2"="often","3"="always"),
                                 direction = direction) +
      ggplot2::theme_classic() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
                     legend.position = 'right') +
      ggplot2::labs(x = xlab,
                    y = ylab,
                    subtitle=title,
                    fill = "Occurrence") +
      ggplot2::facet_grid(severity_class ~ ., scales = "free_y")

    p2 <- ggplot2::ggplot(data = dt,
                          ggplot2::aes(x="severity_score_gpt", y=hpo_name,
                                       fill=severity_score_gpt)) +
      ggplot2::geom_tile(show.legend=show.legend) +
      ggplot2::scale_y_discrete(limits=rev) +
      ggplot2::scale_fill_gradientn(colours = colorspace::heat_hcl(100),
                           trans = "reverse",
                           limits=limits
      ) +
      ggplot2::labs(x=NULL, y=NULL, fill = "Severity\nscore") +
      ggplot2::theme_void() +
      ggplot2::guides(fill = ggplot2::guide_colorbar(reverse = TRUE)) +
      ggplot2::theme(axis.text.y = ggplot2::element_blank(),
                     axis.ticks.y = ggplot2::element_blank(),
                     legend.position = 'right')
    p3 <- patchwork::wrap_plots(p1, p2, ncol = 2,
                                widths = c(1,.2),
                                guides = "collect")
    return(p3)
  }

  if(isTRUE(split_by_congenital)){
    severity_score_gpt <- rbind(get_top_phenos_out$congenital,
                                get_top_phenos_out$noncongenital
                                )$severity_score_gpt
    limits <- c(max(severity_score_gpt),min(severity_score_gpt))
    fig_top_phenos <- (
      plot_top_phenos_i(dt=get_top_phenos_out$congenital,
                        xlab = NULL,
                        show.legend = FALSE,
                        title="Congenital phenotypes",
                        limits=limits)
      |
        plot_top_phenos_i(get_top_phenos_out$noncongenital,
                        xlab = NULL,
                        ylab = NULL,
                        title="Non-congenital phenotypes",
                        limits=limits)
    ) + patchwork::plot_layout(guides = "collect",
                               axes = "collect",
                               axis_titles = "collect") +
      patchwork::plot_annotation(tag_levels = "a")

  } else {
    limits <- c(max(get_top_phenos_out$severity_score_gpt),
                min(get_top_phenos_out$severity_score_gpt))
    fig_top_phenos <- plot_top_phenos_i(get_top_phenos_out,
                                        limits=limits)
  }
  return(
    list(
      data=get_top_phenos_out,
      plot=fig_top_phenos
    )
  )
}


