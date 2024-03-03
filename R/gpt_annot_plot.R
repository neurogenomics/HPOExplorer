#' Plot annotations from GPT
#'
#' Plot annotations from GPT.
#' @param top_n Top number of most severe phenotypes to plot in heatmap.
#' @inheritParams gpt_annot_check
#' @inheritParams add_ont_lvl
#' @inheritParams add_ancestor
#' @inheritParams filter_descendants
#' @returns Named list of plots.
#'
#' @export
#' @examples
#' plots <- gpt_annot_plot()
gpt_annot_plot <- function(annot = gpt_annot_read(),
                           keep_ont_levels=seq(3,17),
                           keep_descendants="Phenotypic abnormality",
                           top_n=50,
                           verbose=TRUE
                           ){
  requireNamespace("ggplot2")
  requireNamespace("scales")
  requireNamespace("patchwork")
  ancestor_name <- variable <- hpo_id <- hpo_name <-
    value <- severity_score_gpt <- mean_severity_score_gpt <- NULL;

  #### Prepare annotation results ####
  res_coded <- gpt_annot_codify(annot = annot)
  dat1 <- gpt_annot_melt(res_coded = res_coded)
  #### Filter out ont levels  ####
  dat1 <- add_ancestor(dat1,
                       keep_descendants = keep_descendants)
  data.table::setorderv(dat1,"severity_score_gpt",-1)
  #### Get top N most severe phenotypes ####
  dat_top <- dat1[hpo_id %in% unique(dat1$hpo_id)[seq(top_n)]]
  #### Filter out onset phenotypes ####
  dat_top <- add_ont_lvl(dat_top, keep_ont_levels = keep_ont_levels)


  ##### Heatmap of top N most severe phenotypes ####
  gp0.1 <- ggplot2::ggplot(data = dat_top,
                           ggplot2::aes(x=variable, y=hpo_name, fill=value)) +
    ggplot2::geom_tile() +
    ggplot2::scale_y_discrete(limits=rev) +
    ggplot2::scale_fill_viridis_d(na.value = "grey",
                                  direction = -1, option = "plasma") +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
          legend.position = 'right')
  gp0.2 <-
    ggplot2::ggplot(data = dat_top,
                    ggplot2::aes(x="severity_score_gpt", y=hpo_name,
                                 fill=severity_score_gpt)) +
    ggplot2::geom_tile() +
    ggplot2::scale_y_discrete(limits=rev) +
    ggplot2::scale_fill_viridis_c(na.value = "grey", option = "viridis") +
    ggplot2::labs(x=NULL, y=NULL) +
    ggplot2::theme_void() +
    ggplot2::theme(axis.text.y = ggplot2::element_blank(),
                   axis.ticks.y = ggplot2::element_blank(),
                   axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
                   legend.position = 'right')
  gp0 <- patchwork::wrap_plots(gp0.1, gp0.2, ncol = 2,
                               widths = c(1,.2),
                               guides = "collect")

  #### Stacked barplot of annotation value proportions ####
  gp1 <- ggplot2::ggplot(dat1,
                         ggplot2::aes(x=variable,fill=value)) +
    ggplot2::geom_bar(position = "fill") +
    ggplot2::scale_y_continuous(labels = scales::percent) +
    ggplot2::scale_fill_viridis_d(na.value = "grey", direction = -1,
                                  option = "plasma") +
    ggplot2::labs(y="Phenotype count") +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  ##### Boxplots: annotation values vs. severity score ####
  gp2 <- ggplot2::ggplot(dat1, ggplot2::aes(x=value, y=severity_score_gpt,
                                            fill=value)) +
    ggplot2::geom_boxplot() +
    ggplot2::facet_wrap(facets =  "variable~.", ncol = 5) +
    ggplot2::scale_fill_viridis_d(na.value = "grey", direction = -1,
                                  option = "plasma") +
    ggplot2::labs(x=NULL) +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_blank(),
          strip.background = ggplot2::element_rect(fill = "transparent"))

  #### Histograms of severity scores in each HPO branch ####
  {
    res_coded <- gpt_annot_codify(annot = annot)
    dat2 <- gpt_annot_melt(res_coded = res_coded)
    dat2 <- add_ancestor(dat2,
                         keep_descendants = keep_descendants)
    dat2[,mean_severity_score_gpt:=mean(severity_score_gpt, na.rm=TRUE),
               by="ancestor_name"] |>
      data.table::setorderv("mean_severity_score_gpt", -1, na.last = TRUE)
    dat2[,ancestor_name:=factor(ancestor_name,
                                levels = unique(dat2$ancestor_name),
                                ordered = TRUE)]
  }
  gp3 <- ggplot2::ggplot(dat2, ggplot2::aes(x=severity_score_gpt
                         # fill=factor(congenital_onset)
                         )) +
    ggplot2::geom_histogram(bins = 50, fill="slateblue") +
    ggplot2::geom_vline(ggplot2::aes(xintercept=mean_severity_score_gpt),
                        color="red") +
    ggplot2::geom_label(data = unique(
      dat2[,list(mean_severity_score_gpt), by="ancestor_name"]
    ),
    ggplot2::aes(x=mean_severity_score_gpt,
                  y=Inf,
                  label=round(mean_severity_score_gpt,2)),
    color="red", size=3, hjust = 0, vjust = 1.5, alpha=.65) +
    ggplot2::facet_wrap(facets = "ancestor_name~.", scales = "free_y",
                        ncol = 3) +
    ggplot2::labs(y="Frequency") +
    ggplot2::theme_bw() +
    ggplot2::theme(strip.background = ggplot2::element_rect(
      fill = "transparent"))
  #### Return ####
  return(
    list(gp0=gp0,
         gp1=gp1,
         gp2=gp2,
         gp3=gp3,
         data=list(res_coded=res_coded,
                   dat1=dat1,
                   dat2=dat2,
                   dat_top=dat_top)
         )
  )
}
