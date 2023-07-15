test_that("add_gene_frequency works", {

  phenotype_to_genes <- load_phenotype_to_genes()[seq_len(1000),]
  phenos2 <- add_gene_frequency(phenotype_to_genes = phenotype_to_genes)
  cols <- c("gene_freq","gene_freq_name",
            "gene_freq_min","gene_freq_max","gene_freq_mean")
  testthat::expect_false(all(cols %in% names(phenotype_to_genes)))
  testthat::expect_true(all(cols %in% names(phenos2)))
})
