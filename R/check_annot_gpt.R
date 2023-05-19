#' Check annotations from GPT
#'
#' Check chatGPT phenotype annotations using a several metrics.
#' @param path Path to annotations file.
#' @returns Named list
#'
#' @keywords internal
check_annot_gpt <- function(path){

  # path="~/Downloads/annot_HPO_gpt_test.csv"
  #### Read data ####
  d <- data.table::fread(path, key = "Phenotype")
  #### Check phenotype names ####
  annot <- HPOExplorer::load_phenotype_to_genes()
  phenotype_miss_rate <-
    length(d$Phenotype[!d$Phenotype %in% annot$Phenotype]) /
    length(d$Phenotype)

  #### Check annotation consistency ####
  nm <- names(d)[!names(d) %in% c("Phenotype","Justification")]
  d_mean <- d[,lapply(.SD,function(x){mean(x=="Yes")}),.SDcols=nm,
              by="Phenotype"]
  d_consist <- lapply(d_mean[,-1], function(x)sum(x%in%c(0,1)/nrow(d_mean)))

  #### Check ontology classifications #####
  d$HPO_ID <- harmonise_phenotypes(phenotypes = d$Phenotype,
                                   as_hpo_ids = TRUE)
  ## Find matching HPO branches
  hpo <- get_hpo()
  queries <- list(
    Intellectual_Disability=c("intellectual disability"),
    Impaired_Mobility=c("Abnormal central motor function",
                        "Abnormality of movement"),
    Physical_Malformations=c("malformation","morphology"),
    Blindness=c("^blindness"),
    Sensory_Impairments=c("Abnormality of vision",
                          "Abnormality of the sense of smell",
                          "Abnormality of taste sensation",
                          "Somatic sensory dysfunction",
                          "Hearing abnormality"
                          ),
    Immunodeficiency=c("Immunodeficiency"),
    Cancer=c("Neoplasm","Cancer"),
    Reduced_Fertility=c("Decreased fertility")
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
      r[,c("Phenotype","HPO_ID")],
      lapply(stats::setNames(names(tiers),names(tiers)),
             function(x){
               if(r$HPO_ID %in% tiers[[x]]){
                 r[,x,with=FALSE][[1]]=="Yes"
               } else {
                 NA
               }
             }) |> data.table::as.data.table()
    )
  }) |> data.table::rbindlist()

  ### Number of rows where annotation is not NA
  missing_rate <- sapply(
    annot_check[,names(tiers),with=FALSE],
    function(x){sum(is.na(x))/length(x)})
  ### Number of rows where the annotation was checkable and TRUE
  true_pos_rate <- sapply(
    annot_check[,names(tiers),with=FALSE],
    function(x){sum(na.omit(x)==TRUE)/length(na.omit(x))})
  ### Number of rows where the annotation was checkable and FALSE
  false_neg_rate <- sapply(
    annot_check[,names(tiers),with=FALSE],
    function(x){sum(na.omit(x)==FALSE)/length(na.omit(x))})
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
