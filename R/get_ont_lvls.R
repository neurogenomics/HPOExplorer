#' Get ontology level for HPO terms
#'
#' For a given set of HPO terms, get their level
#' within the hierarchically organised HPO ontology.
#' Ontology level can be computed either absolute mode (\code{absolute=TRUE})
#' where the entire ontology is considered when assigning levels, or
#' relative mode (\code{absolute=FALSE}) where only a subset of the ontology
#' that is connected to a given term is considered when assigning levels.
#' Relative mode can be helpful when trying to make plot where nodes are
#' scaled to the ontology level, as in \link[MultiEWCE]{ggnetwork_plot_full}.
#' This calls the \link[HPOExplorer]{get_ont_lvl} function internally
#' @param absolute Make the levels absolute in the sense that they consider
#'  the entire HPO ontology (\code{TRUE}).
#'  Otherwise, levels will be relative to only the HPO terms that are in
#'   the provided subset of \code{terms} AND are directly adjacent (connected)
#'   to a given cluster of terms (\code{FALSE}).
#' @param reverse If \code{TRUE}, ontology
#' level numbers with be revered such that the level of the parent terms
#' are larger than the child terms.
#' @param exclude_top_lvl Exclude the top level term of the HPO
#' (i.e. "All" (HP:0000001)) when computing \emph{absolute} levels.
#' This argument is not used when computing \emph{relative} levels.
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @inheritParams adjacency_matrix
#' @returns A named vector of relative ontology level,
#' where names are HPO Ids and
#' value is relative ontology level.
#'
#' @export
#' @importFrom stats setNames
#' @examples
#' terms <- ontologyIndex::get_descendants(ontology = get_hpo(),
#'                                         roots = "HP:0000002")
#' lvls <- get_ont_lvls(terms = terms)
#' lvls_abs <- get_ont_lvls(terms = terms, absolute=TRUE)
get_ont_lvls <- function(terms,
                         hpo = get_hpo(),
                         adjacency = NULL,
                         absolute = TRUE,
                         exclude_top_lvl=TRUE,
                         reverse = TRUE,
                         verbose = TRUE) {

    terms <- unique(terms)
    messager("Getting",if(absolute)"absolute"else"relative",
             "ontology level for",
             formatC(length(terms),big.mark = ","),"HPO IDs.", v=verbose)
    #### Create adjacency matrix if needed ####
    if(isFALSE(absolute) &
       is.null(adjacency)){
      adjacency <- adjacency_matrix(terms = terms,
                                    hpo = hpo,
                                    verbose = verbose)
    }
    #### Get ontology levle for each HPO term ####
    hierarchy <- lapply(stats::setNames(terms,
                                        terms),
                        function(term){
      get_ont_lvl(term = term,
                  hpo = hpo,
                  adjacency = adjacency,
                  absolute = absolute,
                  verbose = FALSE)
    }) |> unlist()
    #### Reverse levels ####
    if (isTRUE(reverse) &&
        isFALSE(absolute)) {
        hierarchy <- max(hierarchy) - hierarchy
    }
    if(isFALSE(reverse) &&
       isTRUE(absolute)){
      max_lvl <- get_max_ont_lvl(hpo = hpo,
                                 exclude_top_lvl = exclude_top_lvl)
      hierarchy <- max_lvl- hierarchy
    }
    return(hierarchy)
}
