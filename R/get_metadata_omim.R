get_metadata_omim <- function(save_dir = file.path(
  tools::R_user_dir("HPOExplorer",
                    which="cache")),
  verbose = TRUE){
  Class.ID <- id <- NULL;

  messager("Importing OMIM metadata.",v=verbose)
  f <- file.path(save_dir,"OMIM.csv.gz")
  if(!file.exists(f)){
    dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)
    utils::download.file(paste0(
      "https://data.bioontology.org/ontologies/OMIM/download?",
      "apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb&download_format=csv"
    ), f)
  }
  meta <- data.table::fread(f)
  colnames(meta) <- gsub(" ",".",colnames(meta))
  meta[,id:=paste0("OMIM:",basename(Class.ID))]
  return(meta)
}
