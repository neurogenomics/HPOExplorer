#' Add disease definition
#'
#' Add metadata for diseases using files from their respective databases:
#' OMIM, DECIPHER, Orphanet.
#' @param id_col Name of the disease ID column.
#' @param cols Metadata columns to include.
#' @param save_dir Directory to save metadata files to.
#' @param include_mondo Add IDs/names/definitions from MONDO via
#' \link[HPOExplorer]{add_mondo}.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns.
#'
#' @export
#' @importFrom data.table merge.data.table fcoalesce :=
#' @importFrom utils data
#' @examples
#' phenos <- load_phenotype_to_genes(3)[seq(1000)]
#' phenos2 <- add_disease_definition(phenos = phenos)
add_disease_definition <- function(phenos,
                                   cols = c("Definitions","Preferred.Label"),
                                   id_col = "disease_id",
                                   save_dir = file.path(
                                     tools::R_user_dir("HPOExplorer",
                                                       which="cache")),
                                   include_mondo = TRUE,
                                   all.x = TRUE,
                                   verbose = TRUE) {

  # devoptera::args2vars(add_disease_definition)
  disease_name <- disease_id <- Preferred.Label <- Definitions <-
    MONDO_definition <- NULL;

  #### Check if already filled out ####
  if(!is.null(phenos) &&
     all(cols %in% names(phenos))){
    return(phenos)
  }
  #### Gather metadata ####
  messager("Adding disease metadata:",paste(cols,collapse = ", "),v=verbose)
  meta <- list(
    ORPH = get_metadata_orphanet(save_dir = save_dir,
                                 verbose = verbose),
    OMIM  = get_metadata_omim(save_dir = save_dir,
                              verbose = verbose)
  ) |> data.table::rbindlist(fill=TRUE,
                             use.names = TRUE,
                             idcol = "Database")
  #### Return only metadata ####
  if(is.null(phenos)) {
    return(meta)
  #### Merge metdata ####
  } else {
    phenos <-
      data.table::merge.data.table(phenos,
                                   meta[,unique(c("id",cols)), with=FALSE],
                                   all.x = all.x,
                                   by.x = id_col[1],
                                   by.y = "id")
    if("disease_name" %in% names(phenos)){
      #### Report missing  ####
      report_missing(phenos = phenos,
                     id_col = id_col,
                     report_col = c("disease_name","Definitions"),
                     verbose = verbose)
      ## Needs to be lowercase to harmonise across metadata sources, eg.:
      ## "CEREBROOCULOFACIOSKELETAL SYNDROME 1" vs.
      ## "Cerebrooculofacioskeletal syndrome 1"
      phenos[,disease_name:=tolower(data.table::fcoalesce(Preferred.Label,
                                                          disease_name,
                                                          disease_id))]
    }
    #### Add mondo ####
    if(isTRUE(include_mondo)){
      phenos <- add_mondo(phenos = phenos,
                          all.x = all.x,
                          verbose = verbose)
      ## Coalesce definitions ##
      phenos[,Definitions:=tolower(data.table::fcoalesce(Definitions,
                                                         MONDO_definition))]
      report_missing(phenos = phenos,
                     id_col = id_col,
                     report_col = "Definitions",
                     verbose = verbose)
    }
    return(phenos)
  }
}
