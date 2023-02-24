#' Kernel Density Estimation (KDE) surface
#'
#' Compute a KDE surface based on the density of points along
#' an x- and y-axis.
#' @param xyz A data.frame containing the columns "x" and "y" (required).
#' Can also include a third column "z" (optional).
#' @param extend_kde Extend the limits of the KDE area by setting
#'  \code{extend_kde>1}.
#' This makes the "mountains' of the KDE end more smoothly along the edges of
#' the x/y coordinates.
#' @param rescale_z Rescale the z-axis so that the KDE can be positioned
#'  below the original data points (when plotting them together).
#' @inheritParams MASS::kde2d
#' @returns
#' \itemize{
#' \item{\code{x, y}: }{
#' The x and y coordinates of the grid points, vectors of length n.
#' }
#' \item{\code{z}: }{
#' An \code{n[1]} by \code{n[2]} matrix of the estimated density:
#' rows correspond to the value of \code{x}, columns to the value of \code{y}.
#' }
#' }
#'
#' @export
#' @examples
#' xyz <- data.frame(x=stats::rnorm(50),
#'                   y=stats::rnorm(50),
#'                   z=stats::rnorm(50))
#' kd <- kde_surface(xyz = xyz)
kde_surface <- function(xyz,
                        n = 50,
                        extend_kde = 1,
                        rescale_z = TRUE){
  # templateR:::args2vars(kde_surface)
  requireNamespace("MASS")
  requireNamespace("scales")

  kd <- MASS::kde2d(x = xyz$x,
                    y = xyz$y,
                    n = n,
                    lims = c(range(xyz$x),
                             range(xyz$y)
                             )*extend_kde)
  #### Rescale the z-axis so that the KDE plot is below the points ####
  if(isTRUE(rescale_z)){
    if("z" %in% names(xyz)){
      kd$z <- scales::rescale(x = kd$z,
                              to = c(min(xyz$z*2),
                                     min(xyz$z)-.25))
    } else{
      wrn <- "Cannot rescale_z when z column not present in xyz data.frame."
      warning(wrn)
    }
  }
  return(kd)
}
