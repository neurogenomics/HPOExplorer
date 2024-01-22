test_that("as_ascii works", {

  dat <- HPOExplorer:::as_ascii(dat = HPOExplorer::hpo_deaths)
  testthat::expect_true(methods::is(dat,"data.table"))
})
