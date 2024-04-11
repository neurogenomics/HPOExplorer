test_that("add_hpo_id works", {

  phenotype_to_genes <- load_phenotype_to_genes()
  phenos <- unique(phenotype_to_genes[,-c("hpo_id")])
  phenos <- add_hpo_id(phenos=phenos)
  testthat::expect_equal(sum(is.na(phenos$hpo_id)),0)
})
