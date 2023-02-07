test_that("assign_tiers works", {

  terms <- get_hpo()$id[seq_len(10)]
  tiers <- assign_tiers(terms = terms)
  testthat::expect_true(all(sort(unique(tiers))==paste0("Tier",seq_len(4))))
})
