#' Add severity Tiers
#'
#' Add severity Tier for each HPO ID, in accordance with the
#'  rating system provided by
#' \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4262393/}{
#' Lazarin et al (2014)}.
#' In order of increasing severity:
#' \itemize{
#' \item{Tier 4 }{Reduced fertility}
#' \item{Tier 3 }{Sensory impairment: vision,
#'  Immunodeficiency/cancer,
#'  Sensory impairment: hearing,
#'  Sensory impairment: touch, other (including pain),
#'  Mental illness,
#'  Dysmorphic features}
#' \item{Tier 2 }{Shortened life span: premature adulthood,
#' Impaired mobility,
#' Internal physical malformation}
#' \item{Tier 1 }{Shortened life span: infancy,
#' Shortened life span: childhood/adolescence,
#' Intellectual disability}
#' }
#' @param include_disease_characteristics Include \code{phenotypes} that
#' are also high-level \code{include_disease_characteristics}.
#' @inheritParams make_network_object
#' @param auto_assign Automatically assing HPO IDs to Tiers by conducting
#' regex searches for keywords that appear in the term name,
#'  or the names of its descendants or ancestors.
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table merge.data.table :=
#' @importFrom utils data
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_tier(phenos = phenos)
add_tier <- function(phenos,
                     all.x = TRUE,
                     include_disease_characteristics = TRUE,
                     auto_assign=TRUE,
                     hpo = get_hpo(),
                     verbose = TRUE){

  # templateR:::args2vars(add_tier)
  disease_characteristic <- phenotype <- tier_auto <- HPO_ID <-
    Onset_score_min <- tier <- tier_merge <- NULL;

  if(!all(c("tier","disease_characteristic") %in% names(phenos))){
    messager("Annotating phenos with Tiers.",v=verbose)
    #### Tiers #####
    utils::data("hpo_tiers", package = "HPOExplorer")
    hpo_tiers <- get("hpo_tiers")
    if(isFALSE(include_disease_characteristics)){
      hpo_tiers <- hpo_tiers[Phenotype!=disease_characteristic,]
    }
    phenos <- data.table::merge.data.table(
      phenos,
      hpo_tiers[,c("HPO_ID","disease_characteristic","tier")],
      by = "HPO_ID",
      all.x = all.x)
  }
  ##### Automatically assign tiers #####
  if(isTRUE(auto_assign) &&
     !("tier_auto" %in% names(phenos))){
    utils::data("hpo_tiers_auto", package = "HPOExplorer")
    hpo_tiers_auto <- get("hpo_tiers_auto")
    phenos <- data.table::merge.data.table(
      phenos,
      hpo_tiers_auto,
      by = "HPO_ID",
      all.x = all.x)
  }
  #### Add merged tier col ####
  phenos[,tier_merge:=pmin(tier,tier_auto, na.rm = TRUE)]
  # lapply(c("tier","tier_auto","tier_merge"), function(x){sum(!is.na(phenos[[x]]))})
  return(phenos)
}
