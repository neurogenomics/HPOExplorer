hpo_modifiers_agg <- function(dt,
                              by = c("DatabaseID","HPO_ID")){
  Modifier <- Modifier_name <- DiseaseName <- DiseaseName <- DatabaseID <-
    Severity_score <- Severity_score_min <- HPO_ID <- NULL;

  by <- by[1]
  if(by=="HPO_ID"){
    dt2 <- dt[,list(
      Modifier=paste(unique(Modifier),collapse=";"),
      Modifier_name=paste(unique(Modifier_name),collapse=";"),
      Modifier_count=paste(table(unlist(Modifier_name)),collapse=";"),
      DiseaseNames=paste(unique(DiseaseName),collapse = ";"),
      DiseaseNames_count=length(unique(DiseaseName)),
      DatabaseID_count=length(unique(DatabaseID)),
      Severity_score_mean=mean(Severity_score, na.rm=TRUE),
      Severity_score_min=min(Severity_score, na.rm=TRUE)
    ), by=by]
  } else if (by=="DatabaseID"){
    dt2 <- dt[,list(
      DiseaseName=DiseaseName,
      Modifier=paste(unique(Modifier),collapse=";"),
      Modifier_name=paste(unique(Modifier_name),collapse=";"),
      Modifier_count=paste(table(unlist(Modifier_name)),collapse=";"),
      HPO_IDs=paste(unique(HPO_ID),collapse = ";"),
      HPO_ID_count=length(unique(HPO_ID)),
      Severity_score_count=length(stats::na.omit(unique(Severity_score))),
      Severity_score_mean=mean(Severity_score, na.rm=TRUE),
      Severity_score_min=min(Severity_score, na.rm=TRUE)
    ), by=by]
  }
  #### Post-processing ####
  dt2[Severity_score_min==Inf,]$Severity_score_min <- NA
  dt2[Severity_score_min<0,]$Severity_score_min <- NA
  dt2$Modifer_top <- lapply(seq_len(nrow(dt2)),
                            function(i){
                                  r <- dt2[i,]
                                  mn <- strsplit(r$Modifier_name,";")[[1]]
                                  mc <- strsplit(r$Modifier_count,";")[[1]]
                                  mn[mc==max(mc)][[1]]
                                }) |> unlist()
  return(dt2)
}
