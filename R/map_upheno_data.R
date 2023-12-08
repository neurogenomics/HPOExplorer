#' Map uPheno data
#'
#' Get uPheno cross-species mapping data by:
#' \itemize{
#' \item{Downloading cross-species phenotype-phenotype mappings.}
#' \item{Downloading within-spceies phenotype-gene mappings,
#' and converting these genes to human orthologs.}
#' \item{Merging the phenotype-phenotype and phenotype-gene mappings.}
#' \item{Filtering out any mappings that do not have a human ortholog within
#' each respective phenotype.}
#' \item{Calculating the proportion of orthologous genes overlapping across
#' the species-specific phenotype-gene mappings.}
#' \item{Iterating the above steps using multiple methods
#' (\code{pheno_map_method}) and concatenating the results together.}
#' }
#' @param keep_nogenes Logical indicating whether to keep mappings that do not
#' have any orthologous genes.
#' @inheritParams map_upheno
#' @returns A data.table containing the mapped data.
#'
#' @export
#' @examples
#' pheno_map_genes_match <- map_upheno_data()
map_upheno_data <- function(pheno_map_method=c("upheno","monarch"),
                            gene_map_method=c("monarch","orthogene"),
                            keep_nogenes=FALSE,
                            fill_scores=NULL,
                            terms=NULL,
                            save_dir=tools::R_user_dir(package = "HPOExplorer",
                                                       which = "cache"),
                            force_new=FALSE){
  # devoptera::args2vars(map_upheno_data)

  #### Check for cached data ####
  path <- file.path(save_dir,"pheno_map_genes_match.rds")
  if(file.exists(path) &&
     isFALSE(force_new)){
    ## Read from cache
    messager("Importing cached data:",path)
    pheno_map_genes_match <- readRDS(path)
  } else {
    ## Create
    pheno_map_genes_match <- lapply(
      stats::setNames(pheno_map_method,
                      pheno_map_method),
      function(m){
        map_upheno_data_i(pheno_map_method=m,
                          gene_map_method=gene_map_method,
                          keep_nogenes=keep_nogenes,
                          fill_scores=fill_scores,
                          terms=terms)
      }) |> data.table::rbindlist(fill=TRUE, idcol = "pheno_map_method")
    ## Save
    messager("Caching processed file -->",path)
    attr(pheno_map_genes_match,"version") <- format(Sys.Date(), "%Y-%m-%d")
    dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)
    saveRDS(pheno_map_genes_match,path)
  }
  ## Return
  return(pheno_map_genes_match)
}
