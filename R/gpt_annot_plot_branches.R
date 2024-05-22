#' Plot annotations from GPT: by branch
#'
#' Plot annotations from GPT by ancestral HPO branch.
#' @param gpt_annot Output from \link{gpt_annot_read}.
#' @param metric Annotation metric to use (name of column in \code{gpt_annot}).
#' @param fill_lab Fill label in legend.
#' @param show_plot Show the plot.
#' @inheritParams gpt_annot_check
#' @inheritParams add_ont_lvl
#' @inheritParams add_ancestor
#' @param metric Annotation metric to plot.
#' @returns Named list of plot and data.
#'
#' @export
#' @examples
#' out <- gpt_annot_plot_branches()
gpt_annot_plot_branches <- function(hpo=get_hpo(),
                                    gpt_annot = gpt_annot_read(hpo = hpo),
                                    keep_descendants=NULL,
                                    keep_ont_levels=NULL,
                                    metric="congenital_onset",
                                    fill_lab=gsub("_"," ",metric),
                                    show_plot=TRUE){
  hpo_name <- n <- ancestor_name <- NULL;

  metric <- metric[1]
  gpt_annot <- add_ancestor(gpt_annot,
                            keep_descendants = keep_descendants,
                            hpo = hpo)
  gpt_annot <- add_ont_lvl(gpt_annot,
                           keep_ont_levels=keep_ont_levels,
                           hpo = hpo)
  branches_dt <- gpt_annot[,list(n=data.table::uniqueN(hpo_name)),
                           by=c("ancestor_name",metric)]
  branches_dt[,c("proportion_always",
                 "proportion_often"):=list(
                   sum(n[get(metric) %in% c("always")], na.rm = TRUE)/
                     sum(n, na.rm = TRUE),
                   sum(n[get(metric) %in% c("often")], na.rm = TRUE)/
                     sum(n, na.rm = TRUE)
                 ),
              by=c("ancestor_name")]
  data.table::setorderv(branches_dt,c("proportion_always","proportion_often"),
                        c(-1), na.last = TRUE)
  branches_dt[,c(metric):=factor(
    get(metric),
    levels=c("always","often","rarely","never",NA),
    ordered = TRUE)]
  branches_dt[,ancestor_name:=factor(
    ancestor_name,
    levels=unique(branches_dt$ancestor_name),
    ordered = TRUE)]
#
#   ggstatsplot::ggbarstats(branches_dt[!is.na(get(metric))],
#                           x="ancestor_name",
#                           y="n",fill=metric)
  p <- ggplot2::ggplot(branches_dt[!is.na(get(metric))],
                  ggplot2::aes(x=ancestor_name,
                               y=n,
                               fill=!!ggplot2::sym(metric))) +
    ggplot2::geom_bar(stat = "identity",position = "fill") +
    ggplot2::scale_fill_brewer(palette = "GnBu", direction = -1) +
    ggplot2::scale_y_continuous(labels = scales::percent) +
    ggplot2::labs(x="HPO ancestor",
                  y="Phenotypes",
                  fill=fill_lab) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, vjust = .5))

  if(show_plot) methods::show(p)
  return(list(data=branches_dt,
              plot=p))
}
