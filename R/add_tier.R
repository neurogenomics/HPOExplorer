#' Add severity Tiers
#'
#' Add age of onset for each HPO ID.
#' @param include_disease_characteristics Include \code{phenotypes} that
#' are also high-level \code{include_disease_characteristics}.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table merge.data.table
#' @importFrom utils data
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenos2 <- add_tier(phenos = phenos)
add_tier <- function(phenos,
                     all.x = TRUE,
                     include_disease_characteristics = FALSE,
                     verbose = TRUE){
  # templateR:::source_all()
  # templateR:::args2vars(add_age_of_onset)
  disease_characteristic <- phenotype <- NULL;

  if(!all(c("tier","disease_characteristic") %in% names(phenos))){
    messager("Annotating phenos with Tiers.",v=verbose)
    utils::data(hpo_tiers, package = "HPOExplorer")
    hpo_tiers <- get("hpo_tiers")
    if(isFALSE(include_disease_characteristics)){
      hpo_tiers <- hpo_tiers[phenotype!=disease_characteristic,]
    }
    phenos <- data.table::merge.data.table(
      phenos,
      hpo_tiers[,c("hpo_id","tier","disease_characteristic")],
      by.x = "HPO_ID",
      by.y = "hpo_id",
      all.x = all.x)
  }
  return(phenos)
}
