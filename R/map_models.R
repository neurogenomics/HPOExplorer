map_models <- function(){

  #### Get disease models ####
  ## Link by disease (MONDO_ID)
  models <- get_monarch("disease_to_model")
  top_targets <- MultiEWCE::example_targets$top_targets
  top_targets_map <- data.table::merge.data.table(
    top_targets,
    map,
    by.x = "hpo_id",
    by.y = "id1",
    all = FALSE
  )
  top_targets_fmap <- data.table::merge.data.table(top_targets,
                                                   map2[,-c("hpo_name")],
                                                   by="hpo_id")
  messager(round(length(unique(top_targets_map$hpo_id)) /
                   length(unique(top_targets$hpo_id))*100,1),
           "% of hpo_ids mapped across non-human ontologies.")
  messager(round(length(unique(top_targets_fmap$hpo_id)) /
                   length(unique(top_targets$hpo_id))*100,1),
           "% of hpo_ids mapped across non-human ontologies.")


  sum(top_targets$hpo_id %in% map2$hpo_id)
}
