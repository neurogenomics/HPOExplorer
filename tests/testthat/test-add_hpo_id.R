test_that("add_hpo_id works", {

  phenotype_to_genes <- load_phenotype_to_genes()
  phenos <- unique(phenotype_to_genes[,-c("hpo_id")])
  phenos2 <- add_hpo_id(phenos=phenos)

  ## Several terms were omitted from later versions of the HPO
  ## due to becoming obsolete.
  testthat::expect_lte(sum(phenos2$hpo_id!=phenos2$hpo_id), 4)
  mismatched_phenos <- map_phenotypes(
    terms = phenos2$ID[phenos2$hpo_id!=phenos2$hpo_id]
  )
  testthat::expect_true(
    all(grepl("^obsolete",mismatched_phenos, ignore.case = TRUE))
  )
})
