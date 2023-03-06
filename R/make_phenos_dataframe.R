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
#' @param add_hoverboxes Add hoverdata with
#' \link[HPOExplorer]{make_hoverboxes}.
#' @param add_age_onset Add age of onset columns using
#' \link[HPOExplorer]{add_onset}.
#' @param add_age_death Add age of death columns using
#' \link[HPOExplorer]{add_death}.
#' @param add_severity_tiers Add severity Tiers column using
#' \link[HPOExplorer]{add_tier}.
#' @param columns A named vector of columns in \code{phenos}
#'  to add to the hoverdata via \link[HPOExplorer]{make_hoverboxes}.
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
make_phenos_dataframe <- function(ancestor,
                                  hpo = get_hpo(),
                                  phenotype_to_genes =
                                    load_phenotype_to_genes(),
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
                                  verbose = TRUE
                                  ){
  # templateR:::args2vars(make_phenos_dataframe)
  # ancestor = "Neurodevelopmental delay"

  ID <- . <- NULL;

  if(!is.null(ancestor)){
    IDx <- get_hpo_id_direct(phenotype = ancestor,
                             hpo = hpo)
    IDx_all <- ontologyIndex::get_descendants(ontology = hpo,
                                              roots = IDx,
                                              exclude_roots = FALSE)
    descendants <- phenotype_to_genes[ID %in% IDx_all,]
  } else {
    descendants <- phenotype_to_genes
  }
  messager("Extracting data for",
           formatC(length(unique(descendants$Phenotype)),big.mark = ","),
           "descendents.",v=verbose)
  messager("Computing gene counts.",v=verbose)
  phenos <- descendants[,.(geneCount=.N), by=c("ID","Phenotype")]
  data.table::setnames(phenos, "ID","HPO_ID")
  #### Annotate phenotypes ####
  phenos <- annotate_phenos(phenos = phenos,
                            hpo = hpo,
                            adjacency = adjacency,
                            add_ont_lvl_absolute = add_ont_lvl_absolute,
                            add_ont_lvl_relative = add_ont_lvl_relative,
                            add_description = add_description,
                            add_hoverboxes = add_hoverboxes,
                            add_age_onset = add_age_onset,
                            add_age_death = add_age_death,
                            add_severity_tiers = add_severity_tiers,
                            columns = columns,
                            interactive = interactive,
                            verbose = verbose)
  return(phenos)
}
