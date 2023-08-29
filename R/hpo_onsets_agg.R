hpo_onsets_agg <- function(hpo_onsets,
                           phenos,
                           agg_by=c("disease_id","hpo_id")){
  hpo_id <- onset <- onset_name <- onset_score <- . <- NULL;

  dict <- hpo_dict(type = "onset")
  if("hpo_id" %in% names(phenos)){
    hpo_onsets <- hpo_onsets[hpo_id %in% unique(phenos$hpo_id)]
  }
  # f <- function(x, fun=mean){
  #   if(all(is.na(x))) NA else fun(x,na.rm=TRUE)
  # }
  annot_agg <- hpo_onsets[,.(onset=paste(unique(onset),collapse = ";"),
                        onset_names=paste(unique(onset_name),collapse = ";"),
                        onset_counts=paste(table(onset_name),collapse = ";"),
                        onset_score_mean=mean(onset_score,na.rm=TRUE),
                        onset_score_min=min(onset_score,na.rm=TRUE),
                        onset_score_max=max(onset_score,na.rm=TRUE)
  ),
  by=agg_by] |> suppressWarnings()
  annot_agg$onset_top <- lapply(seq(nrow(annot_agg)),
                                function(i){
                                  r <- annot_agg[i,]
                                  on <- strsplit(r$onset_names,";")[[1]]
                                  oc <- strsplit(r$onset_counts,";")[[1]]
                                  on[oc==min(oc)][[1]]
                                }) |> unlist()
  annot_agg$onset_earliest <- stats::setNames(names(dict),unname(dict))[
    as.character(annot_agg$onset_score_min)
  ]
  annot_agg$onset_latest <- stats::setNames(names(dict),unname(dict))[
    as.character(annot_agg$onset_score_max)
  ]
  return(annot_agg)
}
