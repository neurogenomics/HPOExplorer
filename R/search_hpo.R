#' Search the Human Phenotype Ontology
#'
#' Serarch for phenotypes in the HPO that match substring queries,
#' or are the descendants of those substring-matched phenotypes.
#' @param queries A named list of character vectors.
#' Each vector includes a phenoptype name (or a substring)
#' to be searched for in the HPO.
#' @param include_descendants Include all descendants of query hits.
#' @param include_ancestors Include all ancestors of query hits.
#' @param search_cols HPO metadata column names to query for hits.
#' @inheritParams make_phenos_dataframe
#' @inheritParams base::grepl
#' @returns Named list of HPO IDs.
#'
#' @export
#' @examples
#' query_hits <- search_hpo()
search_hpo <- function(hpo = get_hpo(),
                       queries = list(

                         intellectual_disability=c(
                           "Intellectual disability",
                           "Mental deterioration"),
                         impaired_mobility=c(
                           # "Abnormal central motor function",
                           "Gait disturbance",
                           "Diminished movement",
                           " mobility"),
                         physical_malformations=c(
                           "malformation"#,"morphology"
                         ),
                         blindness=c("^blindness"),
                         sensory_impairments=c(
                           "Abnormality of vision",
                           "Abnormality of the sense of smell",
                           "Abnormality of taste sensation",
                           "Somatic sensory dysfunction",
                           "Hearing abnormality"
                         ),
                         immunodeficiency=c("Immunodeficiency",
                                            "Impaired antigen-specific response"),
                         cancer=c("Cancer",
                                  "malignant",
                                  "carcinoma"
                         ),
                         reduced_fertility=c(
                           "Decreased fertility",
                           "Hypogonadism")
                       ),
                       search_cols=c("name"),#"definition"),
                       include_descendants=TRUE,
                       include_ancestors=FALSE,
                       ignore.case = TRUE,
                       fixed = FALSE,
                       verbose=TRUE){

  messager("Querying HPO for matching terms.")
  query_hits <- lapply(queries, function(q){
    terms <- c()
    search_cols <- intersect(search_cols, colnames(hpo@elementMetadata))
    if(length(search_cols) == 0){
      stop("No search columns found in HPO metadata.")
    }
    for(col in search_cols){
      terms <- c(terms,
                 rownames(hpo@elementMetadata)[
                   grepl(paste(q,collapse = "|"),
                         hpo@elementMetadata[[col]],
                         ignore.case = TRUE,
                         fixed = fixed)
                 ]
      )
    }
    terms <- unique(terms)
    res <- c()
    if(isTRUE(include_descendants)){
      res <- c(res,
               simona::dag_offspring(hpo,
                                     term = terms)
        )
    }
    if(isTRUE(include_ancestors)){
      res <- c(res,
               simona::dag_ancestors(hpo,
                                     term = terms)
      )
    }
    return(unique(res))
  })
  hit_counts <- lapply(query_hits, length)
  messager("Number of phenotype hits per query group:")
  messager(paste(paste(" -",names(hit_counts)),hit_counts,
                 collapse = "\n",sep=": "),v=verbose)
  return(query_hits)
}
