#' List onsets
#'
#' List Onset phenotypes in the HPO.
#' @param exclude_onsets Onset names to exclude.
#' @param as_hpo_ids Return as a character vector vector HPO IDs only.
#' @param include_na Include NA values for Onset.
#' @inheritParams make_phenos_dataframe
#' @returns Named list of HPO IDs.
#'
#' @export
#' @examples
#' onsets <- list_onsets()
list_onsets <- function(hpo = get_hpo(),
                        exclude_onsets = FALSE, #c("Antenatal","Fetal")
                        as_hpo_ids = FALSE,
                        include_na = TRUE,
                        verbose = TRUE){
  Onset <- NULL;

  annot <- load_phenotype_to_genes(filename = "phenotype.hpoa",
                                   verbose = verbose)
  annot <- annot[Onset!="",]
  onsets <- hpo$name[unique(annot$Onset)]
  if(!is.null(exclude_onsets)){
    onsets <- onsets[!grepl(paste(exclude_onsets,collapse = "|"),onsets,
                            ignore.case = TRUE)]
  }
  if(isTRUE(as_hpo_ids)){
    ids <- names(onsets)
    if(isTRUE(include_na)){
      ids <- c(ids,NA)
    }
    return(ids)
  } else {
    if(isTRUE(include_na)){
      onsets <- c(onsets,"NA"=NA)
    }
    return(onsets)
  }

}
