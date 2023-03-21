hpo_death_agg <- function(phenos,
                          hpo_deaths,
                          by=c("DatabaseID","HPO_ID")){
  HPO_ID <- AgeOfDeath <- AgeOfDeath_name <- AgeOfDeath_score <- . <- NULL;

  by <- by[1]
  dict <- hpo_dict(type = "AgeOfDeath")
  annot_agg <-hpo_deaths[,.(
    AgeOfDeath=paste(unique(AgeOfDeath),collapse = ";"),
    AgeOfDeath_names=paste(unique(AgeOfDeath_name),collapse = ";"),
    AgeOfDeath_counts=paste(table(AgeOfDeath_name),collapse = ";"),
    AgeOfDeath_score_mean=mean(AgeOfDeath_score,na.rm=TRUE),
    AgeOfDeath_score_min=min(AgeOfDeath_score,na.rm=TRUE),
    AgeOfDeath_score_max=max(AgeOfDeath_score,na.rm=TRUE)
  ), by=by]
  annot_agg$AgeOfDeath_top <- lapply(seq_len(nrow(annot_agg)),
                             function(i){
                               r <- annot_agg[i,]
                               on <- strsplit(r$AgeOfDeath_names,";")[[1]]
                               oc <- strsplit(r$AgeOfDeath_counts,";")[[1]]
                               on[oc==min(oc)][[1]]
                             }) |> unlist()
  annot_agg$AgeOfDeath_earliest <- stats::setNames(names(dict),unname(dict))[
    as.character(annot_agg$AgeOfDeath_score_min)
  ]
  annot_agg$AgeOfDeath_latest <- stats::setNames(names(dict),unname(dict))[
    as.character(annot_agg$AgeOfDeath_score_max)
  ]
  return(annot_agg)
}
