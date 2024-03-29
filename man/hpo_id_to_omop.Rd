% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{hpo_id_to_omop}
\alias{hpo_id_to_omop}
\title{Human Phenotype Ontology: HPO ID to OMOP}
\format{
An object of class \code{data.table} (inherits from \code{data.frame}) with 16426 rows and 3 columns.
}
\source{
\code{
 hpo <- get_hpo()
 ids <- unique(hpo@terms)
 hpo_id_to_omop <- oard_query_api(ids = ids, workers=10)
 input_col="hpo_id"
 data.table::setnames(hpo_id_to_omop,
                      toupper(gsub("concept_","OMOP_",names(hpo_id_to_omop)))
                      )
 data.table::setnames(hpo_id_to_omop, "OMOP_CODE",input_col)
 hpo_id_to_omop <- hpo_id_to_omop[,c(input_col,"OMOP_ID","OMOP_NAME"),
                                  with=FALSE]
 usethis::use_data(hpo_id_to_omop, overwrite = TRUE)
 }
@format data.table
@usage data("hpo_id_to_omop")
}
\usage{
hpo_id_to_omop
}
\description{
Mapping of HPO phenotype IDs (hpo_id) to OMOP concepts (OMOP_ID).
}
\keyword{datasets}
