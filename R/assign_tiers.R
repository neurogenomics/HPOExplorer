#' Add severity Tiers (auto)
#'
#' Automatically add severity Tier for each HPO ID, in accordance with the
#'  rating system provided by
#' \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4262393/}{
#' Lazarin et al (2014)}.
#' In order of increasing severity:
#' \itemize{
#' \item{Tier 4 }{Reduced fertility}
#' \item{Tier 3 }{Sensory impairment: vision,
#'  Immunodeficiency/cancer,
#'  Sensory impairment: hearing,
#'  Sensory impairment: touch, other (including pain),
#'  Mental illness,
#'  Dysmorphic features}
#' \item{Tier 2 }{Shortened life span: premature adulthood,
#' Impaired mobility,
#' Internal physical malformation}
#' \item{Tier 1 }{Shortened life span: infancy,
#' Shortened life span: childhood/adolescence,
#' Intellectual disability}
#' }
#' @param terms A subset of HPO IDs to assign Tiers to.
#' @param keyword_sets A named list of regex queries to be used when searching
#' for phenotypes that have matching metadata.
#' @param check_names When regexsearching for matching terms,
#' check the phenotype names.
#' @param check_definitions When regex searching for matching terms,
#' check the phenotype definition.
#' @param check_diseases When regex searching for matching terms,
#' check the names of diseases associated with the phenotype.
#' @param search_ancestors Inherit Tiers of ancestors.
#' @param search_descendants Inherit Tiers of descendants.
#' @param as_datatable Return the results as a \link[data.table]{data.table}.
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @returns Tier assignments for each term in \code{terms}.
#' Will be returned as either a named vector or a \link[data.table]{data.table}.
#'
#' @export
#' @importFrom data.table data.table
#' @importFrom utils data
#' @importFrom stats setNames
#' @importFrom ontologyIndex get_ancestors get_descendants
#' @examples
#' terms <- get_hpo()$id[seq_len(10)]
#' tiers <- assign_tiers(terms = terms)
assign_tiers <- function(hpo=get_hpo(),
                         terms=hpo$id,
                         keyword_sets = list(
                            Tier1=c("intellectual disability","death"),
                            Tier2=c("impaired mobility","malform"),
                            Tier3=c("sight","vision","immunodeficien","cancer",
                                    "hearing","touch","pain "," pain",
                                    "mental illness","dysmorphic"),
                            Tier4=c("fertility")
                            ),
                         check_names=TRUE,
                         check_definitions=TRUE,
                         check_diseases=FALSE,
                         search_ancestors=TRUE,
                         search_descendants=TRUE,
                         as_datatable=FALSE,
                         verbose=TRUE){

  # templateR:::args2vars(assign_tiers)

  DiseaseName <- definition <- NULL;
  #### Gather sets of IDs in the HPO that would qualify ####
  utils::data("hpo_meta", package = "HPOExplorer")
  hpo_meta <- get("hpo_meta")
  annot <- load_phenotype_to_genes("phenotype.hpoa")
  hpo_sets <- lapply(stats::setNames(names(keyword_sets),
                                     names(keyword_sets)),
                     function(nm){
    k <- keyword_sets[[nm]]
    ids <- c()
    #### Matched in the name #####
    if(check_names){
      ids1 <- grep(paste(k,collapse = "|"),
                   hpo$name,value = TRUE, ignore.case = TRUE)
      ids <- c(ids,ids1)
    }
    #### Matched in the definition ####
    if(check_definitions){
      hpo_meta_sub <- hpo_meta[grepl(paste(k,collapse = "|"), definition,
                                     ignore.case = TRUE),]
      ids2 <- hpo$name[names(hpo$name) %in% hpo_meta_sub$HPO_ID]
      ids <- c(ids,ids2)
    }
    #### Matches in the disease association ####
    if(check_diseases){
      annot_sub <- annot[grepl(paste(k,collapse = "|"), DiseaseName,
                               ignore.case = TRUE),]
      ids3 <- hpo$name[names(hpo$name) %in% annot_sub$HPO_ID]
      ids <- c(ids,ids3)
    }
    ids <- ids[!duplicated(names(ids))]
    messager(paste0("keyword_set=",nm,":"),
             "Found",formatC(length(unique(ids)),big.mark = ","),
             "terms matching category.",v=verbose)
    return(ids)
  })
  #### Remove phenotypes belonging to multiple tiers ####
  counts <- table(unname(unlist(hpo_sets)))
  dups <- counts[counts>1]
  dups <- unlist(hpo_sets)[duplicated(unname(unlist(hpo_sets)))]

  terms <- unique(terms)
  messager("Auto-assigning severity Tiers to",
           formatC(length(terms),big.mark = ","),
           "terms.",
           v=verbose)
  tiers <- lapply(stats::setNames(terms,
                                  terms),
                   function(term){
                     lapply(hpo_sets, function(h){
                       if(term %in% names(h)){
                         return("direct")
                       } else if(isTRUE(search_descendants) &&
                                 any(names(h) %in%
                                     ontologyIndex::get_descendants(
                                       ontology = hpo,
                                       roots = term))){
                         return("descendant")
                       } else if(isTRUE(search_ancestors) &&
                                 any(names(h) %in%
                                     ontologyIndex::get_ancestors(
                                       ontology = hpo,
                                       terms = term))){
                         return("ancestor")

                       }  else {
                         NULL
                       }
                     }) |> unlist() |> names()
                   }) |> unlist()
  #### Return ####
  if(isTRUE(as_datatable)){
    dt <- data.table::data.table(HPO_ID=names(tiers),
                                 tier_auto=unname(tiers),
                                 key="HPO_ID")
    dups <- dt$HPO_ID[duplicated(dt$HPO_ID)]
    return(dt)
  } else {
    return(tiers)
  }
}
