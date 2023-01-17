test_that("add_hpo_id works", {

  phenotype_to_genes <- load_phenotype_to_genes()
  phenos <- unique(phenotype_to_genes[,c("ID","Phenotype")])
  phenos2 <- add_hpo_id(phenos=phenos)
  testthat::expect_equal(phenos2$ID, phenos2$HPO_ID)
})
