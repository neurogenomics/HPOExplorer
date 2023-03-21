#' Add age of death
#'
#' Add age of death for each HPO ID.
#' AgeOfDeath IDs and assigned "AgeOfDeath_score" values:
#' \itemize{
#' \item{HP:0005268 }{"Miscarriage" (AgeOfDeath_score=1)}
#' \item{HP:0003826 }{"Stillbirth" (AgeOfDeath_score=1)}
#' \item{HP:0034241 }{"Prenatal death" (AgeOfDeath_score=1)}
#' \item{HP:0003811 }{"Neonatal death" (AgeOfDeath_score=2)}
#' \item{HP:0001522 }{"Death in infancy" (AgeOfDeath_score=3)}
#' \item{HP:0003819 }{"Death in childhood" (AgeOfDeath_score=4)}
#' \item{HP:0011421 }{"Death in adolescence" (AgeOfDeath_score=5)}
#' \item{HP:0100613 }{"Death in early adulthood" (AgeOfDeath_score=6)}
#' \item{HP:0033764 }{"Death in middle age" (AgeOfDeath_score=7)}
#' \item{HP:0033763 }{"Death in adulthood" (AgeOfDeath_score=7)}
#' \item{HP:0033765 }{"Death in late adulthood" (AgeOfDeath_score=8)}
#' }
#' @param keep_deaths The age of death associated with each HPO ID to keep.
#'  If >1 age of death is associated with the term,
#'  only the earliest age is considered.
#'  See \link[HPOExplorer]{add_death} for details.
#' @param agg_by Column to aggregate age of death metadata by.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns:
#' \itemize{
#' \item{"AgeOfDeath": }{AgeOfDeath HPO IDs of disease phenotypes associated
#' with the target HPO_ID phenotype.}
#' \item{"AgeOfDeath_names": }{AgeOfDeath HPO names of disease phenotypes
#' associated with the target HPO_ID phenotype.}
#' \item{"AgeOfDeath_counts": }{The number of times each term in
#' "AgeOfDeath_names" appears across associated disease phenotypes.}
#' \item{"AgeOfDeath_score_mean": }{Mean age of death score.}
#' \item{"AgeOfDeath_score_min": }{Minimum age of death score.}
#' \item{"AgeOfDeath_top": }{The most common age of death term.}
#' \item{"AgeOfDeath_earliest": }{The earliest age of death.}
#' \item{"AgeOfDeath_latest": }{The latest age of death.}
#' }
#'
#' @export
#' @importFrom data.table merge.data.table
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_death(phenos = phenos)
add_death <- function(phenos,
                      keep_deaths = NULL,
                      all.x = TRUE,
                      allow.cartesian = FALSE,
                      agg_by = NULL,
                      verbose = TRUE){

  # devoptera::args2vars(add_death)
  AgeOfDeath_score <- NULL;

  if(!all(c("AgeOfDeath",
            "AgeOfDeath_name") %in% names(phenos))){
    messager("Annotating phenos with AgeOfDeath",v=verbose)
    phenos <- add_disease(phenos = phenos,
                           verbose = verbose)
    utils::data("hpo_deaths",package = "HPOExplorer")
    annot <- get("hpo_deaths")
    annot <- annot[,c("DatabaseID",
                      "AgeOfDeath_name",
                      "AgeOfDeath_score")]
    #### Each disease can have >1 AgeofDeath ####
    if(!is.null(agg_by)){
      annot <- hpo_death_agg(phenos = phenos,
                             hpo_deaths = annot,
                             by = agg_by)
    }
    ## AgeOfDeath annotations are only at level of Disease,
    ## so merge by DatabaseID alone.
    phenos <- data.table::merge.data.table(x = phenos,
                                           y = annot,
                                           by = "DatabaseID",
                                           allow.cartesian = allow.cartesian,
                                           all.x = all.x)
  }
  if(!is.null(keep_deaths)){
    phenos <- phenos[AgeOfDeath_score %in% keep_deaths,]
  }
  return(phenos)
}
