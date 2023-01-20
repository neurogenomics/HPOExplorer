add_ont_lvl <- function(phenos,
                         hpo = get_hpo(),
                         verbose=TRUE){

  ontLvl_geneCount_ratio <- geneCount <- NULL;

  messager("Computing ontology level.",v=verbose)
  phenos[,ontLvl:=get_ont_lvls(terms = HPO_ID,
                               hpo = hpo,
                               verbose = verbose)]
  messager("Computing ontology level / gene count ratio",v=verbose)
  if("geneCount" %in% names(phenos)){
    phenos[,ontLvl_geneCount_ratio:=(ontLvl/geneCount)]
  }
  return(phenos)
}
