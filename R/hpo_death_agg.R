hpo_death_agg <- function(hpo_deaths,
                          by=c("disease_id","hpo_id")){
  AgeOfDeath <- AgeOfDeath_name <- AgeOfDeath_score <- . <- NULL;

  by <- by[by %in% names(hpo_deaths)]
  dict <- hpo_dict(type = "AgeOfDeath")
  annot_agg <-hpo_deaths[,.(
    AgeOfDeath=list(unique(AgeOfDeath)),
    AgeOfDeath_names=list(unique(AgeOfDeath_name)),
    AgeOfDeath_counts=list(table(AgeOfDeath_name)),
    AgeOfDeath_score_mean=mean(AgeOfDeath_score,na.rm=TRUE),
    AgeOfDeath_score_min=min(AgeOfDeath_score,na.rm=TRUE),
    AgeOfDeath_score_max=max(AgeOfDeath_score,na.rm=TRUE)
  ), by=by]
  annot_agg$AgeOfDeath_top <- lapply(seq(nrow(annot_agg)),
                             function(i){
                               r <- annot_agg[i,]
                               on <-unlist(r$AgeOfDeath_names)
                               oc <-unlist(r$AgeOfDeath_counts)
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
