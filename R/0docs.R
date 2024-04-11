#' @title Main functions
#'
#' @description
#' Main functions.
#' @param phenos A data.table containing HPO IDs and other metadata.
#' @param hpo Human Phenotype Ontology object,
#'  loaded from \link[KGExplorer]{get_ontology}.
#' @param add_ont_lvl_absolute Add the absolute ontology level of each HPO term.
#' See \link[KGExplorer]{get_ontology_levels} for more details.
#' @param add_ont_lvl_relative Add the relative ontology level of each HPO term.
#' See \link[KGExplorer]{get_ontology_levels} for more details.
#' @param add_description Whether to get the phenotype descriptions as
#'  well (slower).
#' @param add_info_content Add information content column for each phenotype.
#' @param add_disease_data Add all disease metadata columns.
#' This will expand the data using \code{allow.cartesian=TRUE}.
#' @param add_ndiseases Add the number of diseases per phenotype.
#' @param add_pheno_frequencies Add the frequency of each phenotype in
#' each disease.
#' @param add_tiers Add severity Tiers column using
#' \link[HPOExplorer]{add_tier}.
#' @param add_severities Add severity column using
#' \link[HPOExplorer]{add_severity}.
#' @param add_hoverboxes Add hoverdata with
#' \link[KGExplorer]{add_hoverboxes}.
#' @param add_onsets Add age of onset columns using
#' \link[HPOExplorer]{add_onset}.
#' @param add_deaths Add age of death columns using
#' \link[HPOExplorer]{add_death}.
#' @param columns A named vector of columns in \code{phenos}
#'  to add to the hoverdata via \link[KGExplorer]{add_hoverboxes}.
#' @param add_disease_definitions Add disease definitions.
#' @param include_mondo Add \href{https://mondo.monarchinitiative.org/}{MONDO}
#' IDs, names, and definitions to each disease.
#' @param interactive Make the plot interactive.
#' @family main
#' @returns Data.
#' @import data.table
#' @import KGExplorer
#' @name main
NULL


#' @title Get functions
#'
#' @description
#' Functions to get data objects and extract elements.
#' @param term One or more ontology IDs.
#' @family get_
#' @param force_new Force a new download or creation of a data resource.
#' @param lvl How many levels deep into the ontology to get ancestors from.
#' For example:
#' \itemize{
#' \item{1: }{"All"}
#' \item{2: }{"Phenotypic abnormality"}
#' \item{3: }{"Abnormality of the nervous system"}
#' \item{4: }{"Abnormality of nervous system physiology"}
#' \item{5: }{"Neurodevelopmental abnormality" or "Behavioral abnormality"}
#' }
#' @inheritParams main
#' @inheritParams make_
#' @returns Data.
#' @name get_
NULL

#' @title Add functions
#'
#' @description
#' Functions to add metadata to data.table objects.
#' @family add_
#' @param agg_by Column to aggregate metadata by.
#' @param add_definitions Add disease definitions using \link{add_mondo}.
#' @param gpt_filters A named list of filters to apply to the GPT annotations.
#' @inheritParams main
#' @inheritParams make_
#' @inheritParams get_
#' @inheritParams filter_
#' @inheritParams data.table::merge.data.table
#' @returns Annotated data.
#' @name add_
NULL


#' @title Filter functions
#'
#' @description
#' Functions to filter data.table objects.
#' @family filter_
#' @inheritParams main
#' @inheritParams KGExplorer::filter_
#' @returns Filtered data.
#' @name filter_
NULL

#' @title Map functions
#'
#' @description
#' Functions to map IDs.
#' @family map_
#' @inheritParams main
#' @inheritParams KGExplorer::map_ontology_terms
#' @returns Mapped data.
#' @name map_
NULL


#' @title Make functions
#'
#' @description
#' Functions to make complex R objects.
#' @param as R object class to return output as.
#' @param phenotype_to_genes Output of
#' \link{load_phenotype_to_genes} mapping phenotypes
#' to gene annotations.
#' @param ancestor The ancestor to get all descendants of. If \code{NULL},
#' returns the entirely ontology.
#' @family make_
#' @inheritParams main
#' @inheritParams KGExplorer::map_colors
#' @returns R object.
#' @name make_
NULL
