oard_query_api <- function(ids,
                           concept_prefix="q=",
                           domain="https://rare.cohd.io/api/",
                           dataset_id=NULL,
                           endpoint="vocabulary/findConceptByAny",
                           batch_size=100,
                           workers=1,
                           verbose=TRUE){
  # devoptera::args2vars(oard_query_api)
  requireNamespace("BiocParallel")

  ids <- na.omit(unique(ids))
  messager("Querying OARD API for",formatC(length(ids),big.mark = ","),
           "IDs.",v=verbose)
  batches <- split(ids, ceiling(seq_along(ids)/batch_size))
  oard_query_api_i <- function(batch,
                               ...){
    URL <- paste0(paste0(domain,endpoint),"?",
                  ifelse(is.null(dataset_id),
                         "",
                         paste0("dataset_id=",dataset_id,"&")
                  ),
                  if(!is.null(batch)){
                    paste0(concept_prefix,
                           htmltools::urlEncodePath(
                             paste(batch,collapse = ";")
                           )
                    )
                  } else {
                    ""
                  }
    )
    # message(URL)
    res <- httr::GET(URL)
    cont <- httr::content(res, as = "text", encoding = "UTF-8")
    js <- jsonlite::fromJSON(cont, simplifyDataFrame = TRUE)
    dt <- js$results
    if(length(dt)==0) return(dt)
    if(nrow(dt)==length(js$parameter$q)) dt$query <- js$parameter$q
    return(dt)
  }
  BiocParallel::register(BiocParallel::MulticoreParam(workers=workers,
                                                      progressbar = TRUE))
  RES <- BiocParallel::bplapply(batches,
                                oard_query_api_i,
                                match.call()) |>
    data.table::rbindlist(idcol = "batch", fill = TRUE)
  return(RES)
}
