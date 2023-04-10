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


#' Human Phenotype Ontology: disease onset
#'
#' @description
#' HPO disease onsets.
#' @source
#' \code{
#' annot <- load_phenotype_to_genes(filename = "phenotype.hpoa")
#' annot <- annot[Onset!="",]
#' annot$Onset_name <- harmonise_phenotypes(phenotypes = annot$Onset,
#'                                          as_hpo_ids = FALSE)
#' counts <- dplyr::group_by(annot, DatabaseID) |>
#'   dplyr::summarise(HPO_IDs=length(unique(HPO_ID)),
#'                    Onsets=length(unique(Onset)))
#' ## The number of Onsets partially depends on the number of HPO_IDs
#' ## so it's necessary to keep HPO_ID too.
#' cor(counts$HPO_IDs, counts$Onsets)
#' hpo_onsets <- annot[,c("DatabaseID","HPO_ID","Onset","Onset_name")]
#' usethis::use_data(hpo_onsets, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_onsets")
"hpo_onsets"


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
#' annot <- HPOExplorer::load_phenotype_to_genes(3)
#' annot <- annot[Modifier!=""]
#' parse_mod <- function(x){
#'   unique(HPOExplorer::harmonise_phenotypes(strsplit(x,";")[[1]]))
#' }
#' annot <- annot[,Modifier_name:=lapply(Modifier,parse_mod)][Modifier!="",]
#' annot <- annot[,.(Modifier_name=unlist(Modifier_name)),
#'                by=c("HPO_ID","Modifier","DiseaseName","Aspect","DatabaseID")]
#' data.table::setnames(annot,"DatabaseID","DatabaseID")
#' dict <- HPOExplorer:::hpo_dict(type="severity")
#' annot$Severity_score <- dict[annot$Modifier_name]
#' hpo_modifiers <- annot
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
#' hpo_frequencies <- parse_pheno_frequency(annot=annot)
#' hpo_frequencies <- HPOExplorer:::as_ascii(dt=hpo_frequencies)
#' data.table::setcolorder(hpo_frequencies,c("DatabaseID","HPO_ID"))
#' usethis::use_data(hpo_frequencies, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_frequencies")
"hpo_frequencies"


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
#'                 messager("Extracting API data for",hpo_id)
#'                 d <- hpo_api(hpo_id = hpo_id, type = "diseases")$diseases
#'               }) |> data.table::rbindlist(fill = TRUE,
#'                                           use.names = TRUE,
#'                                           idcol = "AgeOfDeath")
#' aod$AgeOfDeath_name <- harmonise_phenotypes(phenotypes = aod$AgeOfDeath,
#'                                             as_hpo_ids = FALSE)
#' #### Convert AoD to numeric scores ####
#' dict <- hpo_dict(type="AgeOfDeath")
#' aod$AgeOfDeath_score <- dict[aod$AgeOfDeath_name]
#' data.table::setnames(aod,
#'                      c("diseaseId","diseaseName"),
#'                      c("DatabaseID","DiseaseName"))
#' hpo_deaths <- aod
#' usethis::use_data(hpo_deaths, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_deaths")
"hpo_deaths"
