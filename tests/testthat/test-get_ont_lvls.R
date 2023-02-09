test_that("get_ont_lvls works", {

  hpo <- get_hpo()
  parents <- unique(hpo$id)[seq_len(2)]
  childs <- unlist(unname(hpo$children[parents]))

  terms1 <- c(parents,childs)
  #### Using only immediate children ####
  lvls1 <- get_ont_lvls(terms = terms1, absolute = TRUE)
  testthat::expect_length(lvls1, length(terms1))
  testthat::expect_equal(min(lvls1),1)
  testthat::expect_equal(max(lvls1),16) ## Increased from 14 to 16 in 2023 version

  #### Using all descendants ####
  terms2 <- ontologyIndex::get_descendants(ontology = hpo,
                                           roots = parents[[2]],
                                           exclude_roots = FALSE)
  lvls2 <- get_ont_lvls(terms = terms2)
  testthat::expect_length(lvls2, length(terms2))
  testthat::expect_equal(min(lvls2),0)
  testthat::expect_equal(max(lvls2),5)

  #### Using relative levels ####
  lvls3 <- get_ont_lvls(terms = terms1, absolute = FALSE)
  testthat::expect_length(lvls3, length(terms1))
  testthat::expect_equal(min(lvls3),0)
  testthat::expect_equal(max(lvls3),1)

  #### Visual confirmation of correct hierarchy ####
  # ontologyPlot::onto_plot(ontology = hpo,
  #                         label = terms1,
  #                         terms = terms1)
  # ontologyPlot::onto_plot(ontology = hpo,
  #                         label = terms2,
  #                         terms = terms2)
})
