#' @describeIn add_ add_
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
#' @param severity_threshold Only keep phenotypes with a mean
#' severity score (averaged across multiple associated diseases) below the
#' set threshold. The severity score ranges from 1-4 where 1 is the MOST severe.
#'  Include \code{NA} if you wish to retain phenotypes that
#'  do not have any severity score.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns
#'
#' @export
#' @importFrom data.table merge.data.table
#' @importFrom utils data
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_severity(phenos = phenos)
add_severity <- function(phenos,
                         hpo = get_hpo(),
                         all.x = TRUE,
                         allow.cartesian = FALSE,
                         severity_threshold = NULL){
  Severity_score <- NULL;

  if(!all(c("modifier","modifier_name") %in% names(phenos))){
    messager("Annotating phenos with modifiers")
    phenos <- add_disease(phenos = phenos,
                          all.x = all.x,
                          allow.cartesian = allow.cartesian)
    hpo_mod <- pkg_data("hpo_modifiers")
    #### Aggregate to HPO level ####
    # hpo_agg <- hpo_modifiers_agg(dat = hpo_mod,
    #                              by = by)
    #### Add diseases ####
    phenos <- data.table::merge.data.table(
      phenos,
      hpo_mod[,c("disease_id","hpo_id","modifier_name","Severity_score")],
      by = c("disease_id","hpo_id"),
      all.x = all.x)
  }
  #### Filter ####
  if(!is.null(severity_threshold)){
    if(any(is.na(severity_threshold))){
      phenos <- phenos[
        Severity_score<=min(severity_threshold,na.rm = TRUE) |
          is.na(Severity_score),]
    } else{
      phenos <- phenos[Severity_score<=
                           min(severity_threshold,na.rm = TRUE),]
    }
  }
  return(phenos)
}
