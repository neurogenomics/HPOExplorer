#' Check annotations from chatGPT
#'
#' Check chatGPT phenotype annotations using a several metrics.
#' @param path Path to annotations file.
#' @returns Named list
#'
#' @keywords internal
#' @import data.table
#' @importFrom stats na.omit
gpt_annot_check <- function(path,
                            query_hits = search_hpo(),
                            verbose = TRUE
                            ){

  # path="~/Downloads/gpt_hpo_annotations.csv"
  pheno_count <- NULL;

  #### Read data ####
  d <- gpt_annot_read(path = path,
                      verbose = verbose)
  #### Proportion of HPO_IDs annotated before/after chatGPT ####
  # hpo <- get_hpo()
  # prior_ids <- unique(HPOExplorer::hpo_modifiers$hpo_id)
  # new_ids <- unique(d$hpo_id)
  # length(new_ids)/length(prior_ids)
  # length(prior_ids)/length(hpo$id)
  # length(new_ids)/length(hpo$id)
  #### Check annotation consistency ####
  nm <- names(d)[!grepl("phenotype|justification|hpo_id",names(d),
                        ignore.case = TRUE)]
  counts <- table(tolower(unlist(d[,nm,with=FALSE])), useNA = "always")
  neg_values <- c("never","no")
  opts <- unlist(sapply(d[,nm,with=FALSE], unique)) |> unique()

  #### Compute number of non-negative answers within each column####
  d_mean <- d[pheno_count>1][,lapply(.SD,function(x){
    mean(!tolower(x) %in% neg_values)
  }),.SDcols=nm,by="phenotype"]
  #### Compute consistency within each column ####
  d_consist <- lapply(d_mean[,-1], function(x)sum(x%in%c(0,1)/nrow(d_mean)))
  #### Check ontology classifications #####
  d_check <- lapply(seq_len(nrow(d)), function(i){
    r <- d[i,]
    cbind(
      r[,c("phenotype","hpo_id")],
      lapply(stats::setNames(names(query_hits),
                             names(query_hits)),
             function(x){
               if(r$hpo_id %in% query_hits[[x]]){
                 !tolower(r[,x,with=FALSE][[1]]) %in% neg_values
               } else {
                 NA
               }
             }) |> data.table::as.data.table()
    )
  }) |> data.table::rbindlist()
  ### Proportion of rows where annotation is NA
  missing_rate <- sapply(
    d_check[,names(query_hits),with=FALSE],
    function(x){sum(is.na(x))/length(x)})
  nonmissing_count <- sapply(
    d_check[,names(query_hits),with=FALSE],
    function(x){sum(!is.na(x))})
  ### Proportion of rows where the annotation was checkable and TRUE
  true_pos_rate <- sapply(
    d_check[,names(query_hits),with=FALSE],
    function(x){sum(stats::na.omit(x)==TRUE)/length(stats::na.omit(x))})
  ### Proportion of rows where the annotation was checkable and FALSE
  false_neg_rate <- sapply(
    d_check[,names(query_hits),with=FALSE],
    function(x){sum(stats::na.omit(x)==FALSE)/length(stats::na.omit(x))})
  #### Return ####
  return(list(
    annot=d,
    annot_mean=d_mean,
    annot_consist=d_consist,
    annot_check=d_check,
    missing_rate=missing_rate,
    nonmissing_count=nonmissing_count,
    true_pos_rate=true_pos_rate,
    false_neg_rate=false_neg_rate
  ))
}
