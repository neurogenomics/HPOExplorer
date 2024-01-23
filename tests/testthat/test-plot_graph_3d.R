test_that("plot_graph_3d works", {

  phenos <- make_phenos_dataframe(ancestor = "Neurodevelopmental delay")[seq(1,100),]
  g <- make_igraph_object(phenos = phenos)
  plt <- suppressWarnings(
    KGExplorer::plot_graph_3d(g=g, show_plot = FALSE)
  )
  testthat::expect_true(methods::is(g,"igraph"))
  testthat::expect_length(g,23)
  testthat::expect_true(methods::is(plt,"plotly"))
})
