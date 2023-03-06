#' Add age of death
#'
#' Add age of death for each HPO ID.
#' AgeOfDeath IDs and assigned "AgeOfDeath_score" values:
#' \itemize{
#' \item{HP:0005268 }{"Miscarriage" (AgeOfDeath_score=1)}
#' \item{HP:0003826 }{"Stillbirth" (AgeOfDeath_score=1)}
#' \item{HP:0034241 }{"Prenatal death" (AgeOfDeath_score=1)}
#' \item{HP:0003811 }{"Neonatal death" (AgeOfDeath_score=2)}
#' \item{HP:0001522 }{"Death in infancy" (AgeOfDeath_score=3)}
#' \item{HP:0003819 }{"Death in childhood" (AgeOfDeath_score=4)}
#' \item{HP:0011421 }{"Death in adolescence" (AgeOfDeath_score=5)}
#' \item{HP:0100613 }{"Death in early adulthood" (AgeOfDeath_score=6)}
#' \item{HP:0033764 }{"Death in middle age" (AgeOfDeath_score=7)}
#' \item{HP:0033763 }{"Death in adulthood" (AgeOfDeath_score=7)}
#' \item{HP:0033765 }{"Death in late adulthood" (AgeOfDeath_score=8)}
#' }
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns:
#' \itemize{
#' \item{"AgeOfDeath": }{AgeOfDeath HPO IDs of disease phenotypes associated
#' with the target HPO_ID phenotype.}
#' \item{"AgeOfDeath_names": }{AgeOfDeath HPO names of disease phenotypes
#' associated with the target HPO_ID phenotype.}
#' \item{"AgeOfDeath_counts": }{The number of times each term in
#' "AgeOfDeath_names" appears across associated disease phenotypes.}
#' \item{"AgeOfDeath_score_mean": }{Mean age of death score.}
#' \item{"AgeOfDeath_score_min": }{Minimum age of death score.}
#' \item{"AgeOfDeath_top": }{The most common age of death term.}
#' \item{"AgeOfDeath_earliest": }{The earliest age of death.}
#' \item{"AgeOfDeath_latest": }{The latest age of death.}
#' }
#'
#' @export
#' @importFrom data.table merge.data.table
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_death(phenos = phenos)
add_death <- function(phenos,
                      all.x = TRUE,
                      allow.cartesian = FALSE,
                      verbose = TRUE){

  # templateR:::args2vars(add_death)
  HPO_ID <- AgeOfDeath <- AgeOfDeath_name <- AgeOfDeath_score <- . <- NULL;

  if(!all(c("AgeOfDeath",
            "AgeOfDeath_names",
            "AgeOfDeath_earliest") %in% names(phenos))){

    messager("Annotating phenos with AgeOfDeath",v=verbose)
    utils::data("hpo_death",package = "HPOExplorer")
    hpo_death <- get("hpo_death")
    dict <- hpo_dict(type = "AgeOfDeath")
    annot_agg <- hpo_death[HPO_ID %in% unique(phenos$HPO_ID),.(
      AgeOfDeath=paste(unique(AgeOfDeath),collapse = ";"),
      AgeOfDeath_names=paste(unique(AgeOfDeath_name),collapse = ";"),
      AgeOfDeath_counts=paste(table(AgeOfDeath_name),collapse = ";"),
      AgeOfDeath_score_mean=mean(AgeOfDeath_score,na.rm=TRUE),
      AgeOfDeath_score_min=min(AgeOfDeath_score,na.rm=TRUE),
      AgeOfDeath_score_max=max(AgeOfDeath_score,na.rm=TRUE)
    ), by="HPO_ID"]
    annot_agg$AgeOfDeath_top <- lapply(seq_len(nrow(annot_agg)),
                                  function(i){
                                    r <- annot_agg[i,]
                                    on <- strsplit(r$AgeOfDeath_names,";")[[1]]
                                    oc <- strsplit(r$AgeOfDeath_counts,";")[[1]]
                                    on[oc==min(oc)][[1]]
                                  }) |> unlist()
    annot_agg$AgeOfDeath_earliest <- stats::setNames(names(dict),unname(dict))[
      as.character(annot_agg$AgeOfDeath_score_min)
    ]
    annot_agg$AgeOfDeath_latest <- stats::setNames(names(dict),unname(dict))[
      as.character(annot_agg$AgeOfDeath_score_max)
    ]
    #### Merge ##@#
    phenos <- data.table::merge.data.table(x = phenos,
                                           y = annot_agg,
                                           by = "HPO_ID",
                                           allow.cartesian = allow.cartesian,
                                           all.x = all.x)
  }
  return(phenos)
}
