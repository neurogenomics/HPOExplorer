test_that("get_hpo works", {

  testthat::expect_false("hpo" %in% ls())
  hpo <- get_hpo()
  items <- ls()
  testthat::expect_true("hpo" %in% ls())
  testthat::expect_true(methods::is(hpo,"ontology_DAG"))
})
