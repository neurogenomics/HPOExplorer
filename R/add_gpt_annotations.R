#' @describeIn add_ add_
#' Add ancestor
#'
#' Add annotations generated with a Large Language Model.
#' @param annot GPT annotation data.
#' @param annot_cols Columns to add.
#' @export
#' @examples
#' phenos <- example_phenos()
#' phenos2 <- add_gpt_annotations(phenos)
add_gpt_annotations <- function(phenos,
                                annot = gpt_annot_codify(
                                  reset_weights_dict=TRUE
                                  )$annot_weighted,
                                annot_cols = names(annot)[
                                  !names(annot) %in% c("hpo_id","hpo_name")
                                  ],
                                gpt_filters=rep(list(NULL),
                                                length(annot_cols))|>
                                  `names<-`(annot_cols),
                                force_new = FALSE){
  #### Force new columns ####
  if(force_new){
    messager("Force new. Removing existing annot columns.")
    rm_cols <- annot_cols[annot_cols %in% names(phenos)]
    if(length(rm_cols)>0) phenos[,(rm_cols):=NULL]
  }
  #### Check for existing columns ####
  if(all(annot_cols %in% names(phenos))){
    messager("Ancestor columns already present. Skipping.")
  }else {
    ## According to the latest GPT annotations (3-15-2024),
    ## merging on "hpo_id" yields more annotated results (10724)
    ## than merging on "hpo_name" (10678).
    phenos <- data.table::merge.data.table(phenos,
                                           annot[,-c("hpo_name")][,.SD[1], by="hpo_id"],
                                           by= "hpo_id",
                                           all.x = TRUE)
  }
  #### Filter ####
  phenos <- KGExplorer::filter_dt(dat=phenos,
                                  filters = gpt_filters)
  #### Return #####
  return(phenos)
}
