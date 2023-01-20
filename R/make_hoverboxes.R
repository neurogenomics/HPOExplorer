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
#' @inheritParams make_phenos_dataframe
#' @inheritParams make_network_object
#' @inheritParams base::round
#' @inheritParams stringr::str_wrap
#' @returns A nicely formatted string with newlines etc,
#' to be used as a hoverbox.
#'
#' @export
#' @importFrom stats setNames
#' @importFrom data.table :=
#' @importFrom stringr str_wrap
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay",
#'                                 add_hoverboxes = FALSE)
#' phenos <- make_hoverboxes(phenos = phenos)
make_hoverboxes <- function(phenos,
                            columns = list(
                              Phenotype="Phenotype",
                              ID="HPO_ID",
                              ontLvl="ontLvl",
                              ontLvl_genes="ontLvl_geneCount_ratio",
                              Definition="definition"),
                            interactive = TRUE,
                            width = 60,
                            digits = 3,
                            verbose = TRUE) {
  # templateR:::source_all()
  # templateR:::args2vars(make_hoverboxes)

  hover <- HPO_ID <- Phenotype <- NULL;

  #### Select sep ####
  sep <- if(isTRUE(interactive)) "<br>" else "\n"
  columns <- columns[unname(columns) %in% names(phenos)]
  if(length(columns)==0){
    messager("No columns found. Making hoverboxes from HPO_ID only.",v=verbose)
    phenos[hover:=paste("HPO_ID:",HPO_ID)]
  } else {
    messager("Making hoverboxes from:",
             paste(shQuote(columns),collapse = ", "),v=verbose)
    #### Iterate over phenotypes ####
    hoverBoxes <- lapply(stats::setNames(
      unique(phenos$Phenotype),
      unique(phenos$Phenotype)
    ), function(pheno_i){
      lapply(seq_len(length(columns)), function(i){
        val <- phenos[Phenotype == pheno_i, ][[columns[[i]]]]
        val <- if(is.numeric(val)) round(val,digits = digits) else {
          paste(
            stringr::str_wrap(val, width = width),
          collapse = sep
          )
        }
        paste0("<b>",names(columns)[[i]],"</b>",
               ": ",val
               )
      }) |> paste(collapse = sep)
    })
    #### Assign to each row #####
    phenos$hover <- unlist(hoverBoxes[phenos$Phenotype])
  }
  return(phenos)
}
