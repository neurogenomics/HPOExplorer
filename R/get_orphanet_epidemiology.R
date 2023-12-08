get_orphanet_epidemiology <- function(agg_by=c("MONDO_ID","id","Name"),
                                      include_mondo=TRUE){
  # https://www.orphadata.com/epidemiology/
  # tmp <- tempfile(fileext = ".xml")
  # download.file("https://www.orphadata.com/data/xml/en_product9_prev.xml",
  #               destfile = tmp)
  # xml <- rvest::read_html(tmp)

  # xml <- xml2::read_xml(tmp)
  # xmlconvert::xml_to_df(xml, records.xpath = "/html")
  #   xmls <- xml |>
  #     rvest::html_nodes("Disorder") |>
  #     # xml2::xml_find_all(".//Disorder") |>
  #     xml2::as_list()# |>
  #     tibble::as_tibble(xmls[[1]]) |>
  #     tidyr::unnest_longer(col=c(OrphaCode,ExpertLink,
  #                                Name,DisorderType,DisorderGroup), simplify = TRUE) |>
  #     tidyr::unnest_wider(col=PrevalenceList) |>
  #     tidyr::unnest_longer(col = c(Source,PrevalenceType,PrevalenceQualification,ValMoy))
  #
  #
  #   nodes <- xml2::xml_find_all(xml, ".//Disorder")
  #   ## Preview structure
  #   nodes[1]|> xml2::html_structure()
  #     # xml2::xml_path()|>
  #     # xml2::xml_text()
  #
  #   ### Convert each node to a flattened data.table
  #   xml2::xml_find_all(nodes[1:10], ".//Prevalence") |>
  #     xml2::as_list() |>
  #     purrr::flatten() |>
  #     data.table::as.data.table()# |>
  # data.table::transpose()


  mean_prevalence <- Prevalence.ValMoy <- prevalence_denominator <- MONDO_ID <-
    NULL;
  ## Open in Excel and convert to CSV first ##
  path <- system.file("extdata", "orphanet_epidemiology.csv.gz",
                      package = "HPOExplorer")
  d <- data.table::fread(path)
  #### Fix column names ####
  names(d) <- trimws(whitespace = "[.]",
                     gsub("[.]+",".",
                          gsub("/|#",".",
                               gsub(paste("/DisorderList",
                                          "/Disorder",
                                          "/PrevalenceList",
                                          sep = "|"),
                                    "",
                                    names(d)
                               )
                          )
                     )
  ) |> `names<-`(names(d))
  #### Prepare numeric prevalence data ####
  d[,prevalence_numerator:=`Prevalence.ValMoy`]
  d$prevalence_denominator <- gsub(
    " +","",
    stringr::str_split(d$Prevalence.PrevalenceClass.Name," / ",
                       simplify = TRUE)[,2]
  ) |> as.numeric()
  d[,prevalence:=prevalence_numerator/prevalence_denominator*100]

  #### Add MONDO ID ####
  if(isTRUE(include_mondo)){
     d[,MONDO_ID:=mondo_dict(ids = id)]
   }

  if(!is.null(agg_by)){
    ## Compute mean prevalence
    dprev <- d[,list(n=.N, mean_prevalence=mean(prevalence, na.rm=TRUE)),
               by=agg_by #"Prevalence.PrevalenceType.Name"
    ][order(-mean_prevalence)]
    return(dprev)
  } else {
    return(d)
  }
}
