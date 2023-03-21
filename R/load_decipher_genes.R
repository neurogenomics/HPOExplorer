load_decipher_genes <- function(verbose=TRUE){

  requireNamespace("R.utils")
  disease_name <- DiseaseName <- ID <- `DatabaseID` <- NULL;

  messager("Loading DECIPHER genes.",v=verbose)
  #### UCSC bigbed file ####
  # "https://hgdownload.soe.ucsc.edu/gbdb/hg38/"

  #### EBI annotations file ####
  dat <- data.table::fread(
    "https://www.ebi.ac.uk/gene2phenotype/downloads/DDG2P.csv.gz")
  names(dat) <- gsub(" ","_",names(dat))
  dat[,disease_name:=tolower(disease_name)]
  ## Bizarrely, the do not provide their disease IDs in their own database.
  ## Have to instead infer from the HPO data
  d <- load_phenotype_to_genes("phenotype.hpoa")
  d <- d[grepl("DECIPHER",d$DatabaseID),]
  d[,ID:=DatabaseID][,DiseaseName:=tolower(DiseaseName)]
  dat <- data.table::merge.data.table(dat,
                               d[,c("ID","DiseaseName")],
                               by.x = "disease_name",
                               by.y = "DiseaseName",
                               all.x = TRUE)
  # sum(!is.na(dat$ID))
  return(dat)
}
