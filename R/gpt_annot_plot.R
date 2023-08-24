gpt_annot_plot <- function(path,
                           keep_ont_levels=seq(0,5),
                           remove_descendants=c("Clinical course",
                                                "Sporadic",
                                                "Multifactorial inheritance",
                                                "Inheritance modifier",
                                                "Phenotypic variability"),
                           top_n=50,
                           verbose=TRUE
                           ){
  # path="~/Downloads/gpt_hpo_annotations.csv"
  requireNamespace("ggplot2")
  requireNamespace("scales")
  ancestor_name <- variable <- hpo_id <- phenotype <-
    value <- severity_score_gpt <- NULL;

  #### Prepare annotation results ####
  annot <- gpt_annot_read(path = path,
                          verbose = verbose)
  res_coded <- gpt_annot_codify(annot = annot)
  dat <- gpt_annot_melt(res_coded = res_coded)
  #### Get top N most severe phenotypes ####
  dat_top <- dat[hpo_id %in% unique(dat$hpo_id)[seq(top_n)]]
  #### Filter out onset phenotypes ####
  dat_top <- add_ont_lvl(dat_top, keep_ont_levels = keep_ont_levels)
  #### Filter out ont levels  ####
  dat_top <- add_ancestor(dat_top,remove_descendants = remove_descendants)

  ##### Heatmap of top N most severe phenotypes ####
  gp0.1 <- ggplot(data = dat_top,
         aes(x=variable, y=phenotype, fill=value)) +
    geom_tile() +
    scale_y_discrete(limits=rev) +
    scale_fill_viridis_d(na.value = "grey", direction = -1, option = "plasma") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = 'right')
  gp0.2 <-
    ggplot(data = dat_top,
           aes(x="severity_score_gpt", y=phenotype, fill=severity_score_gpt)) +
    geom_tile() +
    scale_y_discrete(limits=rev) +
    scale_fill_viridis_c(na.value = "grey", option = "viridis") +
    theme_bw() +
    labs(x=NULL, y=NULL) +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = 'right')
  gp0 <- patchwork::wrap_plots(gp0.1, gp0.2, ncol = 2,
                               widths = c(1,.2),
                               guides = "collect")

  #### Stacked barplot of annotation value proportions ####
  gp1 <- ggplot(dat,
                aes(x=variable,fill=value)) +
    geom_bar(position = "fill") +
    scale_y_continuous(label = scales::percent) +
    scale_fill_viridis_d(na.value = "grey", direction = -1, option = "plasma") +
    labs(y="Phenotype count") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  ##### Boxplots: annotation values vs. severity score ####
  gp2 <- ggplot(dat, aes(x=value, y=severity_score_gpt, fill=value)) +
    geom_boxplot() +
    facet_wrap(facets =  "variable~.", ncol = 5) +
    scale_fill_viridis_d(na.value = "grey", direction = -1, option = "plasma") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          strip.background = element_rect(fill = "transparent"))

  #### Histograms of severity scores in each HPO branch ####
  {
    res_coded <- gpt_annot_codify(annot = res$annot,
                                  keep_congenital_onset = NULL)
    dat <- gpt_annot_melt(res_coded = res_coded)
    dat <- add_ancestor(dat, remove_descendants = NULL)
    dat[,variable_true:=ifelse(value %in% c("always","often","varies","rarely"),
                                      paste(variable,"TRUE",sep = ": "),NA)]
    dat[,mean_severity_score_gpt:=mean(severity_score_gpt, na.rm=TRUE),
               by="ancestor_name"] |>
      data.table::setorderv("mean_severity_score_gpt", -1, na.last = TRUE)
    dat[,ancestor_name:=factor(ancestor_name,
                                      levels = unique(dat$ancestor_name),
                                      ordered = TRUE)]
  }
  gp3 <- ggplot(dat, aes(x=severity_score_gpt
                         # fill=factor(congenital_onset)
                         )) +
    geom_histogram(bins = 50, fill="slateblue") +
    geom_vline(aes(xintercept=mean_severity_score_gpt), color="red") +
    geom_label(data = unique(
      dat[,list(mean_severity_score_gpt), by="ancestor_name"]
    ),
              aes(x=mean_severity_score_gpt,
                  y=Inf,
                  label=round(mean_severity_score_gpt,2)),
    color="red", size=3, hjust = 0, vjust = 1.5, alpha=.65) +
    facet_wrap(facets = "ancestor_name~.", scales = "free_y", ncol = 3) +
    theme_bw() +
    theme(strip.background = element_rect(fill = "transparent"))

  return(
    list(gp0=gp0,
         gp1=gp1,
         gp2=gp2,
         gp3=gp3)
  )

}
