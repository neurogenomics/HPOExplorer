#' @describeIn add_ add_
#' Add evidence
#'
#' Add the strength of evidence supporting each gene-disease association.
#' \href{https://thegencc.org/faq.html#validity-termsdelphi-survey}{
#' Delphi survey} evidence classification IDs and
#' assigned "evidence_score" values:
#' \itemize{
#' \item{GENCC:100001 }{"Definitive" (evidence_score=6)}
#' \item{GENCC:100002 }{"Strong" (evidence_score=5)}
#' \item{GENCC:100003 }{"Moderate" (evidence_score=4)}
#' \item{GENCC:100009 }{"Supportive" (evidence_score=3)}
#' \item{GENCC:100004 }{"Limited" (evidence_score=2)}
#' \item{GENCC:100005 }{"Disputed Evidence" (evidence_score=1)}
#' \item{GENCC:100006 }{"Refuted Evidence" (evidence_score=0)}
#' \item{GENCC:100008 }{"No Known Disease Relationship" (evidence_score=0)}
#' }
#' @param keep_evidence The evidence scores of each gene-disease
#' association to keep.
#' @param default_score Default evidence score to
#' apply to gene-disease associations that are present in the HPO annotations
#' but don't have evidence scores in the GenCC annotations.
#' @inheritParams make_network_object
#' @inheritParams data.table::merge.data.table
#' @returns phenos data.table with extra columns:
#' \itemize{
#' \item{"evidence_score_min": }{Minimum evidence score.}
#' \item{"evidence_score_max": }{Maximum evidence score.}
#' \item{"evidence_score_mean": }{Mean evidence score.}
#' }
#'
#' @export
#' @importFrom data.table merge.data.table
#' @examples
#' phenos <- load_phenotype_to_genes()
#' phenos2 <- add_evidence(phenos = phenos)
add_evidence <- function(phenos,
                         keep_evidence = NULL,
                         all.x = TRUE,
                         allow.cartesian = FALSE,
                         agg_by = c("disease_id",
                                    "gene_symbol"),
                         default_score = 1){
  evidence_score <- evidence_score_mean <- NULL;

  if(!all(c("evidence_score_mean") %in% names(phenos))){
    messager("Annotating gene-disease associations with Evidence score")
    phenos <- add_disease(phenos = phenos,
                          all.x = all.x,
                          allow.cartesian = allow.cartesian)
    annot <- get_gencc(agg_by = agg_by)
    #### Merge with input data ####
    phenos <- data.table::merge.data.table(
      x = phenos,
      y = annot,
      by = c("disease_id","gene_symbol"),
      all.x = all.x,
      sort = FALSE,
      allow.cartesian = allow.cartesian)
  }
  #### Filter ####
  if(!is.null(keep_evidence)){
    if("evidence_score_mean" %in% names(phenos)){
      phenos <- phenos[evidence_score_mean %in% keep_evidence,]
    } else if("evidence_score" %in% names(phenos)){
      phenos <- phenos[evidence_score %in% keep_evidence,]
    }
  }
  #### Set default score ####
  if(!is.null(default_score)){
    data.table::setnafill(
      phenos,
      type = "const",
      fill = default_score,
      cols = grep('evidence_score',names(phenos),value = TRUE))
  }
  return(phenos)
}
