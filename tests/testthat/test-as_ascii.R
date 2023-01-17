test_that("as_ascii works", {

  dt <- HPOExplorer:::as_ascii(dt = HPOExplorer::hpo_meta)
  testthat::expect_true(methods::is(dt,"data.table"))
})
