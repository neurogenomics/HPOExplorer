test_that("add_disease works", {

  phenos <- example_phenos()
  phenos2 <- add_disease(phenos = phenos, add_definitions = TRUE)
  testthat::expect_true(
    all(phenos$hpo_id %in% phenos2$hpo_id)
  )
  testthat::expect_gte(
    nrow(phenos2),7000
  )
})
