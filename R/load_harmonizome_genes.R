load_harmonizome_genes <- function(dataset){
  # dataset <- c("omim","clinvar")
  dataset <- tolower(dataset[1])
  baseurl <- paste0(
    "https://maayanlab.cloud/static/hdfs/harmonizome/data/",dataset
  )
  genes <- data.table::fread(paste0(baseurl,"/gene_list_terms.txt.gz"))
  terms <- data.table::fread(paste0(baseurl,"/attribute_list_entries.txt.gz"))
  dat <- data.table::merge.data.table(terms, genes)
  return(dat)
}
