mondo_dict <- function(mondo=get_mondo(),
                       ids=NULL){
  xref <- unlist(mondo$xref)
  # xref <- xref[names(xref) %in% names(mondo$id)]
  dict <- xref |> invert_dict()
  names(dict) <- gsub("^Orphanet","ORPHA",names(dict))
  if(!is.null(ids)) {
    return(dict[ids])
  } else {
    return(dict)
  }
}
