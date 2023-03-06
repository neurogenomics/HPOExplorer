annotate_phenos <- function(phenos,
                            hpo = get_hpo(),
                            adjacency = NULL,
                            add_ont_lvl_absolute = TRUE,
                            add_ont_lvl_relative = FALSE,
                            add_description = TRUE,
                            add_hoverboxes = TRUE,
                            add_age_onset = FALSE,
                            add_age_death = FALSE,
                            add_severity_tiers = FALSE,
                            columns = list_columns(),
                            interactive = TRUE,
                            verbose = TRUE){

  #### Add ontology levels: absolute ####
  if(isTRUE(add_ont_lvl_absolute)){
    phenos <- add_ont_lvl(phenos = phenos,
                          hpo = hpo,
                          absolute = TRUE,
                          verbose = verbose)
  }
  #### Add ontology levels: relative ####
  if(isTRUE(add_ont_lvl_relative)){
    phenos <- add_ont_lvl(phenos = phenos,
                          hpo = hpo,
                          adjacency = adjacency,
                          absolute = FALSE,
                          verbose = verbose)
  }

  phenos <- add_info_content(phenos = phenos,
                             hpo = hpo,
                             verbose = verbose)
  phenos <- add_hpo_definition(phenos = phenos,
                               verbose = verbose)
  phenos <- add_ancestor(phenos = phenos,
                         verbose = verbose)
  #### Add age of onset ####
  if(isTRUE(add_age_onset)){
    phenos <- add_onset(phenos = phenos,
                        verbose = verbose)
  }
  #### Add age of death ####
  if(isTRUE(add_age_death)){
    phenos <- add_death(phenos = phenos,
                        verbose = verbose)
  }
  #### Add Tiers ####
  if(isTRUE(add_severity_tiers)){
    phenos <- add_tier(phenos = phenos,
                       verbose = verbose)
  }
  #### Add hoverboxes ####
  if(isTRUE(add_hoverboxes)){
    phenos <- make_hoverboxes(phenos = phenos,
                              interactive = interactive,
                              columns = columns,
                              verbose = verbose)
  }
  return(phenos)
}
