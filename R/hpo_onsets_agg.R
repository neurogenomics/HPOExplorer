hpo_onsets_agg <- function(hpo_onsets,
                           phenos,
                           agg_by=c("DatabaseID","HPO_ID")){
  HPO_ID <- Onset <- Onset_name <- Onset_score <- . <- NULL;


  if("HPO_ID" %in% names(phenos)){
    hpo_onsets <- hpo_onsets[HPO_ID %in% unique(phenos$HPO_ID)]
  }
  annot_agg <- hpo_onsets[,.(Onset=paste(unique(Onset),collapse = ";"),
                        Onset_names=paste(unique(Onset_name),collapse = ";"),
                        Onset_counts=paste(table(Onset_name),collapse = ";"),
                        Onset_score_mean=mean(Onset_score,na.rm=TRUE),
                        Onset_score_min=min(Onset_score,na.rm=TRUE),
                        Onset_score_max=max(Onset_score,na.rm=TRUE)
  ),
  by=agg_by]
  annot_agg$Onset_top <- lapply(seq_len(nrow(annot_agg)),
                                function(i){
                                  r <- annot_agg[i,]
                                  on <- strsplit(r$Onset_names,";")[[1]]
                                  oc <- strsplit(r$Onset_counts,";")[[1]]
                                  on[oc==min(oc)][[1]]
                                }) |> unlist()
  annot_agg$Onset_earliest <- stats::setNames(names(dict),unname(dict))[
    as.character(annot_agg$Onset_score_min)
  ]
  annot_agg$Onset_latest <- stats::setNames(names(dict),unname(dict))[
    as.character(annot_agg$Onset_score_max)
  ]
  return(annot_agg)
}
