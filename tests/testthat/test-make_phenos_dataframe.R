test_that("make_phenos_dataframe works", {


  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay",
                                  add_disease_data = TRUE)
  testthat::expect_gte(nrow(phenos),5000)
  testthat::expect_true(
    all(
      c("disease_id","disease_name","hpo_id","hpo_name","geneCount","definition",
        "disease_characteristic","pheno_freq_name","AgeOfDeath_name") %in% names(phenos)
    )
  )
})
