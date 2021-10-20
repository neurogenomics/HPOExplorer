#' Download phenotype_to_genes.txt
#'
#' This downloads the gene list annotations for phenotypes in the HPO. The file
#' is called phenotype_to_genes.txt and includes over 9000 phenotypes annotated
#' with associated genes.
#'
#' @param path The desired path/filename.txt to save the phenotype_to_genes.txt file.
#' @export
download_phenotype_to_genes <- function(path = "data/phenotype_to_genes.txt") {
  if (!file.exists(path)) {
    utils::download.file("https://ndownloader.figshare.com/files/27722238",
                  path)
  } else {
      print(paste0('file "',path,'" already exists'))
  }
}
