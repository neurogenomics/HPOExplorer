#' Load phenotype_to_genes
#'
#' This is a function for loading the HPO phenotype to genes text file from HPO.
#' It adds the column names and returns as a dataframe.
#'  It contains phenotypes annotated with associated genes.
#' @source \href{https://hpo.jax.org/app/data/annotations}{HPO source data}
#' @param filename Name of the file.
#' @param save_dir Folder where the phenotype to genes text
#' file is/will be stored.
#' @param verbose Print messages.
#' @returns a dataframe of the phenotype_to_genes.txt file from HPO
#'
#' @export
#' @importFrom utils download.file
#' @importFrom tools R_user_dir
#' @importFrom data.table fread
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()
load_phenotype_to_genes <- function(filename = "phenotype_to_genes.txt",
                                    save_dir = file.path(
                                      tools::R_user_dir("HPOExplorer",
                                                        which="cache"),
                                      "data"),
                                    verbose = TRUE
                                    ) {
  #### Get right URL #####
  file <- file.path(save_dir, filename)
  if(basename(file)=="phenotype.hpoa"){
    URL <- "http://purl.obolibrary.org/obo/hp/hpoa/phenotype.hpoa"
  } else if(basename(file)=="genes_to_phenotype.txt"){
    URL <- "http://purl.obolibrary.org/obo/hp/hpoa/genes_to_phenotype.txt"
    col.names <- c("EntrezID","Gene","ID","Phenotype","FrequencyRaw",
                   "FrequencyHPO","Additional","Source","LinkID")
  } else {
    URL <- "http://purl.obolibrary.org/obo/hp/hpoa/phenotype_to_genes.txt"
    # URL <- "https://ndownloader.figshare.com/files/27722238"
    col.names <- c("ID", "Phenotype", "EntrezID", "Gene",
                   "Additional", "Source", "LinkID")
  }
  #### Download files if necessary ####
  if (file.exists(file)) {
      messager("Importing existing file: ...",basename(file),v=verbose)
  }else {
    dir.create(dirname(file), showWarnings = FALSE,recursive = TRUE)
      utils::download.file(url = URL,
                           destfile = file)
      messager("Caching file ==> ",file,v=verbose)
  }
  #### Read file ####
  if(basename(file)=="phenotype.hpoa"){
    phenotype_to_genes <- data.table::fread(
      input = file,
      skip = 4,
    )
  } else {
    phenotype_to_genes <- data.table::fread(
      input = file,
      skip = 1,
      header = FALSE,
      col.names = col.names
    )
  }
  return(phenotype_to_genes)
}
