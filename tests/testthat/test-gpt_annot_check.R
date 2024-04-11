test_that("gpt_annot_check works", {

  checks <- gpt_annot_check()
  testthat::expect_true(all(
    c("annot","annot_mean","consistency_count","annot_check","checkable_rate",
      "checkable_count","true_pos_rate","false_neg_rate") %in% names(checks)
  ))
})
