test_that("make_tiers works", {

  terms <- get_hpo()@terms[seq(100)]
  tiers <- make_tiers(terms = terms)
  testthat::expect_true(all(sort(unique(tiers))==paste0("Tier",seq(4))))
})
