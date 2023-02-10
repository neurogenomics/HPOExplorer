test_that("add_hpo_id works", {

  phenotype_to_genes <- load_phenotype_to_genes()
  phenos <- unique(phenotype_to_genes[,c("ID","Phenotype")])
  phenos2 <- add_hpo_id(phenos=phenos)

  ## Several terms were omitted from later versions of the HPO
  ## due to becoming obsolete.
  testthat::expect_lte(sum(phenos2$ID!=phenos2$HPO_ID), 4)
  mismatched_phenos <- harmonise_phenotypes(
    phenotypes = phenos2$ID[phenos2$ID!=phenos2$HPO_ID]
  )
  testthat::expect_true(
    all(grepl("^obsolete",mismatched_phenos, ignore.case = TRUE))
  )
})
