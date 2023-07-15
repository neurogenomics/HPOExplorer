#' igraph to plotly data
#'
#' Convert an igraph to data for a 3D plotly plot.
#' @param dim Number of dimensions to create layout in.
#' @inheritParams network_3d
#' @returns Named list of data.frames.
#'
#' @keywords internal
#' @importFrom data.table data.table as.data.table .SD :=
igraph_to_plotly <- function(g,
                             layout_func = igraph::layout.fruchterman.reingold,
                             dim = 3,
                             seed = 2023,
                             verbose = TRUE){

  requireNamespace("igraph")
  .SD <- NULL;

  set.seed(seed)
  messager("Converting igraph to plotly data.",v=verbose)
  layout_coords <- cbind(
    name=names(igraph::V(g)),
    layout_func(g,dim=dim) |>
      data.table::as.data.table()|>
      `colnames<-`(c("x","y","z")[seq_len(dim)])
  )
  # d <- data.table::as.data.table(igraph::as_edgelist(g))
  d <- igraph::as_data_frame(g, what = "both")
  # d <- igraph::as_long_data_frame(g)
  # gnet <- data.table::data.table(
  #   igraph_to_ggnetwork(g)
  # )[,-c("x","y","xend","yend")]
  # if("node_type" %in% names(gnet)){
  #   gnet <- unique(gnet[node_type %in% c("hpo_name","ancestor_name")])
  # }

  #### Vertex data ####
  #### Merge layout coordinates with vertex metadata ####
  vdf <- merge(
    layout_coords,
    d$vertices,
    by = "name",
    all = TRUE
  )
  ## Make NAs into characters so that they still get assigned a point color
  cols <- names(vdf)[sapply(vdf, class) == 'character']
  vdf[, (cols) := lapply(.SD, replace,NA,"NA"),.SDcols=cols]
  #### Edge data ####
  edf <- data.table::merge.data.table(
    data.table::data.table(d$edges),
    layout_coords,
    by.x="from",
    by.y="name"
  ) |> data.table::merge.data.table(
    data.table::copy(layout_coords) |>
      data.table::setnames(c("x","y","z")[seq_len(dim)],
                           c("xend","yend","zend")[seq_len(dim)]
                           ),
    by.x="to",
    by.y="name"
  )

  if(!"hpo_name" %in% names(vdf)){
    vdf$hpo_name <- harmonise_phenotypes(phenotypes = vdf$hpo_id,
                                         as_hpo_ids = FALSE)
  }
  return(list(vertices=vdf,
              edges=edf))
}
