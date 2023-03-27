#' Add disease definition
#'
#' Add metadata for diseases using files from their respective databases:
#' OMIM, DECIPHER, Orphanet.
#' @param cols Metadata columns to include.
#' @param save_dir Directory to save metadata files to.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns
#'
#' @export
#' @importFrom data.table merge.data.table
#' @importFrom utils data
#' @examples
#' phenos <- load_phenotype_to_genes(3)[seq_len(1000)]
#' phenos2 <- add_disease_definition(phenos = phenos)
add_disease_definition <- function(phenos,
                                   cols = c("Definitions"),
                                   save_dir = file.path(
  tools::R_user_dir("HPOExplorer",
                    which="cache")),
  all.x = TRUE,
  verbose = TRUE
  ) {

  # devoptera::args2vars(add_disease_definition)
  Definitions <- DiseaseName <- NULL;

  meta <- list(
    ORPH = get_metadata_orphanet(save_dir = save_dir,
                                 verbose = verbose),
    OMIM  = get_metadata_omim(save_dir = save_dir,
                              verbose = verbose)
  ) |> data.table::rbindlist(fill=TRUE,
                             use.names = TRUE,
                             idcol = "Database")
  if(is.null(phenos)) {
    return(meta)
  } else {
    merge_col <- c("DatabaseID","LinkID")
    merge_col <- merge_col[merge_col %in% names(phenos)]
    if(length(merge_col)==0){
      stp <- "phenos must contain either DatabaseID or LinkID column."
      stop(stp)
    }
    phenos <-
      data.table::merge.data.table(phenos,
                                   meta[,unique(c("id",cols)), with=FALSE],
                                   all.x = all.x,
                                   by.x = merge_col[1],
                                   by.y = "id")
    if("DiseaseName" %in% names(phenos)){
      messager(
        "Filling",sum(is.na(phenos$Definitions)),"/",
        nrow(phenos),
        paste0("(",round(sum(is.na(phenos$Definitions))/
                           nrow(phenos)*100,2),"%)"),
        "missing Definitions with DiseaseName.",v=verbose)
      phenos[,Definitions:=ifelse(is.na(Definitions),
                                  DiseaseName,
                                  Definitions)]
    }
    return(phenos)
  }
}
