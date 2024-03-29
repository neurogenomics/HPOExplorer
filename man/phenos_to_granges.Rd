% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/phenos_to_granges.R
\name{phenos_to_granges}
\alias{phenos_to_granges}
\title{Phenotypes to \link[GenomicRanges]{GenomicRanges}}
\usage{
phenos_to_granges(
  phenos = NULL,
  phenotype_to_genes = load_phenotype_to_genes(),
  hpo = get_hpo(),
  keep_chr = c(seq(22), "X", "Y"),
  by = c("hpo_id", "disease_id"),
  gene_col = "intersection",
  split.field = "hpo_id",
  as_datatable = FALSE,
  allow.cartesian = FALSE,
  verbose = TRUE
)
}
\arguments{
\item{phenos}{A data.table containing HPO IDs and other metadata.}

\item{phenotype_to_genes}{Output of
\link{load_phenotype_to_genes} mapping phenotypes
to gene annotations.}

\item{hpo}{Human Phenotype Ontology object,
loaded from \link[KGExplorer]{get_ontology}.}

\item{keep_chr}{Chromosomes to keep.}

\item{by}{A vector of shared column names in \code{x} and \code{y} to merge on.
This defaults to the shared key columns between the two tables.
If \code{y} has no key columns, this defaults to the key of \code{x}.}

\item{gene_col}{Name of the gene column.}

\item{split.field}{
      A character string of a recognized column name in \code{df} that contains
      the grouping. This column defines how the rows of \code{df} are split and
      is typically a \code{factor} or \code{character} vector.  When
      \code{split.field} is not provided the \code{df} will be split by the
      number of rows.
  }

\item{as_datatable}{Return as a \link[data.table]{data.table}.}

\item{allow.cartesian}{See \code{allow.cartesian} in \code{\link[data.table]{[.data.table}}.}

\item{verbose}{Print messages.}
}
\value{
A \link[GenomicRanges]{GRangesList}.
}
\description{
Convert a HPO phenotype dataframe generated by
\link[HPOExplorer]{make_phenos_dataframe}
to a \link[GenomicRanges]{GRangesList} split by HPO ID.
The resulting object will contain genes (and gene metadata) for all
genes associated with each phenotypes.
}
\examples{
phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
grl <- phenos_to_granges(phenos = phenos)
}
