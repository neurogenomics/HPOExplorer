#' Human Phenotype Ontology: metadata
#'
#' @description
#' Additional metadata from the \href{https://hpo.jax.org/}{HPO}.
#' @source \href{https://bioportal.bioontology.org/ontologies/HP}{BioPortal}
#' \code{
#' URL <- "https://data.bioontology.org/ontologies/HP/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb&download_format=csv"
#' tmp <- tempfile(fileext = "hpo.csv.gz")
#' utils::download.file(URL, tmp)
#' hp <- data.table::fread(tmp)
#' hp <- hp[,hpo_id:=basename(hp$`Class ID`)][,link:=hp$`Class ID`][Obsolete==FALSE]
#' cols <- c("hpo_id","link","Preferred Label","Synonyms",#"Definitions",
#'           "CUI","database_cross_reference","definition")
#' hpo_meta <- hp[,cols, with=FALSE]
#' names(hpo_meta) <- gsub(" +","",tolower(names(hpo_meta)))
#' ### Make ASCI-friendly
#' hpo_meta <- HPOExplorer:::as_ascii(dt=hpo_meta)
#' data.table::fwrite(hpo_meta,"~/Desktop/hpo_meta.csv.gz")
#' usethis::use_data(hpo_meta, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_meta")
"hpo_meta"


#' Human Phenotype Ontology: disease severity tiers
#'
#' @description
#' A list of the 49 HPO disease phenotypes in 4 different tiers
#' from \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4262393/}{
#' Lazarin et al (2014)}, specifically Table 1.
#' HPO IDs of all the terms are displayed in the right column.
#' @source \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4262393/}{
#' Lazarin et al (2014)}
#' \code{
#' hpo_tiers <- data.table::fread("~/Downloads/hpo_tiers.csv")
#' hpo_tiers <- HPOExplorer:::as_ascii(dt=hpo_tiers)
#' usethis::use_data(hpo_tiers, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_tiers")
"hpo_tiers"
