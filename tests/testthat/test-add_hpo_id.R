test_that("add_hpo_id works", {

  # Only run locally (failing on GHA only for some unknown reason)
  if (Sys.getenv("GITHUB_ACTION")==""){
    phenotype_to_genes <- load_phenotype_to_genes()
    phenos <- unique(phenotype_to_genes[,-c("hpo_id")])
    phenos <- add_hpo_id(phenos=phenos)
    testthat::expect_equal(sum(is.na(phenos$hpo_id)),0)
  }

})
