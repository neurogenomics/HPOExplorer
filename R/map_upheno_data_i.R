map_upheno_data_i <- function(pheno_map_method,
                              gene_map_method,
                              keep_nogenes,
                              fill_scores,
                              terms){
  hgnc_id <- gene_label1 <- subject <- subject_taxon_label <-
    hgnc_label <- n_phenotypes <- n_genes_intersect <-
    prop_intersect <- p1 <- p2 <- db1 <- db2 <- id1 <- id2 <-
    equivalence_score <- subclass_score  <-  hgnc_label1 <-
    hgnc_label2 <- hgnc_id2 <- gene_id <- gene_label1 <- gene_label2 <-
    n_genes_db1 <- object <-
    n_genes_db2 <- subject_taxon_label1 <- subject_taxon_label2 <-
    phenotype_genotype_score <- equivalence_score <- NULL;

  pheno_map_method <- pheno_map_method[1]
  gene_map_method <- gene_map_method[1]
  messager(paste0("map_upheno_data: pheno_map_method=",
                  shQuote(pheno_map_method)))
  #### Import data ####
  ## Cross-species phenotype map
  {
    if(pheno_map_method=="upheno"){
      pheno_map <- get_upheno("bestmatches")
      pheno_map[,db1:=gsub("*:.*","",basename(id1))]
    } else if(pheno_map_method=="monarch"){
      pheno_map <- get_monarch("phenotype_to_phenotype") |>
        data.table::setnames(c("label_x","label_y"),c("label1","label2"))
      pheno_map[,id1:=gsub("_",":",basename(p1))
      ][,id2:=gsub("_",":",basename(p2))]
      pheno_map[,db1:=gsub("*_.*","",basename(p1))
      ][,db2:=gsub("*_.*","",basename(p2))]
      pheno_map[,equivalence_score:=NA][,subclass_score:=NA]
    }
    #### Filter data ####
    if(!is.null(terms)){
      pheno_map <- pheno_map[id1 %in% terms,]
      if(nrow(pheno_map)==0){
        stop("No terms found in pheno_map")
      }
    }
  }

  ## Gene-phenotype associations across 8 species
  {
    genes <- get_monarch("phenotype_to_gene")
    data.table::setkeyv(genes,"object")
    messager("Unique species with genes:",
             data.table::uniqueN(genes$subject_taxon_label))
    # genes[,db:=gsub("*:.*","",object)]
    ## Create an ID-label map for each phenotype
    genes_map <- genes[,c("object","object_label",
                          "subject_taxon","subject_taxon_label")] |> unique()
    genes_map <- genes_map[,.SD[1], by="object"
    ][,db:=gsub("*:.*","",object)]
    ## Create an db-species map for each Ontology
    species_map <- genes_map[,.SD[1], keyby="db"][,.(db,subject_taxon_label)]
  }

  ## Gene-gene homology across 12 species
  if(gene_map_method=="monarch"){
    {
      homol <- get_monarch("gene_to_gene")
      messager("Unique species with ortholog:",
               data.table::uniqueN(homol$subject_taxon_label))
      ## Subset to only convert human --> non-human
      homol <- homol[grep("^HGNC",subject),] |>
        data.table::setnames(
          c("subject","subject_label","object","object_label"),
          c("hgnc_id","hgnc_label","gene_id","gene_label"))
      ## Add human-to-human back into map
      hhomol <- (homol[,c("hgnc_id","hgnc_label",
                          "subject_taxon","subject_taxon_label")] |> unique()
      )[,gene_id:=hgnc_id][,gene_label:=hgnc_label]
      homol <- rbind(hhomol,homol,fill=TRUE)
      message("Unique orthologs: ",data.table::uniqueN(homol$gene_id))
    }
    ## Orthogene
  } else if(gene_map_method=="orthogene"){
    requireNamespace("orthogene")
    homol <- lapply(stats::setNames(unique(genes$subject_taxon_label),
                                    unique(genes$subject_taxon_label)),
                    function(x){

                      input_species <- if(x=="Xenopus laevis"){
                        "Xenopus"
                      } else if(x=="Caenorhabditis elegans"){
                        "celegans"
                      } else {
                        x
                      }
                      orthogene::convert_orthologs(
                        gene_df = genes[subject_taxon_label==x,]$subject_label|>
                          unique(),
                        # gene_input = "subject_label",
                        gene_output = "columns",
                        input_species = input_species,
                        non121_strategy = "kbs",
                        output_species = "human")
                    }) |>
      data.table::rbindlist(fill=TRUE, idcol = "subject_taxon_label") |>
      data.table::setkeyv(c("subject_taxon_label","input_gene"))
    data.table::setnames(homol,"input_gene","subject_label")
    message("Unique orthologs: ",
            data.table::uniqueN(
              homol[subject_taxon_label!="Homo sapiens"]$subject_label))
  }
  #### Map non-human genes onto human orthologs ####
  {
    genes_homol <- data.table::merge.data.table(
      genes,
      homol[,c("hgnc_id","hgnc_label","gene_id","gene_label")],
      by.x="subject",
      by.y="gene_id")
    messager(formatC(nrow(genes_homol),big.mark = ","),"/",
             formatC(nrow(genes),big.mark = ","),
             "rows remain after cross-species gene mapping.")
    messager(data.table::uniqueN(genes_homol$subject_taxon_label),"/",
             data.table::uniqueN(genes$subject_taxon_label),
             "species remain after cross-species gene mapping.")
  }

  #### Map non-human phenotypes onto human phenotypes ####
  #### Merge nonhuman ontology genes with human HPO genes ####
  {
    pheno_map_genes <- data.table::merge.data.table(
      pheno_map,
      genes_homol,
      by.x="id1",
      by.y="object",
      all.x = keep_nogenes,
      allow.cartesian = TRUE) |>
      #### Merge nonhuman ontology genes with human HPO genes ####
    data.table::merge.data.table(
      genes_homol,
      by.x="id2",
      by.y="object",
      all.y = keep_nogenes,
      suffixes = c(1,2),
      allow.cartesian = TRUE
    )
    ## Fill in missing species for those without gene data
    pheno_map_genes[
      is.na(subject_taxon_label1),
      subject_taxon_label1:=species_map[db1]$subject_taxon_label]
    pheno_map_genes[
      is.na(subject_taxon_label2),
      subject_taxon_label2:=species_map[db2]$subject_taxon_label]
    ## Add gene counts
    pheno_map_genes[,n_genes_db1:=data.table::uniqueN(gene_label1), by="id1"]
    pheno_map_genes[,n_genes_db2:=data.table::uniqueN(gene_label2), by="id2"]
    ## Report
    messager(data.table::uniqueN(pheno_map_genes$subject_taxon_label2),"/",
             data.table::uniqueN(genes_homol$subject_taxon_label),
             "species remain after cross-species phenotype mapping.")
    ## Remove
    # remove(genes_human,genes_nonhuman,pheno_map)
  }

  #### Count the number of overlapping genes
  {
    if(isFALSE(keep_nogenes)){
      pheno_map_genes_match <- pheno_map_genes[hgnc_label1==hgnc_label2,]
    } else {
      pheno_map_genes_match <- pheno_map_genes |> data.table::copy()
    }
    pheno_map_genes_match <-
      pheno_map_genes_match[,
                            list(n_genes_intersect=data.table::uniqueN(hgnc_id2)),
                            by=c("id1","db1","label1","n_genes_db1",
                                 "id2","db2","label2","n_genes_db2",
                                 "subject_taxon1","subject_taxon_label1",
                                 "subject_taxon2","subject_taxon_label2",
                                 "equivalence_score","subclass_score")
      ] |>
      data.table::setorderv("n_genes_intersect",-1)
    pheno_map_genes_match[,n_phenotypes:=data.table::uniqueN(id1),
                          by=c("db1","db2",
                               "subject_taxon1","subject_taxon2",
                               "subject_taxon_label1","subject_taxon_label2"
                          )]
    pheno_map_genes_match[,prop_intersect:=(n_genes_intersect/n_genes_db1)]
    ## Compute a score that captures both the phenotype mapping score and
    ## the poportional gene overlap score.
    pheno_map_genes_match[,phenotype_genotype_score:=data.table::nafill(
      (equivalence_score*prop_intersect)^(1/2),fill = 0)]
    # remove(pheno_map_genes)
  }
  ## Fill missing data
  if(!is.null(fill_scores)){
    data.table::setnafill(x = pheno_map_genes_match,
                          fill = fill_scores,
                          cols=c("equivalence_score","subclass_score"))
  }
  ## Check that the number of intersecting nonhuman ontology genes is always
  ## less than or equal to the number of total HPO genes.
  # pheno_map_genes_match[n_genes>n_genes_hpo,]
  return(pheno_map_genes_match)
}
