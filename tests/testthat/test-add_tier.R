test_that("add_tier works", {

  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  phenos2 <- add_tier(phenos = phenos)
  cols <- c("tier","tier_auto")
  testthat::expect_false(all(cols %in% names(phenos)))
  testthat::expect_true(all(cols %in% names(phenos2)))
})
