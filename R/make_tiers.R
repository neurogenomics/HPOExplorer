#' @describeIn make_ make_
#' Make severity Tiers (auto)
#'
#' Automatically add severity Tier for each HPO ID, in accordance with the
#'  rating system provided by
#' \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4262393/}{
#' Lazarin et al (2014)}.
#' In order of increasing severity:
#' \describe{
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
#' @returns Tier assignments for each term in \code{terms}.
#' Will be returned as either a named vector or a \link[data.table]{data.table}.
#'
#' @export
#' @examples
#' terms <- get_hpo()@terms[seq(100)]
#' tiers <- make_tiers(terms = terms)
make_tiers <- function(hpo=get_hpo(),
                         terms=hpo@terms,
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
  disease_name <- NULL;
  #### Gather sets of IDs in the HPO that would qualify ####
  annot <- load_phenotype_to_genes("phenotype.hpoa")
  hpo_sets <- lapply(stats::setNames(names(keyword_sets),
                                     names(keyword_sets)),
                     function(nm){
    k <- keyword_sets[[nm]]
    ids <- c()
    #### Matched in the name #####
    if(isTRUE(check_names)){
      ids1 <- grep(paste(k,collapse = "|"),
                   hpo@elementMetadata$name,value = TRUE, ignore.case = TRUE)
      ids <- c(ids,ids1)
    }
    #### Matched in the definition ####
    if(isTRUE(check_definitions)){
      hp_sub <- grep(paste(k,collapse = "|"),
                     hpo@elementMetadata$definition,
                     ignore.case = TRUE,value = TRUE)
      ids2 <- hpo@elementMetadata$name[names(hp_sub)]
      ids <- c(ids,ids2)
    }
    #### Matches in the disease association ####
    if(isTRUE(check_diseases)){
      annot_sub <- annot[grepl(paste(k,collapse = "|"), disease_name,
                               ignore.case = TRUE),]
      ids3 <- hpo@terms[hpo@terms %in% annot_sub$hpo_id]
      ids <- c(ids,ids3)
    }
    ids <- ids[!duplicated(names(ids))]
    messager(paste0("keyword_set=",nm,":"),
             "Found",formatC(length(unique(ids)),big.mark = ","),
             "terms matching category.")
    return(ids)
  })
  #### Remove phenotypes belonging to multiple tiers ####
  counts <- table(unname(unlist(hpo_sets)))
  dups <- counts[counts>1]
  dups <- unlist(hpo_sets)[duplicated(unname(unlist(hpo_sets)))]

  terms <- unique(terms)
  messager("Auto-assigning severity Tiers to",
           formatC(length(terms),big.mark = ","),
           "terms.")
  tiers <- lapply(stats::setNames(terms,
                                  terms),
                   function(term){
                     lapply(hpo_sets, function(h){
                       if(term %in% names(h)){
                         return("direct")
                       } else if(isTRUE(search_descendants) &&
                                 any(names(h) %in%
                                     simona::dag_offspring(
                                       dag = hpo,
                                       term = term)
                                     )
                                 ){
                         return("descendant")
                       } else if(isTRUE(search_ancestors) &&
                                 any(names(h) %in%
                                     simona::dag_ancestors(
                                       dag = hpo,
                                       term = term)
                                     )
                                 ){
                         return("ancestor")
                       }  else {
                         NULL
                       }
                     }) |> unlist() |> names()
                   }) |> unlist()
  #### Return ####
  if(isTRUE(as_datatable)){
    dat <- data.table::data.table(hpo_id=names(tiers),
                                  tier_auto=unname(tiers),
                                  key="hpo_id")
    dups <- dat$hpo_id[duplicated(dat$hpo_id)]
    return(dat)
  } else {
    return(tiers)
  }
}
