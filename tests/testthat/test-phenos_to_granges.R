test_that("phenos_to_granges works", {

  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  grl <- phenos_to_granges(phenos = phenos)
  testthat::expect_true(methods::is(grl,"GRangesList"))
  testthat::expect_length(grl,length(unique(phenos$hpo_id)))

  gr <- phenos_to_granges(phenos = phenos,
                          split.field = NULL)
  testthat::expect_true(methods::is(gr,"GRanges"))
  testthat::expect_length(unique(gr$hpo_id),
                          length(unique(phenos$hpo_id)))
})
