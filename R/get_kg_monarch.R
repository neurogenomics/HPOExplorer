#' Get knowledge graph: Monarch
#'
#'
#' Option 1: Use the \href{https://api.monarchinitiative.org/api/}{biolink API}
#'  to efficiently extract specific subset of data
#' from the Monarch server.
#' Option 2: Import the entire knowledge graph from the
#' \href{https://data.monarchinitiative.org/monarch-kg/latest/}{Monarch server}.
#' @source \href{https://pubmed.ncbi.nlm.nih.gov/37707514/}{BioThings Explorer}
get_kg_monarch <- function(){
  ### Option 1 ####
  #
  # con <- neo4r::neo4j_api$new(
  #   url = "https://api.monarchinitiative.org/api/",
  #   user = "neo4j",
  #   password = "plop"
  # )
  # jsonlite::read_json("https://api.monarchinitiative.org/api/bioentity/MONDO:0012990")
  # neo2R::graphRequest(graph = ,
  #                     endpoint = "/bioentity/",
  #                     postText = "MONDO:0012990")
  # neo <- neo2R::graphRequest("https://data.monarchinitiative.org/monarch-kg-dev/latest/monarch-kg.neo4j.dump", )
  # top_targets <- add_mondo(top_targets)

  ### Option 2 ####
  d <- data.table::fread("https://data.monarchinitiative.org/monarch-kg/latest/monarch-kg-denormalized-edges.tsv.gz")

  sort(unique(d$subject_category))

  d[subject_category== "biolink:Cell",]$subject_label |>
    gsub(pattern="[0-9]+",replacement="") |>
    # stringr::str_trunc(20) |>
    unique() |> sort()

  d2 <- d[#(subject_category=="biolink:Disease" & object_category=="biolink:PhenotypicFeature") |
          (subject_category=="biolink:PhenotypicFeature" & object_category=="biolink:Gene") |
          (subject_category=="biolink:Disease" & object_category=="biolink:Gene")]

  #### Use evidence_count as connection weights ####
  round(table(d$evidence_count,useNA = "always")/nrow(d)*100,6)

}
