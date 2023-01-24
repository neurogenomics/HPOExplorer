#' Make phenotypes dataframe
#'
#' Make a dataframe from a subset of the Human Phenotype Ontology.
#' @param hpo Human Phenotype Ontology object, loaded from \pkg{ontologyIndex}.
#' @param phenotype_to_genes Output of
#' \link[HPOExplorer]{load_phenotype_to_genes} mapping phenotypes
#' to gene annotations.
#' @param ancestor The ancestor to get all descendants of. If \code{NULL},
#' returns the entirely ontology.
#' @param add_description Whether to get the phenotype descriptions as
#'  well (slower).
#' @param add_hoverboxes Add hoverdata with
#' \link[HPOExplorer]{make_hoverboxes}.
#' @param add_age_onset Add age of onset columns using
#' \link[HPOExplorer]{add_onset}.
#' @param add_severity_tiers Add severity Tiers column using
#' \link[HPOExplorer]{add_tier}.
#' @param columns A named vector of columns in \code{phenos}
#'  to add to the hoverdata via \link[HPOExplorer]{make_hoverboxes}.
#' @param verbose Print messages.
#' @inheritParams ggnetwork_plot
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
                                  add_description = TRUE,
                                  add_hoverboxes = TRUE,
                                  add_age_onset = FALSE,
                                  add_severity_tiers = FALSE,
                                  columns = list_columns(),
                                  interactive = TRUE,
                                  verbose = TRUE
                                  ){
  # templateR:::source_all()
  # templateR:::args2vars(make_phenos_dataframe)
  # ancestor = "Neurodevelopmental delay"

  ID <- . <- NULL;

  if(!is.null(ancestor)){
    IDx <- get_hpo_id_direct(hpo = hpo,
                             phenotype = ancestor)
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
  phenos <- add_ont_lvl(phenos = phenos,
                        hpo = hpo,
                        verbose = verbose)
  phenos <- add_info_content(phenos = phenos,
                             hpo = hpo,
                             verbose = verbose)
  phenos <- add_hpo_definition(phenos = phenos,
                               verbose = verbose)
  #### Add age of onset ####
  if(isTRUE(add_age_onset)){
    phenos <- add_onset(phenos = phenos,
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
