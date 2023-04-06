#' Add age of onset
#'
#' Add age of onset for each HPO ID.
#' Onset IDs and assigned "Onset_score" values:
#' \itemize{
#' \item{HP:0011461 }{"Fetal onset" (Onset_score=1)}
#' \item{HP:0030674 }{"Antenatal onset" (Onset_score=2)}
#' \item{HP:0003577 }{"Congenital onset" (Onset_score=3)}
#' \item{HP:0003623 }{"Neonatal onset" (Onset_score=4)}
#' \item{HP:0003593 }{"Infantile onset" (Onset_score=5)}
#' \item{HP:0011463 }{"Childhood onset" (Onset_score=6)}
#' \item{HP:0003621 }{"Juvenile onset" (Onset_score=7)}
#' \item{HP:0011462 }{"Young adult onset" (Onset_score=8)}
#' \item{HP:0003581 }{"Adult onset" (Onset_score=9)}
#' \item{HP:0003596 }{"Middle age onset" (Onset_score=10)}
#' \item{HP:0003584 }{"Late onset" (Onset_score=11)}
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
#' \item{"Onset": }{Onset HPO IDs of disease phenotypes associated
#' with the target HPO_ID phenotype.}
#' \item{"Onset_names": }{Onset HPO names of disease phenotypes associated
#' with the target HPO_ID phenotype.}
#' \item{"Onset_counts": }{The number of times each term in
#' "Onset_names" appears across associated disease phenotypes.}
#' \item{"Onset_score_mean": }{Mean onset score.}
#' \item{"Onset_score_min": }{Minimum onset score.}
#' \item{"Onset_top": }{The most common onset term.}
#' \item{"Onset_earliest": }{The earliest age of onset.}
#' \item{"Onset_latest": }{The latest age of onset.}
#' }
#' @export
#' @importFrom data.table merge.data.table=
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
  Onset_latest <- Onset_score <- Onset_name <- NULL;

  if(!any(c("Onset","Onset_name","Onset_names","Onset_score")
          %in% names(phenos))){
    messager("Annotating phenos with Onset.",v=verbose)
    phenos <- add_disease(phenos = phenos,
                          allow.cartesian = allow.cartesian,
                          verbose = verbose)
    utils::data("hpo_onsets",package = "HPOExplorer")
    hpo_onsets <- get("hpo_onsets")
    dict <- hpo_dict(type = "Onset")
    hpo_onsets[,Onset_score:=dict[Onset_name]]
    if(!is.null(agg_by)){
      hpo_onsets <- hpo_onsets_agg(hpo_onsets = hpo_onsets,
                                   phenos = phenos,
                                   agg_by = agg_by)
    }
    phenos <- data.table::merge.data.table(x = phenos,
                                           y = hpo_onsets,
                                           by = c("DatabaseID","HPO_ID"),
                                           allow.cartesian = allow.cartesian,
                                           all.x = all.x)
  }
  #### Filter ####
  if(!is.null(keep_onsets)){
    phenos <- phenos[Onset_latest %in% keep_onsets,]
  }
  return(phenos)
}
