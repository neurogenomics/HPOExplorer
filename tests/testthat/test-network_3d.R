test_that("network_3d works", {

  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")
  g <- make_igraph_object(phenos = phenos)
  plt <- network_3d(g=g)

  testthat::expect_true(methods::is(g,"igraph"))
  testthat::expect_length(g,23)
  testthat::expect_true(methods::is(plt,"plotly"))
})
