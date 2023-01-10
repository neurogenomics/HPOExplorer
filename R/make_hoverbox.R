#' Make Hoverbox
#'
#' A hoverbox is a box of text that shows up when the cursor hovers over something.
#' These can be useful when making interactive network plots of the HPO phenotypes
#' because we can include a hoverbox that gives information and data associated
#' with each phenotype.
#'
#' This function expects a dataframe of with a "Phenotype" column that has the
#' name of each phenotype. It must then include columns for all of the parameters
#' you wish to include in the hoverbox.
#'
#' @param phenotype The phenotype you are making a hoverbox for
#' @param phenos_dataframe The dataframe of phenotypes and parameters to be included
#' @param columns chr vector of column names from the phenos_dataframe
#' @param labels chr vector of labels for the selected columns
#' @returns A nicely formatted string with newlines etc, to be used as a hoverbox
#' @export
#'
#' @examples
#' library(ontologyIndex)
#' data(hpo)
#' phenos = make_phenos_dataframe(hpo = hpo,
#'                                ancestor = "Neurodevelopmental delay")
#' hoverBox = c()
#' for (p in unique(phenos$Phenotype)) {
#'     hoverBox <- append(hoverBox,
#'                        make_hoverbox(p,
#'                                      phenos,
#'                                      columns = c("HPO_Id",
#'                                                  "ontLvl_geneCount_ratio",
#'                                                  "description"),
#'                                      labels = c("ID",
#'                                                 "Ont.Lvl/n.genes",
#'                                                 "Description")))
#' }
#' phenos$hover<- hoverBox
make_hoverbox <- function(phenotype,
                          phenos_dataframe,
                          columns = c("HPO_Id", "description"),
                          labels = c("ID", "Description")) {
    if (length(columns) > 0 & length(labels) > 0) {
        if (!length(columns) == length(labels)) {
            message("number of columns must be same as number of labels")
            return(phenotype)
        } else {
            hoverBox <- phenotype
            for (i in seq(1, length(columns))) {
                cur <- phenos_dataframe[
                  phenos_dataframe$Phenotype == phenotype, columns[i]][1]
                hoverBox <- paste0(hoverBox, " \n", labels[i], ": ", cur)
            }
            return(hoverBox)
        }
    } else {
        message("No parameters supplied to make hoverbox. ",
                "Box will only include phenotype name")
        return(phenotype)
    }
}
