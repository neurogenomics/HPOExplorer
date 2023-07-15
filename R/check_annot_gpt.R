#' Check annotations from GPT
#'
#' Check chatGPT phenotype annotations using a several metrics.
#' @param path Path to annotations file.
#' @returns Named list
#'
#' @keywords internal
#' @import data.table
#' @importFrom stats na.omit
check_annot_gpt <- function(path){

  # path="~/Downloads/gpt_hpo_annotations_scale.csv"
  hpo_id <- phenotype <- pheno_count <- NULL;

  #### Read data ####
  d <- data.table::fread(path)[,1:21]
  #### Check phenotype names ####
  annot <- HPOExplorer::load_phenotype_to_genes()
  d <- merge(d,
             unique(annot[,c("hpo_id","hpo_name")]),
             by.x="phenotype",
             by.y="hpo_name")
  unique(d[is.na(hpo_id)]$phenotype)
  phenotype_miss_rate <-
    length(d$phenotype[!d$phenotype %in% annot$hpo_name]) /
    length(d$phenotype)
  #### Check annotation consistency ####
  nm <- names(d)[!grepl("phenotype|justification|hpo_id",names(d),
                        ignore.case = TRUE)]
  opts <- unlist(sapply(d[,nm,with=FALSE], unique)) |> unique()
  print(opts)
  d[,pheno_count:=table(d$phenotype)[phenotype]]
  d_mean <- d[pheno_count>1][,lapply(.SD,function(x){mean(tolower(x)!="never")}),
                             .SDcols=nm,
              by="phenotype"]
  d_consist <- lapply(d_mean[,-1], function(x)sum(x%in%c(0,1)/nrow(d_mean)))
  #### Check ontology classifications #####
  ## Find matching HPO branches
  hpo <- get_hpo()
  queries <- list(
    intellectual_disability=c("intellectual disability"),
    impaired_mobility=c("Abnormal central motor function",
                        "Abnormality of movement"),
    physical_malformations=c("malformation","morphology"),
    blindness=c("^blindness"),
    sensory_impairments=c("Abnormality of vision",
                          "Abnormality of the sense of smell",
                          "Abnormality of taste sensation",
                          "Somatic sensory dysfunction",
                          "Hearing abnormality"
                          ),
    immunodeficiency=c("Immunodeficiency"),
    cancer=c("Neoplasm","Cancer"),
    reduced_fertility=c("Decreased fertility")
    )
  tiers <- lapply(queries, function(q){
    terms <- grep(paste(q,collapse = "|"),
         hpo$name,
         ignore.case = TRUE, value = TRUE)
    ontologyIndex::get_descendants(ontology = hpo,
                                   roots = names(terms),
                                   exclude_roots = FALSE) |>
      unique()
  })
  annot_check <- lapply(seq_len(nrow(d)), function(i){
    r <- d[i,]
    cbind(
      r[,c("phenotype","hpo_id")],
      lapply(stats::setNames(names(tiers),names(tiers)),
             function(x){
               if(r$hpo_id %in% tiers[[x]]){
                 tolower(r[,x,with=FALSE][[1]])!="no"
               } else {
                 NA
               }
             }) |> data.table::as.data.table()
    )
  }) |> data.table::rbindlist()

  ### Proportion of rows where annotation is NA
  missing_rate <- sapply(
    annot_check[,names(tiers),with=FALSE],
    function(x){sum(is.na(x))/length(x)})
  nonmissing_count <- sapply(
    annot_check[,names(tiers),with=FALSE],
    function(x){sum(!is.na(x))})
  ### Proportion of rows where the annotation was checkable and TRUE
  true_pos_rate <- sapply(
    annot_check[,names(tiers),with=FALSE],
    function(x){sum(stats::na.omit(x)==TRUE)/length(stats::na.omit(x))})
  ### Proportion of rows where the annotation was checkable and FALSE
  false_neg_rate <- sapply(
    annot_check[,names(tiers),with=FALSE],
    function(x){sum(stats::na.omit(x)==FALSE)/length(stats::na.omit(x))})
  #### Return ####
  return(list(
    phenotype_miss_rate=phenotype_miss_rate,
    d_mean=d_mean,
    d_consist=d_consist,
    annot_check=annot_check,
    missing_rate=missing_rate,
    true_pos_rate=true_pos_rate,
    false_neg_rate=false_neg_rate
  ))
}
