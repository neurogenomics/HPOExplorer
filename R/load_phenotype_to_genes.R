#' Load phenotype_to_genes.txt
#'
#' This is a function for loading the phenotype to genes text file from HPO.
#' It adds the collumn names and returns as a dataframe
#'
#' @param pheno_to_genes_txt_file path to the phenotype to genes text
#' file from the HPO. It contains phenotypes annotated with associated genes
#' @returns a dataframe of the phenotype_to_genes.txt file from HPO
#' @export
#' @importFrom utils download.file
#' @importFrom tools R_user_dir
#' @importFrom data.table fread
#' @examples
#' phenotype_to_genes <- load_phenotype_to_genes()
load_phenotype_to_genes <- function(pheno_to_genes_txt_file =
                                        file.path(
                                          tools::R_user_dir("HPOExplorer",
                                                            which="cache"),
                                          "data",
                                          "phenotype_to_genes.txt")
                                    ) {

    if (file.exists(pheno_to_genes_txt_file)) {
        messager("Importing existing file:",pheno_to_genes_txt_file)
    }else {
      dir.create(dirname(pheno_to_genes_txt_file),
                 showWarnings = FALSE,
                 recursive = TRUE)
        utils::download.file(
            "https://ndownloader.figshare.com/files/27722238",
            pheno_to_genes_txt_file
        )
        messager("Caching file ==> ",pheno_to_genes_txt_file)
    }
    #### Read file ####
    phenotype_to_genes <- data.table::fread(
      input = pheno_to_genes_txt_file,
      skip = 1,
      header = FALSE,
      col.names =  c(
          "ID", "Phenotype", "EntrezID", "Gene",
          "Additional", "Source", "LinkID"
        )
    )
    return(phenotype_to_genes)
}
