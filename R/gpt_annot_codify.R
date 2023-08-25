#' Check annotations from GPT
#'
#' Check GPT phenotype annotations using a several metrics.
#' @param remove_duplicates Ensure only 1 row per phenotype.
#' @param code_dict Numerical encodings of annotation values.
#' @param tiers_dict Numerical encodings of annotation column.
#' @param keep_congenital_onset Which stages of congenital onset to keep.
#' @inheritParams gpt_annot_check
#' @returns Named list
#'
#' @export
#' @import data.table
#' @importFrom stats na.omit
#' @importFrom utils head
#' @examples
#' checks <- gpt_annot_check()
gpt_annot_codify <- function(annot = gpt_annot_read(),
                             remove_duplicates=TRUE,
                             code_dict = c(
                               "never"=0,
                               "rarely"=1,
                               "varies"=2,
                               "often"=3,
                               "always"=4
                             ),
                             tiers_dict=list(
                               intellectual_disability=1,
                               death=1,
                               impaired_mobility=2,
                               physical_malformations=2,
                               blindness=3,
                               sensory_impairments=3,
                               immunodeficiency=3,
                               cancer=3,
                               reduced_fertility=4
                             ),
                             keep_congenital_onset=head(names(code_dict),4)
                             ){
  # res <- gpt_annot_check(path="~/Downloads/gpt_hpo_annotations.csv")
  # annot <- res$annot
  severity_score_gpt <- congenital_onset <- phenotype <- hpo_id <- NULL;

  d <- data.table::copy(annot)
  #### Ensure only 1 row/phenotype by simply taking the first ####
  if(isTRUE(remove_duplicates)){
    d <- d[,utils::head(.SD,1), by=c("hpo_id","phenotype")]
  }
  cols <- names(tiers_dict)
  #### Add levels ####
  d <- d[,lapply(.SD,function(x){
    factor(tolower(x),levels = rev(names(code_dict)), ordered = TRUE)
    }),
    .SDcols = unique(c(cols,"congenital_onset")),
    by=c("hpo_id","phenotype")]
  #### Filter congenital onset ####
  if(!is.null(keep_congenital_onset)){
    d <- d[congenital_onset %in% keep_congenital_onset,]
  }
  #### Compute max possible score ####
  max_score <-
    sum(
      max(code_dict, na.rm = TRUE) *
        (max(unlist(tiers_dict))+1) - unlist(tiers_dict)
    )
  d_coded <- d[,lapply(.SD,FUN=function(x){
    unlist(code_dict[tolower(x)])}),.SDcols = cols, by=c("hpo_id","phenotype")]
  d_weighted <- data.table::as.data.table(
    lapply(stats::setNames(cols,cols),
           function(co){d_coded[[co]]*
               ((max(unlist(tiers_dict))+1)-tiers_dict[[co]]) })
  )[,hpo_id:=d_coded$hpo_id][,severity_score_gpt:=(
    rowSums(.SD,na.rm = TRUE)/max_score*100),
                             .SDcols=cols][d_coded[,-cols,with=FALSE],
                                           on="hpo_id"] |>
    data.table::setorderv("severity_score_gpt",-1, na.last = TRUE) |>
    unique()
  #### Order phenotypes by severity_score_gpt #####
  d[,phenotype:=factor(phenotype,
                       levels = unique(d_weighted$phenotype),
                       ordered = TRUE)]
  d_coded[,phenotype:=factor(phenotype,
                       levels = unique(d_weighted$phenotype),
                       ordered = TRUE)]
  d_weighted[,phenotype:=factor(phenotype,
                       levels = unique(d_weighted$phenotype),
                       ordered = TRUE)]
  #### Return ####
  return(list(
    annot=d,
    annot_coded=d_coded,
    annot_weighted=d_weighted
  ))
}
