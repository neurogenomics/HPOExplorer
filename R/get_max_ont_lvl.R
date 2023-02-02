get_max_ont_lvl <- function(hpo,
                            exclude_top_lvl=TRUE){

  max_lvl <- get_ont_lvl(term = hpo$id[[1]],
                         hpo=hpo,
                         absolute = TRUE)
  #### Exclude the top level term "All" (HP:0000001) ####
  if(isTRUE(exclude_top_lvl)) max_lvl <- max_lvl-1
  return(max_lvl)
}
