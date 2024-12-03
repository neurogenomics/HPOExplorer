test_that("filter_descendants works", {

  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  phenos2 <- filter_descendants(phenos = phenos,
                                keep_descendants = "Motor delay")
  testthat::expect_in(nrow(phenos),seq(21, 28))
  testthat::expect_in(nrow(phenos2),seq(7, 13))
})
