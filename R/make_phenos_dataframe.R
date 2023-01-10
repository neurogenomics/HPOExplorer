#' Make phenotypes dataframe
#'
#' Make a dataframe from a subset of the Human Phenotype Ontology.
#' @param hpo Human Phenotype Ontology object.
#' @param phenotype_to_genes Output of
#' \link[HPOExplorer]{load_phenotype_to_genes} mapping phenotypes
#' to gene annotations.
#' @param ancestor The ancestor to get all descendants of. If \code{NULL},
#' returns the entirely ontology.
#' @param add_description Whether to get the phenotype descriptions as
#'  well (slower).
#' @param verbose Print messages.
#' @inheritParams get_term_definition
#' @returns The HPO in dataframe format.
#'
#' @export
#' @importFrom ontologyIndex get_descendants
#' @importFrom data.table data.table rbindlist
#' @examples
#' library(ontologyIndex)
#' data(hpo)
#' pheno <- make_phenos_dataframe(hpo = hpo,
#'                                ancestor = "Neurodevelopmental delay",
#'                                add_description = FALSE)
make_phenos_dataframe <- function(hpo,
                                  phenotype_to_genes = load_phenotype_to_genes(),
                                  ancestor = NULL,
                                  add_description = TRUE,
                                  line_length = 10,
                                  verbose = TRUE
                                  ){
  # templateR:::source_all()
  # templateR:::args2vars(make_phenos_dataframe)

  if(!is.null(ancestor)){
    IDx <- get_hpo_termID_direct(hpo = hpo,
                                 phenotype = ancestor)
    descendants <- phenotype_to_genes[
      phenotype_to_genes$ID %in% ontologyIndex::get_descendants(ontology = hpo,
                                                                roots = IDx),
    ]
  } else {
    descendants <- phenotype_to_genes
  }
  messager("Extracting data for",
           formatC(length(unique(descendants$Phenotype)),big.mark = ","),
           "descendents.")
  pheno <- lapply(unique(descendants$Phenotype), function(p){
    messager("Processing:",p,v=verbose)
    id <- get_hpo_termID(phenotype = p,
                         phenotype_to_genes = phenotype_to_genes)
    ontLvl_geneCount_ratio <- (get_ont_level(hpo = hpo,
                                             term_ids = p) + 1)/
      length(get_gene_list(p,phenotype_to_genes))
    description <- if(isTRUE(add_description)){
        get_term_definition(ontologyId = id,
                            line_length = line_length)
    } else {
      NA
    }
    data.table::data.table("Phenotype"=p,
                           "HPO_Id"=id,
                           "ontLvl_geneCount_ratio"=ontLvl_geneCount_ratio,
                           "description"=description)
  }) |> data.table::rbindlist(fill=TRUE)
  return(pheno)
}
