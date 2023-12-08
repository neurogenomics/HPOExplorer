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

  ggplot(check_df[annotation!="pheno_count"],
         aes(x=annotation, y=value, fill=metric)) +
    geom_bar(stat="identity") +
    facet_grid(rows="metric",
               scales = "free_y",) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          strip.background = element_rect(fill = "grey20"),
          strip.text = element_text(color = "white")) +
    labs(title = "GPT annotation validation",
         x = "Annotation column",
         y = "Value",
         fill = "Metric")

}
