#' Convert ontology
#'
#' Convert an  \link[ontologyIndex]{ontology_index} to
#' a number of other useful formats.
#' @param ont An \link[ontologyIndex]{ontology_index} object.
#' @param to A character string specifying the format to convert to.
#' @param as_sparse If TRUE, return a sparse matrix where possible.
#' @inheritParams adjacency_matrix
#' @returns An object of the specified format.
#'
#' @export
#' @importFrom ontologyIndex get_term_descendancy_matrix
#' @importFrom stats as.dist hclust cutree
#' @examples
#' ont <- get_hpo()
#' terms <- head(ont$id,100)
#' obj <- convert_ontology(ont=ont, terms=terms, to="igraph_dist_hclust")
convert_ontology <- function(ont=get_hpo(),
                             terms=unique(ont$id),
                             remove_terms=grep(":",terms,
                                               invert = TRUE, value = TRUE),
                             to=c("adjacency",
                                  "descendancy",
                                  "dist",
                                  "dist_hclust",
                                  "dist_hclust_dendrogram",
                                  "clusters",
                                  "igraph",
                                  "igraph_dist",
                                  "igraph_dist_hclust",
                                  "igraph_dist_hclust_dendrogram",
                                  "tidygraph",
                                  "data.frame",
                                  "data.table"),
                             as_sparse=FALSE){
  # devoptera::args2vars(convert_ontology, reassign = TRUE)
  to <- match.arg(to)
  if(to=="tidygraph") requireNamespace("tidygraph")
  if(to=="igraph") requireNamespace("igraph")
  terms <- terms[!terms %in% remove_terms]

  if(to=="adjacency"){
    obj <- adjacency_matrix(hpo = ont,
                            terms = terms,
                            remove_terms = remove_terms)
  } else if(to=="descendancy"){
    obj <- ontologyIndex::get_term_descendancy_matrix(ontology = ont,
                                                      terms = terms)
  } else if(to=="dist"){
    adj <- convert_ontology(ont, terms, remove_terms, to="adjacency")
    # obj <- stats::dist(adj) ### seems to take forever
    obj <- stats::as.dist(abs(adj-max(adj)))
  } else if(to=="dist_hclust"){
    d <- convert_ontology(ont, terms, remove_terms, to="dist")
    obj <- stats::hclust(d)
  } else if(to=="dist_hclust_dendrogram"){
    dh <- convert_ontology(ont, terms, remove_terms, to="dist_hclust")
    obj <- stats::as.dendrogram(dh)
  }else if(to=="clusters"){
    hc <- convert_ontology(ont, terms, remove_terms, to="hclust")
    obj <- stats::cutree(hc,k=10)
  } else if(to=="igraph"){
    adj <- convert_ontology(ont, terms, remove_terms, to="adjacency")
    obj <- igraph::graph_from_adjacency_matrix(adj)
  } else if (to=="igraph_dist"){
    g <- convert_ontology(ont, terms, remove_terms, to="igraph")
    obj <- igraph::distances(g)
  } else if(to=="igraph_dist_hclust"){
    gd <- convert_ontology(ont, terms, remove_terms, to="igraph_dist")
    if(any(is.infinite(gd))) gd[is.infinite(gd)] <- max(gd[!is.infinite(gd)])
    obj <- stats::hclust(stats::as.dist(gd))
  } else if(to=="igraph_dist_hclust_dendrogram"){
    gdh <- convert_ontology(ont, terms, remove_terms, to="igraph_dist_hclust")
    obj <- stats::as.dendrogram(gdh)
  } else if(to=="tidygraph"){
    g <- convert_ontology(ont, terms, remove_terms, to="igraph")
    obj <- tidygraph::as_tbl_graph(g)
  } else if(to=="data.frame"){
    obj <- as.data.frame(ont)
    if(!is.null(terms)) obj <- obj[terms,]
    if(!is.null(remove_terms)) obj <- obj[!obj$id %in% remove_terms,]
  } else if(to=="data.table"){
    df <- convert_ontology(ont, terms, remove_terms, to="data.frame")
    obj <- data.table::as.data.table(df)
  }else {
    stop("Unknown conversion type.")
  }
  #### Convert to sparse ####
  if(isTRUE(as_sparse)){
    if(methods::is(obj,"matrix")){
      obj <- Matrix::Matrix(adj, sparse=TRUE)
    }
  }
  ## Report
  messager("Converted ontology to:",to,
           if(as_sparse) paste0("(sparse)") else NULL
             )
  return(obj)
}
