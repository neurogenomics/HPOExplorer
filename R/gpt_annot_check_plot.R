gpt_annot_check_plot <- function(checks,
                                 items = c("consistency_count","consistency_rate",
                                           "consistency_stringent_count","consistency_stringent_rate",
                                           # "checkable_count","checkable_rate",
                                           "true_pos_count","true_pos_rate"),
                                 metric_types=c("Rate","Count")[1],
                                 scales = "free"){
  requireNamespace("ggplot2")

  annotation <- metric <- metric_category <- metric_type <- n <-
    value <- label <-NULL;
  check_df <- lapply(checks[items],
                     data.table::as.data.table, keep.rownames = TRUE) |>
    data.table::rbindlist(idcol = "metric") |>
    data.table::setnames(c("metric","annotation","value"))

  check_df$metric <- factor(check_df$metric,
                            levels = items,
                            ordered = TRUE)
  check_df$annotation <- factor(check_df$annotation,
                                levels = unique(check_df$annotation),
                                ordered = TRUE)
  # check_df[,row_count:=.N[!is.na(value)], by=c("metric","annotation")]
  check_df[,metric_type:=ifelse(grepl("count",metric),
                                "Count",ifelse(grepl("rate",metric),"Rate",NA))]
  check_df[,metric_category:=gsub("_count|_rate","",metric)]
  check_df$metric_type <- factor(check_df$metric_type, ordered = TRUE)
  check_df <- check_df[annotation!="pheno_count"]
  combos <- expand.grid(
    metric_category=check_df$metric_category,
    metric_type=check_df$metric_type,
    annotation=check_df$annotation
    ) |> unique() |> `rownames<-`(NULL)
  check_df2 <- merge(check_df,
                     combos,
                     by=c("metric_category","metric_type","annotation"),
                     all.y=TRUE)
  # check_df[,label:=paste0("n=",value[metric_type=="Count"]),
  #          by=c("metric_category","annotation")]
  check_df[,n:=value[metric_type=="Count"],
           by=c("metric_category","annotation")]

  plt <- ggplot2::ggplot(check_df[metric_type %in% metric_types],
                       ggplot2::aes(x=annotation, y=value,
                                    fill=n,
                                    label=round(value,2))) +
    ggplot2::geom_bar(stat="identity", show.legend = TRUE) +
    # ggplot2::scale_fill_viridis_d(drop = FALSE, end = .8 )+
    ggplot2::scale_fill_viridis_c()+
    ggplot2::scale_x_discrete(drop = scales %in% c("free","free_x")) +
    ggplot2::facet_grid(facets=metric_type~metric_category,
                        scales = scales) +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
                   strip.background = ggplot2::element_rect(fill = "grey20"),
                   strip.text = ggplot2::element_text(color = "white")) +
    ggplot2::labs(x = "Annotation",
                  y = "Value",
                  fill = "N phenotypes") +
    ggplot2::geom_label(fill='white')
    # ggplot2::geom_text(angle=90, size=3, hjust=1.2)
  # plt

  if(scales %in% c("free","free_x")){
    plt <- plt+
      ggplot2::geom_vline(data = check_df2[is.na(value)],
                        ggplot2::aes(xintercept=annotation),
                        # label="N/A",
                        color="red", linetype="solid", linewidth=3, alpha=0.25) +
      ggplot2::geom_text(data = check_df2[is.na(value)][,label:="N/A"],
                         ggplot2::aes(x=annotation, label=label, y=2),
                         position=ggplot2::position_fill(vjust = 0.1),
                         color="red",  alpha=0.5, angle=90)
  }
  # count_df <- check_df[metric_type=="Count",,drop=FALSE]
  # rate_df <- check_df[metric_type=="Rate",,drop=FALSE][annotation!="pheno_count"]
  # plts <- list()
  # make_plot <- function(df,
  #                       y_lab=NULL){
  #   p <- ggplot2::ggplot(df,
  #                   ggplot2::aes(x=annotation, y=value,
  #                                fill=metric_type)) +
  #     ggplot2::geom_bar(stat="identity", show.legend = FALSE) +
  #     ggplot2::scale_fill_viridis_d(drop=FALSE, end = .8 )+
  #     ggplot2::scale_x_discrete(drop = FALSE) +
  #     ggplot2::facet_grid(rows="metric") +
  #     ggplot2::theme_bw() +
  #     ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
  #                    strip.background = ggplot2::element_rect(fill = "grey20"),
  #                    strip.text = ggplot2::element_text(color = "white")) +
  #     ggplot2::labs(x = "Annotation",
  #                   y = y_lab,
  #                   fill = "Metric")
  # }
  # if(nrow(count_df)>0){
  #   plts[["count"]] <- make_plot(count_df,y_lab = "Count")
  # }
  # if(nrow(rate_df)>0){
  #   plts[["rate"]] <- make_plot(rate_df,y_lab = "Rate")
  # }
  # if(length(plts)>1){
  #   plts[[1]] <- plts[[1]] +
  #     ggplot2::theme(axis.text.x = ggplot2::element_blank())
  # }
  #
  # plt <- patchwork::wrap_plots(plts, ncol = 1,
  #                       guides = "collect") +
  #   patchwork::plot_layout(axis_titles = "collect",
  #                          axes = "collect")
  return(list(
    data=check_df,
    plot=plt
  ))
}
