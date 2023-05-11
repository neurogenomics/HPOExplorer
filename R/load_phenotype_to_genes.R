#' Load phenotype_to_genes
#'
#' This is a function for loading the HPO phenotype to genes text file from HPO.
#' It adds the column names and returns as a dataframe.
#'  It contains phenotypes annotated with associated genes.
#' @source \href{https://hpo.jax.org/app/data/annotations}{HPO source data}
#' @param filename Name of the file.
#' @param save_dir Folder where the phenotype to genes text
#' file is/will be stored.
#' @param method Where to download the data from:
#' \itemize{
#' \item{"piggyback": }{An old copy of HPO annotation files
#'  stored in the Releases section of the \pkg{HPOExplorer} GitHub repository.}
#' \item{"hpo": }{An up-to-date copy directly from the official HPO website.}
#' }
#' @param verbose Print messages.
#' @returns A \link[data.table]{data.table} of the HPO annotations.
#'
#' @export
#' @importFrom utils download.file
#' @importFrom tools R_user_dir
#' @importFrom data.table fread setnames
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()
load_phenotype_to_genes <- function(filename = c("phenotype_to_genes.txt",
                                                 "genes_to_phenotype.txt",
                                                 "phenotype.hpoa"),
                                    save_dir = file.path(
                                      tools::R_user_dir("HPOExplorer",
                                                        which="cache"),
                                      "data"),
                                    method = "piggyback",
                                    verbose = TRUE
                                    ) {
  # devoptera::args2vars(load_phenotype_to_genes)

  #### Get right URL #####
  filename <- filename[[1]]
  #### Use index to select file ####
  if(is.numeric(filename)){
    filename <- eval(formals(load_phenotype_to_genes)$filename)[[filename]]
  }
  #### Stored in GitHub Releases ####
  if(method=="piggyback"){
    file <- get_data(fname = filename,
                     save_dir = save_dir)
  #### Directly from the HPO website ####
  } else {
    file <- file.path(save_dir, filename)
    if(basename(file)=="phenotype.hpoa"){
      URL <- "http://purl.obolibrary.org/obo/hp/hpoa/phenotype.hpoa"
    } else if(basename(file)=="genes_to_phenotype.txt"){
      URL <- "http://purl.obolibrary.org/obo/hp/hpoa/genes_to_phenotype.txt"
    } else if(basename(file)=="phenotype_to_genes.txt"){
      URL <- "http://purl.obolibrary.org/obo/hp/hpoa/phenotype_to_genes.txt"
      # URL <- "https://ndownloader.figshare.com/files/27722238"
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
  }
  #### Read file ####
  if(basename(file)=="phenotype.hpoa"){
    phenotype_to_genes <- data.table::fread(
      input = file,
      skip = 4,
    )
  } else if(basename(file)=="genes_to_phenotype.txt"){
    phenotype_to_genes <- data.table::fread(
      input = file,
      skip = 1,
      header = FALSE,
      col.names =  c("EntrezID","Gene","ID","Phenotype","FrequencyRaw",
                     "FrequencyHPO","Additional","Source","LinkID")
    )
  } else {
    phenotype_to_genes <- data.table::fread(
      input = file,
      skip = 1,
      header = FALSE,
      col.names = c("ID", "Phenotype", "EntrezID", "Gene",
                    "Additional", "Source", "LinkID")
    )
  }
  if("#DatabaseID" %in% names(phenotype_to_genes)){
    data.table::setnames(phenotype_to_genes,"#DatabaseID","DatabaseID")
  }
  if("ID" %in% names(phenotype_to_genes)){
    data.table::setnames(phenotype_to_genes,"ID","HPO_ID")
  }
  data.table::setnames(phenotype_to_genes,
                       c("database_id","disease_name","hpo_id","frequency",
                         "qualifier","modifier","onset"),
                       c("DatabaseID", "DiseaseName", "HPO_ID","Frequency",
                         "Qualifier","Modifier","Onset"),
                       skip_absent = TRUE)
  return(phenotype_to_genes)
}
