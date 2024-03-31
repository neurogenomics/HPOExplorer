#' Check annotations from GPT
#'
#' Check GPT phenotype annotations using a several metrics.
#' @param remove_duplicates Ensure only 1 row per phenotype.
#' @param code_dict Numerical encodings of annotation values.
#' @param tiers_dict Numerical encodings of annotation column.
#' @param reset_tiers_dict Override \code{tiers_dict} values and set all values
#' to 1. This will ensure that all annotations are unweighted.
#' @inheritParams gpt_annot_check
#' @inheritParams KGExplorer::filter_dt
#' @returns Named list
#'
#' @export
#' @import data.table
#' @importFrom stats na.omit
#' @importFrom utils head
#' @examples
#' coded <- gpt_annot_codify()
gpt_annot_codify <- function(annot = gpt_annot_read(),
                             remove_duplicates=TRUE,
                             code_dict = c(
                               "never"=0,
                               "rarely"=1,
                               "often"=2,
                               "always"=3
                             ),
                             tiers_dict=list(
                               intellectual_disability=5,
                               death=5,
                               impaired_mobility=4,
                               physical_malformations=3,
                               blindness=4,
                               sensory_impairments=3,
                               immunodeficiency=3,
                               cancer=3,
                               reduced_fertility=1,
                               congenital_onset=4
                             ),
                             reset_tiers_dict=FALSE,
                             filters=list()
                             ){
  severity_score_gpt <- hpo_name <- NULL;

  d <- data.table::copy(annot)
  if(isTRUE(reset_tiers_dict)) tiers_dict <- lapply(tiers_dict,function(x){1})
  #### Ensure only 1 row/hpo_name by simply taking the first ####
  if(isTRUE(remove_duplicates)){
    d <- d[,utils::head(.SD,1), by=c("hpo_id","hpo_name")]
  }
  cols <- names(tiers_dict)
  #### Add levels ####
  d <- d[,lapply(.SD,function(x){
    factor(tolower(x),levels = rev(names(code_dict)), ordered = TRUE)
    }),
    .SDcols = unique(c(cols,"congenital_onset")),
    by=c("hpo_id","hpo_name")]
  #### Filter congenital onset ####
  d <- KGExplorer::filter_dt(dat = d,
                             filters = filters)
  #### Compute max possible score ####
  max_score <-
    sum(
      max(code_dict, na.rm = TRUE) *
      (max(unlist(tiers_dict))*length(tiers_dict))
    )
  d_coded <- d[,lapply(.SD,FUN=function(x){
    unlist(code_dict[tolower(x)])}),.SDcols = cols, by=c("hpo_id","hpo_name")]
  d_weighted <- data.table::as.data.table(
    lapply(stats::setNames(cols,cols),
           function(co){
           d_coded[[co]]*tiers_dict[[co]]
             })
  )[,hpo_name:=d_coded$hpo_name][,severity_score_gpt:=(
    rowSums(.SD,na.rm = TRUE)/max_score*100),
                             .SDcols=cols][d_coded[,-cols,with=FALSE],
                                           on="hpo_name"] |>
    data.table::setorderv("severity_score_gpt",-1, na.last = TRUE) |>
    unique()
  #### Order hpo_names by severity_score_gpt #####
  d[,hpo_name:=factor(hpo_name,
                       levels = unique(d_weighted$hpo_name),
                       ordered = TRUE)]
  d_coded[,hpo_name:=factor(hpo_name,
                       levels = unique(d_weighted$hpo_name),
                       ordered = TRUE)]
  d_weighted[,hpo_name:=factor(hpo_name,
                       levels = unique(d_weighted$hpo_name),
                       ordered = TRUE)]
  #### Return ####
  return(list(
    annot=d,
    annot_coded=d_coded,
    annot_weighted=d_weighted
  ))
}
