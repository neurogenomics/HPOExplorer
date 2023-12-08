report_missing <- function(phenos,
                           id_col,
                           report_col,
                           verbose=TRUE){
  report_missing_i <- function(phenos,
                               id_col,
                               report_col,
                               verbose=TRUE){
    phenos2 <- phenos[,c(id_col,report_col),with=FALSE] |> unique()
    n_missing <- sum(is.na(phenos2[[report_col]]))
    n_total <- nrow(phenos2)
    messager(formatC(n_missing,big.mark = ","),
             "/",
             formatC(n_total,big.mark=","),
             paste0("(",round(n_missing/n_total*100,2),"%)"),
             report_col,"missing.",v=verbose)
  }
  for(rc in report_col){
    report_missing_i(phenos = phenos,
                     id_col = id_col,
                     report_col = rc,
                     verbose = verbose)
  }
}
