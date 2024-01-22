add_prevalence_report <- function(phenos,
                                  phenos2,
                                  input_col,
                                  verbose=TRUE){
  mean_prevalence <- NULL;
  phenos2 <- data.table::copy(phenos2)
  phenos2 <- phenos2[!is.na(mean_prevalence),]
 for(idc in input_col){
   n_end <- length(unique(phenos2[[idc]]))
   n_start <-  length(unique(phenos[[idc]]))
   messager(
     "Prevalence added for",
     formatC(n_end,big.mark = ","),
     "/",
     formatC(n_start,big.mark = ","),
     idc,
     "IDs",
     paste0("(",round(n_end/n_start*100,1),"%)"),
     v=verbose
   )
 }
}
