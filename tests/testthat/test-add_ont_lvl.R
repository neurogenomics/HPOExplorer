test_that("add_ont_lvl works", {

  hp <- get_hpo()
  phenos <- data.table::data.table(hpo_id=hp@terms[1:10])
  #### Absolute ####
  phenos2 <- add_ont_lvl(phenos = data.table::copy(phenos))
  cols <- c("ontLvl")
  testthat::expect_false(all(cols %in% names(phenos)))
  testthat::expect_true(all(cols %in% names(phenos2)))
  #### Relative ####
  phenos3 <- add_ont_lvl(phenos = data.table::copy(phenos),
                         absolute = FALSE)
  cols <- c("ontLvl_relative")
  testthat::expect_false(all(cols %in% names(phenos)))
  testthat::expect_true(all(cols %in% names(phenos3)))
})
