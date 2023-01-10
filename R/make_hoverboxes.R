#' Make hoverboxes
#'
#' A hoverbox is a box of text that shows up when the cursor
#'  hovers over something.
#' These can be useful when making interactive network plots
#' of the HPO phenotypes because we can include a hoverbox that gives
#' information and data associated with each phenotype.
#'
#' This function expects a dataframe of with a "Phenotype" column that has the
#' name of each phenotype. It must then include columns
#'  for all of the parameters you wish to include in the hoverbox.
#'
#' @inheritParams make_hoverbox
#' @returns A nicely formatted string with newlines etc,
#' to be used as a hoverbox.
#' @export
#'
#' @examples
#' library(ontologyIndex)
#' data(hpo)
#' phenos = make_phenos_dataframe(hpo = hpo,
#'                                ancestor = "Neurodevelopmental delay",
#'                                add_description = FALSE)
#' phenos <- make_hoverboxes(phenos_dataframe = phenos)
make_hoverboxes <- function(phenos_dataframe,
                            columns = c("HPO_Id",
                                        "ontLvl_geneCount_ratio",
                                        "description"),
                            labels = c("ID",
                                       "Ont.Lvl/n.genes",
                                       "Description")) {

  phenos_dataframe$hover <- lapply(unique(phenos_dataframe$Phenotype),
                                   function(phenotype){
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
  })
  return(phenos_dataframe)
}
