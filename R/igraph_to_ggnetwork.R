igraph_to_ggnetwork <- function(g){
  g |>
    igraph::simplify() |>
    ggnetwork::fortify()
}
