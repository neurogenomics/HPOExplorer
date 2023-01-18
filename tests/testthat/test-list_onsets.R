test_that("multiplication works", {

  onsets <- list_onsets()
  testthat::expect_length(onsets,11)
})
