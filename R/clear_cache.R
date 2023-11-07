#' Clear cache
#'
#' @param save_dir Path to cache directory.
#' @inheritParams base::unlink
#' @inheritDotParams base::unlink
#'
#' @keywords internal
#' @importFrom tools R_user_dir
clear_cache <- function(save_dir=tools::R_user_dir(package = "HPOExplorer",
                                                   which = "cache"),
                        recursive = TRUE,
                        ...
                        ){
  unlink(x = save_dir,recursive = recursive,...)
}
