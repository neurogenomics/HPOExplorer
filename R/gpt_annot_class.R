#' GPT annotations: add severity class
#'
#' Convert severity annotations ot severity classes
#'  (profound > severe > moderate > mild) to approximate those introduced in
#'  \href{https://doi.org/10.1371/journal.pone.0114391}{Lazarin et al. 2014}.
#'
#' @param res_coded The output of list \link{gpt_annot_codify}.
#' @param tiers_dict A named list of severity tiers.
#' @param inclusion_values Numerically encoded annotation values
#' to count as hits. See the \code{gpt_annot_codify(code_dict=)}
#'  argument defaults for the mappings.
#'  Defaults to 2 ("often") and 3 ("always").
#' @param add_severity_score_gpt Whether to add a continuous severity score
#' as well.
#' @returns A data.table with severity classes, as well as severity
#'  scores (0-100) which can be used to rank severity within each class.
#' @export
#' @examples
#' res_coded <- gpt_annot_codify()
#' res_class <- gpt_annot_class(res_coded)
gpt_annot_class <- function(res_coded = gpt_annot_codify(),
                            inclusion_values=c(2,3),
                            tiers_dict = list(
                              ## Tier 1
                              death=1,
                              intellectual_disability=1,
                              # congenital_onset=1,
                              ## Tier 2
                              impaired_mobility=2,
                              physical_malformations=2,
                              ## Tier 3
                              blindness=3,
                              sensory_impairments=3,
                              immunodeficiency=3,
                              cancer=3,
                              ## Tier 4
                              reduced_fertility=4
                            ),
                            add_severity_score_gpt=TRUE){
  severity_class <- NULL;
  map_severity_class <- function(r,
                                 tiers_dict,
                                 inclusion_values,
                                 return_score=FALSE){
    variable <- hpo_name <- value <- NULL;

    tiers <- unique(unlist(tiers_dict))
    tier_scores <- lapply(stats::setNames(tiers,paste0("tier",tiers)),
                          function(x){
                            tx <- tiers_dict[unname(unlist(tiers_dict)==x)]
                            counts <- r[,sapply(.SD, function(v){
                              v %in% inclusion_values
                              }),
                              .SDcols = names(tx)]
                            list(
                              counts=counts,
                              proportion=sum(counts)/length(tx)
                            )
                          })
    mean_proportion <- sapply(tier_scores, function(x)x$proportion)|>mean()
    assigned_class <- if(sum(tier_scores$tier1$counts)>1){
      c("profound"=mean_proportion)
    } else if (sum(tier_scores$tier1$counts)>0 ||
               sum(c(tier_scores$tier2$counts,tier_scores$tier3$counts))>3){
      c("severe"=mean_proportion)
    } else if(sum(tier_scores$tier3$counts)>0){
      c("moderate"=mean_proportion)
    } else{
      c("mild"=mean_proportion)
    }
    if(return_score){
      return(assigned_class)
    } else{
      return(names(assigned_class))
    }
  }
  res_class <- data.table::copy(res_coded$annot_coded)
  messager("Assigning severity classes.")
  res_class[,severity_class:=map_severity_class(.SD,
                                                inclusion_values = inclusion_values,
                                                tiers_dict = tiers_dict), by=.I]
  res_class[,severity_class:=factor(severity_class,
                                    levels = c("profound","severe",
                                               "moderate","mild"),
                                    ordered = TRUE)]
  # messager("Assigning severity class scores.")
  # res_class[,severity_class_score:=map_severity_class(.SD,
  #                                                     tiers_dict = tiers_dict,
  #                                                     inclusion_values = inclusion_values,
  #                                                     return_score = TRUE), by=.I]
  if(isTRUE(add_severity_score_gpt) &&
     "annot_weighted" %in% names(res_coded) &&
     !"severity_score_gpt" %in% names(res_class)){
    res_class <- merge(res_class,
                       res_coded$annot_weighted[,c("hpo_name",
                                                   "severity_score_gpt")])
    data.table::setorderv(res_class,
                          c("severity_class","severity_score_gpt"),c(1,-1))
  } else{
    data.table::setorderv(res_class,
                          c("severity_class"))
  }
  return(res_class)
}
