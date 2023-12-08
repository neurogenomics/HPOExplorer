map_upheno_nn <- function(){

  #### Find nearest neighbors for each HPO term in each non-human ontology ####
  Xnonhuman <- data.table::dcast.data.table(
    genes_nonhuman,
    formula = ortholog_hgnc_label ~ alt_id,
    fun.aggregate = length,
  ) |> scKirby::to_sparse()
  Xhuman <- data.table::dcast.data.table(
    genes_human,
    formula = hgnc_label ~ hpo_id,
    fun.aggregate = length,
  ) |> scKirby::to_sparse()
  X <- Seurat::RowMergeSparseMatrices(mat1 = Xhuman, Xnonhuman)
  obj <- scKirby::process_seurat(
    list(data=list(genes=X),
         obs=data.frame(genes_map,
                        row.names = genes_map$object)
    ),
    nfeatures = 4600
  )

  dbs <- stringr::str_split(colnames(Xnonhuman),"[:]",simplify = TRUE)[,1] |>
    unique()
  BPPARAM <- BiocParallel::MulticoreParam(10,progressbar = TRUE)
  hpo_ids <- grep("^HP:",rownames(obj@graphs$RNA_snn), value = TRUE)
  nei_mat <- BiocParallel::bplapply(
    BPPARAM = BPPARAM,
    X = stats::setNames(hpo_ids,hpo_ids),
    FUN = function(hpo_id){
      lapply(dbs,
             function(db){
               obj@graphs$RNA_snn[
                 hpo_id,
                 grepl(db,colnames(obj@graphs$RNA_snn))] |>
                 sort() |>
                 tail(10)
             })
    })
  dt <- lapply(nei_mat,
               function(x) {
                 lapply(x,
                        function(y){
                          data.table::as.data.table(data.frame(val=y),
                                                    keep.rownames = "alt_id")
                        }) |>
                   data.table::rbindlist()
               }) |>
    data.table::rbindlist(idcol = "hpo_id")

  dt_map <- genes_map[dt[val>.5,], on=c("object"="alt_id"), allow.cartesian = TRUE]
  dt_map <- genes_map[dt_map, on=c("object"="hpo_id"), allow.cartesian = TRUE]

  # View(dt_map[val>.95])
  # o = order(obj@graphs$RNA_snn, decreasing=TRUE)[1:10]
  # mm <- MatrixModels::glm4()

  # res <- phenomix::iterate_lm(xmat = Xhuman, ymat = Xnonhuman, workers = 10)
  # orthogene:::sparsity(Xg)
  # Xc <- fastcluster::hclust(dist(Xg))

}
