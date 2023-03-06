read_enrichr <- function(file){
  lines <- readLines(file)
  lapply(strsplit(lines,"\t"), function(l){
    data.table::data.table(term=l[1],
                           gene=l[-c(1,2)])
  }) |> data.table::rbindlist(fill = TRUE)
}
