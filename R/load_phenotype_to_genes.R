#' Load phenotype_to_genes
#'
#' This is a function for loading the HPO phenotype to genes text file from HPO.
#' It adds the column names and returns as a dataframe.
#'  It contains phenotypes annotated with associated genes.
#' @source \href{https://hpo.jax.org/app/data/annotations}{HPO source data}
#' @param save_dir Folder where the phenotype to genes text
#' file is/will be stored.
#' @param verbose Print messages.
#' @inheritParams piggyback::pb_download
#' @returns A \link[data.table]{data.table} of the HPO annotations.
#'
#' @export
#' @importFrom utils download.file
#' @importFrom tools R_user_dir
#' @importFrom data.table fread setnames
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()
load_phenotype_to_genes <- function(file = c("phenotype_to_genes.txt",
                                             "genes_to_phenotype.txt",
                                             "phenotype.hpoa"),
                                    save_dir = file.path(
                                      tools::R_user_dir("HPOExplorer",
                                                        which="cache"),
                                      "data"),
                                    repo = paste(
                                      "obophenotype",
                                      "human-phenotype-ontology",
                                      sep="/"
                                    ),
                                    tag = "latest",
                                    overwrite = FALSE,
                                    verbose = TRUE
                                    ) {
  # devoptera::args2vars(load_phenotype_to_genes, reassign = TRUE)

  #### Get right URL #####
  file <- file[[1]]
  #### Use index to select file ####
  if(is.numeric(file)){
    file <- eval(formals(load_phenotype_to_genes)$file)[[file]]
  }
  #### Read from RDS if exists ####
  path_rds <- file.path(save_dir,paste0(file,".rds"))
  if(file.exists(path_rds) &&
     !overwrite){
    messager("Reading cached RDS file:",file,v=verbose)
    obj <- readRDS(path_rds)
    get_version(obj,verbose=verbose)
    return(obj)
  }
  #### Stored in GitHub Releases ####
  f <- get_data(file = file,
                repo = repo,
                tag = tag,
                save_dir = save_dir,
                overwrite = overwrite,
                add_version = TRUE)
  #### Read file ####
  if(file=="phenotype.hpoa"){
    phenotype_to_genes <- data.table::fread(
      input = f,
      skip = 4,
    )
    data.table::setnames(phenotype_to_genes,"database_id","disease_id")
  } else {
    phenotype_to_genes <- data.table::fread(input = f)
  }
  #### Add version ####
  if(!is.null(attr(f,"version"))){
    attr(phenotype_to_genes,"version") <- attr(f,"version")
    get_version(phenotype_to_genes,verbose=verbose)
  }
  #### Save RDS ####
  ## This lets up keep track of the version of the data without having to
  ## store this info in a redundant column.
  saveRDS(phenotype_to_genes,path_rds)
  #### Return ####
  return(phenotype_to_genes)
}
