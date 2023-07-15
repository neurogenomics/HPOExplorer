#' HPO to matrix
#'
#' Convert gene-phenotype associations from the Human Phenotype Ontology (HPO)
#' into a gene x phenotype matrix. The returned matrix is sparse and binary,
#' such that 1 indicates a the gene is associated with a given phenotype
#' according to the HPO annotation, and 0 indicates it is not.
#' By default, full phenotype names are used as the column names
#'  (e.g. "Abnormality of body height"),
#'  however you can instead set them to the HPO IDs
#'  by changing the \code{formula} argument to:
#'   \code{formula = "gene_symbol ~ hpo_id"}.
#' Phenotypes that are not present in the \code{phenotype_to_genes} annotations
#' are omitted from the final matrix.
#' @param terms A subset of HPO IDs to include.
#' Set to \code{NULL} (default) to include all terms.
#' @param run_cor Return a matrix of pairwise correlations.
#' @param as_matrix Return the results as a matrix (\code{TRUE}).
#' Otherwise, will return the results as a \link[data.table]{data.table}
#' with an extra column "gene_symbol".
#' @param as_sparse Convert the data to a sparse matrix.
#' Only used when \code{as_matrix=TRUE}.
#' @inheritParams make_phenos_dataframe
#' @inheritParams data.table::dcast.data.table
#' @inheritParams stats::cor
#' @returns A gene x phenotype matrix,
#' or a phenotype x phenotype matrix if \code{run_cor=TRUE}.
#'
#' @export
#' @importFrom data.table dcast.data.table copy setnafill :=
#' @importFrom stats terms as.formula cor
#' @examples
#' phenos <- example_phenos()
#' X <- hpo_to_matrix(terms = phenos$hpo_id)
hpo_to_matrix <- function(terms = NULL,
                          phenotype_to_genes = load_phenotype_to_genes(),
                          formula = "gene_symbol ~ hpo_name",
                          fun.aggregate = mean,
                          value.var = "evidence_score_mean",
                          fill = 0,
                          run_cor = FALSE,
                          as_matrix = TRUE,
                          as_sparse = TRUE,
                          method = "pearson",
                          verbose = TRUE){
  # devoptera::args2vars(hpo_to_matrix, reassign = TRUE)
  requireNamespace("Matrix")
  hpo_id <- dummy <- NULL;

  messager("Constructing HPO gene x phenotype matrix.",v=verbose)
  if(!is.null(terms)){
    phenotype_to_genes <- phenotype_to_genes[hpo_id %in% unique(terms),]
  }
  #### ####
  if(is.null(value.var)){
    phenotype_to_genes[,dummy:=1]
    value.var <- "dummy"
  } else if(grepl("^evidence_score",value.var)){
    phenotype_to_genes <- add_evidence(phenos = phenotype_to_genes,
                                       verbose = verbose)
  } else if(!value.var %in% names(phenotype_to_genes)){
    stp <- paste("value.var not found in phenotype_to_genes.")
    stop(stp)
  }
  #### Cast into gene x phenotype matrix ####
  X_dt <-
    data.table::dcast.data.table(data = phenotype_to_genes,
                                 formula = formula,
                                 value.var = value.var,
                                 fun.aggregate = fun.aggregate,
                                 fill = fill,
                                 na.rm = TRUE)
  #### Make matrix nownames ####
  meta_vars <- all.vars(stats::terms(stats::as.formula(formula))[-1])
  rn <- data.table::copy(X_dt)[, rn:=do.call(paste0,.SD),
                               .SDcols=meta_vars]$rn
  #### Fill NAs ####
  if(!is.null(fill)){
    data.table::setnafill(X_dt,
                          fill = fill,
                          cols = names(X_dt[,-meta_vars, with=FALSE]))
  }
  #### Format and return ####
  if(isTRUE(as_matrix) ||
     isTRUE(run_cor)){
    X <- as.matrix(X_dt[,-meta_vars,with=FALSE])|> `rownames<-`(rn)
    if(isTRUE(run_cor)){
      messager("Computing all parwise correlations.",v=verbose)
      X_cor <- stats::cor(X, method = method)
      if(isTRUE(as_sparse)){
        X_cor <- methods::as(X_cor,'sparseMatrix')
      }
      # stats::heatmap(X_cor)
      return(X_cor)
    } else {
      if(isTRUE(as_sparse)){
        X <- methods::as(X,'sparseMatrix')
      }
      return(X)
    }
  } else{
    return(X_dt)
  }
}
