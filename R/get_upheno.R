#' Get UPHENO
#'
#' Get data from the \href{https://github.com/obophenotype/upheno}{
#' Unified Phenotype Ontology (UPHENO)}.
#'
#' @param file Can be one of the following:
#' \itemize{
#' \item{"ontology"}{Creates an \link[ontologyIndex]{ontologyIndex} R object by
#'  importing the OBO file directly from the official
#'  \href{https://github.com/obophenotype/upheno}{UPHENO GitHub repository}.}
#' \item{"bestmatches"}{Returns a merged table with the best matches between
#'  human and non-human homologous phenotypes (from multiple species).
#'  Distributed by the official
#'  \href{https://github.com/obophenotype/upheno/tree/master/mappings}{
#'  UPHENO GitHub repository}.}
#' \item{"upheno_mapping"}{Return a merged table with matches bteween human
#' and non-human homologous phenotypes (from multiple species).
#' Distributed by the
#'  \href{https://data.monarchinitiative.org/upheno2/current/upheno-release/all/index.html}{
#'  Monarch Initiative server}.}
#' }
#' @import data.table
#' @importFrom stringr str_split
#' @returns \link[ontologyIndex]{ontologyIndex} or
#' \link[data.table]{data.table}.
#'
#' @export
#' @examples
#' upheno <- get_upheno()
get_upheno <- function(file=c("ontology",
                              "bestmatches",
                              "upheno_mapping")){
  file <- match.arg(file)
  if(file=="ontology"){
    requireNamespace("ontologyIndex")
    upheno <- ontologyIndex::get_OBO(
      "https://github.com/obophenotype/upheno-dev/raw/master/upheno.obo",
      extract_tags = "everything")
    return(upheno)
  }
  if(file=="bestmatches"){
    #### Fuzzy query ####
    ## Only between HPO and 3 ontologies
    base_url <- "http://purl.obolibrary.org/obo/upheno/mappings/"
    URLs <- paste0(base_url,
                   c("hp-to-zp-bestmatches.tsv",
                     "hp-to-mp-bestmatches.tsv",
                     "hp-to-wbphenotype-bestmatches.tsv"))
    pheno_map <- lapply(URLs, function(x){
      data.table::fread(x)
    }) |> `names<-`(gsub("-bestmatches.tsv","",basename(URLs))) |>
      data.table::rbindlist(idcol = "map", fill = TRUE) |>
      `names<-`(c("map","id1","label1","id2",
                  "label2","equivalence_score","subclass_score"))
    pheno_map$db2 <- stringr::str_split(pheno_map$id2,":", simplify = TRUE)[,1]
    return(pheno_map)
  }
  if (file=="upheno_mapping"){
    id1 <- id2 <- p1 <- p2 <- NULL;
    pheno_map <- get_monarch("phenotype_to_phenotype")
    pheno_map[,id1:=gsub("_",":",basename(p1))
              ][,id2:=gsub("_",":",basename(p2))]
    pheno_map$db1 <- stringr::str_split(pheno_map$id1,":", simplify = TRUE)[,1]
    pheno_map$db2 <- stringr::str_split(pheno_map$id2,":", simplify = TRUE)[,1]
    data.table::setkeyv(pheno_map,"id1")
    return(pheno_map)
  }
}
