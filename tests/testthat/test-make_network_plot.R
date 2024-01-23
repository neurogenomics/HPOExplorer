test_that("make_network_plot works", {

  #### make_phenos_dataframe ####
  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  testthat::expect_true(methods::is(phenos,"data.table"))
  testthat::expect_equal(nrow(phenos),23)

  #### ggnetwork: interactive ####
  plt <- make_network_plot(phenos = phenos,
                           method="ggnetwork",
                           interactive = TRUE)
  testthat::expect_true(methods::is(plt$data,"data.frame"))
  testthat::expect_true(methods::is(plt$plot,"plotly"))
  #### ggnetwork: static ####
  plt <- make_network_plot(phenos = phenos,
                           method="ggnetwork",
                           interactive = FALSE)
  testthat::expect_true(methods::is(plt$data,"data.frame"))
  testthat::expect_true(methods::is(plt$plot,"gg"))
  #### visnetwork ####
  plt <- make_network_plot(phenos = phenos,
                           method="visnetwork")
  testthat::expect_true(methods::is(plt$data,"tbl_graph"))
  testthat::expect_true(methods::is(plt$plot,"visNetwork"))

})
