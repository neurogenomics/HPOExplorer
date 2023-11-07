#' Get version
#'
#' Extract the precise version of the HPO release that the data object
#' was built from. All HPO Releases can be found at the official
#' \href{https://github.com/obophenotype/human-phenotype-ontology/releases}{
#' HPO GitHub Releases page}.
#' @param obj An object from
#' \link[HPOExplorer]{get_hpo} or
#' \link[HPOExplorer]{load_phenotype_to_genes}.
#' @param verbose Print messages.
#' @param return_version Return the version as a character string.
#' @returns HPO Release version a character string.
#'
#' @export
#' @examples
#' obj <- get_hpo()
#' get_version(obj=obj)
get_version <- function(obj,
                        return_version = FALSE,
                        verbose = TRUE){
  ## Extract
  if(methods::is(obj,"ontology_index")){
    x <- grep("data-version:",attr(obj,"version"),value=TRUE)
    v <- paste0("v",
                trimws(gsub("data-version:|hp/releases/|/hp-base.owl","",x))
                )
  } else {
    v <- attr(obj,"version")
  }
  ## Print
  messager("+ Version:",v,v=verbose)
  ## Return
  if(isTRUE(return_version))  return(v)
}
