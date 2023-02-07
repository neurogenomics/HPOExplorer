test_that("add_pheno_frequency works", {

  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  phenos2 <- add_pheno_frequency(phenos = phenos)
  cols <- c("pheno_freq_min","pheno_freq_max","pheno_freq_mean")
  testthat::expect_false(all(cols %in% names(phenos)))
  testthat::expect_true(all(cols %in% names(phenos2)))
})
