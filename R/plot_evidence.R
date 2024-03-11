#' Plot evidence
#'
#' Plot the distribution of evidence scores for gene-disease and gene-phenotype
#' associations.
#' @param metric Aggregated metric of evidence to assess.
#' @inheritParams make_
#' @inheritParams KGExplorer::plot_save
#'
#' @export
#' @examples
#' out <- plot_evidence()
plot_evidence <- function(metric="evidence_score_sum",
                          phenotype_to_genes=load_phenotype_to_genes(),
                          show_plot=TRUE,
                          save_path=NULL,
                          height=NULL,
                          width=NULL){
  requireNamespace("ggplot2")
  requireNamespace("patchwork")

  plot_hist <- function(dat,
                        xvar,
                        color=NULL,
                        title=NULL){
    ggplot2::ggplot(dat,
                    ggplot2::aes(!!ggplot2::sym(xvar))
    ) +
      ggplot2::geom_histogram(fill=color, alpha=.7) +
      ggplot2::labs(title=title) +
      ggplot2::theme_bw()
  }

  gcc_disease_raw <- KGExplorer::get_gencc(agg_by = NULL)
  h1 <- plot_hist(gcc_disease_raw,
                  title="gcc_disease_raw",
                  xvar="evidence_score",
                  color="red")

  gcc_disease_agg <- KGExplorer::get_gencc()
  h2 <- plot_hist(gcc_disease_agg,
                  title="gcc_disease_agg",
                  xvar=metric,
                  color="red3")

  gcc_phenotype <- add_evidence(phenotype_to_genes,
                                all.x = FALSE)
  h3 <- plot_hist(gcc_phenotype,
                  title="gcc_phenotype",
                  xvar=metric,
                  color="purple")


  metric_agg <- paste0(metric,"_mean")
  gcc_phenotype_agg <- hpo_to_matrix(value.var = metric,
                                     phenotype_to_genes=phenotype_to_genes,
                                     fill = NA)|>
    as.matrix()|>
    as.data.frame() |>
    data.table::as.data.table(keep.rownames = "gene_symbol") |>
    data.table::melt.data.table(id.vars = c("gene_symbol"),
                                variable.name = "hpo_id",
                                value.name = metric_agg)
  h4 <- plot_hist(gcc_phenotype_agg[!is.na(get(metric_agg))],
                  title="gcc_phenotype_agg",
                  xvar=metric_agg,
                  color="purple3")

  metric_sd <- paste0(metric,"_sd")
  gcc_phenotype_agg_sd <- gcc_phenotype[!is.na(get(metric)),list(
    evidence_score_sum_min=min(get(metric),na.rm=TRUE),
    evidence_score_sum_max=max(get(metric),na.rm=TRUE),
    evidence_score_sum_mean=mean(get(metric),na.rm=TRUE),
    evidence_score_sum_sd=stats::sd(get(metric),na.rm=TRUE)),
    by=c("hpo_id","gene_symbol")]|>
    data.table::setorderv(metric_sd, -1,na.last = TRUE)
  h5 <- plot_hist(gcc_phenotype_agg_sd[!is.na(get(metric_sd))],
                  title="gcc_phenotype_agg_sd",
                  xvar=metric_sd,
                  color="purple4")

  pw <- patchwork::wrap_plots(h1,h2,h3,h4,h5, ncol = 1)
  if(isTRUE(show_plot)) methods::show(pw)

  KGExplorer::plot_save(plt=pw,
                        save_path=save_path,
                        height=height,
                        width=width)
  return(
    list(
      data=list(
        gcc_disease_raw=gcc_disease_raw,
        gcc_disease_agg=gcc_disease_agg,
        gcc_phenotype=gcc_phenotype,
        gcc_phenotype_agg=gcc_phenotype_agg,
        gcc_phenotype_agg_sd=gcc_phenotype_agg_sd
      ),
      plot=pw
    )
  )
}
