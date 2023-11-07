test_that("hpo_api works", {

  dat <- hpo_api(hpo_id="HP:0011420", type="diseases")
  testthat::expect_true(
    all(c("diseases","diseaseCount","offset","max" ) %in% names(dat))
  )
  testthat::expect_true(
    methods::is(dat$diseases,"data.table")
  )
})
