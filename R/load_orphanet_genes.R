load_orphanet_genes <- function(verbose=TRUE){

  Orphanet_ID <- NULL;
  messager("Loading Orphanet genes.",v=verbose)
  #   URL <- "https://hgdownload.soe.ucsc.edu/gbdb/hg38/bbi/orphanet/orphadata.bb"
  #   bb <- rtracklayer::import(URL)

  #### From Orphanet XML file ####
  # (they don't provide the data in any easy-to-use format)
  # xml <- xml2::read_xml("https://www.orphadata.com/data/xml/en_product6.xml")
  # xml_list <- xml2::as_list(xml)
  # df <- lapply(xml_list$JDBOR$DisorderList, function(x){
  #   data.table::data.table(
  #     t(unlist(x[names(x)!="DisorderGeneAssociationList"])),
  #     t(unlist(x$DisorderGeneAssociationList$DisorderGeneAssociation$Gene[
  #       c("Symbol")
  #     ])),
  #     t(unlist(x$DisorderGeneAssociationList$DisorderGeneAssociation[
  #       c("SourceOfValidation","DisorderGeneAssociationType","DisorderGeneAssociationStatus")
  #     ]))
  #     )
  # }) |> data.table::rbindlist(fill = TRUE)

  #### From enrichrR ####
  dat <- read_enrichr(file = "https://maayanlab.cloud/Enrichr/geneSetLibrary?mode=text&libraryName=Orphanet_Augmented_2021")
  splt <- cbind(
    (
      data.table::as.data.table(
        stringr::str_split(dat$term,"ORPHA:",simplify = TRUE)) |>
        `colnames<-`(c("phenotype","Orphanet_ID"))
    )[,Orphanet_ID:=paste0("ORPHA:",Orphanet_ID)],
    gene=dat$gene
  )
  return(splt)
}
