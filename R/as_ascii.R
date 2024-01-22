as_ascii <- function(dat,
                     cols=names(dat)){
  cols <- cols[cols %in% names(dat)]
  func <- function(v){
    Encoding(v) <- "latin1"
    iconv(v, "latin1", "UTF-8")
  }
  for(col in cols){
    if(is.character(dat[[col]])){
      dat[[col]] <- func(dat[[col]])
    }
  }
  return(dat)
}
