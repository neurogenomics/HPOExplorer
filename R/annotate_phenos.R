#' @describeIn main main
#' Annotate phenotypes
#'
#' Annotate phenotypes \link[data.table]{data.table} without various types
#' of metadata.
#' @export
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- annotate_phenos(phenos)
annotate_phenos <- function(phenos,
                            hpo = get_hpo(),
                            ##### Phenotype metadata ####
                            add_ont_lvl_absolute = TRUE,
                            add_ont_lvl_relative = FALSE,
                            add_info_content = TRUE,
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
                            interactive = TRUE){

  #### Add basic phenotype info ####
  phenos <- add_hpo_id(phenos = phenos)
  phenos <- add_hpo_name(phenos = phenos)
  phenos <- add_hpo_definition(phenos = phenos)
  phenos <- add_ancestor(phenos = phenos)
  #### Add ontology levels: absolute ####
  if(isTRUE(add_ont_lvl_absolute)){
    phenos <- add_ont_lvl(phenos = phenos,
                          hpo = hpo,
                          absolute = TRUE)
  }
  #### Add ontology levels: relative ####
  if(isTRUE(add_ont_lvl_relative)){
    phenos <- add_ont_lvl(phenos = phenos,
                          hpo = hpo,
                          absolute = FALSE)
  }
  #### Add info content ####
  if(isTRUE(add_info_content)){
    phenos <- add_info_content(phenos = phenos,
                               hpo = hpo)
  }
  if(isTRUE(add_ndiseases)){
    phenos <- add_ndisease(phenos = phenos)
  }
  #### Add age of onset ####
  if(isTRUE(add_onsets)){
    phenos <- add_onset(phenos = phenos)
  }
  #### Add age of death ####
  if(isTRUE(add_deaths)){
    phenos <- add_death(phenos = phenos,
                        allow.cartesian = TRUE)
  }
  #### Add Tiers ####
  if(isTRUE(add_tiers)){
    phenos <- add_tier(phenos = phenos)
  }
  #### Add Severities ####
  if(isTRUE(add_severities)){
    phenos <- add_severity(phenos = phenos)
  }
  #### Add phenotype-disease freqs ####
  if(isTRUE(add_pheno_frequencies)){
    phenos <- add_pheno_frequency(phenos = phenos)
  }
  #### Add phenotype-disease freqs ####
  if(isTRUE(add_disease_definitions)){
    phenos <- add_disease(phenos = phenos,
                          add_descriptions = TRUE)
  }
  #### Add hoverboxes ####
  if(isTRUE(add_hoverboxes)){
    phenos <- KGExplorer::add_hoverboxes(g=phenos)
  }
  return(phenos)
}
