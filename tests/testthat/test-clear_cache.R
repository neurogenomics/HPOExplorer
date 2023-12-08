test_that("clear_cache works", {

  dat <- load_phenotype_to_genes()
  f <- file.path(tools::R_user_dir("HPOExplorer",
                                   which="cache"),
                 "data",
                 "phenotype_to_genes.rds")
  testthat::expect_true(file.exists(f))
  clear_cache()
  testthat::expect_false(file.exists(f))
})
