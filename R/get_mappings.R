#' @describeIn get_ get_
#' Get Human Phenotype Ontology (HPO) mappings
#'
#' Get mappings between HPO terms and their corresponding IDs in
#'  other medical ontologies (e.g. SNOMED CT, UMLS, ICD-9/10).
#' @param to Medical ontologies to provide mappings to.
#' @param max_dist Maximum cross-ontology distance to search for mappings.
#'  A distance of 1 means only direct mappings are returned.
#'  Greater distances mean that mappings are found through intermediate terms
#'   and are therefore less reliable.
#' @inheritDotParams get_data
#' @returns A named list of \link[data.table]{data.table}
#' objects containing mappings.
#'
#' @export
#' @examples
#' mappings <- get_mappings()
get_mappings <- function(terms=NULL,
                         to=c("UMLS","SNOMED","ICD9","ICD10"),
                         max_dist=1,
                         force_new=FALSE,
                         save_dir=KGExplorer::cache_dir(package="HPOExplorer"),

                         ...){
  file_name <- distance <- NULL;

  files <- piggyback::pb_list(repo = "neurogenomics/HPOExplorer")
  files <- data.table::data.table(files)[grepl("*_to_HPO_dist3\\.csv\\.gz$",
                                               file_name)]
  files$to <- strsplit(files$file_name,"_to_HPO_dist3\\.csv\\.gz$")|>unlist()
  opts <- intersect(toupper(unique(files$to)),
                    toupper(to))
  if(length(opts)==0){
    stop("`to` must be one of: ",paste0(shQuote(opts),collapse=", "))
  }
  out <- lapply(stats::setNames(opts,opts), function(x){
    f <- get_data(file=files[opts==x]$file_name[1],
                  overwrite = force_new,
                  save_dir = save_dir,
                  ...)
    d <- data.table::fread(f)
    if(is.numeric(max_dist)){
      d <- d[distance<=max_dist]
    }
    d
  })
  return(out)
}
