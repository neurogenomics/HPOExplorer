report_missing <- function(phenos,
                           col,
                           verbose=TRUE){
  merge_col <- c("disease_id","disease_id")
  merge_col <- merge_col[merge_col %in% names(phenos)]
  phenos2 <- phenos[,c(merge_col,col),with=FALSE] |> unique()
  n_missing <- sum(is.na(phenos2[[col]]))
  n_total <- nrow(phenos2)
  messager(n_missing,"/",n_total,
           paste0("(",round(n_missing/n_total*100,2),"%)"),
           col,"missing.",v=verbose)
}
