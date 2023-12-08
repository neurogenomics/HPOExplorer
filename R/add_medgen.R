add_medgen <- function(phenos,
                       id_col = "hpo_id",
                       to=""){
  source_id <- MONDO_ID<-definition<-DEF<-NULL;

  URL <- "https://ftp.ncbi.nlm.nih.gov/pub/medgen/"
  def <- data.table::fread(paste0(URL,"csv/MGDEF.csv.gz"), fill = TRUE)
  map <- data.table::fread(paste0(URL,"MedGenIDMappings.txt.gz"),
                           header = TRUE,
                           key = "source_id")
  data.table::setnames(map,"#CUI","CUI")
  # sort(table(map$source), decreasing = TRUE)
  #### Conform disease_id to MedGen format ####
  phenos <- HPOExplorer::make_phenos_dataframe(add_disease_data = FALSE)
  phenos <- HPOExplorer::add_mondo(phenos,
                                   id_col = id_col)
  phenos[,source_id:=get(id_col)]
  phenos <- phenos[!is.na(get(id_col))]
  if(id_col=="disease_id"){
    phenos[,source_id:=gsub("OMIM:","",source_id)]
    phenos[,source_id:=gsub("ORPHANET:","Orphanet_",source_id)]
    phenos[,source_id:=ifelse(source_id %in% unique(map$source_id), source_id, MONDO_ID)]
  }
  mapped <- data.table::merge.data.table(
    phenos,map,
    by="source_id",
    all.x = TRUE
  ) |>
    data.table::merge.data.table(def,
                                 by=c("CUI","source"),
                                 all.x = TRUE)
  data.table::uniqueN(phenos[!is.na(definition)]$hpo_id)
  data.table::uniqueN(grep("^HP:",map$source_id, value = TRUE))
  data.table::uniqueN(def[source=="HPO"]$CUI)
  data.table::uniqueN(mapped[!is.na(DEF)]$hpo_id)
  HPOExplorer:::report_missing(mapped,
                               id_col = "disease_id",
                               report_col = "CUI")

  ### CONCLUSIONS ####
  # Medgen has HPO-CUI mappings for 16569 HPO IDs
  # However, their definitions data only has definitions for 22 HPO IDs max
  # ....not very useful.
}
