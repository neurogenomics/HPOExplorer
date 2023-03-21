#' Plot N phenotypes per branch
#'
#' This plots the number of phenotypes per HPO branch and colours selected
#' branches to highlight them. This is not using any EWCE results, it is simply
#' using the raw HPO data to get an overview of how many phenotypes there are.
#'
#' Default value for the background_branches argument is the child terms of
#' phenotypic abnormality. Essentially this gives the main branches of the HPO.
#'
#' Note that the highlighted branches must be also present in the background
#' branches.
#' @param highlighted_branches Names of branches you want
#' to highlight \<vector\<string\>\>
#' @param background_branches HPO Ids of all branches to be shown
#'  (including highlighted) \<vector\<string\>\>
#' @inheritParams make_phenos_dataframe
#' @returns ggplot object
#'
#' @export
#' @import ggplot2
#' @importFrom ontologyIndex get_descendants
#' @examples
#' ## Selecting child terms of
#' ## "Abnormality of the nervous system" as background branches
#' plt <-  per_branch_plot(
#'     highlighted_branches = "Abnormality of nervous system physiology",
#'     ancestor = "Abnormality of the nervous system")
per_branch_plot <- function(highlighted_branches,
                            ancestor,
                            hpo = get_hpo(),
                            background_branches = hpo$children[
                              hpo$id[match(ancestor, hpo$name)]
                            ][[1]],
                            phenotype_to_genes = load_phenotype_to_genes()) {

  # templateR:::source_all()
  # devoptera::args2vars(per_branch_plot)

  requireNamespace("ggplot2")
  n_phenos <- branch <- target <- NULL;

  highlighted_branches_ids <- hpo$id[match(highlighted_branches, hpo$name)]
  #### Count phenotypes per branch ####
  phenos_per_branch <- lapply(background_branches, function(b){
    n <- length(ontologyIndex::get_descendants(ontology = hpo,
                                               roots =  b))
    if (b %in% highlighted_branches_ids) {
      target_branch <- "target"
    } else {
      target_branch <- "other"
    }
    data.table::data.table("branch" = hpo$name[b],
                           "n_phenos" = n,
                           "target" = target_branch)
  }) |> data.table::rbindlist()
  data.table::setkeyv(phenos_per_branch, "n_phenos")
  phenos_per_branch$branch <- factor(x = phenos_per_branch$branch,
                                     levels = unique(phenos_per_branch$branch),
                                     ordered = TRUE)
  plt <- ggplot(phenos_per_branch,
                aes_string(x = "n_phenos", y = "branch",
                    color = "target", fill = "target")) +
    geom_col(width = .5) +
    labs(x="Descendants (n)",
         y="Phenotype",
         fill="Group",
         color="Group") +
    theme_bw()
  return(plt)
}
