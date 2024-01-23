#' @describeIn add_ add_
#' Add ancestor
#'
#' Assign each HPO ID to the higher-order ancestral term that it is part of.
#' @export
#' @import KGExplorer
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_ancestor(phenos = phenos, lvl=5)
add_ancestor <- function(phenos,
                         lvl = 2,
                         hpo = get_hpo(),
                         keep_descendants = NULL,
                         remove_descendants = NULL,
                         force_new = FALSE){
  #### Check for existing columns ####
  if(force_new){
    messager("Force new. Removing existing ancestor columns.")
    phenos[,c("ancestor","ancestor_name"):=NULL]
  }
  if(all(c("ancestor","ancestor_name") %in% names(phenos))){
    messager("Ancestor columns already present. Skipping.")
  }else {
    #### Add the new columns ####
    if("hpo_id" %in% names(phenos)){
      messager(paste0("Adding level-",lvl),"ancestor to each HPO ID.")
      hpo <- KGExplorer::add_ancestors(ont = hpo,
                                       lvl = lvl,
                                       force_new = force_new)
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
  }

  #### Filter ####
  phenos <- filter_descendants(hpo = hpo,
                               keep_descendants = keep_descendants,
                               remove_descendants = remove_descendants,
                               phenos = phenos)
  return(phenos)
}
