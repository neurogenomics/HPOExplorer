test_that("add_info_content works", {

  phenos <- example_phenos()
  phenos2 <- add_info_content(phenos = phenos)
  testthat::expect_true(min(phenos2$info_content)==0)
  testthat::expect_true(max(phenos2$info_content)>2)
})
