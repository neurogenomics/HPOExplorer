#' Add age of onset
#'
#' Add age of onset for each HPO ID.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra column
#'
#' @export
#' @importFrom data.table merge.data.table .EACHI
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenos2 <- add_onset(phenos = phenos)
add_onset <- function(phenos,
                       all.x = TRUE,
                       allow.cartesian = TRUE,
                       verbose = TRUE){
  # templateR:::source_all()
  # templateR:::args2vars(add_age_of_onset)

  HPO_ID <- Onset <- NULL;

  if(!all(c("Onset","DiseaseName") %in% names(phenos))){
    messager("Annotating phenos with Onset.",v=verbose)
    annot <- load_phenotype_to_genes(filename = "phenotype.hpoa",
                                     verbose = verbose)
    annot <- annot[Onset!="" & HPO_ID %in% phenos$HPO_ID,]

    phenos <- data.table::merge.data.table(phenos, annot,
                                           by = "HPO_ID",
                                           allow.cartesian = allow.cartesian,
                                           all.x = all.x)
  }
  return(phenos)

  # onset_terms <- grep("onset$",hpo$name, value = TRUE)
  #### Get by gene overlap #####
  # "All phenotype terms associated with any disease that is associated with
  # variants in a gene are assigned to that gene in this file.
  # Other files are available on our Jenkins server that filter terms
  # according to provenance of the annotation and frequency
  # of the features in the disease."

  # X <- data.table::rbindlist(
  #   list(phenos_genes = data.table::as.data.table(unlist(phenos_genes)),
  #        onset_genes= data.table::as.data.table(unlist(onset_genes))),
  #   use.names = TRUE, idcol = "group") |>
  #   data.table::dcast.data.table(formula = "ID ~ Gene",
  #                                fun.aggregate = length)
  # X <- methods::as(as.matrix(X[,-1]),"sparseMatrix",) |>
  #   `rownames<-`(X$ID) |> t()
  # ?stats::dist
  # heatmap(cor(as.matrix(X)))
  # res <- lapply(phenos_genes,
  #               function(gr){
  #   data.table::as.data.table(
  #     # GeneOverlap::newGeneOverlap(listA = gr$Gene,
  #     #                             listB = onset_genes$`HP:0003577`$Gene)
  #       data.frame(overlap=GenomicRanges::countOverlaps(query = onset_genes,
  #                                                       subject = gr),
  #                  gr1_size=length(gr),
  #                  gr2_size=length(unlist(onset_genes)),
  #                  genome_size=length(unique(unlist(onset_genes)$Gene))
  #                  ),
  #     keep.rownames = "onset_ID"
  #   )
  # }) |> data.table::rbindlist(fill=TRUE,
  #                             use.names = TRUE, idcol = "HPO_ID")

}
