#' Add age of onset
#'
#' Add age of onset for each HPO ID.
#' Onset IDs and assigned "Onset_score" values:
#' \itemize{
#' \item{HP:0011461 }{"Fetal onset" (Onset_score=1)}
#' \item{HP:0030674 }{"Antenatal onset" (Onset_score=2)}
#' \item{HP:0003577 }{"Congenital onset" (Onset_score=3)}
#' \item{HP:0003623 }{"Neonatal onset" (Onset_score=4)}
#' \item{HP:0003593 }{"Infantile onset" (Onset_score=5)}
#' \item{HP:0011463 }{"Childhood onset" (Onset_score=6)}
#' \item{HP:0003621 }{"Juvenile onset" (Onset_score=7)}
#' \item{HP:0011462 }{"Young adult onset" (Onset_score=8)}
#' \item{HP:0003581 }{"Adult onset" (Onset_score=9)}
#' \item{HP:0003596 }{"Middle age onset" (Onset_score=10)}
#' \item{HP:0003584 }{"Late onset" (Onset_score=11)}
#' }
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns:
#' \itemize{
#' \item{"Onset": }{Onset HPO IDs of disease phenotypes associated
#' with the target HPO_ID phenotype.}
#' \item{"Onset_names": }{Onset HPO names of disease phenotypes associated
#' with the target HPO_ID phenotype.}
#' \item{"Onset_counts": }{The number of times each term in
#' "Onset_names" appears across associated disease phenotypes.}
#' \item{"Onset_score_mean": }{Mean onset score.}
#' \item{"Onset_score_min": }{Minimum onset score.}
#' \item{"Onset_top": }{The most common onset term.}
#' \item{"Onset_earliest": }{The developmentally earliest onset.}
#' }
#' @export
#' @importFrom data.table merge.data.table .EACHI
#' @examples
#' phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
#' phenos2 <- add_onset(phenos = phenos)
add_onset <- function(phenos,
                      all.x = TRUE,
                      allow.cartesian = FALSE,
                      verbose = TRUE){

  # templateR:::args2vars(add_age_of_onset)

  HPO_ID <- Onset <- Onset_name <- Onset_score <- . <- NULL;

  if(!all(c("Onset","Onset_names","Onset_earliest") %in% names(phenos))){
    messager("Annotating phenos with Onset.",v=verbose)
    annot <- load_phenotype_to_genes(filename = "phenotype.hpoa",
                                     verbose = verbose)
    annot <- annot[Onset!="" & HPO_ID %in% phenos$HPO_ID,]
    annot$Onset_name <- harmonise_phenotypes(annot$Onset)
    dict <- c('Fetal onset'=1,
              'Antenatal onset'=2,
              'Congenital onset'=3,
              'Neonatal onset'=4,
              'Infantile onset'=5,
              'Childhood onset'=6,
              'Juvenile onset'=7,
              'Young adult onset'=8,
              'Adult onset'=9,
              'Middle age onset'=10,
              'Late onset'=11)
    annot$Onset_score <- dict[annot$Onset_name]
    annot_agg <- annot[,.(Onset=paste(unique(Onset),collapse = ";"),
                          Onset_names=paste(unique(Onset_name),collapse = ";"),
                          Onset_counts=paste(table(Onset_name),collapse = ";"),
                          Onset_score_mean=mean(Onset_score,na.rm=TRUE),
                          Onset_score_min=min(Onset_score,na.rm=TRUE)
                          ),
                       by="HPO_ID"]
    annot_agg$Onset_top <- lapply(seq_len(nrow(annot_agg)),
                                        function(i){
      r <- annot_agg[i,]
      on <- strsplit(r$Onset_names,";")[[1]]
      oc <- strsplit(r$Onset_counts,";")[[1]]
      on[oc==min(oc)][[1]]
    }) |> unlist()
    annot_agg$Onset_earliest <- stats::setNames(names(dict),unname(dict))[
      as.character(annot_agg$Onset_score_min)
    ]
    #### Merge ##@#
    phenos <- data.table::merge.data.table(x = phenos,
                                           y = annot_agg,
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
