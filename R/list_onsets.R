#' List onsets
#'
#' List Onset phenotypes in the HPO.
#' @param postnatal_only Only include postnatal onsets.
#' @param as_hpo_ids Return as a character vector vector HPO IDs only.
#' @param include_na Include NA values for Onset.
#' @inheritParams make_phenos_dataframe
#' @returns Named list of HPO IDs.
#'
#' @export
#' @examples
#' onsets <- list_onsets()
list_onsets <- function(hpo = get_hpo(),
                        postnatal_only = FALSE,
                        as_hpo_ids = TRUE,
                        include_na = TRUE,
                        verbose = TRUE){
  Onset <- NULL;

  annot <- load_phenotype_to_genes(filename = "phenotype.hpoa",
                                   verbose = verbose)
  annot <- annot[Onset!="",]
  onsets <- hpo$name[unique(annot$Onset)]
  if(isTRUE(postnatal_only)){
    onsets <- onsets[!grepl("Antenatal|Fetal",onsets,ignore.case = TRUE)]
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
