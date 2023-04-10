mondo_to_matrix <- function(species=c("Homo sapiens")){

  subject_taxon_label <- evidence_score <- evidence <- object_definition <-
    object <- NULL;

  #### Prepare data ####
  dat <- data.table::fread(paste0(
    "https://data.monarchinitiative.org/latest/tsv/",
    "all_associations/gene_disease.all.tsv.gz"
  ))
  dat[,evidence_score:=sapply(evidence,
                              function(x){length(strsplit(x,"|")[[1]])})]
  dat <- dat[subject_taxon_label %in% species]
  mondo <- get_mondo()
  dat[,object_definition:=mondo$def[object]]
  #### Make matrix ####
  X_dt <- data.table::dcast.data.table(data = dat,
                                       formula = "subject_label ~ object",
                                       value.var = "evidence_score",
                                       fun.aggregate = sum,
                                       fill = 0)
  X <- as.matrix(X_dt[,-1], rownames = X_dt[[1]]) |>
    methods::as("sparseMatrix")
  #### Make col meta.data ####
  col_data <- dat[,c("subject_taxon",
                      "subject_taxon_label",
                      "object",
                      "object_label",
                      "object_definition")] |>
    unique() |>
    data.frame()
  rownames(col_data) <- col_data$object

  # obj <- scNLP::seurat_pipeline(obj = X,
  #                               meta.data = col_data,
  #                               vars.to.regress = "nFeature_RNA",
  #                               nfeatures = NULL)
  # tfidf_plt <- scNLP::plot_tfidf(object = obj,
  #                                label_var = "object_definition")
  # dp <- Seurat::DimPlot(obj, group.by = "object_label") + Seurat::NoLegend()
  # plotly::ggplotly(dp)
  # fp <- Seurat::FeaturePlot(obj, features = "n_genes")

  return(list(X=X,
              col_data=col_data,
              row_data=dat))

}
