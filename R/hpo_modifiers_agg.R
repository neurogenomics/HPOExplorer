hpo_modifiers_agg <- function(dat,
                              by = c("disease_id","hpo_id")){
  modifier <- modifier_name <- disease_name <- disease_name <- disease_id <-
    Severity_score <- Severity_score_min <- hpo_id <- NULL;

  by <- by[1]
  if(by=="hpo_id"){
    dt2 <- dat[,list(
      modifier=paste(unique(modifier),collapse=";"),
      modifier_name=paste(unique(modifier_name),collapse=";"),
      modifier_count=paste(table(unlist(modifier_name)),collapse=";"),
      disease_names=paste(unique(disease_name),collapse = ";"),
      disease_names_count=length(unique(disease_name)),
      disease_id_count=length(unique(disease_id)),
      Severity_score_mean=mean(Severity_score, na.rm=TRUE),
      Severity_score_min=min(Severity_score, na.rm=TRUE)
    ), by=by]
  } else if (by=="disease_id"){
    dt2 <- dat[,list(
      disease_name=disease_name,
      modifier=paste(unique(modifier),collapse=";"),
      modifier_name=paste(unique(modifier_name),collapse=";"),
      modifier_count=paste(table(unlist(modifier_name)),collapse=";"),
      hpo_ids=paste(unique(hpo_id),collapse = ";"),
      hpo_id_count=length(unique(hpo_id)),
      Severity_score_count=length(stats::na.omit(unique(Severity_score))),
      Severity_score_mean=mean(Severity_score, na.rm=TRUE),
      Severity_score_min=min(Severity_score, na.rm=TRUE)
    ), by=by]
  }
  #### Post-processing ####
  dt2[Severity_score_min==Inf,]$Severity_score_min <- NA
  dt2[Severity_score_min<0,]$Severity_score_min <- NA
  dt2$Modifer_top <- lapply(seq(nrow(dt2)),
                            function(i){
                                  r <- dt2[i,]
                                  mn <- strsplit(r$modifier_name,";")[[1]]
                                  mc <- strsplit(r$modifier_count,";")[[1]]
                                  mn[mc==max(mc)][[1]]
                                }) |> unlist()
  return(dt2)
}
