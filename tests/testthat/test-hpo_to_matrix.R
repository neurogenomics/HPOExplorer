test_that("hpo_to_matrix works", {


  phenos <- HPOExplorer::example_phenos()
  X <- hpo_to_matrix(terms = phenos$HPO_ID)
  testthat::expect_true(methods::is(X,"dgCMatrix"))
  testthat::expect_gte(nrow(X),4204)
  ## Two phenotypes don't have gene annotations
  testthat::expect_equal(ncol(X),nrow(phenos)-2)


  X <- hpo_to_matrix(terms = phenos$HPO_ID,
                     formula = "Gene ~ ID")
  testthat::expect_true(methods::is(X,"dgCMatrix"))
  testthat::expect_gte(nrow(X),4204)
  ## Two phenotypes don't have gene annotations
  testthat::expect_equal(ncol(X),nrow(phenos)-2)


  Xcor <- hpo_to_matrix(terms = phenos$HPO_ID, run_cor = TRUE)
  testthat::expect_equal(dim(Xcor), rep(nrow(phenos)-2,2))
})
