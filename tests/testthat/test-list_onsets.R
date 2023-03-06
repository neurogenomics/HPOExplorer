test_that("list_onsets works", {

  onsets <- list_onsets()
  testthat::expect_length(onsets,12)

  onsets <- list_onsets(exclude = c("Antenatal","Fetal"),
                        as_hpo_ids = FALSE,
                        include_na = FALSE)
  testthat::expect_length(onsets,9)
})
