test_that("get_gene_lists works", {

  phenotypes <- c("Focal motor seizures","HP:0000002","HP:0000003")

  #### list ####
  gene_list <- get_gene_lists(phenotypes = phenotypes,
                             as_list = TRUE)
  testthat::expect_length(gene_list, length(phenotypes))
  #### data.table ####
  gene_df <- get_gene_lists(phenotypes = phenotypes,
                            as_list = FALSE)
  testthat::expect_equal(length(unique(gene_df$Phenotype)), length(phenotypes))
  testthat::expect_gte(nrow(gene_df),2500)
})
