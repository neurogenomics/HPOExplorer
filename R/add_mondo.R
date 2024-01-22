#' @describeIn add_ add_
#' Add Mondo metadata
#'
#' Add Mondo metadata (MONDO ID mappings, names, and definitions) for diseases
#'  using files from their respective databases:
#'  e.g. OMIM, DECIPHER, Orphanet.
#' @inheritParams KGExplorer::map_mondo
#' @inheritDotParams KGExplorer::map_mondo
#' @returns phenos data.table with extra columns.
#'
#' @export
#' @importFrom KGExplorer map_mondo
#' @examples
#' phenos <- load_phenotype_to_genes(3)[seq(1000)]
#' phenos2 <- add_mondo(phenos = phenos)
add_mondo <- function(phenos,
                      input_col = "disease_id",
                      map_to = "hpo",
                      ...) {

  phenos[,(input_col):=gsub("^ORPHA","Orphanet",get(input_col))]
  #### Map (skips is output_col already present) ####
  phenos <- KGExplorer::map_mondo(dat = phenos,
                                  input_col = input_col,
                                  map_to = map_to,
                                  ...)
  phenos[,(input_col):=gsub("^Orphanet","ORPHA",get(input_col))]
  return(phenos)
}
