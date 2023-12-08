#' Annotate phenotypes
#'
#' Annotate phenotypes \link[data.table]{data.table} without various types
#' of metadata.
#' @inheritParams make_network_object
#' @inheritParams make_phenos_dataframe
#'
#' @export
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- annotate_phenos(phenos)
annotate_phenos <- function(phenos,
                            hpo = get_hpo(),
                            adjacency = NULL,
                            ##### Phenotype metadata ####
                            add_ont_lvl_absolute = TRUE,
                            add_ont_lvl_relative = FALSE,
                            add_info_contents = FALSE,
                            add_description = TRUE,
                            #### Disease/symptom metadata ####
                            add_disease_data = FALSE,
                            add_ndiseases = add_disease_data,
                            add_onsets = add_disease_data,
                            add_deaths = add_disease_data,
                            add_pheno_frequencies = add_disease_data,
                            add_tiers = add_disease_data,
                            add_severities = add_disease_data,
                            add_disease_definitions = add_disease_data,
                            include_mondo = FALSE,
                            #### Extra #####
                            add_hoverboxes = FALSE,
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
  #### Add info content ####
  if(isTRUE(add_info_content)){
    phenos <- add_info_content(phenos = phenos,
                               hpo = hpo,
                               verbose = verbose)
  }
  phenos <- add_hpo_definition(phenos = phenos,
                               verbose = verbose)
  phenos <- add_ancestor(phenos = phenos,
                         verbose = verbose)
  if(isTRUE(add_ndiseases)){
    phenos <- add_ndisease(phenos = phenos,
                           verbose = verbose)
  }
  #### Add age of onset ####
  if(isTRUE(add_onsets)){
    phenos <- add_onset(phenos = phenos,
                        verbose = verbose)
  }
  #### Add age of death ####
  if(isTRUE(add_deaths)){
    phenos <- add_death(phenos = phenos,
                        allow.cartesian = TRUE,
                        verbose = verbose)
  }
  #### Add Tiers ####
  if(isTRUE(add_tiers)){
    phenos <- add_tier(phenos = phenos,
                       verbose = verbose)
  }
  #### Add Severities ####
  if(isTRUE(add_severities)){
    phenos <- add_severity(phenos = phenos,
                           verbose = verbose)
  }
  #### Add phenotype-disease freqs ####
  if(isTRUE(add_pheno_frequencies)){
    phenos <- add_pheno_frequency(phenos = phenos,
                                  verbose = verbose)
  }
  #### Add phenotype-disease freqs ####
  if(isTRUE(add_disease_definitions)){
    phenos <- add_disease_definition(phenos = phenos,
                                     include_mondo = include_mondo,
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
