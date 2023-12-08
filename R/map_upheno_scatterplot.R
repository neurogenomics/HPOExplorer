map_upheno_scatterplot <- function(plot_dat){

  #### Check if there's a relationship between phenotype mapping scores
  # and number of shared genes ####
  ggplot(plot_dat,
         aes(x=(n_genes_intersect/n_genes_db1),
             y=equivalence_score)) +
    geom_point() +
    facet_grid(rows = "subject_taxon_label2") +
    geom_smooth()
}
