% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gpt_annot_read.R
\name{gpt_annot_read}
\alias{gpt_annot_read}
\title{Read annotations from GPT}
\usage{
gpt_annot_read(
  save_dir = KGExplorer::cache_dir(package = "HPOExplorer"),
  phenotype_to_genes = load_phenotype_to_genes(save_dir = save_dir),
  force_new = FALSE,
  hpo = get_hpo(),
  include_nogenes = TRUE,
  verbose = TRUE,
  ...
)
}
\arguments{
\item{save_dir}{Directory to save a file to.}

\item{phenotype_to_genes}{Output of
\link{load_phenotype_to_genes} mapping phenotypes
to gene annotations.}

\item{force_new}{If \code{TRUE}, the data will be downloaded from GitHub
even if it already exists locally.}

\item{hpo}{Human Phenotype Ontology object,
loaded from \link[KGExplorer]{get_ontology}.}

\item{include_nogenes}{Include phenotypes with no associated genes.}

\item{verbose}{Print messages.}

\item{...}{
  Arguments passed on to \code{\link[=get_data]{get_data}}
  \describe{
    \item{\code{add_version}}{Add the release version
to the returned object's \link[base]{attributes}}
    \item{\code{file}}{name or vector of names of files to be downloaded. If \code{NULL},
all assets attached to the release will be downloaded.}
    \item{\code{repo}}{Repository name in format "owner/repo". Defaults to \code{guess_repo()}.}
    \item{\code{tag}}{tag for the GitHub release to which this data should be attached.}
    \item{\code{overwrite}}{Should any local files of the same name be overwritten?
default \code{TRUE}.}
  }}
}
\value{
data.table of phenotype annotations
}
\description{
Read in phenotype annotations generated by GPT and
do some initial preprocessing (e.g. adding HPO IDs).
}
\examples{
gpt_annot <- gpt_annot_read()
}
