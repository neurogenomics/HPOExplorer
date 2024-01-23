gpt_annot_check_plot <- function(checks,
                                 items = c("annot_consist",
                                           "checkable_count",
                                           #"checkable_rate",
                                           "true_pos_rate")){
  requireNamespace("ggplot2")

  annotation <- value <- metric <- NULL;
  check_df <- lapply(checks[items],
                     data.table::as.data.table, keep.rownames = TRUE) |>
    data.table::rbindlist(idcol = "metric") |>
    data.table::setnames(c("metric","annotation","value"))
  check_df$metric <- factor(check_df$metric, levels = items, ordered = TRUE)

  ggplot2::ggplot(check_df[annotation!="pheno_count"],
                  ggplot2::aes(x=annotation, y=value, fill=metric)) +
    ggplot2::geom_bar(stat="identity") +
    ggplot2::facet_grid(rows="metric",
               scales = "free_y",) +
    ggplot2::theme_bw() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
          strip.background = ggplot2::element_rect(fill = "grey20"),
          strip.text = ggplot2::element_text(color = "white")) +
    ggplot2::labs(title = "GPT annotation validation",
         x = "Annotation column",
         y = "Value",
         fill = "Metric")

}
