gpt_annot_plot <- function(path){

  requireNamespace("ggplot2")
  # path="~/Downloads/gpt_hpo_annotations.csv"
  res <- gpt_annot_check(path = path)
  res_coded <- gpt_annot_codify(annot = res$annot)
  id.vars <- grep("justification|phenotype|hpo_id|pheno_count",names(res_coded$annot),
               value = TRUE)
  dat <- data.table::melt.data.table(
    data = res_coded$annot[res_coded$annot_weighted[,c("hpo_id","score")],
                           on="hpo_id"],
    id.vars = c(id.vars,"score"),
    variable.factor = TRUE,
    value.factor = TRUE)

  #### Proportion of HPO_IDs annotated before/after chatGPT ####
  # prior_ids <- unique(HPOExplorer::hpo_modifiers$hpo_id)
  # new_ids <- unique(dat$hpo_id)
  # length(new_ids)/length(prior_ids)
  # length(prior_ids)/length(hpo$id)
  # length(new_ids)/length(hpo$id)

  dat <- add_ont_lvl(dat)
  dat <- add_ancestor(dat)

  gp0 <- ggplot(data = dat[hpo_id %in% unique(dat$hpo_id)[seq(50)]],
         aes(x=variable, y=phenotype, fill=value)) +
    geom_tile() +
    scale_y_discrete(limits=rev) +
    scale_fill_viridis_d(na.value = "grey", direction = -1, option = "plasma") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  gp1 <- ggplot(dat,aes(x=variable,
                 fill=value
                 )) +
    geom_bar(position = "fill") +
    scale_y_continuous(label = scales::percent) +
    scale_fill_viridis_d(na.value = "grey", direction = -1, option = "plasma") +
    labs(y="Phenotype count") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  gp2 <- ggplot(dat, aes(x=value, y=score, fill=value)) +
    geom_boxplot() +
    facet_wrap(facets =  "variable~.", ncol = 5) +
    scale_fill_viridis_d(na.value = "grey", direction = -1, option = "plasma") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          strip.background = element_rect(fill = "transparent"))

  gp3 <- ggplot(dat, aes(x=score, fill=factor(value))) +
    geom_histogram(bins = 50) +
    facet_wrap(facets = "ancestor_name~.", scales = "free_y", ncol = 3) +
    scale_fill_viridis_d(na.value = "grey", direction = -1, option = "plasma") +
    theme_bw() +
    theme(strip.background = element_rect(fill = "transparent"))

}
