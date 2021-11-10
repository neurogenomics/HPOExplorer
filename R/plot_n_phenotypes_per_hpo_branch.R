#' Plot n phenotypes per brach - Highlight selected
#'
#' This plots the number of phenotypes per HPO branch and colours selected
#' branches to highlight them. This is not using any EWCE results, it is simply
#' using the raw HPO data to get an overview of how many phenotypes there are.
#'
#' Uses wesanderson color palette choose from `BottleRocket1, BottleRocket2,`
#' `Rushmore1, Royal1, Royal2, Zissou1, Darjeeling1, Darjeeling2, Chevalier1,`
#' `FantasticFox1 , Moonrise1, Moonrise2, Moonrise3, Cavalcanti1, GrandBudapest1,`
#' `GrandBudapest2, IsleofDogs1, IsleofDogs2`
#'
#' Default value for the background_branches argument is the child terms of
#' phenotypic abnormality. Essentially this gives the main branches of the HPO.
#'
#' Note that the highlighted branches must be also present in the background
#' branches.
#'
#' @param highlighted_branches Names of branches you want
#' to highlight \<vector\<string\>\>
#' @param background_branches HPO Ids of all branches to be shown
#'  (including highlighted) \<vector\<string\>\>
#' @param wes_anderson_palette Name of desired color palette,
#'  see options above \<string\>
#' @param phenotype_to_genes The phenotype_to_genes file from
#' HPO giving phenotype gene lists \<data.frame\>
#' @param hpo The HPO data object from ontologyIndex package.
#' @import ggplot2
#' @examples
#' \dontrun{
#' ## Selecting child terms of
#' ## "Abnormality of the nervous system" as background branches"
#' background_branches <- hpo$children[
#'     hpo$id[match("Abnormality of the nervous system", hpo$name)]
#' ][[1]]
#' ## Highlighting "Abnormality of ganglion" branch in the plot
#' highlighted_branches <- c("Abnormality of nervous system physiology")
#' ## create the plot
#' plot_n_phenotypes_per_branch_hpo(
#'     highlighted_branches = highlighted_branches,
#'     background_branches = background_branches,
#'     wes_anderson_palette = "Moonrise3",
#'     phenotype_to_genes = phenotype_to_genes
#' )
#' }
#' @export
plot_n_phenotypes_per_branch_hpo <- function(phenotype_to_genes,
                                             hpo,
                                             highlighted_branches =
                                                 c(
                                                     "Abnormality of the nervous system",
                                                     "Abnormality of the cardiovascular system",
                                                     "Abnormality of the immune system"
                                                 ),
                                             background_branches = hpo$children["HP:0000118"][[1]],
                                             wes_anderson_palette = "Moonrise3") {
    color_pal <- wesanderson::wes_palette(wes_anderson_palette, 2)
    highlighted_branches_ids <- hpo$id[match(highlighted_branches, hpo$name)]
    phenos_per_branch <- data.frame()
    for (b in background_branches) {
        n <- length(ontologyIndex::get_descendants(hpo, b))
        if (b %in% highlighted_branches_ids) {
            target_branch <- "target"
        } else {
            target_branch <- "Other"
        }
        phenos_per_branch <- rbind(phenos_per_branch, data.frame("branch" = hpo$name[b], "n_phenos" = n, "target" = target_branch))
    }
    phenos_per_branch$branch <- stats::reorder(phenos_per_branch$branch, phenos_per_branch$n_phenos)
    phenos_per_branch_plt <- ggplot(phenos_per_branch, aes(x = n_phenos, y = branch, color = target, fill = target)) +
        geom_segment(mapping = aes(xend = 0, yend = branch), size = 3) +
        xlab("Descendants (n)") +
        ylab(element_blank()) +
        scale_color_manual(values = color_pal) +
        theme(
            axis.line.x = element_blank(), panel.background = element_blank(), panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(), axis.line.y = element_line(color = "black"),
            axis.ticks.x = element_blank(), axis.text.x = element_blank(), legend.position = "none"
        )
    return(phenos_per_branch_plt)
}
