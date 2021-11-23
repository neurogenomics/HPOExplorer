#' Load phenotype_to_genes.txt
#'
#' This is a function for loading the phenotype to genes text file from HPO.
#' It adds the collumn names and returns as a dataframe
#'
#' @param pheno_to_genes_txt_file path to the phenotype to genes text
#' file from the HPO. It contains phenotypes annotated with associated genes
#' @examples
#'
#' genedata <- load_phenotype_to_genes()
#'
#' @returns a dataframe of the phenotype_to_genes.txt file from HPO
#' @export
#' @importFrom utils read.delim download.file
load_phenotype_to_genes <- function(pheno_to_genes_txt_file =
                                        file.path(tempdir(),
                                                  "data/phenotype_to_genes.txt")
                                    ) {
    dir.create(dirname(pheno_to_genes_txt_file),
               showWarnings = TRUE, recursive = TRUE)
    if (file.exists(pheno_to_genes_txt_file)) {
        messager("Importing existing file:",pheno_to_genes_txt_file)
    }else {
        utils::download.file(
            "https://ndownloader.figshare.com/files/27722238",
            pheno_to_genes_txt_file
        )
        messager("Saving file ==> ",pheno_to_genes_txt_file)
    }

    phenotype_to_genes <- utils::read.delim(pheno_to_genes_txt_file,
        skip = 1,
        header = FALSE
    )
    colnames(phenotype_to_genes) <- c(
        "ID", "Phenotype", "EntrezID", "Gene",
        "Additional", "Source", "LinkID"
    )
    return(phenotype_to_genes)
}
