test_that("subset_descendants works", {

  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  phenos2 <- subset_descendants(phenos = phenos,
                                ancestor = "Motor delay")
  testthat::expect_equal(nrow(phenos),17)
  testthat::expect_equal(nrow(phenos2),3)
})
