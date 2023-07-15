get_metadata_orphanet <- function(save_dir = file.path(
  tools::R_user_dir("HPOExplorer",
                    which="cache")),
  verbose = TRUE){
  Class.ID <- id <- NULL;

  options(download.file.method = "curl")
  messager("Importing Orphanet metadata.",v=verbose)
  f <- file.path(save_dir,"ORDO.csv.gz")
  if(!file.exists(f)){
    dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)
    utils::download.file(paste0(
      "https://data.bioontology.org/ontologies/ORDO/download?",
      "apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb&download_format=csv"
    ), f)
  }
  meta <- data.table::fread(f)
  colnames(meta) <- gsub(" ",".",colnames(meta))
  meta[,id:=gsub("Orphanet_","ORPHA:",basename(Class.ID))]
  return(meta)
}
