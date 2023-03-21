annotate_diseases <- function(d = load_phenotype_to_genes("phenotype.hpoa"),
                              verbose = TRUE){

  # devoptera::args2vars(annotate_diseases)
  requireNamespace("ontoProc")
  Disease_MONDO_ID <- HPO_ID <- MONDO_ID <- NULL;

  utils::data("hpo_meta", package = "HPOExplorer")
  hpo_meta <- data.table::copy(get("hpo_meta"))

  mondo <- ontoProc::getMondoOnto()
  # do <- ontoProc::getDiseaseOnto()
  prefixes <- unique(stringr::str_split(d$`DatabaseID`,":",simplify=TRUE)[,1])
  id_to_mondo <- grep(paste(paste0(prefixes,":"),collapse = "|"),
                      unlist(mondo$xref), value = TRUE) |>
    invert_dict()
  mondo_to_hp <- grep("HP:",unlist(mondo$xref),value = TRUE)
  hpo_meta[,MONDO_ID:=invert_dict(mondo_to_hp)[HPO_ID]]
  ### Add new columns ####
  data.table::setnames(d,"HPO_ID","HPO_ID_og")
  d[,Disease_MONDO_ID:=id_to_mondo[d$`DatabaseID`]]
  d[,HPO_ID:=mondo_to_hp[Disease_MONDO_ID]]
  d[!is.na(HPO_ID),]
  ### Annotate diseases with HPO IDs ####
  # nms_og <- names(data.table::copy(d))
  d <- annotate_phenos(phenos = d,
                       add_age_onset = TRUE,
                       add_age_death = TRUE,
                       add_severity_tiers = TRUE,
                       add_hoverboxes = FALSE,
                       verbose = verbose)
  return(d)
}
