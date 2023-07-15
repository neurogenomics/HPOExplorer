parse_frequency <- function(f,
                            type = NULL){
    if(grepl("HP:",f)) {
      get_freq_dict(type = type)[f]
    } else if(grepl("/",f)) {
      eval(parse(text = f))
    } else if(grepl("%",f)){
      as.numeric(gsub("%","",f))
    } else {NA}
}
