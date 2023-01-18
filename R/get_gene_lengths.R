get_gene_lengths <- function(gene_list,
                             keep_seqnames = c(seq_len(22),"X","Y"),
                             verbose = TRUE){

  requireNamespace("EnsDb.Hsapiens.v75")
  requireNamespace("ensembldb")
  requireNamespace("AnnotationFilter")
  messager("Gathering gene metadata",v=verbose)
  keep_seqnames <- unique(
    c(tolower(keep_seqnames),
      paste0("chr",keep_seqnames),
      keep_seqnames)
  )
  txdb <- EnsDb.Hsapiens.v75::EnsDb.Hsapiens.v75
  tx_gr <- ensembldb::genes(txdb,
                            columns = c(ensembldb::listColumns(txdb, "gene"), "entrezid"),
                            filter=AnnotationFilter::AnnotationFilterList(
                              AnnotationFilter::SymbolFilter(value = unique(gene_list)),
                              AnnotationFilter::SeqNameFilter(value = keep_seqnames)
                            ))
  return(tx_gr)
}
