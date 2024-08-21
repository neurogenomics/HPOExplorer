#' Map disease
#'
#' Map disease IDs (e.g. "OMIM:101200") to names (e.g. "Apert syndrome")
#' @inheritParams add_
#' @param dat A data.table with a column of disease IDs.
#' @param id_col The name of the column with the disease IDs.
#' @param fields The fields to extract from the API response.
#' @param return_dat Return the data.table with the mapped fields.
#' @param use_api Use the API to get the disease names and descriptions.
#' Otherwise, use a cached data.table (\code{disease_map}).
#' @inheritParams KGExplorer::set_cores
#' @source \href{https://ontology.jax.org/api/network/docs}{HPO API docs}
#' @source \href{https://github.com/obophenotype/human-phenotype-ontology/issues/10232}{HPO GitHub Issue}
#' @export
#' @examples
#' dat <- HPOExplorer::load_phenotype_to_genes()
#' out <- map_disease(dat = dat, workers=1)
map_disease <- function(dat,
                        id_col="disease_id",
                        fields=c("disease","categories","genes")[1],
                        use_api=FALSE,
                        return_dat=FALSE,
                        workers=NULL,
                        all.x = TRUE,
                        allow.cartesian = FALSE
                        ){
  # res <- httr::GET(
  #   "https://ontology.jax.org/api/network/annotation/OMIM%3A101200",
  #   httr::add_headers(accept = "application/json")
  # )
  # cont <- httr::content(res)
  # Define the URL and headers
  if(!id_col %in% names(dat)){
    stop("id_col not found in dat.")
  }
  if(!all(c("disease_name","disease_description") %in% names(dat))){
    messager("Adding disease_name and disease_description.")
    requireNamespace("BiocParallel")
    #### Slow but up-to-date ####
    if(use_api || length(fields)>1){
      map_disease_i <- function(id){
        url <- utils::URLencode(
          ## encode URL
          paste0("https://ontology.jax.org/api/network/annotation/",id)
        )
        ## get content
        cont <- jsonlite::fromJSON(url)
        ## Extract names
        cont$disease <- data.table::as.data.table(cont$disease)
        cont$disease|> data.table::setnames(
          c("name","description","mondoId"),
          c("disease_name","disease_description","mondo_id"))
        cont$genes <- data.table::as.data.table(cont$genes)
        cont$categories <- lapply(cont$categories, function(x){
          data.table::data.table(x)
        })|>
          data.table::rbindlist(idcol = "hpo_group", fill=TRUE) |>
          data.table::setnames(c("id","name"),c("hpo_id","hpo_name"))
        names(cont$categories) <- gsub("[.]","_",names(cont$categories))

        #### Return ####
        if(length(fields)==1){
          return(cont[[fields]])
        } else {
          return(cont)
        }
      }
      #### Iterate ####
      ids <- unique(dat[[id_col]])
      BPPARAM <- KGExplorer::set_cores(workers = workers)
      res <- BiocParallel::bplapply(X = stats::setNames(ids,ids),
                                    FUN = map_disease_i,
                                    BPPARAM = BPPARAM)
      if(length(fields)==1){
        res <- data.table::rbindlist(res, fill=TRUE)
        if(return_dat){
          dat <- merge(dat, res,
                       by.x=id_col,
                       by.y = "id",
                       all.x = TRUE)
          return(dat)
        }
      }
      return(res)
    #### Fast but potentially out-of-date ####
    } else{
      disease_map <- KGExplorer::get_data_package(name = "disease_map",
                                                  package = "HPOExplorer")
      dat <- data.table::merge.data.table(
        dat,
        disease_map,
        by = "disease_id",
        all.x = all.x,
        allow.cartesian = allow.cartesian)
      return(dat)
    }
  } else {
    messager("disease_name and disease_description already in dat.")
    return(dat)
  }
}
