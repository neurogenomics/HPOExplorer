#' Make phenotypes dataframe
#'
#' Make a dataframe from a subset of the Human Phenotype Ontology.
#' @param hpo Human Phenotype Ontology object, loaded from \pkg{ontologyIndex}.
#' @param phenotype_to_genes Output of
#' \link[HPOExplorer]{load_phenotype_to_genes} mapping phenotypes
#' to gene annotations.
#' @param ancestor The ancestor to get all descendants of. If \code{NULL},
#' returns the entirely ontology.
#' @param add_ont_lvl_absolute Add the absolute ontology level of each HPO term.
#' See \link[HPOExplorer]{get_ont_lvls} for more details.
#' @param add_ont_lvl_relative Add the relative ontology level of each HPO term.
#' See \link[HPOExplorer]{get_ont_lvls} for more details.
#' @param add_description Whether to get the phenotype descriptions as
#'  well (slower).
#' @param add_info_contents Add information content column for each phenotype.
#' @param add_disease_data Add all disease metadata columns.
#' This will expand the data using \code{allow.cartesian=TRUE}.
#' @param add_ndiseases Add the number of diseases per phenotype.
#' @param add_pheno_frequencies Add the frequency of each phenotype in
#' each disease.
#' @param add_tiers Add severity Tiers column using
#' \link[HPOExplorer]{add_tier}.
#' @param add_severities Add severity column using
#' \link[HPOExplorer]{add_severity}.
#' @param add_hoverboxes Add hoverdata with
#' \link[HPOExplorer]{make_hoverboxes}.
#' @param add_onsets Add age of onset columns using
#' \link[HPOExplorer]{add_onset}.
#' @param add_deaths Add age of death columns using
#' \link[HPOExplorer]{add_death}.
#' @param columns A named vector of columns in \code{phenos}
#'  to add to the hoverdata via \link[HPOExplorer]{make_hoverboxes}.
#' @param add_disease_definitions Add disease definitions.
#' @param include_mondo Add \href{https://mondo.monarchinitiative.org/}{MONDO}
#' IDs, names, and definitions to each disease.
#' @param verbose Print messages.
#' @inheritParams ggnetwork_plot
#' @inheritParams make_network_object
#' @returns The HPO in dataframe format.
#'
#' @export
#' @importFrom ontologyIndex get_descendants
#' @importFrom data.table setnames := .N
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
make_phenos_dataframe <- function(ancestor = NULL,
                                  hpo = get_hpo(),
                                  phenotype_to_genes =
                                    load_phenotype_to_genes(),
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
                                  verbose = TRUE
                                  ){
  # devoptera::args2vars(make_phenos_dataframe)
  # ancestor = "Neurodevelopmental delay"

  hpo_id <- . <- NULL;

  if(!is.null(ancestor)){
    IDx <- get_hpo_id_direct(phenotype = ancestor,
                             hpo = hpo)
    IDx_all <- ontologyIndex::get_descendants(ontology = hpo,
                                              roots = IDx,
                                              exclude_roots = FALSE)
    descendants <- phenotype_to_genes[hpo_id %in% IDx_all,]
  } else {
    descendants <- phenotype_to_genes
  }
  messager("Extracting data for",
           formatC(length(unique(descendants$hpo_name)),big.mark = ","),
           "descendents.",v=verbose)
  messager("Computing gene counts.",v=verbose)
  phenos <- descendants[,.(geneCount=.N), by=c("hpo_id","hpo_name")]
  #### Annotate phenotypes ####
  phenos <- annotate_phenos(phenos = phenos,
                            hpo = hpo,
                            adjacency = adjacency,
                            ##### Phenotype metadata ####
                            add_ont_lvl_absolute = add_ont_lvl_absolute,
                            add_ont_lvl_relative = add_ont_lvl_relative,
                            add_info_contents = add_info_contents,
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
                            interactive = interactive,
                            verbose = verbose)
  return(phenos)
}
