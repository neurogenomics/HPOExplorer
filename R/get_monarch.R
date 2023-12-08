#' Get Monarch
#'
#' Get key datasets from the Monarch Initiative server.
#' @param file Short name of the file to retrieve.
#' \itemize{
#' \item{"gene_to_gene"}{Gene-to-gene mappings across species orthologous.}
#' \item{"phenotype_to_gene"}{Phenotype-to-gene mappings for multiple species.}
#' \item{"disease_to_model"}{Disease-to-model mappings for multiple
#' model species.}
#' \item{"phenotype_to_phenotype"}{Phenotype-to-phenotype mappings across
#'  species homologs.}
#' }
#' @param file_map Mapping between short name and full name of each file.
#' @param domain Monarch Initiative server domain.
#' @inheritDotParams data.table::fread
#' @returns \link[data.table]{data.table}
#'
#' @export
#' @examples
#' dat <- get_monarch()
get_monarch <- function(file=c("gene_to_gene",
                               "phenotype_to_gene",
                               "disease_to_model",
                               "phenotype_to_phenotype"
                               ),
                        file_map=list(
                          ## Gene-gene homology across 12 species
                          gene_to_gene=
                            paste0(
                              "monarch-kg-dev/latest/tsv/all_associations/",
                              "gene_to_gene_homology_association.all.tsv.gz"
                            ),
                          ## Gene-phenotype associations across 8 species
                          phenotype_to_gene=
                            paste0(
                              "monarch-kg-dev/latest/tsv/all_associations/",
                              "gene_to_phenotypic_feature_association.all.tsv.gz"
                            ),
                          disease_to_model=
                            paste0(
                              "latest/tsv/model_associations/",
                              "model_disease.all.tsv.gz"
                          ),
                          phenotype_to_phenotype=
                            paste0(
                              "upheno2/current/upheno-release/all/",
                              "upheno_mapping_all.csv"
                            )
                        ),
                        domain="https://data.monarchinitiative.org",
                        ...
                        ){

  file <- match.arg(file)
  URL <- paste(domain,file_map[[file]], sep="/")
  dat <- data.table::fread(URL,...)
  return(dat)
}
