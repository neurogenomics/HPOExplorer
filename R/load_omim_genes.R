load_omim_genes <- function(verbose=TRUE){

  messager("Loading OMIM genes.",v=verbose)
  #### From enrichr #####
  ## Outdated file
  # dat <- read_enrichr(file = "https://maayanlab.cloud/Enrichr/geneSetLibrary?mode=text&libraryName=OMIM_Expanded")

  #### From Harmonizome ####
  # j <- jsonlite::fromJSON("https://maayanlab.cloud/Harmonizome/api/1.0/dataset/OMIM+Gene-Disease+Associations")
  dat <- load_harmonizome_genes(dataset = "omim")
  return(dat)
}
