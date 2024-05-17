#' Get top phenotypes
#'
#' Get the most severe phenotypes per severity class:
#'  Profound, Severe, Moderate, Mild.
#' The exception to this is the "Mild" class, where the \emph{least}
#'  severe phenotypes will be taken instead of the most severe phenotypes.
#' @inheritParams add_ont_lvl
#' @inheritParams add_ancestor
#' @inheritParams plot_top_phenos
#' @importFrom utils head tail
#' @export
#' @examples
#' top_phenos <- get_top_phenos()
get_top_phenos <- function(res_class = gpt_annot_class(),
                           keep_ont_levels = seq(3,17),
                           keep_descendants = "Phenotypic abnormality",
                           n_per_class = 10,
                           annotation_order=NULL,
                           split_by_congenital=TRUE){
  congenital_onset <- is_congenital <- severity_class <- value <- NULL;

  if(is.null(annotation_order)){
    weights_dict <- eval(formals(gpt_annot_codify)$weights_dict)
    annotation_order <- gsub("_"," ",names(sort(unlist(weights_dict),
                                                decreasing = TRUE)))
  }
  res_class[,is_congenital:=(congenital_onset %in% c(2,3))]
  annot_melt <- data.table::melt.data.table(res_class,
                                            id.vars = c("severity_class",
                                                        "is_congenital",
                                                        "hpo_id",
                                                        "hpo_name",
                                                        "severity_score_gpt"))
  annot_melt <- annot_melt[!is.na(value),]
  #### Filter out ont levels ####
  annot_melt <- HPOExplorer::add_ancestor(annot_melt,
                                          keep_descendants = keep_descendants)
  data.table::setorderv(annot_melt,"severity_score_gpt",-1)
  annot_melt <- HPOExplorer::add_ont_lvl(annot_melt,
                                         keep_ont_levels = keep_ont_levels)
  annot_melt$variable <- gsub("_", " ", annot_melt$variable)
  annot_melt$variable <- factor(annot_melt$variable, levels = annotation_order)


  if(split_by_congenital){
    dat_congenital <- lapply(unique(annot_melt$severity_class), function(s){
      sort_fun <- if(s=="mild") utils::tail else utils::head
      annot_melt[severity_class== s &
                   is_congenital==TRUE,
                 sort_fun(.SD,n_per_class), by="variable"]
    })|> data.table::rbindlist()
    dat_noncongenital <- lapply(unique(annot_melt$severity_class), function(s){
      sort_fun <- if(s=="mild") tail else head
      annot_melt[severity_class== s &
                   is_congenital==FALSE,
                 sort_fun(.SD,n_per_class), by="variable"]
    })|> data.table::rbindlist()
    return(list(congenital=dat_congenital,
                noncongenital=dat_noncongenital)
    )
  } else {
    dat <- lapply(unique(annot_melt$severity_class), function(s){
      sort_fun <- if(s=="mild") tail else head
      annot_melt[severity_class== s,
                 sort_fun(.SD,n_per_class), by="variable"]
    })|> data.table::rbindlist()
    return(dat)
  }
}
