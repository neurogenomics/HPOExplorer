##' @describeIn add_ add_
##' Add HPO ID synonyms
##'
##' Map HPO IDs to synonynmous IDs from other ontologies
##'  (e.g. UMLS, SNOMEDCT_US, MSH, ICD-10),
##' @returns A data.table with the HPO ID synonyms in a new column with
##'  the same name as \code{to}.
##'
##' @param to The ontology to map to. Default is \code{UMLS}.
##' @param to_col The name of the new column to add the synonyms to.
##' @export
##' @examples
##' phenos <- xample_phenos()
##' phenos2 <- add_hpo_synonym(phenos)
#add_hpo_synonym <- function(phenos,
#                            to="UMLS",
#                            to_col=paste0(to,"_ID"),
#                            hpo=get_hpo()){
#  hpo_id <- NULL;
#  messager("Adding HPO ID synonyms:",to)
#  dict <- unlist(hpo$xref)
#  ## Fix typos in mapping
#  dict <- gsub("ICD10","ICD-10",dict)
#  dict <- gsub("ICD9","ICD-10",dict)
#  ## Get all prefixes
#  # prefixes <- sort(
#  #   table(stringr::str_split(unname(dict),":",simplify = TRUE)[,1]),
#  #   decreasing = TRUE)
#  if(!is.null(to)){
#    dict <- grep(paste0("^",to,":"),dict, value = TRUE)
#    phenos[,(to_col):=dict[hpo_id]]
#    n_mapped <- length(unique(na.omit(phenos[[to_col]])))
#    n_total <- length(unique(phenos$hpo_id))
#    messager(formatC(n_mapped,big.mark = ","),"/",
#             formatC(n_total,big.mark = ","),
#             paste0("(",round(n_mapped/n_total*100,1),"%)"),
#             "hpo_id mapped to",paste0(to_col,"."), v=verbose
#    )
#    return(phenos)
#  } else{
#    return(dict)
#  }
#}
#
