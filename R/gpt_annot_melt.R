#' Melt annotations from GPT
#'
#' Merge the annotations from GPT with the weighted annotations and melt the
#' resulting data.table such that each annotation metric is a separate row.
#'
#' @param res_coded Result from \link{gpt_annot_codify}.
#' @param id.vars Columns to use as ID variables when merging.
#' @returns A melted data.table with the annotations.
#'
#' @export
#' @examples
#' res_coded <- gpt_annot_codify()
#' annot_melt <- gpt_annot_melt(res_coded)
gpt_annot_melt <- function(res_coded,
                           id.vars = grep(
                             "justification|phenotype|hpo_name|hpo_id|pheno_count",
                             names(res_coded$annot),
                             value = TRUE)
                           ){
  dat <- data.table::melt.data.table(
    data = res_coded$annot[
      unique(res_coded$annot_weighted[,c(id.vars,"severity_score_gpt"),
                                      with=FALSE]),
      on=id.vars],
    id.vars = c(id.vars,"severity_score_gpt"),
    variable.factor = TRUE,
    value.factor = TRUE)
  return(dat)
}
