get_gene_lengths <- function(gene_list,
                             keep_seqnames = c(seq_len(22),"X","Y"),
                             ensembl_version = 75,
                             verbose = TRUE){

  requireNamespace("ensembldb")
  requireNamespace("AnnotationFilter")
  messager("Gathering gene metadata",v=verbose)
  keep_seqnames <- unique(
    c(tolower(keep_seqnames),
      paste0("chr",keep_seqnames),
      keep_seqnames)
  )
  #### Get gene reference database ####
  if(ensembl_version==75){
    #### Outdated ref ####
    requireNamespace("EnsDb.Hsapiens.v75")
    txdb <- EnsDb.Hsapiens.v75::EnsDb.Hsapiens.v75
  } else {
    #### Updated ref ####
    requireNamespace("AnnotationHub")
    hub <- AnnotationHub::AnnotationHub()
    q <- AnnotationHub::query(hub, c("EnsDb",ensembl_version,"sapiens"))
    txdb <- q[[length(q)]]
  }
  tx_gr <- ensembldb::genes(
    txdb,
    columns = c(ensembldb::listColumns(txdb, "gene"), "entrezid"),
    filter=AnnotationFilter::AnnotationFilterList(
      AnnotationFilter::SymbolFilter(value = unique(gene_list)),
      AnnotationFilter::SeqNameFilter(value = keep_seqnames)
    ))
  return(tx_gr)
}
