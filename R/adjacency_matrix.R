#' Adjacency matrix
#'
#' Create adjacency matrix of HPO child-parent relationships.
#' @param pheno_ids Character vector of HPO IDs.
#' @param as_dataframe Can return matrix or dataframe \<bool\>
#' @inheritParams make_phenos_dataframe
#' @returns adjacency matrix
#'
#' @export
#' @examples
#' adjacency <- adjacency_matrix(pheno_ids = c("HP:000001", "HP:000002"))
adjacency_matrix <- function(pheno_ids,
                             hpo = get_hpo(),
                             as_dataframe = FALSE) {
    message("adjacency_matrix")
    HPO_id <- unique(pheno_ids)
    size <- length(HPO_id)
    adjacency <- data.frame(matrix(nrow = size, ncol = size))
    rownames(adjacency) <- HPO_id
    colnames(adjacency) <- HPO_id
    adjacency[is.na(adjacency)] <- 0
    for (id in HPO_id) {
        children <- hpo$children[id][[1]]
        adjacency[id, children] <- 1
    }
    if (isTRUE(as_dataframe)) {
        return(adjacency[HPO_id, HPO_id])
    } else {
        return(as.matrix(adjacency[HPO_id, HPO_id]))
    }
}
