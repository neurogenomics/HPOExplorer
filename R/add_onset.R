#' Add age of onset
#'
#' Add age of onset for each HPO ID.
#' onset IDs and assigned "onset_score" values:
#' \itemize{
#' \item{HP:0011461 }{"Fetal onset" (onset_score=1)}
#' \item{HP:0030674 }{"Antenatal onset" (onset_score=2)}
#' \item{HP:0003577 }{"Congenital onset" (onset_score=3)}
#' \item{HP:0003623 }{"Neonatal onset" (onset_score=4)}
#' \item{HP:0003593 }{"Infantile onset" (onset_score=5)}
#' \item{HP:0011463 }{"Childhood onset" (onset_score=6)}
#' \item{HP:0003621 }{"Juvenile onset" (onset_score=7)}
#' \item{HP:0011462 }{"Young adult onset" (onset_score=8)}
#' \item{HP:0003581 }{"Adult onset" (onset_score=9)}
#' \item{HP:0003596 }{"Middle age onset" (onset_score=10)}
#' \item{HP:0003584 }{"Late onset" (onset_score=11)}
#' }
#' @param keep_onsets The age of onset associated with each HPO ID to keep.
#'  If >1 age of onset is associated with the term,
#'  only the earliest age is considered.
#'  See \link[HPOExplorer]{add_onset} for details.
#' @param agg_by Column to aggregate age of onset metadata by.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns:
#' \itemize{
#' \item{"onset": }{onset HPO IDs of disease phenotypes associated
#' with the target hpo_id phenotype.}
#' \item{"onset_names": }{onset HPO names of disease phenotypes associated
#' with the target hpo_id phenotype.}
#' \item{"onset_counts": }{The number of times each term in
#' "onset_names" appears across associated disease phenotypes.}
#' \item{"onset_score_mean": }{Mean onset score.}
#' \item{"onset_score_min": }{Minimum onset score.}
#' \item{"onset_top": }{The most common onset term.}
#' \item{"onset_earliest": }{The earliest age of onset.}
#' \item{"onset_latest": }{The latest age of onset.}
#' }
#' @export
#' @importFrom data.table merge.data.table :=
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_onset(phenos = phenos)
add_onset <- function(phenos,
                      keep_onsets = NULL,
                      agg_by = NULL,
                      all.x = TRUE,
                      allow.cartesian = FALSE,
                      verbose = TRUE){

  # devoptera::args2vars(add_onset)
  onset_latest <- onset_score <- onset_name <- NULL;

  if(!any(c("onset","onset_name","onset_names","onset_score")
          %in% names(phenos))){
    messager("Annotating phenos with onset.",v=verbose)
    phenos <- add_disease(phenos = phenos,
                          all.x = all.x,
                          allow.cartesian = allow.cartesian,
                          verbose = verbose)
    hpo_onsets <- pkg_data("hpo_onsets")
    dict <- hpo_dict(type = "onset")
    hpo_onsets[,onset_score:=dict[onset_name]]
    if(!is.null(agg_by)){
      hpo_onsets <- hpo_onsets_agg(hpo_onsets = hpo_onsets,
                                   phenos = phenos,
                                   agg_by = agg_by)
    }
    phenos <- data.table::merge.data.table(x = phenos,
                                           y = hpo_onsets,
                                           by = c("disease_id","hpo_id"),
                                           allow.cartesian = allow.cartesian,
                                           all.x = all.x)
  }
  #### Filter ####
  if(!is.null(keep_onsets)){
    phenos <- phenos[onset_latest %in% keep_onsets,]
  }
  return(phenos)
}
