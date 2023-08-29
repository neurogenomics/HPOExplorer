test_that("add_evidence works", {


  phenos <- load_phenotype_to_genes()
  phenos2 <- add_evidence(phenos = phenos,
                          default_score = NULL)
  testthat::expect_true(
    all(c("evidence_score_min",
          "evidence_score_max",
          "evidence_score_mean") %in% names(phenos2))
  )

  #### Plot number of genes/phenotypes/diseases at each evidence level ####
  # rep <- lapply(c(NA,seq(0,6)), function(x){
  #   vars <- c("evidence_score_min","evidence_score_max","evidence_score_mean")
  #   lapply(stats::setNames(vars,vars),
  #          function(v){
  #            p <- if(is.na(x)){
  #              phenos2
  #            } else {
  #              phenos2[get(v)>=x,]
  #            }
  #            data.table::data.table(
  #              evidence_score_filter=toString(x),
  #              rows=nrow(p),
  #              diseases=length(unique(p$disease_id)),
  #              phenotypes=length(unique(p$hpo_id)),
  #              genes=length(unique(p$Gene))
  #            )
  #          }) |> data.table::rbindlist(use.names = TRUE,
  #                                      idcol = "evidence_score_variable")
  # }) |> data.table::rbindlist()
  #
  # rep_melt <- data.table::melt.data.table(
  #   rep,
  #   measure.vars = names(rep)[-seq(2)],
  #   variable.name = "metric",
  #   value.name = "count")
  # rep_melt$evidence_score_filter <- factor(rep_melt$evidence_score_filter,
  #                                          levels = unique(rep_melt$evidence_score_filter),
  #                                          ordered = TRUE)
  # ggplot2::ggplot(rep_melt,
  #                 ggplot2::aes(x=evidence_score_filter,
  #                              y=count,
  #                              shape=evidence_score_variable,
  #                              color=evidence_score_variable)) +
  #   ggplot2::geom_smooth(se = FALSE, na.rm = FALSE) +
  #   ggplot2::geom_point(size=3, alpha=.8, na.rm = FALSE) +
  #   ggplot2::facet_wrap(facets = metric~.,
  #                       scales = "free") +
  #   ggplot2::theme_bw()
})
