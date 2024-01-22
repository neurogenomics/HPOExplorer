#' Search the Human Phenotype Ontology
#'
#' Serarch for phenotypes in the HPO that match substring queries,
#' or are the descendants of those substring-matched phenotypes.
#' @param queries A named list of character vectors.
#' Each vector includes a phenoptype name (or a substring)
#' to be searched for in the HPO.
#' @param include_descendants Include all descendants of query hits.
#' @param include_ancestors Include all ancestors of query hits.
#' @inheritParams make_phenos_dataframe
#' @returns Named list of HPO IDs.
#'
#' @export
#' @examples
#' query_hits <- search_hpo()
search_hpo <- function(hpo = get_hpo(),
                       queries = list(
                         intellectual_disability=c("intellectual disability"),
                         impaired_mobility=c(
                           "Abnormal central motor function",
                           "Abnormality of movement"),
                         physical_malformations=c("malformation"#,"morphology"
                         ),
                         blindness=c("^blindness"),
                         sensory_impairments=c(
                           "Abnormality of vision",
                           "Abnormality of the sense of smell",
                           "Abnormality of taste sensation",
                           "Somatic sensory dysfunction",
                           "Hearing abnormality"
                         ),
                         immunodeficiency=c("Immunodeficiency"),
                         cancer=c("Neoplasm",
                                  "Cancer"),
                         reduced_fertility=c("Decreased fertility")
                       ),
                       include_descendants=TRUE,
                       include_ancestors=FALSE,
                       verbose=TRUE){
  name <- NULL;

  query_hits <- lapply(queries, function(q){
    terms <- grep(paste(q,collapse = "|"),
                  hpo@elementMetadata$name,
                  ignore.case = TRUE, value = TRUE)
    dat <- subset(hpo@elementMetadata, name %in% terms)
    res <- c()
    if(isTRUE(include_descendants)){
      res <- c(res,
               simona::dag_offspring(hpo,
                                     term = dat$id)
        )
    }
    if(isTRUE(include_ancestors)){
      res <- c(res,
               simona::dag_ancestors(hpo,
                                     term = dat$id)
      )
    }
    return(unique(res))
  })
  hit_counts <- lapply(query_hits, length)
  messager("Number of phenotype gits per query group:")
  messager(paste(paste(" -",names(hit_counts)),hit_counts,
                 collapse = "\n",sep=": "),v=verbose)
  return(query_hits)
}
