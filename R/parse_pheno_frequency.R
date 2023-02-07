parse_pheno_frequency <- function(annot){
  HPO_ID <- DiseaseName <- NULL;

  freq_dt <- lapply(seq_len(nrow(annot)), function(i){
    f <- annot[i,]$Frequency
    if(grepl("^HP",f)){
      dt <- data.table::data.table(
        pheno_freq_name = get_freq_dict()[f],
        pheno_freq_min = get_freq_dict(type="min")[f],
        pheno_freq_max = get_freq_dict(type="max")[f])
    } else if(grepl("/",f)){
      splt <- as.numeric(strsplit(f,"/")[[1]])
      val <- splt[[1]] / splt[[2]]*100
      dt <- data.table::data.table(
        pheno_freq_name="ratio",
        pheno_freq_min=val,
        pheno_freq_max=val)
    } else if(grepl("[%]",f)){
      val <- as.numeric(gsub("[%]","",f))
      dt <- data.table::data.table(
        pheno_freq_name="percentage",
        pheno_freq_min=val,
        pheno_freq_max=val)
    } else {
      return(NULL)
    }
    dt[,HPO_ID:=annot[i,]$HPO_ID][,DiseaseName:=annot[i,]$DiseaseName]
    return(dt)
  }) |> data.table::rbindlist(fill=TRUE)
  freq_dt$pheno_freq_mean <- rowMeans(
    freq_dt[,c("pheno_freq_min","pheno_freq_max")], na.rm = TRUE
  )
  return(freq_dt)
}
