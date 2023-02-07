get_freq_dict <- function(type=NULL){
  #### These terms are absent from the R HPO for some reason (outdated?) ####
  freq_dict <- c("HP:0040280"="Obligate (100%)",
                 "HP:0040281"="Very frequent (99-80%)",
                 "HP:0040282"="Frequent (79-30%)",
                 "HP:0040283"="Occasional (29-5%)",
                 "HP:0040284"="Very rare (<4-1%)")
  if(is.null(type)){
    return(freq_dict)
  } else {
    splt <- stringr::str_split(
      gsub("[%]|[)|<]","",stringr::str_split(freq_dict,"[(]",
                                             simplify = TRUE)[,2]),
      "-"
    )
    if(type=="min"){
      min_dict <- lapply(splt, function(x){min(as.integer(x)) }) |>
        `names<-`(names(freq_dict)) |> unlist()
      return(min_dict)
    } else if(type=="max"){
      max_dict <- lapply(splt, function(x){max(as.integer(x)) }) |>
        `names<-`(names(freq_dict)) |> unlist()
      return(max_dict)
    } else{
      stp <- "type must be one of: NULL, 'min', 'max'"
    }
  }
}
