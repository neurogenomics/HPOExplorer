#' Unlist column
#'
#' Unlist a column in a \link[data.table]{data.table}.
#' @param dt \link[data.table]{data.table}
#' @param col Column name.
#' @returns \link[data.table]{data.table}
#'
#' @keywords internal
unlist_col <- function(dt,
                       col){
  dt[rep(dt[,.I],lengths(get(col)))
  ][, eval(col) := unlist(dt[[col]])][]
}
