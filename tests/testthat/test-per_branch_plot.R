test_that("per_branch_plot works", {

  ## Selecting child terms of
  ## "Abnormality of the nervous system" as background branches"
  plt <-  per_branch_plot(
      highlighted_branches = "Abnormality of nervous system physiology",
      ancestor = "Abnormality of the nervous system")
  testthat::expect_true(methods::is(plt,"gg"))
})
