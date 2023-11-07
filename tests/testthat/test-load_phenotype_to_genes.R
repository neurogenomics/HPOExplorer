test_that("load_phenotype_to_genes works", {

  p2g <- load_phenotype_to_genes()
  testthat::expect_gte(nrow(p2g),957881)
  testthat::expect_gte(length(unique(p2g$hpo_id)),9677)

  g2p <- load_phenotype_to_genes(file = "genes_to_phenotype.txt")
  testthat::expect_gte(nrow(g2p),268056)
  testthat::expect_gte(length(unique(g2p$hpo_id)),9298)

  ## Check for version attribute
  testthat::expect_true(is.character(attr(p2g,"version")))
  testthat::expect_true(is.character(attr(g2p,"version")))


  ## Check again using the cached data
  p2g <- load_phenotype_to_genes()
  g2p <- load_phenotype_to_genes(file = "genes_to_phenotype.txt")
  testthat::expect_true(is.character(attr(p2g,"version")))
  testthat::expect_true(is.character(attr(g2p,"version")))
})
