#' Get HPO term ontology level
#'
#' In this function, ontology level refers to the number of generations of
#' sub-phenotypes a term has below it in the HPO DAG. For example, the root of
#' the HPO is term "HP:0000001", the longest path to a term with no child terms
#' is 14. In other words there are 14 generations of "is-a" relationships below
#' HP:0000001 and it is therefore at ontology level 14. A term with no
#' sub-phenotypes below it (a leaf node), is at ontology level 0.
#'
#' Typically this function should be used to get the level of a single term,
#' but you can supply a vector of multiple terms and it will return the level of
#' the highest level term in that vector.
#' @param term_ids A HPO Id (e.g. "HP:0000001") or a
#' vector of multiple Ids \<string\> or \<vector_string\>.
#' @inheritParams make_phenos_dataframe
#' @returns Ontology level of HPO ID.
#'
#' @export
#' @examples
#' lvl <- get_ont_level(term_ids = "HP:0000001")
get_ont_level <- function(term_ids,
                          hpo = get_hpo(),
                          verbose = FALSE) {
    messager("Getting ontology level for:", paste(term_ids,collapse = ", "),
             v=verbose)
    children <- unique(
      setdiff(unlist(hpo$children[term_ids]),
              term_ids)
    )
    if (length(children) == 0) {
        return(0)
    } else {
        return(1 + get_ont_level(term_ids = children,
                                 hpo = hpo,
                                 verbose = verbose)) #<- recursion..
    }
}
