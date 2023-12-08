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
#' annot <- load_phenotype_to_genes(file = "phenotype.hpoa")
#' annot <- annot[onset!="",]
#' annot$onset_name <- harmonise_phenotypes(phenotypes = annot$onset,
#'                                          as_hpo_ids = FALSE)
#' counts <- dplyr::group_by(annot, disease_id) |>
#'   dplyr::summarise(hpo_ids=length(unique(hpo_id)),
#'                    onsets=length(unique(onset)))
#' ## The number of onsets partially depends on the number of hpo_ids
#' ## so it's necessary to keep hpo_id too.
#' cor(counts$hpo_ids, counts$onsets)
#' hpo_onsets <- annot[,c("disease_id","hpo_id","onset","onset_name")]
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
#' hpo_tiers_auto <- HPOExplorer:::assign_tiers(as_datatable=TRUE)
#' hpo_tiers_auto <- add_onset(phenos = hpo_tiers_auto)
#' #### Filter by onset criterion ####
#' ### Tier 1: Shortened life span: infancy
#' hpo_tiers_auto[tier_auto=="Tier1" & onset_score>5,]$tier_auto <- NA
#' ### Tier 2: Shortened life span: premature adulthood
#' hpo_tiers_auto[tier_auto=="Tier2" & onset_score>=11,]$tier_auto <- NA
#' hpo_tiers_auto <- hpo_tiers_auto[,c("hpo_id","tier_auto")]
#' hpo_tiers_auto <- hpo_tiers_auto[!is.na(tier_auto),]
#' hpo_tiers_auto[,tier_auto:=as.integer(gsub("Tier","",tier_auto))]
#' hpo_tiers_auto <- unique(hpo_tiers_auto)
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
#' annot <- annot[modifier!=""]
#' parse_mod <- function(x){
#'   unique(harmonise_phenotypes(strsplit(x,";")[[1]]))
#' }
#' annot <- annot[,modifier_name:=lapply(modifier,parse_mod)][modifier!="",]
#' annot <- annot[,.(modifier_name=unlist(modifier_name)),
#'                by=c("hpo_id","modifier","disease_name","aspect","disease_id")]
#' data.table::setnames(annot,"disease_id","disease_id")
#' dict <- HPOExplorer:::hpo_dict(type="severity")
#' annot$Severity_score <- dict[annot$modifier_name]
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
#' hpo_frequencies <- HPOExplorer:::parse_pheno_frequency(annot=annot)
#' hpo_frequencies <- HPOExplorer:::as_ascii(dt=hpo_frequencies)
#' data.table::setcolorder(hpo_frequencies,c("disease_id","hpo_id"))
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
#' terms <- ontologyIndex::get_descendants(ontology = get_hpo(),
#'                                         roots = "HP:0011420",
#'                                         exclude_roots = TRUE)
#' aod <- lapply(stats::setNames(terms, terms),
#'               function(hpo_id){
#'                 message("Extracting API data for",hpo_id)
#'                 d <- hpo_api(hpo_id = hpo_id, type = "diseases")$diseases
#'               }) |> data.table::rbindlist(fill = TRUE,
#'                                           use.names = TRUE,
#'                                           idcol = "AgeOfDeath")
#' aod$AgeOfDeath_name <- harmonise_phenotypes(phenotypes = aod$AgeOfDeath,
#'                                             as_hpo_ids = FALSE)
#' #### Convert AoD to numeric scores ####
#' dict <- HPOExplorer:::hpo_dict(type="AgeOfDeath")
#' aod$AgeOfDeath_score <- dict[aod$AgeOfDeath_name]
#' data.table::setnames(aod,
#'                      c("diseaseId","diseaseName"),
#'                      c("disease_id","disease_name"))
#' hpo_deaths <- aod
#' usethis::use_data(hpo_deaths, overwrite = TRUE)
#' }
#' @format data.table
#' @usage data("hpo_deaths")
"hpo_deaths"


#' Human Phenotype Ontology: HPO ID to OMOP
#'
#' @description
#' Mapping of HPO phenotype IDs (hpo_id) to OMOP concepts (OMOP_ID).
#' @source
#' \code{
#'  hpo <- get_hpo()
#'  ids <- unique(hpo$id)
#'  hpo_id_to_omop <- oard_query_api(ids = ids, workers=10)
#'  id_col="hpo_id"
#'  data.table::setnames(hpo_id_to_omop,
#'                       toupper(gsub("concept_","OMOP_",names(hpo_id_to_omop)))
#'                       )
#'  data.table::setnames(hpo_id_to_omop, "OMOP_CODE",id_col)
#'  hpo_id_to_omop <- hpo_id_to_omop[,c(id_col,"OMOP_ID","OMOP_NAME"),
#'                                   with=FALSE]
#'  usethis::use_data(hpo_id_to_omop, overwrite = TRUE)
#'  }
#'  @format data.table
#'  @usage data("hpo_id_to_omop")
"hpo_id_to_omop"


#' Human Phenotype Ontology: Disease ID to OMOP
#'
#' @description
#' Mapping of HPO disease IDs (disease_id) to OMOP concepts (OMOP_ID).
#' @source
#' \code{
#'  annot <- load_phenotype_to_genes(3)
#'  id_col <- "disease_id"
#'  ## NOTE: must keep batch_size=1 as the OARD API returns results only for
#'  ## the IDs it can map. This leads to a mismatch between the input and output
#'  ## which is exacerbated that the concept_id is automatically converted to
#'  ## MONDO IDs for some reason, without any way to map back to the original
#'  ## input ID...
#'  disease_id_to_omop <- oard_query_api(ids = annot$disease_id, workers=10,
#'                                       batch_size=1)
#'  data.table::setnames(disease_id_to_omop,
#'                 toupper(gsub("concept_","OMOP_",names(disease_id_to_omop)))
#'                       )
#'  data.table::setnames(disease_id_to_omop,"QUERY",id_col)
#'  disease_id_to_omop <- disease_id_to_omop[,c(id_col,"OMOP_ID","OMOP_NAME"),
#'                                           with=FALSE]
#'  usethis::use_data(disease_id_to_omop, overwrite = TRUE)
#'  }
#'  @format data.table
#'  @usage data("disease_id_to_omop")
"disease_id_to_omop"
