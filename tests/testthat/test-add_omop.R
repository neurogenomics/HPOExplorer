test_that("add_omop works", {

  #### Using hpo_id ####
  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  phenos2 <- add_omop(phenos = phenos,
                      input_col = "hpo_id")
  testthat::expect_true(all(!is.na(phenos2$OMOP_ID)))
  testthat::expect_true(all(!is.na(phenos2$OMOP_NAME)))

  #### Using disease_id ####
  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay",
                                  add_disease_data = TRUE)
  phenos2 <- add_omop(phenos = phenos,
                      input_col = "disease_id")
  testthat::expect_gte(sum(!is.na(phenos2$OMOP_ID)),1200)
  testthat::expect_gte(sum(!is.na(phenos2$OMOP_NAME)),1200)
})
