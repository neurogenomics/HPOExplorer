#' Make the Human Phenotype Ontology
#'
#' Make the Human Phenotype Ontology (HPO) \link[ontologyIndex]{ontology_index}
#'  object from the Open Biomedical Ontologies (OBO) file distributed via the
#'  official
#'   \href{https://github.com/obophenotype/human-phenotype-ontology/releases}{
#'   HPO GitHub Releases}.
#' @param fix_ascii Fix non-ASCII characters in metadata.
#' @inheritParams get_data
#' @inheritParams piggyback::pb_download
#' @inheritParams ontologyIndex::get_OBO
#' @inheritDotParams ontologyIndex::get_OBO
#' @returns \link[ontologyIndex]{ontology_index} object
#'
#' @keywords internal
#' @importFrom ontologyIndex get_OBO
make_hpo <- function(file = "hp-base.obo",
                       repo = "obophenotype/human-phenotype-ontology",
                       tag = "latest",
                       save_dir = tools::R_user_dir(
                         package = "HPOExplorer",
                         which = "cache"
                       ),
                       extract_tags = "everything",
                       fix_ascii = TRUE,
                       overwrite = TRUE,
                       upload_tag = NULL,
                       ...){

  #### Download data ####
  f <- get_data(file = file,
                repo = repo,
                tag = tag,
                save_dir = save_dir,
                overwrite = overwrite)
  #### Import data ####
  hpo <- ontologyIndex::get_OBO(file = f,
                                extract_tags = "everything",
                                ...)
  #### Fix non-ASCII characters in metadata ####
  if(fix_ascii){
    func <- function(v){
      Encoding(v) <- "latin1"
      iconv(v, "latin1", "UTF-8")
    }
    attributes(hpo)$version <- func(attributes(hpo)$version)
  }
  if(!is.null(upload_tag)){
    save_path <- file.path(save_dir,"hpo.rds")
    saveRDS(hpo,save_path)
    piggyback::pb_upload(file = save_path,
                         repo = "neurogenomics/HPOExplorer",
                         overwrite = TRUE,
                         tag = upload_tag)
  }
  return(hpo)
}
