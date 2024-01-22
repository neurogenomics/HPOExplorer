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
#' @examples
#' plt <-  per_branch_plot(
#'     highlighted_branches = "Abnormality of nervous system physiology",
#'     ancestor = "Abnormality of the nervous system")
per_branch_plot <- function(highlighted_branches,
                            ancestor,
                            hpo = get_hpo(),
                            background_branches = simona::dag_children(
                              hpo,
                              term = map_phenotypes(terms = ancestor,
                                                    hpo = hpo,
                                                    to = "id")
                              ),
                            phenotype_to_genes = load_phenotype_to_genes()) {
  requireNamespace("ggplot2")

  highlighted_branches_ids <- map_phenotypes(terms = highlighted_branches,
                                             hpo = hpo,
                                             to = "id",
                                             keep_order = FALSE)
  #### Count phenotypes per branch ####
  phenos_per_branch <- lapply(background_branches, function(b){
    n <- length(simona::dag_offspring(hpo,term =  b))
    if (b %in% highlighted_branches_ids) {
      target_branch <- "target"
    } else {
      target_branch <- "other"
    }
    data.table::data.table("branch_id" = b,
                           "branch_name"=map_phenotypes(terms = b,
                                                        hpo = hpo,
                                                        to = "name"),
                           "n_phenos" = n,
                           "target" = target_branch)
  }) |> data.table::rbindlist()
  data.table::setkeyv(phenos_per_branch, "n_phenos")
  phenos_per_branch$branch_name <- factor(
    x = phenos_per_branch$branch_name,
    levels = unique(phenos_per_branch$branch_name),
    ordered = TRUE)
  #### Plot ####
  plt <- ggplot(phenos_per_branch,
                aes(x = !!sym("n_phenos"),
                    y = !!sym("branch_name"),
                    color = !!sym("target"),
                    fill = !!sym("target")
                    )
                )+
    geom_col(width = .5) +
    labs(x="Descendants (n)",
         y="hpo_name",
         fill="Group",
         color="Group") +
    theme_bw()
  #### Return ####
  return(plt)
}
