test_that("gpt_annot_codify works", {

  coded <- gpt_annot_codify()
  testthat::expect_true(
    all(
      c("annot","annot_coded","annot_weighted") %in% names(coded)
    )
  )
})
