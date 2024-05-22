test_that("gpt_annot_plot_branches works", {

  out <- gpt_annot_plot_branches()
  testthat::expect_true(methods::is(out$plot,"gg"))
  testthat::expect_true(methods::is(out$dat,"data.table"))
  testthat::expect_true(length(unique(out$dat$ancestor_name))<100)
})
