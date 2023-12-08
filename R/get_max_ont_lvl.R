get_max_ont_lvl <- function(hpo = get_hpo(),
                            absolute = TRUE,
                            exclude_top_lvl=FALSE){
  #### Get the maximum ontology level ####
  max_lvl <- 0
  for(i in seq(length(hpo$id))){
    tmp <- get_ont_lvl(term = hpo$id[[i]],
                       hpo = hpo,
                       absolute = absolute)
    if(tmp > max_lvl) max_lvl <- tmp
  }
  #### Exclude the top level term "All" (HP:0000001) ####
  if(isTRUE(exclude_top_lvl)) max_lvl <- max_lvl-1
  return(max_lvl)
}
