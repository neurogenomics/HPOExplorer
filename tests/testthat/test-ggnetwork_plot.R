test_that("ggnetwork_plot works", {

  #### make_phenos_dataframe ####
  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  testthat::expect_true(methods::is(phenos,"data.table"))
  testthat::expect_equal(nrow(phenos),23)

  #### make_network_object ####
  phenoNet <- make_network_object(phenos = phenos,
                                  colour_var = "ontLvl_geneCount_ratio")
  testthat::expect_true(methods::is(phenoNet,"data.frame"))
  testthat::expect_equal(nrow(phenoNet),45)

  #### ggnetwork_plot ####
  plt <- ggnetwork_plot(phenoNet = phenoNet,
                        colour_var = "ontLvl_geneCount_ratio")
  testthat::expect_true(methods::is(plt,"plotly"))
  plt <- ggnetwork_plot(phenoNet = phenoNet,
                        colour_var = "ontLvl_geneCount_ratio",
                        interactive = FALSE)
  testthat::expect_true(methods::is(plt,"gg"))

})
