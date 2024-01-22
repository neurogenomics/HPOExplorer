#' @describeIn add_ add_
#' Add ancestor
#'
#' Assign each HPO ID to the higher-order ancestral term that it is part of.
#' @param remove_descendants Remove HPO terms that are descendants of a given
#' ancestral HPO term. Ancestral terms be provided as a character vector of
#' phenotype names (e.g. \code{c("Clinical course")}),
#'  HPO IDs (e.g. \code{"HP:0031797" }) or a mixture of the two.
#'  See \link{add_ancestor} for details.
#'
#' @export
#' @import KGExplorer
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_ancestor(phenos = phenos, lvl=5)
add_ancestor <- function(phenos,
                         lvl = 3,
                         hpo = get_hpo(),
                         remove_descendants = NULL){
  ancestor <- NULL;
  #### Check for existing columns ####
  if(all(c("ancestor","ancestor_name") %in% names(phenos))){
    messager("Ancestor columns already present. Skipping.")
    return(phenos)
  }
  #### Add the new columns ####
  if("hpo_id" %in% names(phenos)){
    messager(paste0("Adding level-",lvl),"ancestor to each HPO ID.")
    hpo <- KGExplorer::add_ancestors(ont = hpo,
                                     lvl = lvl)
    ancestors <- hpo@elementMetadata[,c("id","ancestor","ancestor_name")] |>
      unique()
    phenos <- data.table::merge.data.table(phenos,
                                           ancestors,
                                 by.x = "hpo_id",
                                 by.y = "id",
                                 all.x = TRUE)

  } else {
    messager("hpo_id column not found. Cannot add ancestors.")
  }
  #### Filter ####
  if(!is.null(remove_descendants)){
    messager("Removing remove descendants of:",
             paste(shQuote(remove_descendants),collapse = "\n -"))
    rmd <- map_phenotypes(terms = remove_descendants,
                          hpo = hpo,
                          to="id",
                          keep_order = FALSE)
    phenos <- phenos[!ancestor %in% rmd,]
  }
  return(phenos)
}
