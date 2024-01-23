#' @describeIn make_ make_
#' Make phenotypes dataframe
#'
#' Make a dataframe from a subset of the Human Phenotype Ontology.
#' @inheritParams make_network_plot
#' @inheritParams make_network_object
#' @returns The HPO in dataframe format.
#'
#' @export
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
make_phenos_dataframe <- function(ancestor = NULL,
                                  hpo = get_hpo(),
                                  phenotype_to_genes =
                                    load_phenotype_to_genes(),
                                  ##### Phenotype metadata ####
                                  add_ont_lvl_absolute = TRUE,
                                  add_ont_lvl_relative = FALSE,
                                  add_info_content = FALSE,
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
                                  verbose = TRUE
                                  ){
  hpo_id <- . <- gene_symbol <- NULL;

  if(!is.null(ancestor)){
    IDx <- get_hpo_id_direct(term = ancestor,
                             hpo = hpo)
    IDx_all <- simona::dag_offspring(hpo,
                                     term=IDx,
                                     include_self = TRUE)
    descendants <- phenotype_to_genes[hpo_id %in% IDx_all,]
  } else {
    descendants <- phenotype_to_genes
  }
  messager("Extracting data for",
           formatC(length(unique(descendants$hpo_name)),big.mark = ","),
           "descendents.")
  messager("Computing gene counts.")
  phenos <- descendants[,.(geneCount=data.table::uniqueN(gene_symbol)),
                        by=c("hpo_id","hpo_name")]
  #### Annotate phenotypes ####
  phenos <- annotate_phenos(phenos = phenos,
                            hpo = hpo,
                            ##### Phenotype metadata ####
                            add_ont_lvl_absolute = add_ont_lvl_absolute,
                            add_ont_lvl_relative = add_ont_lvl_relative,
                            add_info_content = add_info_content,
                            add_description = add_description,
                            #### Disease/symptom metadata ####
                            add_disease_data = add_disease_data,
                            add_ndiseases = add_ndiseases,
                            add_onsets = add_onsets,
                            add_deaths = add_deaths,
                            add_pheno_frequencies = add_pheno_frequencies,
                            add_tiers = add_tiers,
                            add_severities = add_severities,
                            add_disease_definitions = add_disease_definitions,
                            include_mondo = include_mondo,
                            #### Extra #####
                            add_hoverboxes = add_hoverboxes,
                            columns = columns,
                            interactive = interactive)
  return(phenos)
}
