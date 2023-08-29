test_that("hpo_to_matrix works", {

  phenos <- HPOExplorer:: example_phenos()

  X <- hpo_to_matrix(terms = phenos$hpo_id)
  testthat::expect_true(methods::is(X,"dgCMatrix"))
  testthat::expect_gte(nrow(X),4204)
  ## Two phenotypes don't have gene annotations
  testthat::expect_equal(ncol(X),nrow(phenos))

  X <- hpo_to_matrix(terms = phenos$hpo_id,
                     formula = "gene_symbol ~ hpo_id")
  testthat::expect_true(methods::is(X,"dgCMatrix"))
  testthat::expect_gte(nrow(X),4204)
  ## Two phenotypes don't have gene annotations
  testthat::expect_equal(ncol(X),nrow(phenos))

  Xcor <- hpo_to_matrix(terms = phenos$hpo_id, run_cor = TRUE)
  testthat::expect_equal(dim(Xcor), rep(nrow(phenos),2))
})
