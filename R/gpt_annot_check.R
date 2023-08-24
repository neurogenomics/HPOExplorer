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
  hpo_id <- phenotype <- pheno_count <- NULL;

  #### Read data ####
  d <- data.table::fread(path)
  #### Check phenotype names ####
  annot <- load_phenotype_to_genes(verbose = verbose)
  d <- merge(d,
             unique(annot[,c("hpo_id","hpo_name")]),
             by.x="phenotype",
             by.y="hpo_name")
  messager(length(unique(d[is.na(hpo_id)]$phenotype)),
           "phenotypes do not have matching HPO IDs.",v=verbose)
  phenotype_miss_rate <-
    length(d$phenotype[!d$phenotype %in% annot$hpo_name]) /
    length(d$phenotype)
  d <- data.frame(d)
  d[d==""] <- NA
  d <- data.table::data.table(d)
  #### Check annotation consistency ####
  nm <- names(d)[!grepl("phenotype|justification|hpo_id",names(d),
                        ignore.case = TRUE)]
  counts <- table(tolower(unlist(d[,nm,with=FALSE])), useNA = "always")
  neg_values <- c("never","no")
  opts <- unlist(sapply(d[,nm,with=FALSE], unique)) |> unique()
  # methods::show(opts)
  d[,pheno_count:=table(d$phenotype)[phenotype]]
  d_mean <- d[pheno_count>1][,lapply(.SD,function(x){
    mean(!tolower(x) %in% neg_values)
  }),.SDcols=nm,by="phenotype"]
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
    phenotype_miss_rate=phenotype_miss_rate,
    annot_mean=d_mean,
    annot_consist=d_consist,
    annot_check=d_check,
    missing_rate=missing_rate,
    nonmissing_count=nonmissing_count,
    true_pos_rate=true_pos_rate,
    false_neg_rate=false_neg_rate
  ))
}
