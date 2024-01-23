test_that("filter_descendants works", {

  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  phenos2 <- filter_descendants(phenos = phenos,
                                keep_descendants = "Motor delay")
  testthat::expect_equal(nrow(phenos),23)
  testthat::expect_equal(nrow(phenos2),9)
})
