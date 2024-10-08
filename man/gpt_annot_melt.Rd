% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gpt_annot_melt.R
\name{gpt_annot_melt}
\alias{gpt_annot_melt}
\title{Melt annotations from GPT}
\usage{
gpt_annot_melt(
  res_coded,
  id.vars = grep("justification|phenotype|hpo_name|hpo_id|pheno_count",
    names(res_coded$annot), value = TRUE)
)
}
\arguments{
\item{res_coded}{Result from \link{gpt_annot_codify}.}

\item{id.vars}{Columns to use as ID variables when merging.}
}
\value{
A melted data.table with the annotations.
}
\description{
Merge the annotations from GPT with the weighted annotations and melt the
resulting data.table such that each annotation metric is a separate row.
}
\examples{
res_coded <- gpt_annot_codify()
annot_melt <- gpt_annot_melt(res_coded)
}
