#' Unlist column
#'
#' Unlist a column in a \link[data.table]{data.table}.
#' @param dat \link[data.table]{data.table}
#' @param col Column name.
#' @returns \link[data.table]{data.table}
#'
#' @keywords internal
unlist_col <- function(dat,
                       col){
  dat[rep(dat[,.I],lengths(get(col)))
  ][, eval(col) := unlist(dat[[col]])][]
}
