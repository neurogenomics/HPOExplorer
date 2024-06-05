#' Plot arrow
#'
#' Plot an error indicating the direction of phenotype specificity.
#' @param labels Labels for each end of the arrow.
#' @param labels_alpha Transparency of the labels.
#' @param labels_size Size of the labels.
#' @param arrrow_size Size of the arrow.
#' @param arrow_color Colour of the arrow.
#' @param x x-coordinate of the arrow.
#' @param xend x-coordinate of the arrow end.
#' @param y y-coordinate of the arrow.
#' @param yend y-coordinate of the arrow end.
#' @param labels_x x-coordinates of the labels.
#' @param labels_y y-coordinates of the labels.
#' @return ggplot2 object.
#' @export
#' @examples
#' plot_arrow()
plot_arrow <- function(x=1, xend = 1,
                       y=0, yend = 1,
                       labels_x=c(x,xend),
                       labels_y=c(yend*.8, yend*.2),
                       labels=c("Broad\nphenotypes",
                                "Specific\nphenotypes"),
                       labels_alpha=.8,
                       labels_size=4,
                       arrrow_size=2,
                       arrow_color="grey50"){
  requireNamespace("ggplot2")


  ggplot2::ggplot() +
    ggplot2::geom_segment(
      ggplot2::aes(x=x, xend = xend , y=y, yend = yend),
        size=arrrow_size,color=arrow_color,
      arrow = ggplot2::arrow(ends="both", type="closed",
                             length = ggplot2::unit(0.6,"cm"))) +
    ggplot2::geom_label(ggplot2::aes(x=labels_x[1], y=labels_y[1],
                                     label=labels[1]),
                        size=labels_size, alpha=labels_alpha) +
    ggplot2::geom_label(ggplot2::aes(x=labels_x[2], y=labels_y[2],
                                     label=labels[2]),
                        size=labels_size, alpha=labels_alpha) +
    ggplot2::theme_void()
}
