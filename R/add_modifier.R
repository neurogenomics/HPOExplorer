#' Add HPO modifiers
#'
#' Annotate each HPO with modifier terms, including
#' (but not limited to) progression and severity ratings.
#' In order of increasing severity:
#' \itemize{
#' \item{HP:0012825 }{"Mild" (Severity_score=4)}
#' \item{HP:0012827 }{"Borderline" (Severity_score=3)}
#' \item{HP:0012828 }{"Severe" (Severity_score=2)}
#' \item{HP:0012829}{"Profound" (Severity_score=1)}
#' }
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns
#'
#' @export
#' @importFrom data.table merge.data.table
#' @importFrom utils data
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_modifier(phenos = phenos)
add_modifier <- function(phenos,
                         hpo = get_hpo(),
                         all.x = TRUE,
                         verbose = TRUE){

  # templateR:::args2vars(add_modifier)
  if(!all(c("Modifier","Modifier_name") %in% names(phenos))){
    messager("Annotating phenos with Modifiers",v=verbose)
    utils::data("hpo_modifiers", package = "HPOExplorer")
    hpo_modifiers <- get("hpo_modifiers")

    #### Add diseases ####
    # DiseaseNames <- hpo$name[hpo$name %in% unique(hpo_modifiers$DiseaseName)]
    # diseases <- hpo_modifiers[,c("DiseaseName","Modifier","Modifier_name")]
    # diseases$HPO_ID <- stats::setNames(
    #   names(DiseaseNames),unname(DiseaseNames)
    # )[diseases$DiseaseName]
    # diseases <- diseases[!is.na(HPO_ID),]
    # data.table::data.table(HPO_ID=names(DiseaseNames),)
    # hpo_mod$Phenotype <- hpo$name[hpo_mod$HPO_ID]
    phenos <- data.table::merge.data.table(
      phenos,
      hpo_modifiers,
      by = "HPO_ID",
      all.x = all.x)
  }
  return(phenos)
}
