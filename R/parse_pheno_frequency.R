parse_pheno_frequency <- function(annot){
  hpo_id <- disease_id <- frequency <- NULL;

  annot <- annot[frequency!=""]
  freq_dt <- lapply(seq(nrow(annot)), function(i){
    f <- annot[i,]$frequency
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
    dt[,hpo_id:=annot[i,]$hpo_id][,disease_id:=annot[i,]$disease_id]
    return(dt)
  }) |> data.table::rbindlist(fill=TRUE)
  freq_dt$pheno_freq_mean <- rowMeans(
    freq_dt[,c("pheno_freq_min","pheno_freq_max")], na.rm = TRUE
  )
  return(freq_dt)
}
