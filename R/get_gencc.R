get_gencc <- function(agg_by=c("disease_id",
                               "gene_symbol"),
                      save_dir=tools::R_user_dir("HPOExplorer",
                                                 which="cache"),
                      verbose=TRUE){

  disease_id <- disease_original_curie <- classification_title <-
    evidence_score <- NULL;

  messager("Gathering data from GenCC.",v=verbose)
  URL <- "https://search.thegencc.org/download/action/submissions-export-csv"
  f <- file.path(save_dir,"genCC_submission.csv")
  if(!file.exists(f)){
    dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)
    utils::download.file(URL, f)
  } else {
    messager("Importing cached file.",v=verbose)
  }
  d <- data.table::fread(f)
  d[,disease_id:=gsub("^Orphanet","ORPHA",disease_original_curie)]
  #### Encode evidence numerically ####
  # https://thegencc.org/faq.html#validity-termsdelphi-survey
  dict <- c("Definitive"=6,# GENCC:100001
            "Strong"=5, # GENCC:100002
            "Moderate"=4, # GENCC:100003
            "Supportive"=3, # GENCC:100009
            "Limited"=2, # GENCC:100004
            "Disputed Evidence"=1, # GENCC:100005
            "Refuted Evidence"=0, # GENCC:100006
            "No Known Disease Relationship"=0 # GENCC:100008
            )
  d[,evidence_score:=dict[classification_title]]
  #### Aggregate so that there's 1 entry/gene/disease ####
  if(!is.null(agg_by)){
    d <- d[,list(evidence_score_min=min(evidence_score, na.rm = TRUE),
                 evidence_score_max=max(evidence_score, na.rm = TRUE),
                 evidence_score_mean=mean(evidence_score, na.rm=TRUE)),
               by=agg_by]
  }
  return(d)
}
