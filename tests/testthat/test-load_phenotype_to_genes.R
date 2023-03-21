test_that("load_phenotype_to_genes works", {

  p2g <- load_phenotype_to_genes()
  testthat::expect_gte(nrow(p2g),968116)
  testthat::expect_gte(length(unique(p2g$HPO_ID)),9677)

  g2p <- load_phenotype_to_genes(filename = "genes_to_phenotype.txt")
  testthat::expect_gte(nrow(g2p),268056)
  testthat::expect_gte(length(unique(g2p$HPO_ID)),9298)
})
