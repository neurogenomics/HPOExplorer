gpt_annot_melt <- function(res_coded){
  id.vars <- grep("justification|phenotype|hpo_id|pheno_count",
                  names(res_coded$annot),
                  value = TRUE)
  dat <- data.table::melt.data.table(
    data = res_coded$annot[
      res_coded$annot_weighted[,c("hpo_id","severity_score_gpt")],on="hpo_id"],
    id.vars = c(id.vars,"severity_score_gpt"),
    variable.factor = TRUE,
    value.factor = TRUE)
  return(dat)
}
