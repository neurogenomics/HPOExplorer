% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{hpo_frequencies}
\alias{hpo_frequencies}
\title{Human Phenotype Ontology: phenotype frequencies}
\format{
data.table
}
\source{
\href{https://hpo-annotation-qc.readthedocs.io/en/latest/annotationFormat.html}{Column explanations}

\code{
annot <- load_phenotype_to_genes("phenotype.hpoa")
hpo_frequencies <- HPOExplorer:::parse_pheno_frequency(annot=annot)
hpo_frequencies <- HPOExplorer:::as_ascii(dat=hpo_frequencies)
data.table::setcolorder(hpo_frequencies,c("disease_id","hpo_id"))
usethis::use_data(hpo_frequencies, overwrite = TRUE)
}
}
\usage{
data("hpo_frequencies")
}
\description{
Frequency of each HPO term \emph{WITHIN} all associated diseases
(as opposed to the general population).
In order of increasing frequency:
\itemize{
\item{HP:0040284 }{"Very rare (<4-1\%)"}
\item{HP:0040283 }{"Occasional (29-5\%)"}
\item{HP:0040282 }{"Frequent (79-30\%)"}
\item{HP:0040281 }{"Very frequent (99-80\%)"}
\item{HP:0040280 }{"Obligate (100\%)"}
}
}
\keyword{datasets}
