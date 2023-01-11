as_ascii <- function(dt,
                     cols=names(dt)){
  cols <- cols[cols %in% names(dt)]
  func <- function(v){
    Encoding(v) <- "latin1"
    iconv(v, "latin1", "UTF-8")
  }
  for(col in cols){
    if(is.character(dt[[col]])){
      dt[[col]] <- func(dt[[col]])
    }
  }
  return(dt)
}
