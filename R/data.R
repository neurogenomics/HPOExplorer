#' Human Phenotype Ontology (HPO)
#'
#' @description
#' Updated version of Human Phenotype Ontology (HPO) from 2023-01-27.
#' Created from the OBO files distributed by
#' \href{https://bioportal.bioontology.org/ontologies/HP}{BioPortal}.
#' By comparison, the \code{hpo} data from \pkg{ontologyIndex} is from 2016.
#' Note that the maximum ontology level depth in the 2016 version was 14,
#' whereas in the 2023 version the maximum ontology level depth is 16
#'  (due to an expansion of the HPO).
#' @source \href{https://bioportal.bioontology.org/ontologies/HP}{BioPortal}
#' @source
#' \code{
#' URL <- paste0(
#'   "https://data.bioontology.org/ontologies/HP/submissions/599/download",
#'   "?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb"
#' )
#' tmp <- tempfile(fileext = "hpo.obo")
#' utils::download.file(URL, tmp)
#' hpo <- ontologyIndex::get_OBO(tmp)
#' #' ### Fix non-ASCII characters in metadata ####
#' func <- function(v){
#'   Encoding(v) <- "latin1"
#'   iconv(v, "latin1", "UTF-8")
#' }
#' attributes(hpo)$version <- func(attributes(hpo)$version)
#' usethis::use_data(hpo, overwrite = TRUE)
#' }
#' @format ontology_index
#' @usage data("hpo")
"hpo"

#' Human Phenotype Ontology: metadata
#'
#' @description
#' Additional metadata from the \href{https://hpo.jax.org/}{HPO}.
#' @source \href{https://bioportal.bioontology.org/ontologies/HP}{BioPortal}
#' @source
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
#' hpo_meta$hpo_id=gsub("_",":",hpo_meta$hpo_id)
#' data.table::setnames(hpo_meta,"hpo_id","HPO_ID")
#' for(nm in c("UMLS","SNOMEDCT_US","MSH")){
#'   hpo_meta[[paste0(nm,"_ID")]] <- lapply(
#'     strsplit(hpo_meta$database_cross_reference,"\\|"),
#'                                      function(x){
#'     s <- grep(paste0(nm,":"),x,value = TRUE)
#'     if(length(s)==0)NA else s
#'                                      })
#' }
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
#' @source
#' \code{
#' file <- system.file("extdata","hpo_tiers.csv.gz",package = "HPOExplorer")
#' hpo_tiers <- data.table::fread(file)
#' usethis::use_data(hpo_tiers, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_tiers")
"hpo_tiers"


#' Human Phenotype Ontology: disease severity tiers (auto)
#'
#' @description
#' HPO severity tiers automatically assigned using
#' \link[HPOExplorer]{assign_tiers}.
#' @source
#' \code{
#' hpo_tiers_auto <- HPOExplorer::assign_tiers(as_datatable=TRUE)
#' hpo_tiers_auto <- add_onset(phenos = hpo_tiers_auto)
#' #### Filter by onset criterion ####
#' ### Tier 1: Shortened life span: infancy
#' hpo_tiers_auto[tier_auto==1 & Onset_score_min>5,]$tier_auto <- NA
#' ### Tier 2: Shortened life span: premature adulthood
#' hpo_tiers_auto[tier_auto==2 & Onset_score_min>=11,]$tier_auto <- NA
#' hpo_tiers_auto <- hpo_tiers_auto[,c("HPO_ID","tier_auto")]
#' hpo_tiers_auto <- hpo_tiers_auto[!is.na(tier_auto),]
#' hpo_tiers_auto[,tier_auto:=as.integer(gsub("Tier","",tier_auto))]
#' usethis::use_data(hpo_tiers_auto, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_tiers_auto")
"hpo_tiers_auto"


#' Human Phenotype Ontology: disease modifiers
#'
#' @description
#' Severity/progression modifiers of each HPO term.
#' In order of increasing severity:
#' \itemize{
#' \item{HP:0012825 }{Mild (Severity_score=4)}
#' \item{HP:0012827 }{Borderline (Severity_score=3)}
#' \item{HP:0012828 }{Severe (Severity_score=2)}
#' \item{HP:0012829 }{Profound (Severity_score=1)}
#' }
#' @source \href{https://mseqdr.org/hpo_browser.php?12823;}{Severity order}
#' @source \href{https://hpo-annotation-qc.readthedocs.io/en/latest/annotationFormat.html}{Column explanations}
#' @source
#' \code{
#' annot <- load_phenotype_to_genes(filename = "phenotype.hpoa")
#' annot <- annot[Modifier!=""]
#' parse_mod <- function(x){
#'   unique(harmonise_phenotypes(strsplit(x,";")[[1]]))
#'   }
#' annot <- annot[,Modifier_name:=lapply(Modifier,parse_mod)][Modifier!="",]
#' annot <- annot[,.(Modifier_name=unlist(Modifier_name)),
#'                by=c("HPO_ID","Modifier","DiseaseName","Aspect","#DatabaseID")]
#' dict <- HPOExplorer:::hpo_dict(type="severity")
#' annot$Severity_score <- dict[annot$Modifier_name]
#' hpo_modifiers <- annot[,list(
#'   Modifier=paste(unique(Modifier),collapse=";"),
#'   Modifier_name=paste(unique(Modifier_name),collapse=";"),
#'   Modifier_count=paste(table(unlist(Modifier_name)),collapse=";"),
#'   DiseaseNames=paste(unique(DiseaseName),collapse = ";"),
#'   DiseaseNames_count=length(unique(DiseaseName)),
#'   DatabaseID_count=length(unique(`#DatabaseID`)),
#'   Severity_score_mean=mean(Severity_score, na.rm=TRUE),
#'   Severity_score_min=min(Severity_score, na.rm=TRUE)
#' ), by="HPO_ID"]
#' hpo_modifiers[Severity_score_min==Inf,]$Severity_score_min <- NA
#' hpo_modifiers[Severity_score_min<0,]$Severity_score_min <- NA
#' hpo_modifiers$Modifer_top <- lapply(seq_len(nrow(hpo_modifiers)),
#'                                     function(i){
#'   r <- hpo_modifiers[i,]
#'   mn <- strsplit(r$Modifier_name,";")[[1]]
#'   mc <- strsplit(r$Modifier_count,";")[[1]]
#'   mn[mc==max(mc)][[1]]
#' }) |> unlist()
#' usethis::use_data(hpo_modifiers, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_modifiers")
"hpo_modifiers"


#' Human Phenotype Ontology: phenotype frequencies
#'
#' @description
#' Frequency of each HPO term \emph{WITHIN} all associated diseases
#' (as opposed to the general population).
#' In order of increasing frequency:
#' \itemize{
#' \item{HP:0040284 }{"Very rare (<4-1%)"}
#' \item{HP:0040283 }{"Occasional (29-5%)"}
#' \item{HP:0040282 }{"Frequent (79-30%)"}
#' \item{HP:0040281 }{"Very frequent (99-80%)"}
#' \item{HP:0040280 }{"Obligate (100%)"}
#' }
#' @source \href{https://hpo-annotation-qc.readthedocs.io/en/latest/annotationFormat.html}{Column explanations}
#' @source
#' \code{
#' annot <- load_phenotype_to_genes("phenotype.hpoa")
#' hpo_frequency <- parse_pheno_frequency(annot=annot)
#' hpo_frequency <- HPOExplorer:::as_ascii(dt=hpo_frequency)
#' usethis::use_data(hpo_frequency, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_frequency")
"hpo_frequency"


#' Human Phenotype Ontology: Age of Death
#'
#' @description
#' Age of Death associated with each disease, and by extension, each phenotype.
#' @source
#' \code{
#' terms <- ontologyIndex::get_descendants(ontology = hpo,
#'                                         roots = "HP:0011420",
#'                                         exclude_roots = TRUE)
#' aod <- lapply(stats::setNames(terms, terms),
#'               function(hpo_id){
#'                 messager("Extracting API data for",hpo_id,v=verbose)
#'                 d <- hpo_api(hpo_id = hpo_id, type = "diseases")$diseases
#'               }) |> data.table::rbindlist(fill = TRUE,
#'                                           use.names = TRUE,
#'                                           idcol = "AgeOfDeath")
#' aod$AgeOfDeath_name <- harmonise_phenotypes(phenotypes = aod$AgeOfDeath,
#'                                             as_hpo_ids = FALSE)
#' #### Convert AoD to numeric scores ####
#' dict <- hpo_dict(type="AgeOfDeath")
#' aod$AgeOfDeath_score <- dict[aod$AgeOfDeath_name]
#' #### Link diseases to HPO phenotypes ####
#' annot <- load_phenotype_to_genes(filename = "phenotype.hpoa")
#' hpo_death <- data.table::merge.data.table(aod,
#'                                           annot[,c("HPO_ID","DiseaseName")],
#'                                           by.x="diseaseName",
#'                                           by.y = "DiseaseName")
#' usethis::use_data(hpo_death, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_death")
"hpo_death"
