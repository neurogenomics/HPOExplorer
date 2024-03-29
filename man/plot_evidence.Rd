% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_evidence.R
\name{plot_evidence}
\alias{plot_evidence}
\title{Plot evidence}
\usage{
plot_evidence(
  metric = "evidence_score_sum",
  phenotype_to_genes = load_phenotype_to_genes(),
  show_plot = TRUE,
  save_path = NULL,
  height = NULL,
  width = NULL
)
}
\arguments{
\item{metric}{Aggregated metric of evidence to assess.}

\item{phenotype_to_genes}{Output of
\link{load_phenotype_to_genes} mapping phenotypes
to gene annotations.}

\item{show_plot}{Print the plot after it's been generated.}

\item{save_path}{Path to save interactive plot to
as a self-contained HTML file.}

\item{height}{: String. Default to "100\%". The height of the network in pixels or as a percentage.}

\item{width}{: Number. Default to 1. The width of the edge. If value is set, this is not used.}
}
\description{
Plot the distribution of evidence scores for gene-disease and gene-phenotype
associations.
}
\examples{
out <- plot_evidence()
}
