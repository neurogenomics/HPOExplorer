gpt_annot_codify <- function(annot,
                             code_dict = c(
                               "never"=0,
                               "rarely"=1,
                               "varies"=2,
                               "often"=3,
                               "always"=4
                             ),
                             tiers_dict=list(
                               congenital_onset=1,
                               intellectual_disability=1,
                               death=1,
                               impaired_mobility=2,
                               physical_malformations=2,
                               blindness=3,
                               sensory_impairments=3,
                               immunodeficiency=3,
                               cancer=3,
                               reduced_fertility=4
                             )
                             ){
  score <- NULL;

  d <- data.table::copy(annot)
  cols <- grep("justification|phenotype|hpo_id|pheno_count",names(d),
               value = TRUE, invert = TRUE)
  #### Add levels ####
  d <- d[,lapply(.SD,function(x){
    factor(tolower(x),levels = rev(names(code_dict)), ordered = TRUE)
    }),
    .SDcols = cols,
    by=c("hpo_id","phenotype")]

  max_score <-
    sum(
      max(code_dict, na.rm = TRUE) *
        (max(unlist(tiers_dict))+1) - unlist(tiers_dict)
    )
  d_coded <- d[,lapply(.SD,FUN=function(x){
    unlist(code_dict[tolower(x)])}),.SDcols = cols, by=c("hpo_id","phenotype")]
  {
    d_weighted <- data.table::as.data.table(
      lapply(stats::setNames(cols,cols),
             function(co){d_coded[[co]]*
                 ((max(unlist(tiers_dict))+1)-tiers_dict[[co]]) })
    )
    d_weighted <- cbind(
      d_coded[,-cols,with=FALSE],
      d_weighted[,score:=(rowSums(d_weighted,na.rm = TRUE)/max_score*100)]) |>
      data.table::setorderv("score",-1, na.last = TRUE)
  }
  d[,phenotype:=factor(phenotype,
                       levels = unique(d_weighted$phenotype),
                       ordered = TRUE)]
  # d_weighted[score!=0]
  return(list(
    annot=d,
    annot_coded=d_coded,
    annot_weighted=d_weighted
  ))
}
