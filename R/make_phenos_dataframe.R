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
#' @param columns A named vector of columns in \code{phenos}
#'  to add to the hoverdata via \link[HPOExplorer]{make_hoverboxes}.
#' @param verbose Print messages.
#' @inheritParams get_term_definition
#' @inheritParams ggnetwork_plot
#' @returns The HPO in dataframe format.
#'
#' @export
#' @importFrom ontologyIndex get_descendants
#' @importFrom data.table setnames := .N
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
make_phenos_dataframe <- function(hpo = get_hpo(),
                                  phenotype_to_genes =
                                    load_phenotype_to_genes(),
                                  ancestor = NULL,
                                  add_description = TRUE,
                                  add_hoverboxes = TRUE,
                                  columns = list(
                                    Phenotype="Phenotype",
                                    ID="HPO_ID",
                                    ontLvl_genes="ontLvl_geneCount_ratio",
                                    Description="description"),
                                  line_length = FALSE,
                                  interactive = TRUE,
                                  verbose = TRUE
                                  ){
  # templateR:::source_all()
  # templateR:::args2vars(make_phenos_dataframe)

  description <- ontLvl <- geneCount <- ontLvl_geneCount_ratio <-
    ID <- HPO_ID <- NULL;

  if(!is.null(ancestor)){
    IDx <- get_hpo_id_direct(hpo = hpo,
                             phenotype = ancestor)
    IDx_all <- unique(
      c(IDx,
        ontologyIndex::get_descendants(ontology = hpo,
                                       roots = IDx)
      )
    )
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
  messager("Computing ontology level.",v=verbose)
  phenos[,ontLvl:=sapply(HPO_ID,get_ont_level)+1]
  messager("Computing ontology level / gene count ratio",v=verbose)
  phenos[,ontLvl_geneCount_ratio:=(ontLvl/geneCount)]
  phenos[,description:=sapply(HPO_ID,get_term_definition)]
  #### Add hoverboxes ####
  if(isTRUE(add_hoverboxes)){
    phenos <- make_hoverboxes(phenos = phenos,
                              interactive = interactive,
                              columns = columns,
                              verbose = verbose)
  }
  return(phenos)
}
