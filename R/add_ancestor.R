#' Add ancestor
#'
#' Assign each HPO ID to the higher-order ancestral term that it is part of.
#' @param lvl How many levels deep into the ontology to get ancestors from.
#' For example:
#' \itemize{
#' \item{1: }{"All"}
#' \item{2: }{"Phenotypic abnormality"}
#' \item{3: }{"Abnormality of the nervous system"}
#' \item{4: }{"Abnormality of nervous system physiology"}
#' \item{5: }{"Neurodevelopmental abnormality" or "Behavioral abnormality"}
#' }
#' @param remove_descendants Remove HPO terms that are descendants of a given
#' ancestral HPO term. Ancestral terms be provided as a character vector of
#' phenotype names (e.g. \code{c("Clinical course")}),
#'  HPO IDs (e.g. \code{"HP:0031797" }) or a mixture of the two.
#'  See \link[HPOExplorer]{add_ancestor} for details.
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table :=
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_ancestor(phenos = phenos, lvl=5)
add_ancestor <- function(phenos,
                         lvl = 3,
                         hpo = get_hpo(),
                         remove_descendants = NULL,
                         verbose=TRUE){

  ancestor_name <- ancestor <- NULL;
  if("HPO_ID" %in% names(phenos)){
    messager(paste0("Adding level-",lvl),"ancestor to each HPO ID.",v=verbose)
    phenos$ancestor <- lapply(hpo$ancestors[phenos$HPO_ID],
                              function(x){
                                if(length(x)>0){
                                  x[lvl]
                                } else {NA}
                              }) |> unlist()
    # phenos[,.(ancestor=unlist(ancestor))]
    phenos[,ancestor_name:=hpo$name[ancestor]]

  } else {
    messager("HPO_ID column not found. Cannot add ancestors.",v=verbose)
  }
  #### Filter ####
  if(!is.null(remove_descendants)){
    messager("Removing remove descendants of:",
             paste(shQuote(remove_descendants),collapse = "\n -"),v=verbose)
    rmd <- HPOExplorer::harmonise_phenotypes(phenotypes = remove_descendants,
                                             hpo = hpo,
                                             as_hpo_ids = TRUE,
                                             keep_order = FALSE,
                                             verbose = verbose)
    phenos <- phenos[!ancestor %in% rmd,]
  }
  return(phenos)
}
